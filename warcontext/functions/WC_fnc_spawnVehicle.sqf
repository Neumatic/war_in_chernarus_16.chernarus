/*
	Author: Joris-Jan van 't Land
	Edited by: Neumatic
	Description: Function to spawn a certain vehicle type with all crew (including
	turrets). The vehicle can either become part of an existing group or create
	a new group.

	Parameter(s):
		0: [Array] Desired position.
		1: [Number] Desired azimuth.
		2: [String] Type of the vehicle.
		3: [Side/Group] Side or existing group.

	Optional parameter(s):
		4: [String] Type of crew.

	Example(s):
		_array = [getPos player, getDir player, "HMMVW", west] call WC_fnc_spawnVehicle;

	Returns:
		Array

		0: [Object] New vehicle
		1: [Objects] All crew
		2: [Group] Vehicle's group
*/

private ["_pos", "_dir", "_type", "_grp", "_new_grp", "_veh", "_crew"];

_pos  = _this select 0;
_dir  = _this select 1;
_type = _this select 2;
_grp  = _this select 3;

switch (typeName _grp) do {
	case (typeName sideUnknown): {
		_grp = createGroup _grp;
		_new_grp = true;
	};

	case (typeName grpNull): {
		_new_grp = false;
	};
};

if (_type isKindOf "Air") then {
	if (count _pos == 2) then {
		if (_type isKindOf "Plane") then {
			_pos set [count _pos, 300];
		} else {
			_pos set [count _pos, 100];
		};
	};

	_veh = createVehicle [_type, _pos, [], 0, "FLY"];
} else {
	_veh = createVehicle [_type, _pos, [], 0, "NONE"];
};

_veh setDir _dir;

if (_type isKindOf "Air") then {
	_veh setVelocity [50 * (sin _dir), 50 * (cos _dir), 0];
} else {
	[_veh] call WC_fnc_alignToTerrain;
};

if (count _this > 4) then {
	_crew = [_veh, _grp, false, "", _this select 4] call BIS_fnc_spawnCrew;
} else {
	_crew = [_veh, _grp] call BIS_fnc_spawnCrew;
};

_grp addVehicle _veh;

if (_new_grp) then {
	_grp selectLeader (commander _veh);
};

[_veh, _crew, _grp]
