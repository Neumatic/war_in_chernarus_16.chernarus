/*
	Author: Neumatic
	Description: Sends a plane or helicopter reinforcement to the marker zone.
	Then sends the vehicle to air patrol. If the vehicle is a helicopter and
	has cargo positions then a group of infantry are spawned and moved into
	the the helicopter to be dropped off in the marker zone.

	Parameter(s):
		0: [String] Destination marker
		2: [String] Air reinforcement type
		3: [String] Vehicle type
		4: [String] Group faction type

	Example(s):
		["marker0", "helicopter", "Mi17", "RU"] spawn WC_fnc_supportAir;

	Returns:
		nil
*/

private [
	"_marker_dest", "_support_type", "_vehicle_type", "_marker_pos", "_transport", "_run", "_position", "_dir",
	"_vehicle_array", "_vehicle", "_crew", "_pilot", "_squad_size", "_count_pos", "_group_type", "_group_size",
	"_group", "_dest_pos", "_heli_pad", "_dest_reached", "_curr_pos"
];

_marker_dest  = _this select 0;
_support_type = _this select 1;

_marker_pos = getMarkerPos _marker_dest;
_transport = false;

_run = true;

// Find a town location where players are not around.
while {_run} do {
	_position = position (wctownlocations call WC_fnc_selectRandom);

	if ({_x distance _position < 3000} count ([] call BIS_fnc_listPlayers) == 0) then {
		_run = false;
	} else {sleep 0.1};
};

_dir = [_position, _marker_pos] call WC_fnc_dirTo;

// Spawn switch.
switch (toLower _support_type) do {
	case "plane": {
		_vehicle_type = WC_EnemyJets call WC_fnc_selectRandom;
		_vehicle_array = [[_position select 0, _position select 1, 300], _dir, _vehicle_type, east] call WC_fnc_spawnVehicle;
		_vehicle = _vehicle_array select 0;
		_crew    = _vehicle_array select 2;

		_vehicle lock true;
		_vehicle setFuel wcenemyglobalfuel;

		[_vehicle, east] spawn WC_fnc_vehiclehandler;

		["INFO", format ["Created reinforcement : %1 : %2", _support_type, [_vehicle] call WC_fnc_getDisplayName]] call WC_fnc_log;
	};

	case "helicopter": {
		_vehicle_type = WC_EnemyHelis call WC_fnc_selectRandom;
		_vehicle_array = [[_position select 0, _position select 1, 100], _dir, _vehicle_type, east] call WC_fnc_spawnVehicle;
		_vehicle = _vehicle_array select 0;
		_crew    = _vehicle_array select 2;

		_vehicle lock true;
		_vehicle setFuel wcenemyglobalfuel;

		[_vehicle, east] spawn WC_fnc_vehiclehandler;

		// Check to see if the vehicle has cargo positions.
		_transport = if (_vehicle emptyPositions "cargo" > 0) then {true} else {false};

		// If vehicle has cargo positions.
		if (_transport) then {
			// Get the pilot of the vehicle, and disable the pilot targeting AI.
			_pilot = driver _vehicle;
			_pilot disableAI "AUTOTARGET";
			_pilot disableAI "TARGET";

			_squad_size = [4,7] select (random 1);
			_count_pos = _vehicle emptyPositions "cargo";
			_group_type = wcfactions call WC_fnc_selectRandom;

			// Check if the squad size is greater then the cargo positions of the vehicle.
			if (_squad_size > _count_pos) then {_group_size = _count_pos} else {_group_size = _squad_size};
			_group = [_group_type, east, _position, _group_size] call WC_fnc_popgroup;

			{
				_x assignAsCargo _vehicle;
				_x moveInCargo _vehicle;
			} forEach units _group;

			[_group, east] spawn WC_fnc_grouphandler;

			// Get a flat position in rescuezone, and put down an invisible helipad (for landing function).
			_dest_pos = [_marker_dest, "onground", "onflat"] call WC_fnc_createpositioninmarker;
			_heli_pad = createVehicle ["HeliHEmpty", _dest_pos, [], 0, "NONE"];

			_dest_reached = false;
		};

		["INFO", format ["Created reinforcement : %1 : %2", _support_type, [_vehicle] call WC_fnc_getDisplayName]] call WC_fnc_log;
	};
};

// Add crew to handler, and support array.
[_crew, east] spawn WC_fnc_grouphandler;
wcsupportgroup set [count wcsupportgroup, _crew];

// Set vehicle flyInHeight and speed.
_vehicle flyInHeight 50;
_pilot setSpeedMode "NORMAL";

// Transport loop.
if (_transport) then {
	while {!_dest_reached && {{alive _x} count units _group > 0} && {alive _pilot} && {alive _vehicle} && {canMove _vehicle}} do {
		_pilot doMove _dest_pos;

		// Vehicle is close enough to begin landing.
		if (_vehicle distance _dest_pos < 300) then {
			// Issues the "GET OUT" land command.
			_vehicle land "GET OUT";

			// Loop to wait for the vehicle to get below 1 meter ATL.
			while {{alive _x} count units _group > 0 && {alive _pilot} && {alive _vehicle} && {canMove _vehicle} && {((getPos _vehicle) select 2) > 1}} do {
				sleep 0.5;
			};

			if ({alive _x} count units _group > 0) then {
				// Eject the cargo of the vehicle
				{
					_x action ["Eject", _vehicle];
					unassignVehicle _x;
					sleep 0.05;
				} forEach assignedCargo _vehicle;

				sleep 1;

				// Send group to upsmon.
				if ({alive _x} count units _group > 0) then {
					if (random 1 > 0.2) then {
						[leader _group, _marker_dest, "showmarker"] spawn EXT_fnc_upsmon;
					} else {
						[leader _group, _marker_dest, "showmarker", "nofollow"] spawn EXT_fnc_upsmon;
					};
				};
			};

			if (alive _pilot && {alive _vehicle} && {canMove _vehicle}) then {
				// Cancels the "GET OUT" land command.
				_vehicle land "NONE";

				_curr_pos = getPos _vehicle;

				// Vehicle lifts back up into the air
				_vehicle doMove [_curr_pos select 0, _curr_pos select 1, (_curr_pos select 2) + 50];
			};

			// Exit the main while loop.
			_dest_reached = true;
		};

		sleep 3;
	};

	// Enable the pilot targeting AI, and delete the helipad.
	if (alive _pilot) then {
		_pilot enableAI "AUTOTARGET";
		_pilot enableAI "TARGET";
	};

	_heli_pad setPos [0,0,0];
	deleteVehicle _heli_pad;
};

// Send the vehicle to airpatrol script.
if (alive _vehicle && {canMove _vehicle} && {{alive _x} count crew _vehicle > 0}) then {
	[_vehicle, _crew, true] spawn WC_fnc_airpatrol;
};
