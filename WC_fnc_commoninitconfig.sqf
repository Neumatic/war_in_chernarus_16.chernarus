// -----------------------------------------------
// Author:     code34 nicolas_boiteux@yahoo.fr
// Edited by:  Neumatic
// Warcontext: Init configuration file share between server and client
// -----------------------------------------------

#define __PATH_EXTERN     "extern\"
#define __PATH_WARCONTEXT "warcontext\"
#define __PATH_MODULES    (__PATH_WARCONTEXT + "modules\")
#define __PATH_RESOURCES  (__PATH_WARCONTEXT + "ressources\")
#define __PATH_FUNCS      (__PATH_WARCONTEXT + "functions\")

// Init BON loadout script
[__PATH_EXTERN + "bon_loadoutpresets\bon_init_loadoutpresets.sqf"] call WC_fnc_compile;

// Init R3F arty and logistic script
[__PATH_EXTERN + "R3F_ARTY_AND_LOG\init.sqf"] call WC_fnc_compile;

////////////////////////////////////////////////////////////////////////////////
// NEUMATICS SCRIPTS
////////////////////////////////////////////////////////////////////////////////

// Warcontext
["WC_fnc_flareLightSource", __PATH_MODULES + "wc_unitsrole\WC_fnc_flareLightSource.sqf"] call WC_fnc_compile;

// Functions
["WC_fnc_addAction", __PATH_FUNCS + "WC_fnc_addAction.sqf"] call WC_fnc_compile;
["WC_fnc_addActions", __PATH_FUNCS + "WC_fnc_addActions.sqf"] call WC_fnc_compile;
["WC_fnc_arrayPushStack", __PATH_FUNCS + "WC_fnc_arrayPushStack.sqf"] call WC_fnc_compile;
["WC_fnc_addMarker", __PATH_FUNCS + "WC_fnc_addMarker.sqf"] call WC_fnc_compile;
["WC_fnc_alignToTerrain", __PATH_FUNCS + "WC_fnc_alignToTerrain.sqf"] call WC_fnc_compile;
["WC_fnc_arrayRemove", __PATH_FUNCS + "WC_fnc_arrayRemove.sqf"] call WC_fnc_compile;
["WC_fnc_arrayShuffle", __PATH_FUNCS + "WC_fnc_arrayShuffle.sqf"] call WC_fnc_compile;
["WC_fnc_avoidDisembark", __PATH_FUNCS + "WC_fnc_avoidDisembark.sqf"] call WC_fnc_compile;
["WC_fnc_codePerformance", __PATH_FUNCS + "WC_fnc_codePerformance.sqf"] call WC_fnc_compile;
["WC_fnc_convertStrings", __PATH_FUNCS + "WC_fnc_convertStrings.sqf"] call WC_fnc_compile;
["WC_fnc_countEmptyPositions", __PATH_FUNCS + "WC_fnc_countEmptyPositions.sqf"] call WC_fnc_compile;
["WC_fnc_createObjName", __PATH_FUNCS + "WC_fnc_createObjName.sqf"] call WC_fnc_compile;
["WC_fnc_deleteObject", __PATH_FUNCS + "WC_fnc_deleteObject.sqf"] call WC_fnc_compile;
["WC_fnc_dirTo", __PATH_FUNCS + "WC_fnc_dirTo.sqf"] call WC_fnc_compile;
["WC_fnc_findEmptyPosition", __PATH_FUNCS + "WC_fnc_findEmptyPosition.sqf"] call WC_fnc_compile;
["WC_fnc_generateKey", __PATH_FUNCS + "WC_fnc_generateKey.sqf"] call WC_fnc_compile;
["WC_fnc_getDisplayName", __PATH_FUNCS + "WC_fnc_getDisplayName.sqf"] call WC_fnc_compile;
["WC_fnc_getDisplayNameShort", __PATH_FUNCS + "WC_fnc_getDisplayNameShort.sqf"] call WC_fnc_compile;
["WC_fnc_getDistance", __PATH_FUNCS + "WC_fnc_getDistance.sqf"] call WC_fnc_compile;
["WC_fnc_getEmptyPosition", __PATH_FUNCS + "WC_fnc_getEmptyPosition.sqf"] call WC_fnc_compile;
["WC_fnc_getLocation", __PATH_FUNCS + "WC_fnc_getLocation.sqf"] call WC_fnc_compile;
["WC_fnc_getLocationText", __PATH_FUNCS + "WC_fnc_getLocationText.sqf"] call WC_fnc_compile;
["WC_fnc_getMarkerSize", __PATH_FUNCS + "WC_fnc_getMarkerSize.sqf"] call WC_fnc_compile;
["WC_fnc_getObjPos", __PATH_FUNCS + "WC_fnc_getObjPos.sqf"] call WC_fnc_compile;
["WC_fnc_getPos", __PATH_FUNCS + "WC_fnc_getPos.sqf"] call WC_fnc_compile;
["WC_fnc_getSide", __PATH_FUNCS + "WC_fnc_getSide.sqf"] call WC_fnc_compile;
["WC_fnc_getVehicleIntel", __PATH_FUNCS + "WC_fnc_getVehicleIntel.sqf"] call WC_fnc_compile;
["WC_fnc_groupReady", __PATH_FUNCS + "WC_fnc_groupReady.sqf"] call WC_fnc_compile;
["WC_fnc_handleDamage", __PATH_FUNCS + "WC_fnc_handleDamage.sqf"] call WC_fnc_compile;
["WC_fnc_isEqual", __PATH_FUNCS + "WC_fnc_isEqual.sqf"] call WC_fnc_compile;
["WC_fnc_isEqual_2", __PATH_FUNCS + "WC_fnc_isEqual_2.sqf"] call WC_fnc_compile;
["WC_fnc_isInArray", __PATH_FUNCS + "WC_fnc_isInArray.sqf"] call WC_fnc_compile;
["WC_fnc_param", __PATH_FUNCS + "WC_fnc_param.sqf"] call WC_fnc_compile;
["WC_fnc_patchCheck", __PATH_FUNCS + "WC_fnc_patchCheck.sqf"] call WC_fnc_compile;
["WC_fnc_PDB", __PATH_FUNCS + "WC_fnc_PDB.sqf"] call WC_fnc_compile;
["WC_fnc_randomMinMax", __PATH_FUNCS + "WC_fnc_randomMinMax.sqf"] call WC_fnc_compile;
["WC_fnc_recompile", __PATH_FUNCS + "WC_fnc_recompile.sqf"] call WC_fnc_compile;
["WC_fnc_removeAction", __PATH_FUNCS + "WC_fnc_removeAction.sqf"] call WC_fnc_compile;
["WC_fnc_removeAllActions", __PATH_FUNCS + "WC_fnc_removeAllActions.sqf"] call WC_fnc_compile;
["WC_fnc_removeDuplicates", __PATH_FUNCS + "WC_fnc_removeDuplicates.sqf"] call WC_fnc_compile;
["WC_fnc_removeMissionVehicle", __PATH_FUNCS + "WC_fnc_removeMissionVehicle.sqf"] call WC_fnc_compile;
["WC_fnc_selectRandom", __PATH_FUNCS + "WC_fnc_selectRandom.sqf"] call WC_fnc_compile;
["WC_fnc_setVehicleVarName", __PATH_FUNCS + "WC_fnc_setVehicleVarName.sqf"] call WC_fnc_compile;
["WC_fnc_spawnVehicle", __PATH_FUNCS + "WC_fnc_spawnVehicle.sqf"] call WC_fnc_compile;
["WC_fnc_spawnIntVehicle", __PATH_FUNCS + "WC_fnc_spawnIntVehicle.sqf"] call WC_fnc_compile;
["WC_fnc_sunAngle", __PATH_FUNCS + "WC_fnc_sunAngle.sqf"] call WC_fnc_compile;
["WC_fnc_vehicleReady", __PATH_FUNCS + "WC_fnc_vehicleReady.sqf"] call WC_fnc_compile;

////////////////////////////////////////////////////////////////////////////////
// RESOURCES PARSER
////////////////////////////////////////////////////////////////////////////////
["WC_fnc_enumcfgpatches", __PATH_RESOURCES + "WC_fnc_enumcfgpatches.sqf"] call WC_fnc_compile;
["WC_fnc_enumcompositions", __PATH_RESOURCES + "WC_fnc_enumcompositions.sqf"] call WC_fnc_compile;
["WC_fnc_enumfaction", __PATH_RESOURCES + "WC_fnc_enumfaction.sqf"] call WC_fnc_compile;
["WC_fnc_enummagazines", __PATH_RESOURCES + "WC_fnc_enummagazines.sqf"] call WC_fnc_compile;
["WC_fnc_enummusic", __PATH_RESOURCES + "WC_fnc_enummusic.sqf"] call WC_fnc_compile;
["WC_fnc_enumvehicle", __PATH_RESOURCES + "WC_fnc_enumvehicle.sqf"] call WC_fnc_compile;
["WC_fnc_enumweapons", __PATH_RESOURCES + "WC_fnc_enumweapons.sqf"] call WC_fnc_compile;
["WC_fnc_enumvillages", __PATH_RESOURCES + "WC_fnc_enumvillages.sqf"] call WC_fnc_compile;

////////////////////////////////////////////////////////////////////////////////
// GLOBAL FUNCTIONS
////////////////////////////////////////////////////////////////////////////////
["WC_fnc_addplayerscore", __PATH_FUNCS + "WC_fnc_addplayerscore.sqf"] call WC_fnc_compile;
["WC_fnc_checkpilot", __PATH_FUNCS + "WC_fnc_checkpilot.sqf"] call WC_fnc_compile;
["WC_fnc_clockformat", __PATH_FUNCS + "WC_fnc_clockformat.sqf"] call WC_fnc_compile;
["WC_fnc_copymarker", __PATH_FUNCS + "WC_fnc_copymarker.sqf"] call WC_fnc_compile;
["WC_fnc_copymarkerlocal", __PATH_FUNCS + "WC_fnc_copymarkerlocal.sqf"] call WC_fnc_compile;
["WC_fnc_creategridofposition", __PATH_FUNCS + "WC_fnc_creategridofposition.sqf"] call WC_fnc_compile;
["WC_fnc_createmarker", __PATH_FUNCS + "WC_fnc_createmarker.sqf"] call WC_fnc_compile;
["WC_fnc_createmarkerlocal", __PATH_FUNCS + "WC_fnc_createmarkerlocal.sqf"] call WC_fnc_compile;
["WC_fnc_createcircleposition", __PATH_FUNCS + "WC_fnc_createcircleposition.sqf"] call WC_fnc_compile;
["WC_fnc_createposition", __PATH_FUNCS + "WC_fnc_createposition.sqf"] call WC_fnc_compile;
["WC_fnc_createpositionaround", __PATH_FUNCS + "WC_fnc_createpositionaround.sqf"] call WC_fnc_compile;
["WC_fnc_createpositioninmarker", __PATH_FUNCS + "WC_fnc_createpositioninmarker.sqf"] call WC_fnc_compile;
["WC_fnc_deletemarker", __PATH_FUNCS + "WC_fnc_deletemarker.sqf"] call WC_fnc_compile;
["WC_fnc_exportweaponsplayer", __PATH_FUNCS + "WC_fnc_exportweaponsplayer.sqf"] call WC_fnc_compile;
["WC_fnc_farofpos", __PATH_FUNCS + "WC_fnc_farofpos.sqf"] call WC_fnc_compile;
["WC_fnc_feelwithzero", __PATH_FUNCS + "WC_fnc_feelwithzero.sqf"] call WC_fnc_compile;
["WC_fnc_garbagecollector", __PATH_FUNCS + "WC_fnc_garbagecollector.sqf"] call WC_fnc_compile;
["WC_fnc_gethousespositions", __PATH_FUNCS + "WC_fnc_gethousespositions.sqf"] call WC_fnc_compile;
["WC_fnc_getterraformvariance", __PATH_FUNCS + "WC_fnc_getterraformvariance.sqf"] call WC_fnc_compile;
["WC_fnc_markerhintlocal", __PATH_FUNCS + "WC_fnc_markerhintlocal.sqf"] call WC_fnc_compile;
["WC_fnc_missionname", __PATH_FUNCS + "WC_fnc_missionname.sqf"] call WC_fnc_compile;
["WC_fnc_newdate", __PATH_FUNCS + "WC_fnc_newdate.sqf"] call WC_fnc_compile;
["WC_fnc_playerhint", __PATH_FUNCS + "WC_fnc_playerhint.sqf"] call WC_fnc_compile;
["WC_fnc_refreshmarkers", __PATH_FUNCS + "WC_fnc_refreshmarkers.sqf"] call WC_fnc_compile;
["WC_fnc_relocateposition", __PATH_FUNCS + "WC_fnc_relocateposition.sqf"] call WC_fnc_compile;
["WC_fnc_seed", __PATH_FUNCS + "WC_fnc_seed.sqf"] call WC_fnc_compile;
["WC_fnc_setskill", __PATH_FUNCS + "WC_fnc_setskill.sqf"] call WC_fnc_compile;
["WC_fnc_weaponcanflare", __PATH_FUNCS + "WC_fnc_weaponcanflare.sqf"] call WC_fnc_compile;

////////////////////////////////////////////////////////////////////////////////
// WARCONTEXT STANDALONE MODULES
////////////////////////////////////////////////////////////////////////////////

// HANDLER
["WC_fnc_grouphandler", __PATH_MODULES + "wc_handler\WC_fnc_grouphandler.sqf"] call WC_fnc_compile;
["WC_fnc_vehiclehandler", __PATH_MODULES + "wc_handler\WC_fnc_vehiclehandler.sqf"] call WC_fnc_compile;

////////////////////////////////////////////////////////////////////////////////
// WIT MAIN SCRIPTS
////////////////////////////////////////////////////////////////////////////////
["WC_fnc_eventhandler", __PATH_WARCONTEXT + "WC_fnc_eventhandler.sqf"] call WC_fnc_compile;

// Check if it is a recompile
if (WC_Recompile) exitWith {true};

// Check if machine can continue
if (WC_ModProtection) exitWith {false};

// Wit version
wcversion = 1.60;

// Friendly side
wcside = [west];

// Enemy side
wcenemyside = [east, resistance];

// Limit min of fps on server under no more units will be create for support
wcminfpsonserver = 16;

// Same rights as the admin - PLAYERUID
// 1.62
//wcteammembers = ["16062726"];
// 1.63
wcteammembers = ["76561197972319376"];

// Limit of playable map
switch (toLower worldName) do {
	case "chernarus": {
		wcmaptopright    = [15360,15360,0];
		wcmapbottomleft  = [0,0,0];

		wcmaptopleft     = [0,15360,0];
		wcmapbottomright = [15360,0,0];
	};

	default {
		private ["_x", "_y"];

		_x = getNumber (configFile >> "CfgWorlds" >> worldName >> "Grid" >> "offsetX");
		_y = getNumber (configFile >> "CfgWorlds" >> worldName >> "Grid" >> "offsetY");

		if ((_x == 0) || (_y == 0)) then {
			wcmaptopright    = [12800,12800,0];

			wcmaptopleft     = [0,12800,0];
			wcmapbottomright = [12800,0,0];
		} else {
			wcmaptopright    = [_x,_y,0];

			wcmaptopleft     = [0,_y,0];
			wcmapbottomright = [_x,0,0];
		};

		wcmapbottomleft = [0,0,0];
	};
};

// Position of map center
wcmapcenter = [((wcmaptopright select 0) / 2), ((wcmaptopright select 1) / 2), 0];

// Safe Position where ai, or body can be teleport for wc purpose
wcinitpos = getMarkerPos "initpos";

// Position where pop enemy sea patrol (left bottom corner)
wcseainitpos = [400,400,0];

// Rain max rate of the country - 0 (low) 1 (full)
wcrainrate = 0.65;

// Mortar spawn percent probability (defaut 20%)
wcmortarprobability = 0.5;

// Civilian terrorist percent - depending of lobby parameter (by default 20% hostile)
wcterroristprobability = (wccivilianfame / 100);

// Civilian driver percent (defaut 20%)
wcciviliandriverprobability = 0.2;

// Player can see marker of others player when they are at max x meters
wcplayermarkerdist = 3000;

// Enemy knowsAbout
WC_KnowsAbout = 1.5;

/***************************************************************************************************
***************************************** AMMOBOX WEAPONS *****************************************/
wclistofweapons = [
	// Items ------------------------------------------
	"Binocular","Binocular_Vector","NVGoggles","ItemGPS","ItemMap","ItemCompass","LaserDesignator","ItemRadio",
	"ItemWatch","LRTV_ACR",

	// Unassorted -------------------------------------
	"Pecheneg",

	// Shotgun ----------------------------------------
	"AA12_PMC","M1014","Saiga12K",

	// Pistols ----------------------------------------
	"M9","M9SD","glock17_EP1","Colt1911","revolver_EP1","revolver_gold_EP1","Sa61_EP1","UZI_EP1","UZI_SD_EP1",

	// Anti tank --------------------------------------
	"M136","MAAWS","M47Launcher_EP1","Javelin","BAF_NLAW_Launcher","MetisLauncher","RPG7V","RPG18","SMAW",

	// Anti air ---------------------------------------
	"Stinger","Igla","Strela",

	// AK47 -------------------------------------------
	"AK_47_M","AK_47_S",

	// AKS --------------------------------------------
	"AKS_74","AKS_74_GOSHAWK","AKS_74_kobra","AKS_74_NSPU","AKS_74_pso","AKS_74_U","AKS_74_UN_kobra","AKS_GOLD",

	// AK107 ------------------------------------------
	"AK_107_GL_kobra","AK_107_GL_pso","AK_107_kobra","AK_107_pso",

	// RPK --------------------------------------------
	"PK","RPK_74",

	// Bizon ------------------------------------------
	"bizon","bizon_silenced",

	// M60 --------------------------------------------
	"M60A4_EP1",

	// M16 --------------------------------------------
	"M16A2","M16A2GL","m16a4","m16a4_acg","M16A4_ACG_GL","M16A4_GL",

	// M4 ---------------------------------------------
	"M4A1","M4A1_Aim","M4A1_Aim_camo","M4A1_AIM_SD_camo","M4A1_HWS_GL","M4A1_HWS_GL_camo","M4A1_HWS_GL_SD_Camo",
	"M4A1_RCO_GL","M4A3_CCO_EP1","M4A3_RCO_GL_EP1",

	// M8 ---------------------------------------------
	"m8_carbine","m8_carbine_pmc","m8_carbineGL","m8_compact","m8_compact_pmc","m8_holo_sd","m8_sharpshooter","m8_tws",
	"m8_tws_sd","m8_SAW",

	// SCAR -------------------------------------------
	"SCAR_H_CQC_CCO","SCAR_H_CQC_CCO_SD","SCAR_H_LNG_Sniper","SCAR_H_LNG_Sniper_SD","SCAR_H_STD_EGLM_Spect",
	"SCAR_H_STD_TWS_SD","SCAR_L_CQC","SCAR_L_CQC_CCO_SD","SCAR_L_CQC_EGLM_Holo","SCAR_L_CQC_Holo","SCAR_L_STD_EGLM_RCO",
	"SCAR_L_STD_EGLM_TWS","SCAR_L_STD_HOLO","SCAR_L_STD_Mk4CQT",

	// M14 --------------------------------------------
	"M14_EP1","DMR",

	// M24 --------------------------------------------
	"M24","M24_des_EP1",

	// MK12 -------------------------------------------
	"M4SPR",

	// M240 -------------------------------------------
	"M240","m240_scoped_EP1",

	// M249 -------------------------------------------
	"M249","M249_EP1","M249_m145_EP1","M249_TWS_EP1",

	// Mk48 -------------------------------------------
	"Mk_48","Mk_48_DES_EP1",

	// M107 -------------------------------------------
	"m107","m107_TWS_EP1",

	// M110 -------------------------------------------
	"M110_NVG_EP1","M110_TWS_EP1",

	// BAF --------------------------------------------
	"BAF_L85A2_RIS_ACOG","BAF_L85A2_RIS_CWS","BAF_L85A2_RIS_Holo","BAF_L85A2_RIS_SUSAT","BAF_L85A2_UGL_ACOG",
	"BAF_L85A2_UGL_Holo","BAF_L85A2_UGL_SUSAT","BAF_L86A2_ACOG","BAF_L110A1_Aim","BAF_L7A2_GPMG","BAF_LRR_scoped",
	"BAF_LRR_scoped_W",

	// AS50 -------------------------------------------
	"BAF_AS50_scoped","BAF_AS50_TWS","PMC_AS50_scoped","PMC_AS50_TWS",

	// FN FAL -----------------------------------------
	"FN_FAL","FN_FAL_ANPVS4",

	// SA ---------------------------------------------
	"Sa58P_EP1","Sa58V_CCO_EP1","Sa58V_EP1","Sa58V_RCO_EP1",

	// SVD --------------------------------------------
	"SVD","SVD_CAMO","SVD_des_EP1","SVD_NSPU_EP1",

	// G36 --------------------------------------------
	"G36_C_SD_camo","G36_C_SD_eotech","G36a","G36A_camo","G36C","G36C_camo","G36K","G36K_camo",

	// MG36 -------------------------------------------
	"MG36","MG36_camo",

	// Unsorted ---------------------------------------
	"LeeEnfield","M32_EP1","M79_EP1","Mk13_EP1","huntingrifle","KSVK","M40A3","VSS_vintorez"
];

// Kind of engineer
wcengineerclass = [
	// Force recon
	"FR_Sapper",

	// USMC
	"USMC_SoldierS_Engineer",

	// US Army
	"US_Soldier_Engineer_EP1",

	// BAF
	"BAF_Soldier_EN_W"
];

// Kind of medics
wcmedicclass = [
	// Force recon
	"FR_Corpsman",

	// USMC
	"USMC_Soldier_Medic",

	// US Army
	"US_Soldier_Medic_EP1",

	// BAF
	"BAF_Soldier_Medic_W",

	// RU
	"RU_Soldier_Medic",

	// INS
	"Ins_Soldier_Medic",

	// GUE
	"GUE_Soldier_Medic"
];

// Kind of civils
wccivilclass = [
	"Assistant","Citizen1","Citizen2","Citizen3","Citizen4","Functionary1","Functionary2","Priest","Profiteer1",
	"Profiteer2","Profiteer3","Profiteer4","Rocker1","Rocker2","Rocker3","Rocker4","SchoolTeacher","Villager1",
	"Villager2","Villager3","Villager4","Woodlander1","Woodlander2","Woodlander3","Woodlander4","Worker1","Worker2",
	"Worker3","Worker4","Damsel1","Damsel2","Damsel3","Damsel4","Damsel5","Farmwife1","Farmwife2","Farmwife3",
	"Farmwife4","Farmwife5","Hooker1","Hooker2","Hooker3","Hooker4","Hooker5","HouseWife1","HouseWife2","HouseWife3",
	"HouseWife4","HouseWife5","Madam1","Madam2","Madam3","Madam4","Madam5","Secretary1","Secretary2","Secretary3",
	"Secretary4","Secretary5","Sportswoman1","Sportswoman2","Sportswoman3","Sportswoman4","Sportswoman5","WorkWoman1",
	"WorkWoman2","WorkWoman3","WorkWoman4","WorkWoman5"
];

// Civils without weapons
wccivilwithoutweapons = [
	"Damsel1","Damsel2","Damsel3","Damsel4","Damsel5","Farmwife1","Farmwife2","Farmwife3","Farmwife4","Farmwife5",
	"Hooker1","Hooker2","Hooker3","Hooker4","Hooker5","HouseWife1","HouseWife2","HouseWife3","HouseWife4","HouseWife5",
	"Madam1","Madam2","Madam3","Madam4","Madam5","Secretary1","Secretary2","Secretary3","Secretary4","Secretary5",
	"Sportswoman1","Sportswoman2","Sportswoman3","Sportswoman4","Sportswoman5","WorkWoman1","WorkWoman2","WorkWoman3",
	"WorkWoman4","WorkWoman5"
];

/***************************************************************************************************
***************************************** BLACK LIST UNITS ****************************************/

// Blacklist of enemy units that can pop dynamicly (exclude mission)
wcblacklistenemyclass = [
	// RU
	"RU_Commander","RU_Soldier_Crew","RU_Soldier_Light","RU_Soldier_Pilot",

	// INS
	"Ins_Bardak","Ins_Commander","Ins_Lopotev","Ins_Soldier_Crew","Ins_Soldier_Pilot","Ins_Villager3","Ins_Villager4",
	"Ins_Woodlander1","Ins_Woodlander2","Ins_Woodlander3","Ins_Worker2"
];

// Blacklist units from west side
wcwestblacklist = [
	// FR
	"FR_Commander","FR_Corpsman","FR_Marksman","FR_TL",

	// USMC
	"USMC_SoldierM_Marksman","USMC_SoldierS_Engineer","USMC_SoldierS_Sniper","USMC_SoldierS_SniperH",
	"USMC_SoldierS_Spotter","USMC_Soldier_Crew","USMC_Soldier_Medic","USMC_Soldier_Officer","USMC_Soldier_Pilot",
	"USMC_Soldier_SL","USMC_Soldier_TL",

	// US Army
	"US_Soldier_Crew_EP1","US_Soldier_Engineer_EP1","US_Soldier_Marksman_EP1","US_Soldier_Medic_EP1",
	"US_Soldier_Officer_EP1","US_Soldier_Pilot_EP1","US_Soldier_SL_EP1","US_Soldier_Sniper_EP1",
	"US_Soldier_Sniper_NV_EP1","US_Soldier_SniperH_EP1","US_Soldier_Spotter_EP1","US_Soldier_TL_EP1",

	// BAF
	"BAF_creWman_W","BAF_Pilot_W","BAF_Soldier_EN_W","BAF_Soldier_Marksman_W","BAF_Soldier_Medic_W",
	"BAF_Soldier_Officer_W","BAF_Soldier_SL_W","BAF_Soldier_Sniper_W","BAF_Soldier_SniperH_W","BAF_Soldier_SniperN_W",
	"BAF_Soldier_spotter_W","BAF_Soldier_spotterN_W","BAF_Soldier_TL_W"
];

// Blacklist of vehicles that can pop dynamicly (exclude mission)
wcblacklistenemyvehicleclass = [
	// RU Vehicles
	"2S6M_Tunguska",

	// INS Vehicles
	"ZSU_INS"
];

// Kind of houses - computed village
wcvillagehouses = [
	"Land_House_C_5_V3_EP1","Land_House_C_5_EP1","Land_House_L_8_EP1","Land_House_K_3_EP1","Land_House_C_5_V1_EP1",
	"Land_A_Mosque_small_2_EP1","Land_Wall_L_Mosque_1_EP1","Land_A_Mosque_small_1_EP1","Land_House_L_7_EP1",
	"Land_House_K_5_EP1","Land_House_K_1_EP1","Land_House_L_6_EP1","Land_House_L_9_EP1","Land_House_L_4_EP1",
	"Land_House_L_3_EP1","Land_Wall_L3_5m_EP1"
];

// Special forces
wcspecialforces = [
	// MVD
	"MVD_Soldier","MVD_Soldier_AT","MVD_Soldier_GL","MVD_Soldier_MG","MVD_Soldier_Marksman","MVD_Soldier_Sniper",
	"MVD_Soldier_TL",

	// RUS
	"RUS_Soldier1","RUS_Soldier2","RUS_Soldier3","RUS_Soldier_GL","RUS_Soldier_Marksman","RUS_Soldier_Sab",
	"RUS_Soldier_TL","RUS_Soldier_GL","RUS_Soldier_Marksman","RUS_Soldier_Sab","RUS_Soldier_TL"
];

// Kind of civil for rescue missions
wcrescuecivils = [
	"Citizen1","Citizen2","Citizen3","Citizen4","Functionary1","Functionary2","Rocker1","Rocker2","Rocker3","Rocker4",
	"SchoolTeacher","Damsel1","Damsel2","Damsel3","Damsel4","Hooker1", "Hooker2","Hooker3","Hooker4","Hooker5",
	"Secretary1","Secretary2","Secretary3","Secretary4","Secretary5"
];

// Kind of units crew of enemies vehicles
wccrewforces = ["RU_Soldier_Crew"];

// Kind of dogs
wcdogclass = ["Fin","Pastor"];

// Kind of sheep
wcsheeps = ["Sheep","Sheep01_EP1","Sheep02_EP1"];

// Kind of ied objects
wciedobjects = [
	"Barrel1","Barrel4","Barrel5","Garbage_can","Garbage_container","Land_Barrel_sand","Misc_TyreHeap","Land_Bag_EP1",
	"Land_Canister_EP1","Land_Misc_Garb_Heap_EP1","Land_bags_stack_EP1","Fort_Crate_wood","Barrels"
];

/***************************************************************************************************
*************************************** MAP OBJECTS MISSIONS **************************************/

// Kind of airport hangar
wckindofhangars = ["Land_SS_hangar"];

// Kind of fuel station
wckindoffuelstations = ["Land_A_FuelStation_Feed"];

// Kind of fuel tanks
wckindoffueltanks = ["Land_Ind_TankBig"];

// Kind of barackment
wckindofbarracks = ["Land_Mil_Barracks"];

// Kind of control tower
wckindofcontroltowers = ["Land_Mil_ControlTower"];

// Kind of factory
wckindoffactory = ["Land_A_BuildingWIP"];

// Kind of castle
wckindofcastle = ["Land_A_Castle_Bergfrit"];

// Kind of dam
wckindofdam = ["Land_Dam_Conc_20"];

// Anti air vehicles
wcaavehicles = [
	// RU
	"2S6M_Tunguska",

	// INS
	"ZSU_INS"
];

// Vehicles escorted in convoy
wcconvoyvehicles = [
	"BTR90_HQ","GAZ_Vodnik_MedEvac","Kamaz","KamazOpen","KamazReammo","KamazRefuel","KamazRepair","UralOpen_INS",
	"UralReammo_INS","UralRefuel_INS","UralRepair_INS","Ural_INS","BMP2_Ambul_INS","BMP2_HQ_INS"
];

// Sea patrol
wcseapatrol = ["PBX"];

// Kind of enemies backpack
wcenemybackpack = [
	"TK_ALICE_Pack_EP1","TK_RPG_Backpack_EP1","TK_ALICE_Pack_Explosives_EP1","TK_ALICE_Pack_AmmoMG_EP1",
	"TKG_ALICE_Pack_AmmoAK47_EP1","TKG_ALICE_Pack_AmmoAK74_EP1"
];

// Change clothes - player can be civil
wcchangeclothescivil = [
	"Assistant","Citizen1","Citizen2","Citizen3","Citizen4","Doctor","Functionary1","Functionary2","Pilot","Policeman",
	"Priest","Profiteer1","Profiteer2","Profiteer3","Profiteer4","Rocker1","Rocker2","Rocker3","Rocker4","SchoolTeacher",
	"Villager1","Villager2","Villager3","Villager4","Woodlander1","Woodlander2","Woodlander3","Woodlander4","Worker1",
	"Worker2","Worker3","Worker4"
];

// Change clothes - player can be west
wcchangeclotheswest = ["US_Pilot_Light_EP1"];

// Change clothes - player can be east - add clothes if you want in array
wcchangeclotheseast = [];

wcchangeclothes = wcchangeclothescivil + wcchangeclotheswest + wcchangeclotheseast;

/***************************************************************************************************
****************************************** MISSION ARRAYS *****************************************/

// Friendly vehicles
WC_FriendlyVehicles = [
	// US Land vehicles
	"HMMWV_Armored","HMMWV_M2","HMMWV_MK19","HMMWV_TOW","HMMWV_Avenger","MLRS","AAV","LAV25","M1A1","M1A2_TUSK_MG",

	// US Air vehicles
	"AH1Z","AH64D","AH64D_Sidewinders","AH64D_EP1","MH6J_EP1","AH6J_EP1","UH1Y","MH60S","UH60M_EP1","CH_47F_EP1","MV22"
];

// Friendly jets
WC_FriendlyJets = ["AV8B","AV8B2","F35B","A10_US_EP1"];

// Enemy transports
WC_EnemyTransports = [
	// RU Transports
	"UAZ_RU","Kamaz","KamazOpen",

	// INS Transports
	"UAZ_INS","Ural_INS","UralOpen_INS"
];

// Enemy tanks
WC_EnemyTanks = [
	// RU Tanks
	"T72_RU","ACE_T72B_Base","ACE_T72BA_Base","T90",

	// INS Tanks
	"T72_INS"
];

// Enemy apcs
WC_EnemyApcs = [
	// RU Apcs
	"GAZ_Vodnik","BTR90","BMP3",

	// INS Apcs
	"BRDM2_INS","BMP2_INS"
];

// Enemy helicopters
WC_EnemyHelis = [
	// RU Helicopters
	"Mi17_rockets_RU","Mi24_P","Mi24_V","Ka52","Ka52Black",

	// INS Helicopters
	"Mi17_Ins"
];

// Enemy jets
WC_EnemyJets = [
	// RU Jets
	"Su34","Su39",

	// INS Jets
	"Su25_Ins"
];

// Air patrol type
switch (wcairforcetype) do {
	case 1: {
		wcairpatroltype = [
			// INS Air vehicles
			"Mi17_Ins",

			// PMC Air vehicles
			"Ka60_GL_PMC"
		];
	};

	case 2: {
		wcairpatroltype = [
			// RU Air vehicles
			"Mi17_rockets_RU","Mi24_P","Mi24_V","Ka52","Ka52Black",

			// INS Air vehicles
			"Mi17_Ins",

			// PMC Air vehicles
			"Ka60_GL_PMC"
		];
	};

	case 3: {
		wcairpatroltype = [
			// RU Air vehicles
			"Mi17_rockets_RU","Mi24_P","Mi24_V","Ka52","Ka52Black","Su34",

			// INS Air vehicles
			"Mi17_Ins","Su25_Ins",

			// PMC Air vehicles
			"Ka60_GL_PMC"
		];
	};
};

// Kind of radio tower
wcradiotype = ["RU_WarfareBUAVterminal"];

// Kind of repair point
wcrepairpointtype = ["USMC_WarfareBVehicleServicePoint"];

// Kind of grave
wcgravetype = ["gravecross2_EP1","GraveCrossHelmet_EP1"];

// Terrain ground details 0 (on) - 50 (off)
wcterraingrid = 50;

// Default player view distance
wcviewdist = 3000;

// Alert threshold begin to increase
// When something happens at ... meters of the mission position
wcalertzonesize = 3000;

// Radio appear at x meter distance of goal (min & max)
wcradiodistminofgoal = 150;
wcradiodistmaxofgoal = 300;

// Civils appear at x meter distance of player
wccivildistancepop = 1000;

// Kind of generator
wcgeneratortype = ["PowerGenerator"];

// Generator appear at distance of goal (min & max)
wcgeneratordistminofgoal = 150;
wcgeneratordistmaxofgoal = 300;

// Time in seconds before to garbage dead body
wctimetogarbagedeadbody = 360;

// Time in seconds before to respawn vehicle
wctimetorespawnvehicle = 360;

// Probability of nuclear attack at begining of a mission - default 25%
wcnuclearprobability = 0.75;

// Probability there is a static weapon in bunker - default 30%
wcstaticinbunkerprobability = 0.3;

// Size of area to detect friendly units leave the zone at end of mission
wcleaveareasizeatendofmission = 1000;

// Percent of players that must leave the zone at end of mission (by defaut 20%)
wcleaversatendofmission = 0.2;

// Simulation mode has a harder scoring system
if (wckindofgame == 1) then {
	wcscorelimitmin = -80;
	wcscorelimitmax = 99;
} else {
	wcscorelimitmin = -80;
	wcscorelimitmax = 99;
};

// Threshold of damage to do, for enemy vehicle been damaged
// This variable can affect ACE damaged threshold
switch (wcdamagethreshold) do {
	case 1: {
		wcdammagethreshold = 1;
	};

	case 2: {
		wcdammagethreshold = 0.75;
	};

	case 3: {
		wcdammagethreshold = 0.5;
	};
};

// Patrols use dogs
wcpatrolwithdogs = false;

// Goal cam uses color
wccamgoalwithcolor = true;

// Goal cam turn around goal
wccamgoalanimate = false;

// Ied false positive are off by default
wciedfalsepositive = false;

// Contain all nuclear zone
wcnuclearzone = [];

// Counter of day start at ..
wcday = 1;

// Position of goal zone
wcselectedzone = [0,0,0];

// Radio is alive or not
wcradioalive = true;

// Alert
wcalert = 0;

// Level start at ..
wclevel = 1;

// AI skill
if (wckindofgame == 1) then {
	wccivilianskill = 0.1;
	wcskill = 0.38;
	wcskill = wcskill + (wclevel * 0.02);
} else {
	wccivilianskill = 0.1;
	wcskill = 0.68;
	wcskill = wcskill + (wclevel * 0.02);
};

// Maximun number of groups in town (depending of wcopposingforce lobby parameter)
switch (wcopposingforce) do {
	case 1: {
		wclevelmaxincity = 2;
	};

	case 2: {
		wclevelmaxincity = 4;
	};

	case 3: {
		wclevelmaxincity = 6;
	};

	case 4: {
		wclevelmaxincity = 8;
	};

	case 5: {
		wclevelmaxincity = 10;
	};
};

// Number of enemy killed
wcenemykilled = 0;
wccivilkilled = 0;

// Count number of mission
wcmissioncount = 1;

// Array of all players in team
wcinteam = [];

// Objective informations - don't edit
wcobjectiveindex = 0;
wcobjective = [-1, objNull, 0, "", ""];

// Vehicles avalaible at hq
wcvehicleslistathq = [
	["USMC"],[
		["USMC","M1030"]
	]
];

wccfgpatches = [];

/*
	1.63 fixes
*/

// Choose mission bool
wcchoosemission = false;

// Current hostage
wchostage = objNull;

// Object index
WC_ObjectIndex = 0;

// End of mission flag
wcflag = objNull;

/***************************************************************************************************
********************************************* INFANTRY ********************************************/
if (wcautoloadtroops == 1) then {
	wceastside = [east] call WC_fnc_enumfaction;
	wcresistanceside = [resistance] call WC_fnc_enumfaction;
	wcwestside = [west] call WC_fnc_enumfaction;
} else {
	wceastside = [
		["RU","INS"],[
			// RU
			["RU","RU_Commander"],["RU","RU_Soldier"],["RU","RU_Soldier2"],["RU","RU_Soldier_AA"],["RU","RU_Soldier_AR"],
			["RU","RU_Soldier_AT"],["RU","RU_Soldier_Crew"],["RU","RU_Soldier_GL"],["RU","RU_Soldier_HAT"],
			["RU","RU_Soldier_LAT"],["RU","RU_Soldier_Light"],["RU","RU_Soldier_Marksman"],["RU","RU_Soldier_Medic"],
			["RU","RU_Soldier_MG"],["RU","RU_Soldier_Officer"],["RU","RU_Soldier_Pilot"],["RU","RU_Soldier_SL"],
			["RU","RU_Soldier_Sniper"],["RU","RU_Soldier_SniperH"],["RU","RU_Soldier_Spotter"],["RU","RU_Soldier_TL"],

			// INS
			["INS","Ins_Bardak"],["INS","Ins_Commander"],["INS","Ins_Lopotev"],["INS","Ins_Soldier_1"],
			["INS","Ins_Soldier_2"],["INS","Ins_Soldier_AA"],["INS","Ins_Soldier_AR"],["INS","Ins_Soldier_AT"],
			["INS","Ins_Soldier_CO"],["INS","Ins_Soldier_Crew"],["INS","Ins_Soldier_GL"],["INS","Ins_Soldier_Medic"],
			["INS","Ins_Soldier_MG"],["INS","Ins_Soldier_Pilot"],["INS","Ins_Soldier_Sab"],["INS","Ins_Soldier_Sapper"],
			["INS","Ins_Soldier_Sniper"],["INS","Ins_Villager3"],["INS","Ins_Villager4"],["INS","Ins_Woodlander1"],
			["INS","Ins_Woodlander2"],["INS","Ins_Woodlander3"],["INS","Ins_Worker2"]
		]
	];

	wcresistanceside = [
		["GUE"],[
			["GUE","GUE_Soldier_1"],["GUE","GUE_Soldier_2"],["GUE","GUE_Soldier_3"],["GUE","GUE_Soldier_AA"],
			["GUE","GUE_Soldier_AR"],["GUE","GUE_Soldier_AT"],["GUE","GUE_Soldier_CO"],["GUE","GUE_Soldier_GL"],
			["GUE","GUE_Soldier_MG"],["GUE","GUE_Soldier_Medic"],["GUE","GUE_Soldier_Sab"],["GUE","GUE_Soldier_Scout"],
			["GUE","GUE_Soldier_Sniper"]
		]
	];

	wcwestside = [
		["FR","USMC","USARMY","BAF"],[
			// Force recon
			["FR","FR_AC"],["FR","FR_AR"],["FR","FR_Assault_GL"],["FR","FR_Assault_R"],["FR","FR_Commander"],
			["FR","FR_Corpsman"],["FR","FR_GL"],["FR","FR_Marksman"],["FR","FR_R"],["FR","FR_Sapper"],["FR","FR_TL"],

			// USMC
			["USMC","USMC_Soldier"],["USMC","USMC_Soldier2"],["USMC","USMC_SoldierM_Marksman"],["USMC","USMC_SoldierS"],
			["USMC","USMC_SoldierS_Engineer"],["USMC","USMC_SoldierS_Sniper"],["USMC","USMC_SoldierS_SniperH"],
			["USMC","USMC_SoldierS_Spotter"],["USMC","USMC_Soldier_AA"],["USMC","USMC_Soldier_AR"],
			["USMC","USMC_Soldier_AT"],["USMC","USMC_Soldier_Crew"],["USMC","USMC_Soldier_GL"],["USMC","USMC_Soldier_HAT"],
			["USMC","USMC_Soldier_LAT"],["USMC","USMC_Soldier_MG"],["USMC","USMC_Soldier_Medic"],
			["USMC","USMC_Soldier_Officer"],["USMC","USMC_Soldier_Pilot"],["USMC","USMC_Soldier_SL"],
			["USMC","USMC_Soldier_TL"],

			// US Army
			["USARMY","US_Soldier_AA_EP1"],["USARMY","US_Soldier_AR_EP1"],["USARMY","US_Soldier_AT_EP1"],
			["USARMY","US_Soldier_Crew_EP1"],["USARMY","US_Soldier_Engineer_EP1"],["USARMY","US_Soldier_EP1"],
			["USARMY","US_Soldier_GL_EP1"],["USARMY","US_Soldier_HAT_EP1"],["USARMY","US_Soldier_LAT_EP1"],
			["USARMY","US_Soldier_Marksman_EP1"],["USARMY","US_Soldier_Medic_EP1"],["USARMY","US_Soldier_MG_EP1"],
			["USARMY","US_Soldier_Officer_EP1"],["USARMY","US_Soldier_Pilot_EP1"],["USARMY","US_Soldier_SL_EP1"],
			["USARMY","US_Soldier_Sniper_EP1"],["USARMY","US_Soldier_Sniper_NV_EP1"],["USARMY","US_Soldier_SniperH_EP1"],
			["USARMY","US_Soldier_Spotter_EP1"],["USARMY","US_Soldier_TL_EP1"],

			// BAF
			["BAF","BAF_creWman_W"],["BAF","BAF_Pilot_W"],["BAF","BAF_Soldier_AA_W"],["BAF","BAF_Soldier_AR_W"],
			["BAF","BAF_Soldier_AT_W"],["BAF","BAF_Soldier_EN_W"],["BAF","BAF_Soldier_FAC_W"],["BAF","BAF_Soldier_GL_W"],
			["BAF","BAF_Soldier_HAT_W"],["BAF","BAF_Soldier_Marksman_W"],["BAF","BAF_Soldier_Medic_W"],
			["BAF","BAF_Soldier_MG_W"],["BAF","BAF_Soldier_N_W"],["BAF","BAF_Soldier_Officer_W"],
			["BAF","BAF_Soldier_scout_W"],["BAF","BAF_Soldier_SL_W"],["BAF","BAF_Soldier_Sniper_W"],
			["BAF","BAF_Soldier_SniperH_W"],["BAF","BAF_Soldier_SniperN_W"],["BAF","BAF_Soldier_spotter_W"],
			["BAF","BAF_Soldier_spotterN_W"],["BAF","BAF_Soldier_TL_W"],["BAF","BAF_Soldier_W"]
		]
	];
};

/***************************************************************************************************
********************************************* VEHICLES ********************************************/
if (wcautoloadvehicles == 1) then {
	wcvehicleslistE = [east] call WC_fnc_enumvehicle;
	wcvehicleslistC = [civilian] call WC_fnc_enumvehicle;
	wcvehicleslistW = [west] call WC_fnc_enumvehicle;
	wccompositions = [east] call WC_fnc_enumcompositions;
} else {
	wcvehicleslistE = [
		// RU Vehicles
		"UAZ_AGS30_RU","GAZ_Vodnik","GAZ_Vodnik_HMG","GRAD_RU","2S6M_Tunguska","BTR90","BMP3","T72_RU","T90",

		// INS Vehicles
		"Pickup_PK_INS","UAZ_MG_INS","Offroad_DSHKM_INS","UAZ_AGS30_INS","UAZ_SPG9_INS","Ural_ZU23_INS","GRAD_INS",
		"BRDM2_INS","BRDM2_ATGM_INS","BMP2_INS","ZSU_INS","T72_INS"
	];

	wcvehicleslistweighedE = [
		// RU Vehicles
		[1,"UAZ_AGS30_RU"],[1,"GAZ_Vodnik"],[2,"GAZ_Vodnik_HMG"],[3,"2S6M_Tunguska"],[3,"BTR90"],[3,"BMP3"],[3,"T72_RU"],
		[3,"T90"],

		// INS Vehicles
		[1,"Pickup_PK_INS"],[1,"UAZ_MG_INS"],[1,"Offroad_DSHKM_INS"],[1,"UAZ_AGS30_INS"],[1,"UAZ_SPG9_INS"],
		[1,"ACE_Offroad_SPG9_INS"],[2,"Ural_ZU23_INS"],[2,"BRDM2_INS"],[2,"BRDM2_ATGM_INS"],[3,"BMP2_INS"],[3,"ZSU_INS"],
		[3,"T72_INS"]
	];

	wcvehicleslistC = [
		"Ikarus","Lada1","Lada2","LadaLM","Skoda","SkodaBlue","SkodaGreen","SkodaRed","TT650_Civ","UralCivil","UralCivil2",
		"car_hatchback","car_sedan","datsun1_civil_1_open","datsun1_civil_2_covered","datsun1_civil_3_open",
		"hilux1_civil_1_open","hilux1_civil_2_covered", "hilux1_civil_3_open","tractor","MMT_Civ"
	];

	wcvehicleslistW = [
		["USMC","USARMY","BAF","PMC","RU","INS","GUE","CDF"],[
			// USMC Vehicles
			["USMC","M1030"],["USMC","MMT_USMC"],["USMC","TowingTractor"],["USMC","HMMWV"],["USMC","HMMWV_Ambulance"],
			["USMC","HMMWV_Armored"],["USMC","HMMWV_M2"],["USMC","HMMWV_MK19"],["USMC","HMMWV_TOW"],
			["USMC","HMMWV_Avenger"],["USMC","MTVR"],["USMC","MtvrReammo"],["USMC","MtvrRefuel"],["USMC","MtvrRepair"],
			["USMC","MLRS"],["USMC","AAV"],["USMC","LAV25_HQ"],["USMC","LAV25"],["USMC","M1A1"],

			// USMC Air vehicles
			["USMC","Chukar"],["USMC","CruiseMissile2"],["USMC","MQ9PredatorB"],["USMC","UH1Y"],["USMC","MH60S"],
			["USMC","MV22"],["USMC","C130J"],["USMC","AH1Z"],["USMC","AH64D"],["USMC","AH64D_Sidewinders"],
			["USMC","AV8B"],["USMC","AV8B2"],["USMC","F35B"],

			// US Army vehicles
			["USARMY","M1A2_TUSK_MG"],

			// US Army air vehicles
			["USARMY","MQ9PredatorB_US_EP1"],["USARMY","MH6J_EP1"],["USARMY","AH6X_EP1"],["USARMY","UH60M_EP1"],
			["USARMY","UH60M_MEV_EP1"],["USARMY","CH_47F_EP1"],["USARMY","C130J_US_EP1"],["USARMY","AH64D_EP1"],
			["USARMY","AH6J_EP1"],["USARMY","A10_US_EP1"],

			// BAF Vehicles
			["BAF","BAF_Offroad_W"],["BAF","BAF_FV510_W"],["BAF","BAF_Jackal2_GMG_W"],["BAF","BAF_Jackal2_L2A1_W"],
			["BAF","BAF_Merlin_HC3_D"],["BAF","CH_47F_BAF"],["BAF","AW159_Lynx_BAF"],["BAF","BAF_Apache_AH1_D"],

			// PMC Vehicles
			["PMC","ArmoredSUV_PMC"],["PMC","Ka137_PMC"],["PMC","Ka137_MG_PMC"],["PMC","Ka60_PMC"],["PMC","Ka60_GL_PMC"],

			// RU Vehicles
			["RU","UAZ_RU"],["RU","UAZ_AGS30_RU"],["RU","GAZ_Vodnik_MedEvac"],["RU","GAZ_Vodnik"],["RU","GAZ_Vodnik_HMG"],
			["RU","Kamaz"],["RU","KamazOpen"],["RU","KamazReammo"],["RU","KamazRefuel"],["RU","KamazRepair"],
			["RU","GRAD_RU"],["RU","2S6M_Tunguska"],["RU","BTR90_HQ"],["RU","BTR90"],["RU","BMP3"],["RU","T72_RU"],
			["RU","T90"],

			// RU Air vehicles
			["RU","Pchela1T"],["RU","Mi17_rockets_RU"],["RU","Mi17_medevac_RU"],["RU","Mi24_P"],["RU","Mi24_V"],
			["RU","Ka52"],["RU","Ka52Black"],["RU","Su34"],["RU","Su39"],

			// INS Vehicles
			["INS","TT650_Ins"],["INS","UAZ_INS"],["INS","Pickup_PK_INS"],["INS","UAZ_MG_INS"],["INS","Offroad_DSHKM_INS"],
			["INS","UAZ_AGS30_INS"],["INS","UAZ_SPG9_INS"],["INS","Ural_INS"],["INS","UralOpen_INS"],["INS","UralReammo_INS"],
			["INS","UralRefuel_INS"],["INS","UralRepair_INS"],["INS","Ural_ZU23_INS"],["INS","GRAD_INS"],["INS","BRDM2_INS"],
			["INS","BRDM2_ATGM_INS"],["INS","BMP2_Ambul_INS"],["INS","BMP2_HQ_INS"],["INS","BMP2_INS"],["INS","ZSU_INS"],
			["INS","T72_INS"],

			// INS Air vehicles
			["INS","Mi17_Ins"],["INS","Mi17_medevac_Ins"],["INS","Su25_Ins"],

			// GUE Vehicles
			["GUE","TT650_Gue"],["GUE","Pickup_PK_GUE"],["GUE","Offroad_DSHKM_Gue"],["GUE","Offroad_SPG9_Gue"],
			["GUE","V3S_Gue"],["GUE","Ural_ZU23_Gue"],["GUE","BRDM2_HQ_Gue"],["GUE","BRDM2_Gue"],["GUE","T34"],
			["GUE","BMP2_Gue"],["GUE","T72_Gue"],

			// CDF Vehicles
			["CDF","UAZ_CDF"],["CDF","UAZ_MG_CDF"],["CDF","UAZ_AGS30_CDF"],["CDF","UralOpen_CDF"],["CDF","Ural_CDF"],
			["CDF","UralReammo_CDF"],["CDF","UralReammo_INS"],["CDF","UralRefuel_CDF"],["CDF","UralRepair_CDF"],
			["CDF","Ural_ZU23_CDF"],["CDF","GRAD_CDF"],["CDF","BRDM2_CDF"],["CDF","BRDM2_ATGM_CDF"],["CDF","ZSU_CDF"],
			["CDF","BMP2_Ambul_CDF"],["CDF","BMP2_HQ_CDF"],["CDF","BMP2_CDF"],["CDF","T72_CDF"],

			// CDF Air vehicles
			["CDF","Mi17_CDF"],["CDF","Mi17_medevac_CDF"],["CDF","Mi24_D"],["CDF","Su25_CDF"]
		]
	];

	wccompositions = [
		"bunkerMedium01","bunkerMedium02","bunkerMedium03","bunkerMedium04","bunkerSmall01","camp_ins1","camp_ins2",
		"citybase01","citybase02","citybase03","cityBase04","guardpost_cdf","guardpost_us","SmallTentCamp_napa",
		"SmallTentCamp2_napa"
	];
};

nil
