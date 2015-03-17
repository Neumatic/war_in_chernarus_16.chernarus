/*
	Author: Muzzleflash
	Edited by: Neumatic
	Description: Removes duplicate items from an array then returns the
	unduplicated array.

	Parameter(s):
		[Array]

	Example(s):
		_array = [0,1,2,2,"string0","string0",[_object1,_object2,_object3]] call WC_fnc_removeDuplicates;
		-> _array = [0,1,2,"string0",[_object1,_object2]];

	Returns:
		Array
*/

private ["_temp", "_unduplicated", "_original", "_exists"];

_temp = _this;

_unduplicated = [];

{
	_original = _x;
	_exists = false;

	{
		if ([_original, _x] call WC_fnc_isEqual) exitWith {
			_exists = true;
		};
	} forEach _unduplicated;

	if (!_exists) then {
		_unduplicated set [count _unduplicated, _original];
	};
} forEach _temp;

_unduplicated
