/*
	Author: thomsonb
	Edited by: code34 and Neumatic
	Description: Gets a position near the parameter position using parameters.

	Parameter(s):
		0: [Array] Position.
		1: [Number] Bearing.
		2: [Number] Distance.

	Example(s):
		_array = [getPos player, getDir player, 20] call WC_fnc_PDB;

	Returns:
		Array
*/

private ["_pos", "_bearing", "_distance"];

_pos      = _this select 0;
_bearing  = _this select 1;
_distance = _this select 2;

[(_pos select 0) + (_distance * (sin _bearing)), (_pos select 1) + (_distance * (cos _bearing)), _pos select 2]
