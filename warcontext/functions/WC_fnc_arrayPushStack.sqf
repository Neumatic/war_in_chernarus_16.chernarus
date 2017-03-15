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

{
	(_this select 0) set [count (_this select 0), _x];
} count (_this select 1);

(_this select 0)
