/*
	Author: Neumatic
	Description: Recompiles scripts.

	Parameter(s):
		0: [String] Which scripts to recompile.

	Example(s):
		["COMMON","CLIENT","SERVER"] call WC_fnc_recompile;

	Returns:
		nil
*/

#define __PATH_WARCONTEXT "warcontext\"
#define __PATH_SERVER     (__PATH_WARCONTEXT + "server\")
#define __PATH_CLIENT     (__PATH_WARCONTEXT + "client\")

private ["_params"];

_params = _this;

startLoadingScreen ["Recompiling scripts..."];

WC_Recompile = true;

if ("COMMON" in _params) then {
	["WC_fnc_commoninitconfig.sqf"] call WC_fnc_compile;
	player sideChat "Recompiled common scripts";
};

if (WC_isClient && {"CLIENT" in _params}) then {
	[__PATH_CLIENT + "WC_fnc_clientinitconfig.sqf"] call WC_fnc_compile;
	player sideChat "Recompiled client scripts";
};

if (WC_isServer && {"SERVER" in _params}) then {
	[__PATH_SERVER + "WC_fnc_serverinitconfig.sqf"] call WC_fnc_compile;
	player sideChat "Recompiled server scripts";
};

WC_Recompile = false;

endLoadingScreen;

nil
