/*
	Author: Neumatic
	Description: Get a position of the passed parameter.

	Parameter(s):
		0: [Any] What to get a position of.

	Example(s):
		_pos = [player] call WC_fnc_getPos;

	Returns:
		Array
*/

if (typeName (_this select 0) == typeName objNull) exitWith {[(_this select 0)] call WC_fnc_getObjPos};
if (typeName (_this select 0) == typeName grpNull) exitWith {[leader (_this select 0)] call WC_fnc_getObjPos};
if (typeName (_this select 0) == typeName "") exitWith {getMarkerPos (_this select 0)};

position (_this select 0);
