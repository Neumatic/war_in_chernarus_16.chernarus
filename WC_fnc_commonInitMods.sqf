/*
	Author: Neumatic
	Description: File used for adding mods.

	Parameter(s):
		nil

	Example(s):
		[] call WC_fnc_commonInitMods;

	Returns:
		nil
*/

if (WC_ModProtection) exitWith {nil};

BWMod_Mod = false;
if (isClass (configFile >> "CfgPatches" >> "bwmod_ace")) then {
	BWMod_Mod = true;
};

/*
	Ammobox weapons.
*/
ACE_ListOfWeapons = [
	// Items ------------------------------------------
	"ACE_MX2A","ACE_Earplugs","ACE_Rangefinder_OD","ACE_YardAge450","ACE_HuntIR_monitor","ACE_Kestrel4500",
	"ACE_SpareBarrel","ACE_SpottingScope","ACE_SOFLAMTripod",

	// Unassorted -------------------------------------
	"ace_arty_rangeTable_2b14_legacy","ace_arty_rangeTable_base","ace_arty_rangeTable_d30_legacy",
	"ace_arty_rangeTable_m119","ace_arty_rangeTable_m119_legacy","ace_arty_rangeTable_m224_legacy",
	"ace_arty_rangeTable_m252_legacy","ACE_DAGR","ACE_GlassesBlackSun","ACE_GlassesBlueSun","ACE_GlassesGreenSun",
	"ACE_GlassesRedSun","ACE_GlassesBalaklava","ACE_GlassesBalaklavaGray","ACE_GlassesBalaklavaOlive",
	"ACE_GlassesGasMask_RU","ACE_GlassesGasMask_US","ACE_GlassesLHD_glasses","ACE_GlassesSunglasses","ACE_GlassesTactical",
	"ACE_KeyCuffs","ACE_Map","ACE_Map_Tools","ACE_MineMarkers","ACE_WireCutter","ACE_Arty_AimingPost_M1A2_M58",
	"ACE_Arty_AimingPost_M1A2_M59","ACE_Arty_M1A1_Collimator","ACE_JerryCan_Dummy_15","ACE_RMG","ACE_RSHG1",
	"ACE_Knicklicht_Proxy","ACE_SearchMirror","ACE_TT","ACE_Minedetector_US","ACE_MugLite","ACE_SniperTripod",
	"ACE_TacticalLadder_Pack",

	// Shotgun ----------------------------------------
	"ACE_M1014_Eotech","ACE_SPAS12",

	// Pistols ----------------------------------------
	"ACE_Flaregun","ACE_Glock18","ACE_L9A1","ACE_P226","ACE_P8","ACE_USP","ACE_USPSD","ACE_KAC_PDW","ACE_M3A1",

	// Anti tank --------------------------------------
	"ACE_Javelin_CLU","ACE_M136_CSRS","ACE_M72","ACE_M72A2","ACE_RPG22","ACE_RPG27","ACE_RPG29","ACE_RPG7V_PGO7","ACE_RPOM",

	// AK74 -------------------------------------------
	"AK_74","AK_74_GL","AK_74_GL_kobra","ACE_AK74M",

	// AK74M ------------------------------------------
	"ACE_AK74M_1P29","ACE_AK74M_1P78","ACE_AK74M_1P78_FL","ACE_AK74M_FL","ACE_AK74M_GL","ACE_AK74M_GL_1P29",
	"ACE_AK74M_GL_1P78","ACE_AK74M_GL_Kobra","ACE_AK74M_GL_NSPU","ACE_AK74M_GL_PSO","ACE_AK74M_GL_TWS","ACE_AK74M_Kobra",
	"ACE_AK74M_Kobra_FL","ACE_AK74M_NSPU","ACE_AK74M_NSPU_FL","ACE_AK74M_PSO","ACE_AK74M_PSO_FL","ACE_AK74M_SD",
	"ACE_AK74M_SD_1P78","ACE_AK74M_SD_Kobra","ACE_AK74M_SD_NSPU","ACE_AK74M_SD_PSO","ACE_AK74M_SD_TWS","ACE_AK74M_TWS",
	"ACE_AK74M_TWS_FL",

	// AKM --------------------------------------------
	"ACE_AKM","ACE_AKM_GL","ACE_AKMS","ACE_AKMS_SD",

	// AKS74 ------------------------------------------
	"ACE_AKS74_GP25","ACE_AKS74_UN","ACE_AKS74P","ACE_AKS74P_1P29","ACE_AKS74P_GL","ACE_AKS74P_GL_1P29",
	"ACE_AKS74P_GL_Kobra","ACE_AKS74P_GL_PSO","ACE_AKS74P_Kobra","ACE_AKS74P_PSO",

	// AK103 ------------------------------------------
	"ACE_AK103","ACE_AK103_1P29","ACE_AK103_GL","ACE_AK103_GL_1P29","ACE_AK103_GL_Kobra","ACE_AK103_GL_PSO",
	"ACE_AK103_Kobra","ACE_AK103_PSO",

	// AK104 ------------------------------------------
	"ACE_AK104","ACE_AK104_1P29","ACE_AK104_Kobra","ACE_AK104_PSO",

	// AK105 ------------------------------------------
	"ACE_AK105","ACE_AK105_1P29","ACE_AK105_Kobra","ACE_AK105_PSO",

	// AEK -----------BROKEN ACCORDING TO ACE SITE IGNORE---------------------------------
	/*
	"ACE_AEK_971","ACE_AEK_971_1p63","ACE_AEK_971_1p78","ACE_AEK_971_1pn100","ACE_AEK_971_gp","ACE_AEK_971_gp_1p63",
	"ACE_AEK_971_shahin","ACE_AEK_971_tgp_cln","ACE_AEK_973s","ACE_AEK_973s_1p63","ACE_AEK_973s_1p78",
	"ACE_AEK_973s_1pn100","ACE_AEK_973s_gp","ACE_AEK_973s_gp_1p63","ACE_AEK_973s_shahin","ACE_AEK_973s_tgp_cln",
	*/

	// RPK --------------------------------------------
	"ACE_RPK","ACE_RPK74M","ACE_RPK74M_1P29",

	// Groza ------------------------------------------
	"ACE_gr1","ACE_gr1sd","ACE_gr1sdsp","ACE_gr1sp","ACE_oc14","ACE_oc14gl","ACE_oc14glsp","ACE_oc14sd","ACE_oc14sdsp",
	"ACE_oc14sp",

	// Makarov ----------------------------------------
	"ACE_APS","ACE_APSB",

	// M60 --------------------------------------------
	"ACE_M60",

	// M16 --------------------------------------------
	"ACE_m16a2_scope","ACE_m16a2gl_scope","ACE_M16A4_CCO_GL","ACE_M16A4_EOT","ACE_M16A4_EOT_GL","ACE_M16A4_Iron",

	// M4 ---------------------------------------------
	"ACE_M4","ACE_M4_ACOG","ACE_M4_ACOG_PVS14","ACE_M4_Aim","ACE_M4_AIM_GL","ACE_M4_C","ACE_M4_Eotech","ACE_M4_Eotech_GL",
	"ACE_M4_GL","ACE_M4_RCO_GL","ACE_M4A1_ACOG","ACE_M4A1_ACOG_PVS14","ACE_M4A1_ACOG_SD","ACE_M4A1_AIM_GL",
	"ACE_M4A1_AIM_GL_SD","ACE_M4A1_Aim_SD","ACE_M4A1_C","ACE_M4A1_EOT_SD","ACE_M4A1_Eotech","ACE_M4A1_GL","ACE_M4A1_GL_SD",
	"ACE_M4A1_RCO2_GL","ACE_M4A1_RCO_GL","ACE_SOC_M4A1","ACE_SOC_M4A1_Aim","ACE_SOC_M4A1_AIM_SD","ACE_SOC_M4A1_EOT_SD",
	"ACE_SOC_M4A1_Eotech","ACE_SOC_M4A1_Eotech_4x","ACE_SOC_M4A1_GL","ACE_SOC_M4A1_GL_13","ACE_SOC_M4A1_GL_AIMPOINT",
	"ACE_SOC_M4A1_GL_EOTECH","ACE_SOC_M4A1_GL_SD","ACE_SOC_M4A1_RCO_GL","ACE_SOC_M4A1_SD_9","ACE_SOC_M4A1_SHORTDOT",
	"ACE_SOC_M4A1_SHORTDOT_SD","ACE_SOC_M4A1_TWS",

	// HK416 & 417 ------------------------------------
	"ACE_HK416_D10","ACE_HK416_D10_AIM","ACE_HK416_D10_COMPM3","ACE_HK416_D10_COMPM3_SD","ACE_HK416_D10_Holo",
	"ACE_HK416_D10_M320","ACE_HK416_D10_SD","ACE_HK416_D14","ACE_HK416_D14_ACOG_PVS14","ACE_HK416_D14_COMPM3",
	"ACE_HK416_D14_COMPM3_M320","ACE_HK416_D14_SD","ACE_HK416_D14_TWS","ACE_HK417_Eotech_4x","ACE_HK417_leupold",
	"ACE_HK417_micro","ACE_HK417_Shortdot",

	// SCAR -------------------------------------------
	"ACE_SCAR_H_STD_Spect",

	// M14 --------------------------------------------
	"ACE_M14_ACOG",

	// MK12 -------------------------------------------
	"ACE_M4SPR_SD","ACE_Mk12mod1","ACE_Mk12mod1_SD",

	// M240 -------------------------------------------
	"ACE_M240B","ACE_M240L","ACE_M240L_M145",

	// M249 -------------------------------------------
	"ACE_M249_AIM","ACE_M249_PIP_ACOG",

	// M27 IAR ----------------------------------------
	"ACE_M27_IAR","ACE_M27_IAR_ACOG","ACE_M27_IAR_CCO",

	// M109 -------------------------------------------
	"ACE_M109",

	// M110 -------------------------------------------
	"ACE_M110","ACE_M110_SD",

	// BAF --------------------------------------------
	"ACE_BAF_L7A2_GPMG",

	// AS50 -------------------------------------------
	"ACE_AS50",

	// G3 ---------------------------------------------
	"ACE_G3A3","ACE_G3A3_RSAS","ACE_G3SG1",

	// MP5 & MP7 --------------------------------------
	"ACE_MP5A4","ACE_MP5A5","ACE_MP5SD","ACE_MP7","ACE_MP7_RSAS",

	// SVD --------------------------------------------
	"ACE_SVD_Bipod",

	// TAC50 ------------------------------------------
	"ACE_TAC50","ACE_TAC50_SD",

	// SKS --------------------------------------------
	"ACE_SKS","ACE_SSVZ",

	// UMP --------------------------------------------
	"ACE_UMP45","ACE_UMP45_AIM","ACE_UMP45_AIM_SD","ACE_UMP45_SD",

	// AS Val -----------------------------------------
	"ACE_Val","ACE_Val_Kobra","ACE_Val_PSO",

	// G36 --------------------------------------------
	"ACE_G36A1_AG36A1","ACE_G36A1_AG36A1_D","ACE_G36A2","ACE_G36A2_AG36A2","ACE_G36A2_Bipod","ACE_G36A2_Bipod_D",
	"ACE_G36A2_D","ACE_G36K_EOTech","ACE_G36K_EOTech_D","ACE_G36K_iron","ACE_G36K_iron_D",

	// MG36 -------------------------------------------
	"ACE_MG36","ACE_MG36_D"
];

BW_ListOfWeapons = [
	"BWMod_VectorIV","BWMod_MG3","BWMod_MG4","BWMod_MG4_Scope","BWMod_PzF"
];

[wclistofweapons, ACE_ListOfWeapons] call WC_fnc_arrayPushStack;

if (BWMod_Mod) then {
	[wclistofweapons, BW_ListOfWeapons] call WC_fnc_arrayPushStack;
};

/*
	Kind of engineers.
*/
ACE_EngineerClass = [
	// RU
	"ACE_RU_Soldier_Engineer",

	// INS
	"ACE_INS_Soldier_Engineer",

	// GUE
	"ACE_GUE_Soldier_Engineer"
];

BW_EngineerClass = [
	"BWMod_EngineerG"
];

[wcengineerclass, ACE_EngineerClass] call WC_fnc_arrayPushStack;

if (BWMod_Mod) then {
	[wcengineerclass, BW_EngineerClass] call WC_fnc_arrayPushStack;
};

/*
	Kind of medics.
*/
ACE_MedicClass = [
	"ACE_RUS_Soldier_Medic"
];

BW_MedicClass = [
	"BWMod_MedicG"
];

[wcmedicclass, ACE_MedicClass] call WC_fnc_arrayPushStack;

if (BWMod_Mod) then {
	[wcmedicclass, BW_MedicClass] call WC_fnc_arrayPushStack;
};

/*
	Blacklist enemy units.
*/
ACE_BlacklistEnemyClass = [
	"ACE_SoldierE_AGS","ACE_SoldierE_AGSAB","ACE_SoldierE_AGSAG","ACE_SoldierE_HMG","ACE_SoldierE_HMGAB",
	"ACE_SoldierE_HMGAG","ACE_SoldierE_KonkursAG","ACE_SoldierE_KonkursG"
];

[wcblacklistenemyclass, ACE_BlacklistEnemyClass] call WC_fnc_arrayPushStack;

/*
	Blacklist friendly units
*/
BW_WestBlacklist = [
	"BWMod_MedicG","BWMod_CrewG","BWMod_CrewG_Beret","BWMod_EngineerG","BWMod_MGunnerG_MG3_2","BWMod_MGunnerG_MG4_2",
	"BWMod_SquadLeaderG"
];

if (BWMod_Mod) then {
	[wcwestblacklist, BW_WestBlacklist] call WC_fnc_arrayPushStack;
};

/*
	Blacklist enemy vehicles.
*/
ACE_BlacklistEnemyVehicleClass = [
	"ACE_ZSU_RU"
];

[wcblacklistenemyvehicleclass, ACE_BlacklistEnemyVehicleClass] call WC_fnc_arrayPushStack;

/*
	Special forces.
*/
ACE_SpecialForces = [
	// MVD
	"ACE_MVD_Soldier_RPOM",

	// RUS
	"ACE_RUS_Soldier_Medic","ACE_RUS_Soldier_RPOM"
];

[wcspecialforces, ACE_SpecialForces] call WC_fnc_arrayPushStack;

/*
	Anti air vehicles.
*/
ACE_AAVehicles = [
	"ACE_ZSU_RU"
];

[wcaavehicles, ACE_AAVehicles] call WC_fnc_arrayPushStack;

/*
	Vehicles escorted in convoy.
*/
ACE_ConvoyVehicles = [
	"ACE_Ural_RU","ACE_UralOpen_RU","ACE_BRDM2_HQ_RU"
];

[wcconvoyvehicles, ACE_ConvoyVehicles] call WC_fnc_arrayPushStack;

/*
	Friendly vehicles.
*/
ACE_FriendlyVehicles = [
	// US Land vehicles
	"ACE_HMMWV_GMV","ACE_HMMWV_GMV_MK19","ACE_Truck5t","ACE_Truck5tMG","ACE_Truck5tMGOpen","ACE_Truck5tOpen","ACE_M113A3",
	"ACE_Vulcan","ACE_Stryker_ICV_M2","ACE_Stryker_ICV_M2_SLAT","ACE_Stryker_ICV_MK19","ACE_Stryker_ICV_MK19_SLAT",
	"ACE_Stryker_TOW","ACE_Stryker_TOW_MG","ACE_Stryker_TOW_Slat","ACE_Stryker_TOW_MG_Slat","ACE_Stryker_MGS",
	"ACE_Stryker_MGS_Slat","ACE_M2A2_W","ACE_M2A3_W","ACE_M6A1_W","ACE_M1A1HC_TUSK","ACE_M1A1HC_TUSK_CSAMM",
	"ACE_M1A1_NATO","ACE_M1A1HA_TUSK","ACE_M1A1HA_TUSK_CSAMM",

	// US Air vehicles
	"ACE_AH1W_AGM_W","ACE_AH1W_TOW_TOW_W","ACE_AH1W_TOW_W","ACE_AH1Z_AGM_AGM_W","ACE_AH1W_AGM_D","ACE_AH1W_TOW_D",
	"ACE_AH1W_TOW_TOW_D","ACE_AH1Z_AGM_AGM_D","ACE_AH1Z_AGM_D","ACE_AH6J_DAGR_FLIR"
];

[WC_FriendlyVehicles, ACE_FriendlyVehicles] call WC_fnc_arrayPushStack;

/*
	Enemy tanks.
*/
ACE_EnemyTanks = [
	// RU
	"ACE_T90A",

	// INS
	"ACE_T72B_INS"
];

[WC_EnemyTanks, ACE_EnemyTanks] call WC_fnc_arrayPushStack;

/*
	Enemy apcs.
*/
ACE_EnemyApcs = [
	// RU
	"ACE_BRDM2_RU","ACE_BTR70_RU","ACE_BMD_1_RU","ACE_BMD_1P_RU","ACE_BMD_2_RU","ACE_BMD_2K_RU","ACE_BMP2_RU","ACE_BMP2D_RU",

	// INS
	"ACE_BTR70_INS","ACE_BMD_2_INS"
];

[WC_EnemyApcs, ACE_EnemyApcs] call WC_fnc_arrayPushStack;

/*
	Enemy helicopters.
*/
ACE_EnemyHelis = [
	// RU
	"Mi17_rockets_RU","Mi24_P","Mi24_V","Ka52","Ka52Black",

	// INS
	"ACE_Mi24_D_INS"
];

[WC_EnemyHelis, ACE_EnemyHelis] call WC_fnc_arrayPushStack;

/*
	Enemy jets.
*/
ACE_EnemyJets = [
	// RU
	"ACE_L39_RU","ACE_L39_RU_BO","ACE_Su27_CAP","ACE_Su27_CAS","ACE_Su27_CASP","ACE_Su30","ACE_Su34_MR"
];

[WC_EnemyJets, ACE_EnemyJets] call WC_fnc_arrayPushStack;

/*
	Air patrol vehicles.
*/
switch (wcairforcetype) do {
	case 1: {
		ACE_AirPatrolType = [
			// RU
			"ACE_Mi17_RU"
		];
	};

	case 2: {
		ACE_AirPatrolType = [
			// RU
			"ACE_Mi17_RU","ACE_Mi24_V_FAB250_RU","ACE_Mi24_V_UPK23_RU","ACE_Ka50",

			// INS
			"ACE_Mi24_D_INS"
		];
	};

	case 3: {
		ACE_AirPatrolType = [
			// RU
			"ACE_Mi17_RU","ACE_Mi24_V_FAB250_RU","ACE_Mi24_V_UPK23_RU","ACE_Ka50","ACE_Su27_CAP","ACE_Su27_CAS",
			"ACE_Su27_CASP","ACE_Su30","ACE_Su34_MR",

			// INS
			"ACE_Mi24_D_INS"
		];
	};
};

[wcairpatroltype, ACE_AirPatrolType] call WC_fnc_arrayPushStack;

/*
	Infantry east.
*/
ACE_EastSide = [
	["RU","INS"],[
		// RU
		["RU","ACE_RU_Soldier_Engineer"],["RU","ACE_RU_Soldier_RPOM"],["RU","ACE_SoldierE_AGS"],["RU","ACE_SoldierE_AGSAB"],
		["RU","ACE_SoldierE_AGSAG"],["RU","ACE_SoldierE_HMG"],["RU","ACE_SoldierE_HMGAB"],["RU","ACE_SoldierE_HMGAG"],
		["RU","ACE_SoldierE_KonkursAG"],["RU","ACE_SoldierE_KonkursG"],

		// INS
		["INS","ACE_INS_Soldier_Engineer"],["INS","ACE_Ins_Soldier_RPG"]
	]
];

[wceastside select 1, ACE_EastSide select 1] call WC_fnc_arrayPushStack;

/*
	Infantry resistance.
*/
ACE_ResistanceSide = [
	["GUE"],[
		["GUE","ACE_GUE_Soldier_RPG"]
	]
];

[wcresistanceside select 1, ACE_ResistanceSide select 1] call WC_fnc_arrayPushStack;

/*
	Infantry west.
*/
ACE_WestSide = [
	["FR","USMC","USARMY"],[
		// Force recon
		["FR","ACE_FR_MG"],

		// USMC
		["USMC","ACE_USMC_Soldier_TAR"]
	]
];

BW_WestSide = [
	["GER"],[
		["GER","BWMod_AASoldierG"],["GER","BWMod_ATSoldierG"],["GER","BWMod_MedicG"],["GER","BWMod_CrewG"],
		["GER","BWMod_CrewG_Beret"],["GER","BWMod_MGunnerG_MG3"],["GER","BWMod_MGunnerG_MG3_2"],["GER","BWMod_RiflemanG"],
		["GER","BWMod_EngineerG"],["GER","BWMod_GrenadierG"],["GER","BWMod_MGunnerG_MG4"],["GER","BWMod_MGunnerG_MG4_2"],
		["GER","BWMod_SquadLeaderG"]
	]
];

[wcwestside select 1, ACE_WestSide select 1] call WC_fnc_arrayPushStack;

if (BWMod_Mod) then {
	[wcwestside select 0, BW_WestSide select 0] call WC_fnc_arrayPushStack;
	[wcwestside select 1, BW_WestSide select 1] call WC_fnc_arrayPushStack;
};

/*
	Vehicles east.
*/
ACE_VehiclesListE = [
	// RU Vehicles
	"ACE_UAZ_MG_RU","ACE_Ural_ZU23_RU","ACE_BRDM2_RU","ACE_BRDM2_ATGM_RU","ACE_BTR70_RU","ACE_ZSU_RU","ACE_BMD_1_RU",
	"ACE_BMD_1P_RU","ACE_BMD_2_RU","ACE_BMD_2K_RU","ACE_BMP2_RU","ACE_BMP2D_RU","ACE_T72B_Base","ACE_T72BA_Base","ACE_T90A",

	// INS Vehicles
	"ACE_Offroad_SPG9_INS","ACE_BRDM2_SA9_INS","ACE_BTR70_INS","ACE_BMD_2_INS","ACE_T72B_INS"
];

[wcvehicleslistE, ACE_VehiclesListE] call WC_fnc_arrayPushStack;

/*
	Vehicles east weighed.
*/
ACE_VehiclesListWeighedE = [
	// RU Vehicles
	[1,"ACE_UAZ_MG_RU"],[2,"ACE_Ural_ZU23_RU"],[2,"ACE_BRDM2_RU"],[2,"ACE_BRDM2_ATGM_RU"],[2,"ACE_BTR70_RU"],
	[3,"ACE_ZSU_RU"],[2,"ACE_BMD_1_RU"],[2,"ACE_BMD_1P_RU"],[2,"ACE_BMD_2_RU"],[2,"ACE_BMD_2K_RU"],[3,"ACE_BMP2_RU"],
	[3,"ACE_BMP2D_RU"],[3,"ACE_T72B_Base"],[3,"ACE_T72BA_Base"],[3,"ACE_T90A"],

	// INS Vehicles
	[1,"ACE_Offroad_SPG9_INS"],[2,"ACE_BRDM2_SA9_INS"],[2,"ACE_BTR70_INS"],[2,"ACE_BMD_2_INS"],[3,"ACE_T72B_INS"]
];

[wcvehicleslistweighedE, ACE_VehiclesListWeighedE] call WC_fnc_arrayPushStack;

/*
	Vehicles west.
*/
ACE_VehiclesListW = [
	["USMC","USARMY","BAF","PMC","RU","INS","GUE","CDF"],[
		// USMC Vehicles
		["USMC","ACE_BCS_HMMV_WOODLAND"],["USMC","ACE_MTVRReammo"],["USMC","ACE_MTVRRefuel"],["USMC","ACE_MTVRRepair"],
		["USMC","ACE_M1A1HC_TUSK"],["USMC","ACE_M1A1HC_TUSK_CSAMM"],

		// USMC Air vehicles
		["USMC","ACE_AH1W_AGM_W"],["USMC","ACE_AH1W_TOW_TOW_W"],["USMC","ACE_AH1W_TOW_W"],["USMC","ACE_AH1Z_AGM_AGM_W"],
		["USMC","ACE_AH1W_AGM_D"],["USMC","ACE_AH1W_TOW_D"],["USMC","ACE_AH1W_TOW_TOW_D"],["USMC","ACE_AH1Z_AGM_AGM_D"],
		["USMC","ACE_AH1Z_AGM_D"],

		// US Army vehicles
		["USARMY","ACE_HMMWV_GMV"],["USARMY","ACE_HMMWV_GMV_MK19"],["USARMY","ACE_Truck5t"],["USARMY","ACE_Truck5tMG"],
		["USARMY","ACE_Truck5tMGOpen"],["USARMY","ACE_Truck5tOpen"],["USARMY","ACE_M113A3"],["USARMY","ACE_Vulcan"],
		["USARMY","ACE_Stryker_RV"],["USARMY","ACE_Stryker_RV_SLAT"],["USARMY","ACE_Stryker_ICV_M2"],
		["USARMY","ACE_Stryker_ICV_M2_SLAT"],["USARMY","ACE_Stryker_ICV_MK19"],["USARMY","ACE_Stryker_ICV_MK19_SLAT"],
		["USARMY","ACE_Stryker_TOW"],["USARMY","ACE_Stryker_TOW_MG"],["USARMY","ACE_Stryker_TOW_Slat"],
		["USARMY","ACE_Stryker_TOW_MG_Slat"],["USARMY","ACE_Stryker_MGS"],["USARMY","ACE_Stryker_MGS_Slat"],
		["USARMY","ACE_M2A2_W"],["USARMY","ACE_M2A3_W"],["USARMY","ACE_M6A1_W"],["USARMY","ACE_M1A1_NATO"],
		["USARMY","ACE_M1A1HA_TUSK"],["USARMY","ACE_M1A1HA_TUSK_CSAMM"],

		// US Army air vehicles
		["USARMY","ACE_MQ8B_cargo"],["USARMY","ACE_HC130_N"],["USARMY","ACE_AH6J_DAGR_FLIR"],["USARMY","ACE_MQ8B_hellfire"],
		["USARMY","ACE_A10_CBU87"],["USARMY","ACE_A10_Mk82"],

		// RU Vehicles
		["RU","ACE_UAZ_MG_RU"],["RU","ACE_Ural_ZU23_RU"],["RU","ACE_BRDM2_HQ_RU"],["RU","ACE_BRDM2_RU"],
		["RU","ACE_BRDM2_ATGM_RU"],["RU","ACE_BTR70_RU"],["RU","ACE_ZSU_RU"],["RU","ACE_BMD_1_RU"],["RU","ACE_BMD_1P_RU"],
		["RU","ACE_BMD_2_RU"],["RU","ACE_BMD_2K_RU"],["RU","ACE_BMP2_RU"],["RU","ACE_BMP2D_RU"],["RU","ACE_T72B_Base"],
		["RU","ACE_T72BA_Base"],["RU","ACE_T90A"],

		// RU Air vehicles
		["RU","ACE_Mi17_RU"],["RU","ACE_Mi24_V_FAB250_RU"],["RU","ACE_Mi24_V_UPK23_RU"],["RU","ACE_Ka50"],
		["RU","ACE_L39_RU"],["RU","ACE_L39_RU_BO"],["RU","ACE_Su27_CAP"],["RU","ACE_Su27_CAS"],["RU","ACE_Su27_CASP"],
		["RU","ACE_Su30"],["RU","ACE_Su34_MR"],

		// INS Vehicles
		["INS","ACE_Offroad_SPG9_INS"],["INS","ACE_BRDM2_SA9_INS"],["INS","ACE_BTR70_INS"],["INS","ACE_BMD_2_INS"],
		["INS","ACE_T72B_INS"],

		// INS Air vehicles
		["INS","ACE_Mi24_D_INS"],

		// CDF Vehicles
		["CDF","ACE_BRDM2_SA9_CDF"],["CDF","ACE_BTR70_CDF"],["CDF","ACE_BMD_1_CDF"],["CDF","ACE_BMD_2_CDF"],
		["CDF","ACE_T72B_CDF"],

		// CDF Air vehicles
		["CDF","ACE_Mi24_V_CDF"],["CDF","ACE_Mi24_V_FAB250_CDF"],["CDF","ACE_Mi24_V_UPK23_CDF"]
	]
];

BW_VehiclesListW = [
	["GER"],[
		// GER Vehicles
		["GER","BWMod_LKW5t_Ammo"],["GER","BWMod_LKW5t_Fuel"],["GER","BWMod_LKW5t_Repair"],["GER","BWMod_Fuchs"],
		["GER","BWMod_Fuchs_ArmoredTurret"],["GER","BWMod_Fuchs_BAT"],["GER","BWMod_Wiesel2_Ozelot"],
		["GER","BWMod_Marder_1A5"],["GER","BWMod_Leopard_2A6"],

		// GER Air vehicles
		["GER","BWMod_UH1D"],["GER","BWMod_UH1D_SAR"]
	]
];

[wcvehicleslistW select 1, ACE_VehiclesListW select 1] call WC_fnc_arrayPushStack;

if (BWMod_Mod) then {
	[wcvehicleslistW select 0, BW_VehiclesListW select 0] call WC_fnc_arrayPushStack;
	[wcvehicleslistW select 1, BW_VehiclesListW select 1] call WC_fnc_arrayPushStack;
};

nil
