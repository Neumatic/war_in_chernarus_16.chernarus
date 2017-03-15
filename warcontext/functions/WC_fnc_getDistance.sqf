/*
	Author: Neumatic
	Description: Gets the distance from one position to another.

	Parameter(s):
		0: [Object/Array] From.
		1: [Object/Array] To.

	Example(s):
		_distance = [player, _vehicle] call WC_fnc_getDistance;
		-> _distance = 100;

	Returns:
		Scalar
*/

private ["_pos_0", "_pos_1"];

_pos_0 = _this select 0;
_pos_1 = _this select 1;

if (typeName _pos_0 != typeName []) then {_pos_0 = [_pos_0] call WC_fnc_getPos};
if (typeName _pos_1 != typeName []) then {_pos_1 = [_pos_1] call WC_fnc_getPos};

_pos_0 distance _pos_1;
