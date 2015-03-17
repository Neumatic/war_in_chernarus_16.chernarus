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

private ["_array", "_remove"];

_array  = _this select 0;
_remove = _this select 1;

if (count _array > 0) then {
	{
		if ([_x, _remove] call WC_fnc_isEqual) then {
			_array set [_forEachIndex, "<DELETE>"];
		};
	} forEach _array;

	_array = _array - ["<DELETE>"];
};

_array
