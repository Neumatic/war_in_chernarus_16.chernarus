// -----------------------------------------------
// Author:     code34 nicolas_boiteux@yahoo.fr
// Edited by:  Neumatic
// Warcontext: Take an objects array, and return an array
// with all objects far enough of distance min to the pos
// -----------------------------------------------

private ["_objects", "_position", "_min_dist"];

_objects  = _this select 0;
_position = _this select 1;
_min_dist = _this select 2;

{
	if (([_x, _position] call WC_fnc_getDistance) < _min_dist) then {
		_objects = _objects - [_x];
	};
} forEach _objects;

_objects
