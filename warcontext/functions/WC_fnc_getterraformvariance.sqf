// -----------------------------------------------
// Author:     code34 nicolas_boiteux@yahoo.fr
// Edited by:  Neumatic
// Warcontext: Get the terraform variance on map
// -----------------------------------------------

#define GRID_SIZE 100

private ["_position", "_object", "_object_pos", "_alt_init", "_alt", "_alt_max", "_position_grid"];

_position = _this select 0;

_object = createVehicle ["Can_small", _position, [], 0, "NONE"];
_object_pos = [_object] call WC_fnc_getPos;
_alt_init = _object_pos select 2;
deleteVehicle _object;

_alt = 0;
_alt_max = _alt_init;

_position_grid = [_position, GRID_SIZE] call WC_fnc_creategridofposition;
{
	_object = createVehicle ["Can_small", _x, [], 0, "NONE"];
	_object_pos = [_object] call WC_fnc_getPos;
	_alt = _object_pos select 2;
	deleteVehicle _object;

	if (_alt > _alt_max) then {
		_position = _x;
		_alt_max = _alt;
		hint format ["maxalt: %1", _alt_max];
	};
	sleep 0.05;
} forEach _position_grid;

if (_alt_init == _alt_max) then {
	_position
} else {
	_position = [_position] call WC_fnc_getterraformvariance;
	_position
};
