/*
	Author: Neumatic
	Description: Shuffles the passed array randomly.

	Parameter(s):
		[Array] Array to shuffle randomly.

	Example(s):
		_array = [1,2,3,4] call WC_fnc_arrayShuffle;
		-> _array = [2,1,4,3];

	Returns:
		Array
*/

private ["_temp", "_array", "_rand", "_sel"];

_temp = _this;

_array = [];

for "_i" from 0 to (count _temp - 1) do {
	_rand = random (count _temp - 1);
	_sel = _temp select _rand;
	_array set [_i, _sel];
	_temp set [_rand, "<DELETE>"];
	_temp = _temp - ["<DELETE>"];
};

_array
