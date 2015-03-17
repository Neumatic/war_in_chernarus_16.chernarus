/*
	Author: R3F team
	Edited by: Neumatic
	Description: Check if the passed parameter in an Array of Arrays.

	Parameter(s):
		0: [Array] Array of arrays to check.
		1: [Any] What to check is in the Arrays.

	Example(s):
		_bool = [[[1,2,3],[4,5,6]], 4] call WC_fnc_isInArray;
		-> _bool = true;

	Returns:
		Bool
*/

private ["_return"];

_return = false;

if (count (_this select 0) > 0) then {
	if ({(_this select 1) in _x} count (_this select 0) > 0) then {
		_return = true;
	};
};

_return
