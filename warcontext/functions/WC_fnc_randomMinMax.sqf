/*
	Author: Andrew Barron
	Description: Selects a random integer between the two passed numbers.

	Parameter(s):
		0: [Number] Minimum number.
		1: [Number] Maximum number.

	Example(s):
		_number = [1, 3] call WC_fnc_randomMinMax;
		-> _number = 1 or 2 or 3;

	Returns:
		Number
*/

private ["_min", "_max", "_result"];

_min = _this select 0;
_max = _this select 1;

if (_min > _max) then {_min = _this select 1; _max = _this select 0};

_min = round _min;
_max = round _max;

_result = ((random 1) * (1 + _max - _min)) + _min;
_result = floor _result;

_result
