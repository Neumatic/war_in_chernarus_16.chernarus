////////////////////////////////////////////////////////////////////////////////
// Author:     code34 nicolas_boiteux@yahoo.fr
// Edited by:  Neumatic
// Warcontext: Init
////////////////////////////////////////////////////////////////////////////////
//
// DEVELOPER - MAP
//
// warcontext\               contains main scripts
// warcontext\others\        contains all mission.sqm for other maps
// warcontext\client\        contains the client side logic
// warcontext\server\        contains the server side logic
// warcontext\modules\       contains all standalone logics
// warcontext\ressources\    contains all script that parse game ressources
// warcontext\dialogs\       contains all script relative to menubox
// warcontext\actions\       contains all script relative to addaction menu
// warcontext\camera\        contains all script that happens camera
// warcontext\functions\     contains all shared functions
////////////////////////////////////////////////////////////////////////////////

#define __PATH_WARCONTEXT "warcontext\"
#define __PATH_CLIENT     (__PATH_WARCONTEXT + "client\")
#define __PATH_SERVER     (__PATH_WARCONTEXT + "server\")
#define __PATH_FUNCS      (__PATH_WARCONTEXT + "functions\")

// Determine if machine is a server, client, or a dedicated server
WC_isServer = if (isServer) then {true} else {false};
WC_isClient = if (isServer && !isDedicated || {!isDedicated}) then {true} else {false};
WC_isDedicated = if (isDedicated) then {true} else {false};

// If client then start the init screen
if (WC_isClient) then {
	10200 cutText [localize "STR_WC_MESSAGEINITIALIZING", "BLACK FADED"];
};

// Disable saving
enableSaving [false, false];

// Get compile function
WC_fnc_compile = compile preprocessFileLineNumbers (__PATH_FUNCS + "WC_fnc_compile.sqf");

// Start log function early for use
["WC_fnc_log", __PATH_FUNCS + "WC_fnc_log.sqf"] call WC_fnc_compile;

// Log machine type
["INFO", format ["isServer=%1 : isClient=%2 : isDedicated=%3", WC_isServer, WC_isClient, WC_isDedicated]] call WC_fnc_log;

////////////////////////////////////////////////////////////////////////////////
// Initialize lobby parameters
////////////////////////////////////////////////////////////////////////////////
for "_i" from 0 to (count paramsArray - 1) do {
	missionNamespace setVariable [configName ((missionConfigFile >> "Params") select _i), paramsArray select _i];
};

// Set mod protection variable
WC_ModProtection = false;

// Protection from ACE mods
if (wcwithACE == 1) then {
	if !(isClass (configFile >> "CfgPatches" >> "cba_main")) then {
		WC_ModProtection = true;
	};

	if !(isClass (configFile >> "CfgPatches" >> "ace_main")) then {
		WC_ModProtection = true;
	};

	if !(isClass (configFile >> "CfgPatches" >> "acex_main")) then {
		WC_ModProtection = true;
	};

	if !(isClass (configFile >> "CfgPatches" >> "acex_ru_main")) then {
		WC_ModProtection = true;
	};
} else {
	if (isClass (configFile >> "CfgPatches" >> "ace_main")) then {
		WC_ModProtection = true;
	};
};

// Set recompile variable
WC_Recompile = false;

////////////////////////////////////////////////////////////////////////////////
// SERVER SIDE
////////////////////////////////////////////////////////////////////////////////
if (WC_isServer) then {
	["WC_fnc_serverinitconfig", __PATH_SERVER + "WC_fnc_serverinitconfig.sqf"] call WC_fnc_compile;
	["WC_fnc_serverside", __PATH_SERVER + "WC_fnc_serverside.sqf"] call WC_fnc_compile;
};

////////////////////////////////////////////////////////////////////////////////
// CLIENT SIDE
////////////////////////////////////////////////////////////////////////////////
if (WC_isClient) then {
	["WC_fnc_clientinitconfig", __PATH_CLIENT + "WC_fnc_clientinitconfig.sqf"] call WC_fnc_compile;
	["WC_fnc_clientside", __PATH_CLIENT + "WC_fnc_clientside.sqf"] call WC_fnc_compile;
};

////////////////////////////////////////////////////////////////////////////////
// COMMON INIT CONFIG FILE
////////////////////////////////////////////////////////////////////////////////
["WC_fnc_commoninitconfig", "WC_fnc_commoninitconfig.sqf"] call WC_fnc_compile;

// Common init mod config file
if (wcwithACE == 1) then {
	["WC_fnc_commonInitMods", "WC_fnc_commonInitMods.sqf"] call WC_fnc_compile;
};

waitUntil {!isNil "bis_fnc_init"};

////////////////////////////////////////////////////////////////////////////////
// INITIALIZE NOW
////////////////////////////////////////////////////////////////////////////////
objNull call WC_fnc_commoninitconfig;

if (wcwithACE == 1) then {
	objNull call WC_fnc_commonInitMods;
};

////////////////////////////////////////////////////////////////////////////////
// SERVER SIDE
////////////////////////////////////////////////////////////////////////////////
if (WC_isServer) then {objNull spawn WC_fnc_serverside};

////////////////////////////////////////////////////////////////////////////////
// CLIENT SIDE
////////////////////////////////////////////////////////////////////////////////
if (WC_isClient) then {objNull spawn WC_fnc_clientside};
