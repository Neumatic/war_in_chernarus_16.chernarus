/*
	Author: Neumatic
	Description: Removes an element from an array.

	Parameter(s):
		0: [Array] Array to remove from.
		1: [Anything] What to remove from array.

	Example(s):
		_array = [[1,2,3,4], 3] call WC_fnc_arrayRemove;
		-> _array = [1,2,4];

	Returns:
		Array
*/

if (count (_this select 0) > 0) then {
	{
		if ([_x, (_this select 1)] call WC_fnc_isEqual) then {
			(_this select 0) set [_forEachIndex, "<DELETE>"];
		};
	} forEach (_this select 0);

	(_this select 0) = (_this select 0) - ["<DELETE>"];
};

(_this select 0)
