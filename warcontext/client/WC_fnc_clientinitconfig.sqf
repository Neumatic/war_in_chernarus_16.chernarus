// -----------------------------------------------
// Author:     code34 nicolas_boiteux@yahoo.fr
// Edited by:  Neumatic
// Warcontext: Client init configuration file
// -----------------------------------------------

#define __PATH_EXTERN     "extern\"
#define __PATH_EIGHT      (__PATH_EXTERN + "eightbits_scripts\")
#define __PATH_WARCONTEXT "warcontext\"
#define __PATH_CLIENT     (__PATH_WARCONTEXT + "client\")
#define __PATH_MODULES    (__PATH_WARCONTEXT + "modules\")
#define __PATH_RESOURCES  (__PATH_WARCONTEXT + "ressources\")
#define __PATH_CAMERA     (__PATH_WARCONTEXT + "camera\")
#define __PATH_FUNCS      (__PATH_WARCONTEXT + "functions\")

////////////////////////////////////////////////////////////////////////////////
// EIGHTBITS SCRIPTS
////////////////////////////////////////////////////////////////////////////////

// Init command menu
[__PATH_EIGHT + "command_menu\commandMenu.sqf"] call WC_fnc_compile;

// Init eighbits attach script
[__PATH_EIGHT + "vehicle_attach\addActionLoop.sqf"] call WC_fnc_compile;

BIS_FNC_CMDMENUCOMM = __PATH_EIGHT + "command_menu\cmdMenuComm.sqf";
["BIS_FNC_CMDMENUCOMM_TEAMSELECT", __PATH_EIGHT + "command_menu\cmdMenuCommTeamSelect.sqf"] call WC_fnc_compile;

////////////////////////////////////////////////////////////////////////////////
// NEUMATICS SCRIPTS
////////////////////////////////////////////////////////////////////////////////

// Key mapper
["WC_fnc_addKeyHandler", __PATH_MODULES + "wc_keymapper\WC_fnc_addKeyHandler.sqf"] call WC_fnc_compile;
["WC_fnc_removeKeyHandler", __PATH_MODULES + "wc_keymapper\WC_fnc_removeKeyHandler.sqf"] call WC_fnc_compile;
["WC_fnc_keyHandler", __PATH_MODULES + "wc_keymapper\WC_fnc_keyHandler.sqf"] call WC_fnc_compile;

// Vehicle manager
["WC_fnc_vehicleManager", __PATH_MODULES + "wc_vehiclemanager\WC_fnc_vehicleManager.sqf"] call WC_fnc_compile;

// Warcontext
["WC_fnc_clienteventhandler", __PATH_CLIENT + "WC_fnc_clienteventhandler.sqf"] call WC_fnc_compile;

////////////////////////////////////////////////////////////////////////////////
// EXTERNAL SCRIPTS
////////////////////////////////////////////////////////////////////////////////
["EXT_fnc_infotext", __PATH_EXTERN + "EXT_fnc_infoText.sqf"] call WC_fnc_compile;
["WC_fnc_teamstatus", __PATH_EXTERN + "TeamStatusDialog\TeamStatusDialog.sqf"] call WC_fnc_compile;

////////////////////////////////////////////////////////////////////////////////
// WARCONTEXT ANIM - CAMERA
////////////////////////////////////////////////////////////////////////////////
["WC_fnc_intro", __PATH_CAMERA + "WC_fnc_intro.sqf"] call WC_fnc_compile;
["WC_fnc_camfocus", __PATH_CAMERA + "WC_fnc_camfocus.sqf"] call WC_fnc_compile;
["WC_fnc_credits", __PATH_CAMERA + "WC_fnc_credits.sqf"] call WC_fnc_compile;
["WC_fnc_outro", __PATH_CAMERA + "WC_fnc_outro.sqf"] call WC_fnc_compile;
["WC_fnc_outrolooser", __PATH_CAMERA + "WC_fnc_outrolooser.sqf"] call WC_fnc_compile;

////////////////////////////////////////////////////////////////////////////////
// WARCONTEXT STANDALONE MODULES
////////////////////////////////////////////////////////////////////////////////

// ALTIMETER
["WC_fnc_altimeter", __PATH_MODULES + "wc_altimeter\WC_fnc_altimeter.sqf"] call WC_fnc_compile;

// AMMOBOX
["WC_fnc_createammobox", __PATH_MODULES + "wc_ammobox\WC_fnc_createammobox.sqf"] call WC_fnc_compile;
["WC_fnc_loadweapons", __PATH_MODULES + "wc_ammobox\WC_fnc_loadweapons.sqf"] call WC_fnc_compile;

// CLOTHES
["WC_fnc_restorebody", __PATH_MODULES + "wc_clothes\WC_fnc_restorebody.sqf"] call WC_fnc_compile;

// FAST TIME
["WC_fnc_fasttime", __PATH_MODULES + "wc_fasttime\WC_fnc_fasttime.sqf"] call WC_fnc_compile;

// HUD
["WC_fnc_lifeslider", __PATH_MODULES + "wc_hud\WC_fnc_lifeslider.sqf"] call WC_fnc_compile;

// IED
["WC_fnc_ieddetector", __PATH_MODULES + "wc_ied\WC_fnc_ieddetector.sqf"] call WC_fnc_compile;

// KEYMAPPER
["WC_fnc_keymapper", __PATH_MODULES + "wc_keymapper\WC_fnc_keymapper.sqf"] call WC_fnc_compile;

// LOADOUT
["WC_fnc_saveloadout", __PATH_MODULES + "wc_loadout\WC_fnc_saveloadout.sqf"] call WC_fnc_compile;
["WC_fnc_restoreloadout", __PATH_MODULES + "wc_loadout\WC_fnc_restoreloadout.sqf"] call WC_fnc_compile;

// MARKERS
["WC_fnc_playersmarkers", __PATH_MODULES + "wc_markers\WC_fnc_playersmarkers.sqf"] call WC_fnc_compile;
["WC_fnc_vehiclesmarkers", __PATH_MODULES + "wc_markers\WC_fnc_vehiclesmarkers.sqf"] call WC_fnc_compile;

// NUKE
["WC_fnc_createnuclearzone", __PATH_MODULES + "wc_nuke\WC_fnc_createnuclearzone.sqf"] call WC_fnc_compile;
["WC_fnc_nuclearnuke", __PATH_MODULES + "wc_nuke\WC_fnc_nuclearnuke.sqf"] call WC_fnc_compile;

// WHEN PLAYER IS KILLED
["WC_fnc_onkilled", __PATH_MODULES + "wc_onkilled\WC_fnc_onkilled.sqf"] call WC_fnc_compile;
["WC_fnc_restoreactionmenu", __PATH_MODULES + "wc_onkilled\WC_fnc_restoreactionmenu.sqf"] call WC_fnc_compile;

// RANKING
["WC_fnc_playerranking", __PATH_MODULES + "wc_ranking\WC_fnc_playerranking.sqf"] call WC_fnc_compile;

// REPAIR ZONE
["WC_fnc_servicing", __PATH_MODULES + "wc_repairzone\WC_fnc_servicing.sqf"] call WC_fnc_compile;

// STEALTH
["WC_fnc_stealth", __PATH_MODULES + "wc_stealth\WC_fnc_stealth.sqf"] call WC_fnc_compile;

// TARGET ADDACTION
["WC_fnc_targetaction", __PATH_MODULES + "wc_targetaction\WC_fnc_targetaction.sqf"] call WC_fnc_compile;

// WEATHER
["WC_fnc_light", __PATH_MODULES + "wc_weather\WC_fnc_light.sqf"] call WC_fnc_compile;

////////////////////////////////////////////////////////////////////////////////
// END OF MODULES
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// WIT MAIN SCRIPTS
////////////////////////////////////////////////////////////////////////////////
["WC_fnc_creatediary", __PATH_WARCONTEXT + "WC_fnc_creatediary.sqf"] call WC_fnc_compile;

////////////////////////////////////////////////////////////////////////////////
// CLIENT SIDE
////////////////////////////////////////////////////////////////////////////////
["WC_fnc_clienthandler", __PATH_CLIENT + "WC_fnc_clienthandler.sqf"] call WC_fnc_compile;
["WC_fnc_clientitems", __PATH_CLIENT + "WC_fnc_clientitems.sqf"] call WC_fnc_compile;

// Check if it is a recompile.
if (WC_Recompile) exitWith {true};

// Check if view distance was set higher then the max view distance
if (wcviewdist > wcviewdistance) then {
	wcviewdist = wcviewdistance;
};

// Set view distance & grass
setTerrainGrid wcterraingrid;
setViewDistance wcviewdist;

// Turn off ao marker
setGroupIconsVisible [false, false];

// Set environment sound with lobby parameter
if (wcwithenvironment == 0) then {enableEnvironment false};

// Turn off ace marker system
//ace_sys_tracking_markers_enabled = false;

// -------------------------------------------
// Don't edit below init of working variables
// -------------------------------------------

// Set player variables for dialog settings
player setVariable ["WC_DiagUpdate", false];

player setVariable ["WC_RctDiagSettings", [0,0]];
player setVariable ["WC_RctDiagSavedSquad", []];

player setVariable ["WC_VehDiagSettings", 0];
player setVariable ["WC_VehDiagCurrVehicles", []];

wcadmin = false;

wccamnvg = true;

wccam = objNull;

wcanim = "";

wcplayerside = west;

wcammoboxindex = 0;

wcobjectiveindex = -1;

wcammoused = 1;

wcnumberofkill = 0;

wcmissionokW = "";

wcplayers = [];

wcteamscore = 0;

wccountoftk = 0;

player setVariable ["deadmarker", false, true];

wcbonus = 0;

wcrankchanged = false;

wcteamplayscore = 0;

wcdragged = false;

wcrankactivate = true;

wccanwriteinfotext = true;

wcbombingavalaible = 0;

wcspectate = false;

wcbombingsupport = -1;

wcdetected = false;

wcplayerinnuclearzone = false;

wcteamlevel = 5;

wcindexmusic = 0;

wcclientlogs = ["Client logs - Playeruid: " + getPlayerUID player];

wclistofweaponsindex = 0;

wccfglocalpatches = [];

// Flag use for arcade jump
wcplayjumpmove = false;

// Flag to go through fast time
wcadvancetodate = [];

// Personnal vehicle
wcmyvehiclecount = 0;
wcmyvehicles = [];

// Local ammocrates
wcammocrates = [];

// Original clothes of player
wcoriginalclothes = typeOf player;

// Key event handlers
WC_EH_KeyDown = [];
WC_EH_KeyUp = [];

// Bool for player moves
WC_PlayerMove = false;

// Markers array
WC_PlayerMarkers = [];

/*
	1.63 fixes
*/

// Choose mission menu
wcchoosemissionmenu = -1;

// If autoload we load player weapons
if (wcautoloadweapons == 1) then {
	private ["_weapons_list"];
	_weapons_list = objNull call WC_fnc_enumweapons;
	wclistofaddonweapons = _weapons_list - wclistofweapons;
} else {
	wclistofaddonweapons = [];
};

nil
