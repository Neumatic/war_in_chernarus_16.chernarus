/*
	Author: Neumatic
	Description: Generates name for objects.

	Parameter(s):
		nil

	Example(s):
		_name = [] call WC_fnc_createObjName;

	Returns:
		String
*/

private ["_name"];

if (WC_isDedicated) then {
	_name = format ["SRV_OBJ_%1", WC_ObjectIndex];
} else {
	_name = format ["%1_OBJ_%2", toUpper (name player), WC_ObjectIndex];
};

WC_ObjectIndex = WC_ObjectIndex + 1;

_name
