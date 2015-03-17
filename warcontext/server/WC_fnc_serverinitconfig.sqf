// -----------------------------------------------
// Author:     code34 nicolas_boiteux@yahoo.fr
// Edited by:  Neumatic
// Warcontext: Server init configuration file
// -----------------------------------------------

#define __PATH_EXTERN     "extern\"
#define __PATH_WARCONTEXT "warcontext\"
#define __PATH_SERVER     (__PATH_WARCONTEXT + "server\")
#define __PATH_MODULES    (__PATH_WARCONTEXT + "modules\")
#define __PATH_RESOURCES  (__PATH_WARCONTEXT + "ressources\")
#define __PATH_FUNCS      (__PATH_WARCONTEXT + "functions\")
#define __PATH_MISSIONS   (__PATH_WARCONTEXT + "missions\")

////////////////////////////////////////////////////////////////////////////////
// NEUMATICS SCRIPTS
////////////////////////////////////////////////////////////////////////////////

// Warcontext
["WC_fnc_baseStatic", __PATH_MODULES + "wc_staticweapons\WC_fnc_baseStatic.sqf"] call WC_fnc_compile;
["WC_fnc_defendParadrop", __PATH_MODULES + "wc_enemygroups\WC_fnc_defendParadrop.sqf"] call WC_fnc_compile;
["WC_fnc_flareLightSource", __PATH_MODULES + "wc_unitsrole\WC_fnc_flareLightSource.sqf"] call WC_fnc_compile;
["WC_fnc_initRoadPatrols", __PATH_MODULES + "wc_roadpatrols\WC_fnc_initRoadPatrols.sqf"] call WC_fnc_compile;
["WC_fnc_moveAnimals", __PATH_MODULES + "wc_animals\WC_fnc_moveAnimals.sqf"] call WC_fnc_compile;
["WC_fnc_radio", __PATH_MODULES + "wc_radio\WC_fnc_radio.sqf"] call WC_fnc_compile;
["WC_fnc_supportAir", __PATH_MODULES + "wc_enemygroups\WC_fnc_supportAir.sqf"] call WC_fnc_compile;

// Server
["WC_fnc_onPlayerDisconnected", __PATH_SERVER + "WC_fnc_onPlayerDisconnected.sqf"] call WC_fnc_compile;

// Missions
["WC_fnc_destroyObjects", __PATH_MISSIONS + "WC_fnc_destroyObjects.sqf"] call WC_fnc_compile;
["WC_fnc_defuseIED", __PATH_MISSIONS + "WC_fnc_defuseIED.sqf"] call WC_fnc_compile;
["WC_fnc_eliminate", __PATH_MISSIONS + "WC_fnc_eliminate.sqf"] call WC_fnc_compile;

////////////////////////////////////////////////////////////////////////////////
// EXTERNAL SCRIPTS
////////////////////////////////////////////////////////////////////////////////
["EXT_fnc_atot", __PATH_EXTERN + "EXT_fnc_atot.sqf"] call WC_fnc_compile;
["EXT_fnc_createcomposition", __PATH_EXTERN + "EXT_fnc_createcomposition.sqf"] call WC_fnc_compile;
["EXT_fnc_SortByDistance", __PATH_EXTERN + "EXT_fnc_Common_SortByDistance.sqf"] call WC_fnc_compile;
["EXT_fnc_vftcas", __PATH_EXTERN + "EXT_fnc_vftcas.sqf"] call WC_fnc_compile;
["EXT_fnc_upsmon", __PATH_EXTERN + "upsmon.sqf"] call WC_fnc_compile;
["EXT_fnc_ups", __PATH_EXTERN + "ups.sqf"] call WC_fnc_compile;

////////////////////////////////////////////////////////////////////////////////
// WARCONTEXT STANDALONE MODULES
////////////////////////////////////////////////////////////////////////////////

// AIR BOMBING
["WC_fnc_bomb", __PATH_MODULES + "wc_airbombing\WC_fnc_bomb.sqf"] call WC_fnc_compile;

// AIR PATROL
["WC_fnc_airpatrol", __PATH_MODULES + "wc_airpatrols\WC_fnc_airpatrol.sqf"] call WC_fnc_compile;
["WC_fnc_initairpatrol", __PATH_MODULES + "wc_airpatrols\WC_fnc_initairpatrol.sqf"] call WC_fnc_compile;

// ANIMALS
["WC_fnc_createsheep", __PATH_MODULES + "wc_animals\WC_fnc_createsheep.sqf"] call WC_fnc_compile;

// ANTI AIR
["WC_fnc_antiair", __PATH_MODULES + "wc_antiair\WC_fnc_antiair.sqf"] call WC_fnc_compile;

// CIVIL CAR
["WC_fnc_createcivilcar", __PATH_MODULES + "wc_civilcars\WC_fnc_createcivilcar.sqf"] call WC_fnc_compile;

// CIVILIANS
["WC_fnc_altercation", __PATH_MODULES + "wc_civilians\WC_fnc_altercation.sqf"] call WC_fnc_compile;
["WC_fnc_buildercivilian", __PATH_MODULES + "wc_civilians\WC_fnc_buildercivilian.sqf"] call WC_fnc_compile;
["WC_fnc_civilianinit", __PATH_MODULES + "wc_civilians\WC_fnc_civilianinit.sqf"] call WC_fnc_compile;
["WC_fnc_drivercivilian", __PATH_MODULES + "wc_civilians\WC_fnc_drivercivilian.sqf"] call WC_fnc_compile;
["WC_fnc_healercivilian", __PATH_MODULES + "wc_civilians\WC_fnc_healercivilian.sqf"] call WC_fnc_compile;
["WC_fnc_popcivilian", __PATH_MODULES + "wc_civilians\WC_fnc_popcivilian.sqf"] call WC_fnc_compile;
["WC_fnc_propagand", __PATH_MODULES + "wc_civilians\WC_fnc_propagand.sqf"] call WC_fnc_compile;
["WC_fnc_sabotercivilian", __PATH_MODULES + "wc_civilians\WC_fnc_sabotercivilian.sqf"] call WC_fnc_compile;
["WC_fnc_walkercivilian", __PATH_MODULES + "wc_civilians\WC_fnc_walkercivilian.sqf"] call WC_fnc_compile;

// COMPOSITIONS
["WC_fnc_createcomposition", __PATH_MODULES + "wc_compositions\WC_fnc_createcomposition.sqf"] call WC_fnc_compile;

// TOWN GENERATOR
["WC_fnc_computeavillage", __PATH_MODULES + "wc_computevillage\WC_fnc_computeavillage.sqf"] call WC_fnc_compile;

// DOGS PATROL
["WC_fnc_dogpatrol", __PATH_MODULES + "wc_dogpatrol\WC_fnc_dogpatrol.sqf"] call WC_fnc_compile;

// ENEMYS GROUPS
["WC_fnc_ambiantlife", __PATH_MODULES + "wc_enemygroups\WC_fnc_ambiantlife.sqf"] call WC_fnc_compile;
["WC_fnc_popgroup", __PATH_MODULES + "wc_enemygroups\WC_fnc_popgroup.sqf"] call WC_fnc_compile;
["WC_fnc_creategroup", __PATH_MODULES + "wc_enemygroups\WC_fnc_creategroup.sqf"] call WC_fnc_compile;
["WC_fnc_creategroupdefend", __PATH_MODULES + "wc_enemygroups\WC_fnc_creategroupdefend.sqf"] call WC_fnc_compile;
["WC_fnc_creategroupsupport", __PATH_MODULES + "wc_enemygroups\WC_fnc_creategroupsupport.sqf"] call WC_fnc_compile;

// GESTURE
["WC_fnc_dosillything", __PATH_MODULES + "wc_gesture\WC_fnc_dosillything.sqf"] call WC_fnc_compile;

// HANDLER
["WC_fnc_civilhandler", __PATH_MODULES + "wc_handler\WC_fnc_civilhandler.sqf"] call WC_fnc_compile;

// IED
["WC_fnc_createied", __PATH_MODULES + "wc_ied\WC_fnc_createied.sqf"] call WC_fnc_compile;
["WC_fnc_createiedintown", __PATH_MODULES + "wc_ied\WC_fnc_createiedintown.sqf"] call WC_fnc_compile;

// MINEFIELD
["WC_fnc_createminefield", __PATH_MODULES + "wc_minefield\WC_fnc_createminefield.sqf"] call WC_fnc_compile;

// MORTAR
["WC_fnc_mortar", __PATH_MODULES + "wc_mortar\WC_fnc_mortar.sqf"] call WC_fnc_compile;

// MORTUARY
["WC_fnc_createmortuary", __PATH_MODULES + "wc_mortuary\WC_fnc_createmortuary.sqf"] call WC_fnc_compile;

// NUKE
["WC_fnc_createnuclearfire", __PATH_MODULES + "wc_nuke\WC_fnc_createnuclearfire.sqf"] call WC_fnc_compile;
["WC_fnc_radiationzone", __PATH_MODULES + "wc_nuke\WC_fnc_radiationzone.sqf"] call WC_fnc_compile;

// WHEN PLAYER IS KILLED
["WC_fnc_onkilled", __PATH_MODULES + "wc_onkilled\WC_fnc_onkilled.sqf"] call WC_fnc_compile;
["WC_fnc_restoreactionmenu", __PATH_MODULES + "wc_onkilled\WC_fnc_restoreactionmenu.sqf"] call WC_fnc_compile;

// RANKING
["WC_fnc_playerscore", __PATH_MODULES + "wc_ranking\WC_fnc_playerscore.sqf"] call WC_fnc_compile;

// RESPAWNABLE VEHICLE
["WC_fnc_respawnvehicle", __PATH_MODULES + "wc_respawnvehicle\WC_fnc_respawnvehicle.sqf"] call WC_fnc_compile;

// ROAD PATROL
["WC_fnc_roadpatrol", __PATH_MODULES + "wc_roadpatrols\WC_fnc_roadpatrol.sqf"] call WC_fnc_compile;
["WC_fnc_createconvoy", __PATH_MODULES + "wc_roadpatrols\WC_fnc_createconvoy.sqf"] call WC_fnc_compile;

// SABOTAGE
["WC_fnc_nastyvehicleevent", __PATH_MODULES + "wc_sabotage\WC_fnc_nastyvehicleevent.sqf"] call WC_fnc_compile;

// SEA PATROL
["WC_fnc_createseapatrol", __PATH_MODULES + "wc_seapatrols\WC_fnc_createseapatrol.sqf"] call WC_fnc_compile;
["WC_fnc_seapatrol", __PATH_MODULES + "wc_seapatrols\WC_fnc_seapatrol.sqf"] call WC_fnc_compile;

// STATIC WEAPONS
["WC_fnc_createstatic", __PATH_MODULES + "wc_staticweapons\WC_fnc_createstatic.sqf"] call WC_fnc_compile;

// SUPPORT
["WC_fnc_support", __PATH_MODULES + "wc_support\WC_fnc_support.sqf"] call WC_fnc_compile;

// TACTICAL OBJECTS
["WC_fnc_creategenerator", __PATH_MODULES + "wc_tacticalobjects\WC_fnc_creategenerator.sqf"] call WC_fnc_compile;
["WC_fnc_createradio", __PATH_MODULES + "wc_tacticalobjects\WC_fnc_createradio.sqf"] call WC_fnc_compile;
["WC_fnc_createmhq", __PATH_MODULES + "wc_tacticalobjects\WC_fnc_createmhq.sqf"] call WC_fnc_compile;

// UNITS PATROL
["WC_fnc_patrol", __PATH_MODULES + "wc_unitpatrols\WC_fnc_patrol.sqf"] call WC_fnc_compile;
["WC_fnc_protectobject", __PATH_MODULES + "wc_unitpatrols\WC_fnc_protectobject.sqf"] call WC_fnc_compile;
["WC_fnc_sentinelle", __PATH_MODULES + "wc_unitpatrols\WC_fnc_sentinelle.sqf"] call WC_fnc_compile;

// UNITS ROLE
["WC_fnc_createmedic", __PATH_MODULES + "wc_unitsrole\WC_fnc_createmedic.sqf"] call WC_fnc_compile;
["WC_fnc_fireflare", __PATH_MODULES + "wc_unitsrole\WC_fnc_fireflare.sqf"] call WC_fnc_compile;

// WEATHER
["WC_fnc_weather", __PATH_MODULES + "wc_weather\WC_fnc_weather.sqf"] call WC_fnc_compile;

////////////////////////////////////////////////////////////////////////////////
// END OF MODULES
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// WIT MAIN SCRIPTS
////////////////////////////////////////////////////////////////////////////////
["WC_fnc_createlistofmissions", __PATH_WARCONTEXT + "WC_fnc_createlistofmissions.sqf"] call WC_fnc_compile;
["WC_fnc_createsidemission", __PATH_WARCONTEXT + "WC_fnc_createsidemission.sqf"] call WC_fnc_compile;
["WC_fnc_debug", __PATH_WARCONTEXT + "WC_fnc_debug.sqf"] call WC_fnc_compile;
["WC_fnc_deletemissioninsafezone", __PATH_WARCONTEXT + "WC_fnc_deletemissioninsafezone.sqf"] call WC_fnc_compile;
["WC_fnc_mainloop", __PATH_WARCONTEXT + "WC_fnc_mainloop.sqf"] call WC_fnc_compile;

////////////////////////////////////////////////////////////////////////////////
// SERVER SIDE
////////////////////////////////////////////////////////////////////////////////
["WC_fnc_publishmission", __PATH_SERVER + "WC_fnc_publishmission.sqf"] call WC_fnc_compile;
["WC_fnc_serverhandler", __PATH_SERVER + "WC_fnc_serverhandler.sqf"] call WC_fnc_compile;

////////////////////////////////////////////////////////////////////////////////
// MISSIONS
////////////////////////////////////////////////////////////////////////////////
["WC_fnc_bringunit", __PATH_MISSIONS + "WC_fnc_bringunit.sqf"] call WC_fnc_compile;
["WC_fnc_bringvehicle", __PATH_MISSIONS + "WC_fnc_bringvehicle.sqf"] call WC_fnc_compile;
["WC_fnc_build", __PATH_MISSIONS + "WC_fnc_build.sqf"] call WC_fnc_compile;
["WC_fnc_defend", __PATH_MISSIONS + "WC_fnc_defend.sqf"] call WC_fnc_compile;
["WC_fnc_destroygroup", __PATH_MISSIONS + "WC_fnc_destroygroup.sqf"] call WC_fnc_compile;
["WC_fnc_destroyvehicle", __PATH_MISSIONS + "WC_fnc_destroyvehicle.sqf"] call WC_fnc_compile;
["WC_fnc_heal", __PATH_MISSIONS + "WC_fnc_heal.sqf"] call WC_fnc_compile;
["WC_fnc_jail", __PATH_MISSIONS + "WC_fnc_jail.sqf"] call WC_fnc_compile;
["WC_fnc_liberatehotage", __PATH_MISSIONS + "WC_fnc_liberatehotage.sqf"] call WC_fnc_compile;
["WC_fnc_record", __PATH_MISSIONS + "WC_fnc_record.sqf"] call WC_fnc_compile;
["WC_fnc_rescuecivil", __PATH_MISSIONS + "WC_fnc_rescuecivil.sqf"] call WC_fnc_compile;
["WC_fnc_rob", __PATH_MISSIONS + "WC_fnc_rob.sqf"] call WC_fnc_compile;
["WC_fnc_steal", __PATH_MISSIONS + "WC_fnc_steal.sqf"] call WC_fnc_compile;
["WC_fnc_sabotage", __PATH_MISSIONS + "WC_fnc_sabotage.sqf"] call WC_fnc_compile;
["WC_fnc_securezone", __PATH_MISSIONS + "WC_fnc_securezone.sqf"] call WC_fnc_compile;

// Check if it is a recompile.
if (WC_Recompile) exitWith {true};

// Broacast ace public variables.
if (wcwithACE == 1) then {
	// Repair vehicles fully.
	ace_sys_repair_full = true;
	publicVariable "ace_sys_repair_full";

	// AI Radio talk.
	ace_sys_aitalk_enabled = true;
	publicVariable "ace_sys_aitalk_enabled";

	ace_sys_aitalk_radio_enabled = true;
	publicVariable "ace_sys_aitalk_radio_enabled";

	ace_sys_aitalk_talkforplayer = false;
	publicVariable "ace_sys_aitalk_talkforplayer";

	// Blockgrass.
	ace_sys_viewblock_blockgrass = true;
	publicVariable "ace_sys_viewblock_blockgrass";

	// Turn off ace marker system
	ace_sys_tracking_markers_enabled = false;
	publicVariable "ace_sys_tracking_markers_enabled";

	// Fix 1.63 bool?
	ACE_EjectingBool = false;
	publicVariable "ACE_EjectingBool";

	// Fix RHS Decal.
	RHSDecalsOff = true;
	publicVariable "RHSDecalsOff";
};

// Patch files
wccfgpatchesoa = [
	"cadata","halo_test","caanimals","ca_anims","ca_anims_sdr","ca_anims_wmn","ca_anims_e","cabuildings","ca_e",
	"ca_pmc","ca_heads","cadata_particleeffects","ca_dubbing","calanguage","calanguage_missions","ca_modules",
	"ca_missions_ambientcombat","ca_modules_dyno","ca_modules_e","caroads2","caroads_e","carocks_e","casounds",
	"castructures","cafonts","ca_animals2","ca_animals2_anim_config","ca_animals2_chicken","ca_animals2_cow",
	"ca_animals2_dogs","ca_animals2_dogs_fin","ca_animals2_dogs_pastor","ca_animals2_goat","ca_animals2_rabbit",
	"ca_animals2_sheep","ca_animals2_wildboar","ca_anims_char","cabuildings2","ca_dubbingradio_e","ca_missions_e",
	"castructures_e","castructures_e_housea","castructures_e_ind","castructures_e_misc","castructures_e_wall",
	"castructures_pmc","castructures_pmc_buildings","castructures_pmc_misc","caui","caweapons","caweapons_ak",
	"caweapons_colt1911","caweapons_ksvk","caweapons_m107","caweapons_m252_81mm_mortar","caweapons_metis_at_13",
	"caweapons_2b14_82mm_mortar","caweapons_spg9","caweapons_zu23","caweapons_e_ammoboxes","cacharacters",
	"cacharacters_e_head","ca_dubbing_baf","camisc2","camisc","ca_missions_armory2","ca_missions_secops",
	"ca_missions_pmc","warfare2","cawater2","cawater2_seafox","caweapons2","caweapons2_rpg18","caweapons_kord",
	"cacharacters2","cacharacters_e","catracked","caweapons_warfare_weapons","cawheeled","cawheeled_pickup",
	"cawheeled_offroad","caair","camisc3","catracked2","catracked2_2s6m_tunguska","catracked2_t34",
	"catracked2_us_m270mlrs","cawheeled2","cawheeled2_hmmwv_base","cawheeled2_m1114_armored",
	"cawheeled2_hmmwv_ambulance","cawheeled2_m998a2_avenger","cawheeled2_ikarus","cawheeled2_lada",
	"cawheeled2_mtvr","cawheeled2_v3s","cawheeled3","cawheeled3_m1030","cawheeled3_tt650","cawheeled_e",
	"cawheeled_e_atv","cawheeled_e_landrover","cawheeled_pmc","caa10","ca_ah64d","caair2","caair2_c130j",
	"caair2_chukartarget","caair2_f35b","arma2_ka52","caair2_mq9predatorb","caair2_mv22","ca_air2_su25",
	"caair2_uh1y","caair3","caair3_su34","ca_baf","warfarebuildings","camisc_e", "ca_modules_arty",
	"camp_armory_misc","caweapons_baf","caweapons_e","caweapons_pmc","caweapons_pmc_xm8","caair_e","caair_e_ah64d",
	"caair_e_ch_47f","caair_pmc","cacharacters_baf","cacharacters_w_baf","catracked_e","cawheeled_d_baf",
	"caair_baf","catracked_baf"
];

// All vehicles in bluefor marker are respawnables (arcade mode)
wcrespawnablevehicles = [];

// Contain all civilian to init
wccivilianstoinit = [];

// Index for marker of town
wcciviltownindex = 0;

// Index of virtual
wcvirtualindex = 0;

// Array of player name intizialited
wcplayerready = [];

// Lobby Parameters
setDate [2011, 7, 1, 12, 0];
wcdate = date;

// Delete enemy vehicles without weapons, or in blacklist
{
	if ((count (configFile >> "CfgVehicles" >> _x >> "Turrets") == 0) || {(_x in wcblacklistenemyvehicleclass)}) then {
		wcvehicleslistE = wcvehicleslistE - [_x];
	};
} forEach wcvehicleslistE;

// Delete enemy vehicles without weapons, or in blacklist
if (!isNil "wcvehicleslistweighedE") then {
	{
		if ((count (configFile >> "CfgVehicles" >> _x select 1 >> "Turrets") == 0) || {((_x select 1) in wcblacklistenemyvehicleclass)}) then {
			wcvehicleslistweighedE = wcvehicleslistweighedE - [_x];
		};
	} forEach wcvehicleslistweighedE;
};

wcallsides = wceastside + wcresistanceside;

wcfactions = wcallsides select 0;
wcclasslist = wcallsides select 1;
wcvehicleslistEmission = wcvehicleslistE;
wcsupportfaction = "RU";

// Mission done
wcmissiondone = [];

// Mission done debug
/*
wcmissiondone = wcmissiondone + [
	0,1,2,3,4,5,6,7,8,9,
	10,11,12,13,14,15,16,17,18,19,
	20,21,22,23,24,25,26,27,28,29,
	30,31,32,33,34,35,36,37,38,39,
	40,41,42,43,44,45,46,47,48,49,
	50,51,52,53,54,55,56,57,58,59,
	60,61,62,63,64,65,66,67,68,69,
	70,71,72
];
*/

// Contain all securised zone
wcsecurezone = [getMarkerPos "respawn_west"];
wcsecurezoneindex = 0;

// Exclude mission that contains building not present on map, or in safe zone
objNull call WC_fnc_deletemissioninsafezone;

// Enemy zone size
wcdistancegrowth = 10;
wcdistance = 300 + (wclevel * wcdistancegrowth);

// Soldiers fame - start at good
wcfame = 0.70;

// Begining distance of ambiant life (grow during the game)
wcambiantdistance = 1500;

// Civilian are friends of everybody at begining
civilian setFriend [west, 1];
civilian setFriend [east, 1];
civilian setFriend [resistance, 1];

// Contain all the name of player die once time
wconelife = [];

// Bonus
wcbonusfame = 0;
wcenemyglobalfuel = 1;
wcenemyglobalelectrical = 1;

// Number of player killed
wcnumberofkilled = 0;
wcnumberofkilledofmissionW = 0;
wcnumberofkilledofmissionE = 0;
wcnumberofkilledofmissionC = 0;
wcnumberofkilledofmissionV = 0;

// Initialise the index composition
wccompositionindex = 0;

// Initialise marker index
wciedindex = 0;
wccivilcarindex = 0;
wcnuclearindex = 0;
wcminefieldindex = 0;

// Patrol wc index marker
wcpatrolindex = 0;

// AA index marker
wcaaindex = 0;

wcdefendzoneindex = 0;
wcteleportindex = 0;

// Initialise index ambiant
wcambiantindex = 0;

// Index markeur merlin
wcmerlinmrk = 0;

// Init ammoboxindex
wcammoboxindex = 0;

// Init E soldiers flare counter
wcflarecounter = 0;

// Contains all markers
wcarraymarker = [];
wcambiantmarker = [];

// Contains scores of all players
wcscoreboard = [];

// Contains patrol groups wich used wc patrol script
wcpatrolgroups = [];

// Contains current mission position
wcmissionposition = [0,0,0];

// Contains last mission position
wclastmissionposition = [0,0,0];

// Position of air zone
wcairpatrolzone = [0,0,0];

// Contains all town locations
wcmissionlocations = [];
wctownlocations = [];
wcemptylocations = [];

// Enum town locations
//objNull call WC_fnc_enumvillages;

wctownlocationsneartarget = [];
wctownwithbunker = [];

// Contains all units, and vehicles enemy
wcunits = [];
wcsentinelle = [];
wcvehicles = [];
wcambiantlife = [];
wcobjecttodelete = [];
wcsabotagelist = [];
wcpropagander = [];

// Used at the end of mission to add 1 level
wcleveltoadd = 0;

// Score initialisation
wcteamscore = 0;

// Ups initialisation
wcblinde = [];

// Guerilla ammobox
wcammobox = [];

// Contains all buildin mission
wclistofmissions = [];

// Contains all aa site position
wcallaaposition = [];

// Contains all position to send mortar
wcmortarposition = [];

// Contains all support groups
wcsupportgroup = [];

// Contains all enemies group that attack defend missions
wcdefendgroup = [];

// Alert threshold
wcalert = 0;
wcindexpropagande = 0;

// Number of grave at begining
wcgrave = 0;

// Contains road convoys, airpatrols, and sea patrols
WC_AirPatrols = [];
WC_RoadConvoys = [];
WC_SeaPatrols = [];

// Garbage array
WC_GarbageArray = [];

// Persistent marker array
WC_MarkersArray = [];

// Set some variables
wcradio = objNull;
wcgenerator = objNull;
wcheavyfactory = objNull;
wcbarrack = objNull;

nil
