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

private ["_param", "_pos"];

_param = _this select 0;

_pos = switch (typeName _param) do {
	case (typeName objNull): {[_param] call WC_fnc_getObjPos};
	case (typeName grpNull): {[leader _param] call WC_fnc_getObjPos};
	case (typeName ""): {getMarkerPos _param};
	default {position _param};
};

_pos
