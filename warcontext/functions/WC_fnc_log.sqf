/*
	Author: Neumatic
	Description: Logs message to RPT file.

	Parameter(s):
		0: [String] Message type.
		1: [String] Message.

	Optional parameter(s):
		0: [String] Message type.
		1: [String] From script.
		2: [String] Message.

	Example(s):
		["INFO", "Message to RPT file"] call WC_fnc_log;
		["ERROR", "WC_fnc_log", "Error in this script"] call WC_fnc_log;

	Returns:
		nil
*/

if (count _this == 2) exitWith {diag_log format ["[WARCONTEXT (%1)] : %2", _this select 0, _this select 1]; nil};

diag_log format ["[WARCONTEXT (%1)] : %2 : %3", _this select 0, _this select 1, _this select 2];

nil
