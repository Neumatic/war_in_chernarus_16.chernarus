/*
	Author: BIS Wiki
	Edited by: Neumatic
	Description: Gets a position of an object.

	Parameter(s):
		0: [Object] Object to get position.

	Example(s):
		_pos = [player] call WC_fnc_getObjPos;
		-> _pos = [1234,5678,0.00135];

	Returns:
		Array
*/

private ["_pos"];

_pos = getPosASL (_this select 0);
if (!surfaceIsWater _pos) then {
	_pos = ASLToATL _pos;
};

_pos
