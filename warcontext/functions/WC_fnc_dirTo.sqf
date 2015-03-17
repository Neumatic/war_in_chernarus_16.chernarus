/*
	Direction To
	By Andrew Barron

	Parameters: [object or position 1, object or position 2]

	Returns the compass direction from object/position 1 to
	object/position 2. Return is always >=0 <360.

	Example: [player, getPos dude] call BIS_fnc_dirTo
*/

private ["_pos1", "_pos2", "_ret"];

_pos1 = _this select 0;
_pos2 = _this select 1;

// If objects, not positions, were passed in, then get their positions
if (typeName _pos1 == "OBJECT") then {_pos1 = [_pos1] call WC_fnc_getPos};
if (typeName _pos2 == "OBJECT") then {_pos2 = [_pos2] call WC_fnc_getPos};

// Get compass heading from _pos1 to _pos2
_ret = ((_pos2 select 0) - (_pos1 select 0)) atan2 ((_pos2 select 1) - (_pos1 select 1));
_ret = _ret % 360; // Ensure return is 0 - 360
_ret
