// -----------------------------------------------
// Author:     code34 nicolas_boiteux@yahoo.fr
// Edited by:  Neumatic
// Warcontext: Generate sea patrol
// -----------------------------------------------

private ["_size", "_run", "_position", "_boat", "_vehicle_array", "_vehicle", "_group"];

_size = _this select 0;

while {true} do {
	if (count WC_SeaPatrols < _size) then {
		_run = true;

		// Get a position on the sea to spawn at with no players around.
		while {_run} do {
			_position = [wcmaptopright, wcmapbottomleft, "onsea"] call WC_fnc_createposition;

			if ({([_x, _position] call WC_fnc_getDistance) < 1000} count ([] call BIS_fnc_listPlayers) == 0) then {
				_run = false;
			} else {sleep 0.1};
		};

		_boat = wcseapatrol call WC_fnc_selectRandom;

		_vehicle_array = [_position, 0, _boat, east] call WC_fnc_spawnVehicle;
		_vehicle = _vehicle_array select 0;
		_group   = _vehicle_array select 2;

		// Set the vehicle, and units of group to protected so they will not be deleted on clean up.
		_vehicle setVariable ["wcprotected", true];
		{
			_x setVariable ["wcprotected", true];
		} forEach units _group;

		[_vehicle, east] spawn WC_fnc_vehiclehandler;
		[_group, east] spawn WC_fnc_grouphandler;

		WC_SeaPatrols set [count WC_SeaPatrols, _vehicle];

		// Send vehicle to sea patrol script.
		[_vehicle, _group] spawn WC_fnc_seapatrol;
	} else {
		sleep 600 + random 600;
	};

	// Remove dead vehicles from sea patrols array.
	{
		_vehicle = _x;
		if (isNull _vehicle || {!alive _vehicle} || {!canMove _vehicle} || {{alive _x} count crew _vehicle == 0}) then {
			WC_SeaPatrols = WC_SeaPatrols - [_x];
		};
	} forEach WC_SeaPatrols;

	sleep 30;
};
