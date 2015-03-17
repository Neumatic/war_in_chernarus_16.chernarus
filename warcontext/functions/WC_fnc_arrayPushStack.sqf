/*
	Author: Neumatic
	Description: Used to add 2 arrays together.

	Parameter(s):
		0: [Array] Array to add to.
		1: [Array] Array to add from.

	Example(s):
		_array_0 = [_array_0, _array_1] call WC_fnc_arrayPushStack;

	Returns:
		Array
*/

private ["_array_0", "_array_1"];

_array_0 = _this select 0;
_array_1 = _this select 1;

if (count _array_1 > 0) then {
	{
		_array_0 set [count _array_0, _x];
	} forEach _array_1;
};

_array_0
