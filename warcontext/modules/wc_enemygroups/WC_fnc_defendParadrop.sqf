/*
	Author: Eightbit
	Edited by: Neumatic
	Description: Sends a plane or helicopter full of infantry to zone during
	defend mission.

	Parameter(s):
		0: [Array] Position start
		1: [Array] Position destination
		2: [String] Destination patrol marker
		3: [String] Paradrop type switch
		4: [String] Group faction type

	Example(s):
		[_position, getMarkerPos "marker0", "marker1", "helicopter", "RU"] spawn WC_fnc_defendParadrop;

	Returns:
		nil
*/

// Uncomment for debug chat.
//#define DEBUG_CHAT

#define MAIN_LOOP_CYCLE 20
#define VELOCITY_MULTI 4

#define GROUP_FORMATIONS ["STAG COLUMN","WEDGE","ECH LEFT","ECH RIGHT","VEE","LINE"]

private [
	"_position", "_destination", "_marker_dest", "_defend_type", "_alt", "_get_form", "_dir", "_vehicle_array", "_vehicle",
	"_crew", "_pilot", "_squad_size", "_count_pos", "_group_size", "_group", "_unit", "_index", "_dest_reached", "_vel",
	"_leader", "_old_leader", "_target", "_mission", "_behaviour", "_combat_mode", "_formation", "_speed_mode","_known_pos"
];

_position    = _this select 0;
_destination = _this select 1;
_marker_dest = _this select 2;
_defend_type = _this select 3;

sleep random 120;

_alt = 200 + round (random 50);
_get_form = GROUP_FORMATIONS call WC_fnc_selectRandom;

// Get the direction of the destination.
_dir = [_position, _destination] call WC_fnc_dirTo;

switch (toLower _defend_type) do {
	case "helicopter": {
		_vehicle_array = [[_position select 0, _position select 1, _alt], _dir, "ACE_Mi17_RU", east] call WC_fnc_spawnVehicle;
		_vehicle = _vehicle_array select 0;
		_crew    = _vehicle_array select 2;
	};

	case "plane": {
		_vehicle_array = [[_position select 0, _position select 1, _alt], _dir, "An2_TK_EP1", east, "RU_Soldier_Pilot"] call WC_fnc_spawnVehicle;
		_vehicle = _vehicle_array select 0;
		_crew    = _vehicle_array select 2;
	};
};

[_vehicle, east] spawn WC_fnc_vehiclehandler;

_pilot = driver _vehicle;

// Disable vehicle crews targeting so they won't target enemy.
{
	_x disableAI "AUTOTARGET";
	_x disableAI "TARGET";
} forEach crew _vehicle;

// Check if the squad size is greater then the cargo positions of the vehicle.
_squad_size = 7;
_count_pos = _vehicle emptyPositions "cargo";

if (_squad_size > _count_pos) then {_group_size = _count_pos} else {_group_size = _squad_size};

_group = createGroup east;

// Spawn the group of infantry.
for "_x" from 1 to _group_size do {
	_group createUnit [wcspecialforces call WC_fnc_selectRandom, _position, [], 10, "NONE"];
	sleep 0.05;
};

// Assign group as cargo, and move them into cargo.
{
	_x assignAsCargo _vehicle;
	_x moveInCargo _vehicle;
} forEach units _group;

["INFO", format ["Creating paradrop : %1 : %2 : %3", _defend_type, [_vehicle] call WC_fnc_getDisplayName, _group_size]] call WC_fnc_log;

// Add vehicle crew, group infantry to handlers, and add to defend group array.
[_crew, east] spawn WC_fnc_grouphandler;
[_group, east] spawn WC_fnc_grouphandler;
wcdefendgroup set [count wcdefendgroup, _group];

// If debug then get the index of the group.
#ifdef DEBUG_CHAT
	_index = (count wcdefendgroup) + 1;
#endif

// Set the speed based on the vehicle type.
if (_vehicle isKindOf "Plane") then {
	_pilot setSpeedMode "NORMAL";
} else {
	_pilot setSpeedMode "FULL";
};

_dest_reached = false;
_vehicle flyInHeight _alt;

// Vehicle move to loop.
while {!_dest_reached && {alive _pilot} && {alive _vehicle} && {canMove _vehicle} && {{alive _x} count units _group > 0}} do {
	_pilot doMove _destination;

	// Check to see if the vehicle is close enough to eject cargo
	if (_vehicle distance _destination < 300) then {
		{
			// Checks if vehicle is a helicopter.
			if (_vehicle isKindOf "Helicopter") then {
				if (speed _vehicle < 120) then {
					_vel = velocity _vehicle;
					_dir = direction _vehicle;
					_vehicle setVelocity [(_vel select 0) + ((sin _dir) * VELOCITY_MULTI), (_vel select 1) + ((cos _dir) * VELOCITY_MULTI), (_vel select 2)];
				};
			};

			// Ejects vehicles cargo.
			if (vehicle _x == _vehicle) then {
				_x action ["Eject", vehicle _x];
				unassignVehicle _x;
				sleep 0.5;
			};
		} forEach assignedCargo _vehicle;

		// Exit the while loop.
		_dest_reached = true;
	};

	sleep 3;
};

#ifdef DEBUG_CHAT
	player globalChat format ["paradrop %1: destreached=%2 : pilot=%3 : alive=%4 : canmove=%5 : count=%6", _index, _dest_reached, alive _pilot, alive _vehicle, canMove _vehicle, {alive _x} count units _group];
#endif

// Eject group if vehicle died before drop.
if (!_dest_reached && {{alive _x} count units _group > 0}) then {
	{
		if (vehicle _x == _vehicle) then {
			_x action ["Eject", vehicle _x];
			unassignVehicle _x;
			sleep 0.5;
		};
	} forEach assignedCargo _vehicle;
};

// Spawns new script to move vehicle after cargo has been ejected.
if (alive _pilot && {alive _vehicle} && {canMove _vehicle}) then {
	[_vehicle, _alt] spawn {
		private ["_vehicle", "_alt", "_run", "_position", "_dest_reached", "_crew", "_pilot"];

		_vehicle = _this select 0;
		_alt     = _this select 1;

		_run = true;

		// Get a random town location to send the paradrop vehicle to for deletion.
		while {_run} do {
			_position = position (wctownlocations call WC_fnc_selectRandom);

			if ({_x distance _position < 3000} count ([] call BIS_fnc_listPlayers) == 0) then {
				_run = false;
			} else {sleep 0.1};
		};

		_dest_reached = false;
		_crew = group _vehicle;
		_pilot = driver _vehicle;

		_vehicle flyInHeight _alt;
		_pilot setSpeedMode "FULL";

		// Send vehicle to position for deletion.
		while {!_dest_reached && {alive _pilot} && {alive _vehicle} && {canMove _vehicle}} do {
			_pilot doMove _position;

			if (_vehicle distance _position < 300) then {
				_dest_reached = true;
			};

			sleep 3;
		};

		// Deletes vehicles group and vehicle.
		_vehicle setPos [0,0,0];

		{
			[_x] call WC_fnc_deleteObject;
		} forEach units _crew;

		[_vehicle] call WC_fnc_deleteObject;
	};
};

// Get leader of group.
_leader = leader _group;

// Infantry move to loop.
while {{alive _x} count units _group > 0 && {_leader distance _destination > 300}} do {
	// Check if the leader of the group is too wounded to lead.
	if (!canStand _leader) then {
		_old_leader = _leader;
		_leader = objNull;

		{
			if (alive _x && {canStand _x}) exitWith {
				_leader = _x;
			};
		} forEach units _group;

		// If we have a new leader then set the unit as new leader.
		if (!isNull _leader) then {
			_group selectLeader _leader;
		} else {
			_leader = _old_leader;
		};
	};

	/*
		Check for a target.
		If there is a target then change mission to attack.
	*/
	_target = _leader findNearestEnemy _leader;
	if (!isNull _target) then {
		_mission = "ATTACK";
	} else {
		_mission = "MOVE";
	};

	switch (_mission) do {
		// No target so keep moving to destination.
		case "MOVE": {
			_behaviour = "AWARE";
			_combat_mode = "WHITE";
			_formation = "COLUMN";
			_speed_mode = "NORMAL";

			_group move _destination;

			// Set unitPos, and reset doWatch.
			{
				if (vehicle _x == _x) then {
					_x setUnitPos "UP";
				};

				_x doWatch objNull;
			} forEach units _group;

			#ifdef DEBUG_CHAT
				player globalChat format ["paradrop %1: mission=%2 : position=%3 : behaviour=%4 : combatmode=%5 : formation=%6 : speedmode=%7", _index, _mission, _position, _behaviour, _combat_mode, _formation, _speed_mode];
			#endif
		};

		// Leader has found a target.
		case "ATTACK": {
			_behaviour = "COMBAT";
			_combat_mode = "RED";
			_formation = _get_form;

			/*
				Get the known position of the target.
				If no position was return then just set a position on the target.
			*/
			_known_pos = _leader getHideFrom _target;
			if (count _known_pos == 0) then {
				_known_pos = getPos _target;
			};

			{
				_x doWatch _known_pos;
				_x doMove _known_pos;
			} forEach units _group;

			// Change unitPos, and speedMode based on distance to target knownPos.
			if (_leader distance _known_pos > 100) then {
				_speed_mode = "FULL";

				{
					if (vehicle _x == _x) then {
						_x setUnitPos "AUTO";
					};
				} forEach units _group;
			} else {
				_speed_mode = "NORMAL";

				{
					if (vehicle _x == _x) then {
						_x setUnitPos "MIDDLE";
					};
				} forEach units _group;
			};

			#ifdef DEBUG_CHAT
				player globalChat format ["defend %1: mission=%2 : target=%3 : knownpos=%4 : behaviour=%5 : combatmode=%6 : formation=%7 : speedmode=%8", _index, _mission, _known_pos, _behaviour, _combat_mode, _formation, _speed_mode];
			#endif
		};
	};

	_group setBehaviour _behaviour;
	_group setCombatMode _combat_mode;
	_group setFormation _formation;
	_group setSpeedMode _speed_mode;

	sleep MAIN_LOOP_CYCLE;

	_leader = leader _group;
};
// End infantry move to loop.

// If units still left in group send them to upsmon.
if ({alive _x} count units _group > 0) then {
	[leader _group, _marker_dest, "noslow", "showmarker"] spawn EXT_fnc_upsmon;
};
