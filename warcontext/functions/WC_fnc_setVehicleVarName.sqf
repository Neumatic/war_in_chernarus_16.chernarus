/*
	Author: Ollem
	Edited by: Neumatic
	Description: Set and broadcast setVehicleVarName.

	Parameter(s):
		0: [Object] Object to set var name.
		1: [String] Var name to set.

	Example(s):
		[_object, _var_name] call WC_fnc_setVehicleVarName;

	Returns:
		nil
*/

// Uncomment for debug chat.
//#define DEBUG_CHAT

private ["_object", "_var_name"];

_object   = _this select 0;
_var_name = _this select 1;

_object setVehicleVarName _var_name;
_object call compile format ["%1=_this; publicVariable '%1'", _var_name];

#ifdef DEBUG_CHAT
	player sideChat format ["%1 : %2", _object, _var_name];
#endif

nil
