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

private ["_param_0", "_param_1", "_distance"];

_param_0 = _this select 0;
_param_1 = _this select 1;

if (typeName _param_0 == typeName objNull) then {_param_0 = [_param_0] call WC_fnc_getPos};
if (typeName _param_1 == typeName objNull) then {_param_1 = [_param_1] call WC_fnc_getPos};

_distance = _param_0 distance _param_1;
_distance
