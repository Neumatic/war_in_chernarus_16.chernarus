// -----------------------------------------------
// Author:     code34 nicolas_boiteux@yahoo.fr
// Edited by:  Neumatic
// Warcontext: Creates reinforcment groups
// -----------------------------------------------

// Uncomment for debug chat.
//#define DEBUG_CHAT

#define MAIN_LOOP_CYCLE 20

#define GROUP_FORMATIONS ["STAG COLUMN","WEDGE","ECH LEFT","ECH RIGHT","VEE","LINE"]

private [
	"_marker_dest", "_support_type", "_destination", "_find_vehicle", "_get_form", "_marker_pos", "_marker_size",
	"_stuck_check", "_stuck_count", "_position", "_dir", "_vehicle_type", "_vehicle_array", "_vehicle", "_group",
	"_squad_size", "_count_pos", "_group_type", "_group_size", "_index", "_start_pos", "_count", "_leader", "_target",
	"_mission", "_motorized", "_behaviour", "_combat_mode", "_formation", "_speed_mode", "_old_leader", "_near_objects",
	"_object", "_time", "_crew"
];

_marker_dest  = _this select 0;
_support_type = _this select 1;

_destination = [];
_find_vehicle = false;
_get_form = GROUP_FORMATIONS call WC_fnc_selectRandom;
_marker_pos = getMarkerPos _marker_dest;
_marker_size = [_marker_dest] call WC_fnc_getMarkerSize;
_stuck_check = true;
_stuck_count = 0;

// Spawn switch.
switch (toLower _support_type) do {
	case "tank": {
		_position = [wcheavyfactory, 0, 300, sizeOf "M1A1", 0.2] call WC_fnc_getEmptyPosition;
		_dir = [_position, _marker_pos] call WC_fnc_dirTo;

		_vehicle_type = WC_EnemyTanks call WC_fnc_selectRandom;
		_vehicle_array = [_position, _dir, _vehicle_type, east] call WC_fnc_spawnVehicle;
		_vehicle = _vehicle_array select 0;
		_group   = _vehicle_array select 2;

		_vehicle lock true;
		_vehicle setFuel wcenemyglobalfuel;

		[_vehicle, east] spawn WC_fnc_vehiclehandler;
		[_vehicle] spawn EXT_fnc_atot;

		["INFO", format ["Created reinforcement : %1 : %2", _support_type, [_vehicle] call WC_fnc_getDisplayName]] call WC_fnc_log;
	};

	case "apc": {
		_position = [wcheavyfactory, 0, 300, sizeOf "M1A1", 0.2] call WC_fnc_getEmptyPosition;
		_dir = [_position, _marker_pos] call WC_fnc_dirTo;

		_vehicle_type = WC_EnemyApcs call WC_fnc_selectRandom;
		_vehicle = createVehicle [_vehicle_type, _position, [], 0, "NONE"];
		_vehicle setDir _dir;
		[_vehicle] call WC_fnc_alignToTerrain;

		_vehicle lock true;
		_vehicle setFuel wcenemyglobalfuel;

		[_vehicle, east] spawn WC_fnc_vehiclehandler;
		[_vehicle] spawn EXT_fnc_atot;

		_squad_size = [4,7] select (random 1);
		_count_pos = [_vehicle] call WC_fnc_countEmptyPositions;
		_group_type = wcfactions call WC_fnc_selectRandom;

		// Check if the squad size is greater then the empty positions of the vehicle.
		if (_squad_size > _count_pos) then {_group_size = _count_pos} else {_group_size = _squad_size};
		_group = [_group_type, east, _position, _group_size] call WC_fnc_popgroup;

		_group addVehicle _vehicle;

		// Assign and moveIn units of the group to the vehicle.
		{
			switch (true) do {
				case (isNull driver _vehicle): {_x assignAsDriver _vehicle; _x moveInDriver _vehicle};
				case (isNull commander _vehicle): {_x assignAsCommander _vehicle; _x moveInCommander _vehicle};
				case (isNull gunner _vehicle): {_x assignAsCargo _vehicle; _x moveInGunner _vehicle};
				default {_x assignAsCargo _vehicle; _x moveInCargo _vehicle; [_x, 60] spawn WC_fnc_avoidDisembark};
			};
		} forEach units _group;

		["INFO", format ["Created reinforcement : %1 : %2 : %3 : %4", _support_type, [_vehicle] call WC_fnc_getDisplayName, _group_type, _group_size]] call WC_fnc_log;
	};

	case "transport": {
		_position = [wcbarrack, 0, 300, sizeOf "M1A1", 0.2] call WC_fnc_getEmptyPosition;
		_dir = [_position, _marker_pos] call WC_fnc_dirTo;

		_vehicle_type = WC_EnemyTransports call WC_fnc_selectRandom;
		_vehicle = createVehicle [_vehicle_type, _position, [], 0, "NONE"];
		_vehicle setDir _dir;
		[_vehicle] call WC_fnc_alignToTerrain;

		_vehicle lock true;
		_vehicle setFuel wcenemyglobalfuel;

		[_vehicle, east] spawn WC_fnc_vehiclehandler;
		[_vehicle] spawn EXT_fnc_atot;

		_squad_size = [4,7] select (random 1);
		_count_pos = [_vehicle] call WC_fnc_countEmptyPositions;
		_group_type = wcfactions call WC_fnc_selectRandom;

		// Check if the squad size is greater then the empty positions of the vehicle.
		if (_squad_size > _count_pos) then {_group_size = _count_pos} else {_group_size = _squad_size};
		_group = [_group_type, east, _position, _group_size] call WC_fnc_popgroup;

		_group addVehicle _vehicle;

		// Assign and moveIn units of the group to the vehicle.
		{
			switch (true) do {
				case (isNull driver _vehicle): {_x assignAsDriver _vehicle; _x moveInDriver _vehicle};
				default {_x assignAsCargo _vehicle; _x moveInCargo _vehicle; [_x, 60] spawn WC_fnc_avoidDisembark};
			};
		} forEach units _group;

		["INFO", format ["Created reinforcement : %1 : %2 : %3 : %4", _support_type, [_vehicle] call WC_fnc_getDisplayName, _group_type, _group_size]] call WC_fnc_log;
	};
};

// Add group to handler, and support array.
[_group, east] spawn WC_fnc_grouphandler;
wcsupportgroup set [count wcsupportgroup, _group];

// If debug then get the index of the group.
#ifdef DEBUG_CHAT
	_index = (count wcsupportgroup) + 1;
#endif

// Get the starting position of the vehicle.
_start_pos = getPos _vehicle;

// Get position for group to goto
_destination = [_marker_pos, 0, _marker_size, sizeOf "M1A1", 0.2] call WC_fnc_getEmptyPosition;
if (count _destination == 0) then {
	_count = 0;
	_destination = [1,1,0];

	while {format ["%1", _destination] == "[1,1,0]"} do {
		if (_count > 3) then {
			_destination = [_marker_dest, "onground", "empty"] call WC_fnc_createpositioninmarker;
		} else {
			_destination = [_marker_dest, "onground", "onflat"] call WC_fnc_createpositioninmarker;
		};

		_count = _count + 1;
		sleep 0.5;
	};
};

_leader = leader _group;

// Main loop.
while {{alive _x} count units _group > 0 && {_leader distance _destination > 150}} do {
	/*
		Check for target.
		If there is a target then change mission to attack.
	*/
	_target = _leader findNearestEnemy _leader;
	if (!isNull _target) then {
		_mission = "ATTACK";
	} else {
		_mission = "MOVE";
	};

	// Check to see if group is in a vehicle or not.
	_motorized = if (vehicle _leader != _leader) then {true} else {false};

	switch (_mission) do {
		// No target so keep moving to destination.
		case "MOVE": {
			_behaviour = "AWARE";
			_combat_mode = "WHITE";
			_formation = "COLUMN";

			if (_motorized) then {
				_speed_mode = "FULL";

				// Get the commander, and the main turret to form to the vehicle.
				{
					if (!isNull _x && {alive _x}) then {
						_x setFormDir (getDir _vehicle);
					};
				} forEach [commander _vehicle, gunner _vehicle];

				_position = _destination;
			} else {
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

				// If group is still a ways out from the destination marker then find a vehicle.
				if (_leader distance _marker_pos > (wcdistance * 2)) then {
					_find_vehicle = true;
				} else {
					_find_vehicle = false;
				};

				if (_find_vehicle) then {
					// Does the group need a new vehicle?
					if (isNull _vehicle || {!alive _vehicle} || {!canMove _vehicle} || {_leader distance _vehicle > 100}) then {
						_group leaveVehicle _vehicle;
						_vehicle = objNull;

						// Find a suitable vehicle for the group.
						_near_objects = nearestObjects [getPos _leader, ["Car","Tank"], 100];
						if (count _near_objects > 0) then {
							{
								_object = _x;
								if (alive _object && {canMove _object} && {{alive _x} count crew _object == 0}) then {
									_count_pos = [_object] call WC_fnc_countEmptyPositions;
									if (_count_pos >= {alive _x} count units _group) exitWith {
										_object setDamage 0;
										_object setFuel 1;
										_vehicle = _object;
									};
								};
							} forEach _near_objects;
						};

						// If there is a new vehicle then goto that vehicle. Else just keep moving to destination.
						if (!isNull _vehicle) then {
							_speed_mode = "NORMAL";

							_group addVehicle _vehicle;
							(units _group) orderGetIn true;

							_position = getPos _vehicle;
						} else {
							_speed_mode = "FULL";
							_position = _destination;
						};
					} else {
						_speed_mode = "NORMAL";

						_group addVehicle _vehicle;
						(units _group) orderGetIn true;

						_position = getPos _vehicle;
					};
				} else {
					_speed_mode = "FULL";
					_position = _destination;
				};
			};

			_group move _position;

			// Set unitPos, and reset doWatch.
			{
				if (vehicle _x == _x) then {
					_x setUnitPos "UP";
				};

				_x doWatch objNull;
			} forEach units _group;

			#ifdef DEBUG_CHAT
				player globalChat format ["reinforce %1: mission=%2 : motorized=%3 : vehicle=%4 : position=%5 : behaviour=%6 : combatmode=%7 : formation=%8 : speedmode=%9", _index, _mission, _motorized, [_vehicle] call WC_fnc_getDisplayName, _position, _behaviour, _combat_mode, _formation, _speed_mode];
			#endif
		};

		// Leader has found a target.
		case "ATTACK": {
			_behaviour = "COMBAT";
			_combat_mode = "RED";

			/*
				Get the known position of the target.
				If no position was return then just set a position on the target.
			*/
			_position = _leader getHideFrom _target;
			if (count _position == 0) then {
				_position = getPos _target;
			};

			if (_motorized) then {
				// If the vehicle is a transport truck then eject the group.
				if ((typeOf _vehicle) in WC_EnemyTransports) then {
					(driver _vehicle) action ["EngineOff", _vehicle];
					_group leaveVehicle _vehicle;

					_time = time + 60;

					// Wait till the vehicle has stopped.
					while {alive _vehicle && {canMove _vehicle} && {speed _vehicle > 5} && {time < _time}} do {sleep 1};

					(units _group) orderGetIn false;

					{
						_x action ["Eject", _vehicle];
					} forEach crew _vehicle;

					_formation = _get_form;

					// Goto the knownPos of the target.
					{
						_x doWatch _position;
						_x doMove _position;
					} forEach units _group;
				} else {
					_formation = "COLUMN";

					{
						_x doWatch _position;
					} forEach crew _vehicle;

					_group move _position;
				};
			} else {
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

				_formation = _get_form;

				{
					_x doWatch _position;
					_x doMove _position;
				} forEach units _group;
			};

			// Change unitPos, and speedMode based on distance to target knownPos.
			if (_leader distance _position > 100) then {
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
		};

		#ifdef DEBUG_CHAT
			player globalChat format ["reinforce %1: mission=%2 : motorized=%3 : target=%4 : knownpos=%5 : behaviour=%6 : combatmode=%7 : formation=%8 : speedmode=%9", _index, _mission, _motorized, [_target] call WC_fnc_getDisplayName, _position, _behaviour, _combat_mode, _formation, _speed_mode];
		#endif
	};

	_group setBehaviour _behaviour;
	_group setCombatMode _combat_mode;
	_group setFormation _formation;
	_group setSpeedMode _speed_mode;

	sleep MAIN_LOOP_CYCLE;

	_leader = leader _group;

	// Check to see if the vehicle is stuck.
	if (_stuck_check) then {
		if (_vehicle distance _start_pos < 5) then {
			_stuck_count = _stuck_count + 1;
		} else {
			_stuck_check = false;
		};

		// If the vehicle hasn't moved in 120 seconds (6 cycles) then delete the group and vehicle.
		if (_stuck_count >= 6) then {
			#ifdef DEBUG_CHAT
				player globalChat format ["reinforce %1: vehicle=%2 : is stuck deleting", _index, [_vehicle] call WC_fnc_getDisplayName];
			#endif

			{
				[_x] call WC_fnc_deleteObject;
			} forEach units _group;

			[_vehicle] call WC_fnc_deleteObject;
		};
	};
};
// End main loop.

if ({alive _x} count units _group == 0) exitWith {};

_motorized = if (vehicle _leader != _leader) then {true} else {false};

if (_motorized) then {
	// If the vehicle is a transport or apc then eject the infantry.
	if ((typeOf _vehicle) in WC_EnemyTransports || {(typeOf _vehicle) in WC_EnemyApcs}) then {
		(driver _vehicle) action ["EngineOff", _vehicle];
		_group leaveVehicle _vehicle;

		_time = time + 30;

		// Wait till the vehicle has stopped.
		while {alive _vehicle && {canMove _vehicle} && {speed _vehicle > 5} && {time < _time}} do {sleep 1};

		{
			_x action ["Eject", _vehicle];
		} forEach crew _vehicle;

		#ifdef DEBUG_CHAT
			player globalChat format ["reinforce %1: vehicle=%2 : ejecting infantry", _index, [_vehicle] call WC_fnc_getDisplayName];
		#endif

		if (random 1 > 0.2) then {
			[leader _group, _marker_dest, "showmarker"] spawn EXT_fnc_upsmon;
		} else {
			[leader _group, _marker_dest, "showmarker", "nofollow"] spawn EXT_fnc_upsmon;
		};

		_time = time + 60;

		// Wait for the vehicle to be cleared before spawning new crew.
		while {alive _vehicle && {canMove _vehicle} && {{alive _x} count crew _vehicle > 0} && {time < _time}} do {sleep 1};

		// If the vehicle has a turret then give it a new crew.
		if (alive _vehicle && {canMove _vehicle} && {count (configFile >> "CfgVehicles" >> typeOf _vehicle >> "Turrets") > 0}) then {
			_crew = createGroup east;
			[_vehicle, _crew] call BIS_fnc_spawnCrew;
			[_crew, east] spawn WC_fnc_grouphandler;

			#ifdef DEBUG_CHAT
				player globalChat format ["reinforce %1: vehicle=%2 : spawning new crew", _index, [_vehicle] call WC_fnc_getDisplayName];
			#endif

			[_vehicle, _marker_dest, "showmarker"] spawn EXT_fnc_ups;
		};
	} else {
		[_vehicle, _marker_dest, "showmarker"] spawn EXT_fnc_ups;
	};
} else {
	if (random 1 > 0.2) then {
		[leader _group, _marker_dest, "showmarker"] spawn EXT_fnc_upsmon;
	} else {
		[leader _group, _marker_dest, "showmarker", "nofollow"] spawn EXT_fnc_upsmon;
	};
};
