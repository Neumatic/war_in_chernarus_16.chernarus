/*
	Author: CBA
	Edited by: Neumatic
	Description: Inspired by CBA. Handles key presses.

	Parameter(s):
		0: [String] Key handler type (KeyDown / KeyUp)
		1: [Array] Key data

	Example(s):
		_bool = ["KeyDown", _this] call WC_fnc_keyHandler;
		-> _bool = true;

	Returns:
		Bool
*/

private ["_type", "_params", "_handled"];

_type   = _this select 0;
_params = _this select 1;

_handled = false;

{
	if (format ["[%1,%2,%3]", _params select 2, _params select 3, _params select 4] == format ["%1", _x select 0]) then {
		_handled = _params call (_x select 1);
	};

	if (!isNil "_handled" && {typeName _handled == typeName true} && {_handled}) exitWith {nil};
} count (missionNamespace getVariable [format ["WC_EH_%1_%2", _type, _params select 1], []]);

!isNil "_handled" && {typeName _handled == typeName true} && {_handled};
