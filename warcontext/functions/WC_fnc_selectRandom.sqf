/*
	Author: Neumatic
	Description: Selects a random element from the passed array then returns
	selection.

	Parameter(s):
		[Array]

	Example(s):
		_random = [1,2,3,4] call WC_fnc_selectRandom;
		-> _random = 1 or 2 or 3 or 4;

	Returns:
		Scalar
*/

private ["_sel"];

_sel = _this select (random (count _this - 1));

_sel
