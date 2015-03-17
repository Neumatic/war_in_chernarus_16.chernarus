// -----------------------------------------------
// Author:     code34 nicolas_boiteux@yahoo.fr
// Edited by:  Neumatic
// Warcontext: Create side mission
// -----------------------------------------------

private [
	"_mission_marker", "_mission_number", "_mission_name", "_marker_pos", "_marker_size", "_position", "_new_pos", "_camo",
	"_crew", "_skill", "_handler", "_protect", "_mission_type", "_mission_text", "_vehicle_array", "_vehicle", "_group",
	"_name", "_hangar", "_type", "_unit", "_vehicle_2", "_house", "_minute", "_hour", "_day", "_month", "_date", "_camo_net",
	"_crew_size", "_crew_group", "_crew_unit"
];

_mission_marker = _this select 0;
_mission_number = _this select 1;
_mission_name   = _this select 2;

_marker_pos = getMarkerPos _mission_marker;
_marker_size = [_mission_marker] call WC_fnc_getMarkerSize;

// Get a position in the marker.
_position = [_marker_pos, 0, _marker_size, sizeOf "Land_CamoNetB_EAST", 0.2] call WC_fnc_getEmptyPosition;
if (count _position == 0) then {
	_position = [_marker_pos, 0, _marker_size, 100, "Land_CamoNetB_EAST"] call WC_fnc_findEmptyPosition;
};

// Create radio tower.
_new_pos = [_marker_pos, wcradiodistminofgoal, wcradiodistmaxofgoal, sizeOf "RU_WarfareBUAVterminal", 0.2] call WC_fnc_getEmptyPosition;
wcradio = [_new_pos, wcradiotype] call WC_fnc_createradio;

// Create electrical generator.
wcgenerator = [_marker_pos, wcgeneratortype] call WC_fnc_creategenerator;

_camo = false;
_crew = false;
_skill = false;
_handler = false;
_protect = false;

wcbonusfame = 0;
wcbonusfuel = 0;
wcbonuselectrical = 0;
wcbonusnuclear = 0;

switch (_mission_number) do {
	case 0: {
		_mission_type = "destroy";
		_mission_text = [_mission_name, "Destroy a nuclear launcher"];
		_vehicle_array = [_position, random 360, "MAZ_543_SCUD_TK_EP1", east, "RU_soldier"] call WC_fnc_spawnVehicle;
		_vehicle = _vehicle_array select 0;
		_group   = _vehicle_array select 2;
		[_vehicle, _group] spawn {
			private ["_vehicle", "_group"];
			_vehicle = _this select 0;
			_group   = _this select 1;
			(driver _vehicle) action ["ScudLaunch", _vehicle];
			waitUntil {sleep 6; unitReady (driver _vehicle)};
			{
				[_x] call WC_fnc_deleteObject;
			} forEach units _group;
		};
		wcbonusnuclear = 0.15;
		_handler = true;
		_protect = true;
	};

	// Enemy random missions.
	case 1: {
		_mission_type = "destroy";
		_vehicle = missionNamespace getVariable format ["wcmissionvehicle%1", _mission_number];
		_name = [_vehicle] call WC_fnc_getDisplayName;
		_mission_text = [_mission_name, "Destroy a " + _name];
		_vehicle = createVehicle [_vehicle, _position, [], 0, "NONE"];
		_vehicle setDir (random 360);
		[_vehicle] call WC_fnc_alignToTerrain;
		_handler = true;
		_protect = true;
		_camo = true;
		_crew = true;
	};

	case 2: {
		_mission_type = "rob";
		_vehicle = missionNamespace getVariable format ["wcmissionvehicle%1", _mission_number];
		_name = [_vehicle] call WC_fnc_getDisplayName;
		_mission_text = [_mission_name, "Rob a " + _name];
		_vehicle = createVehicle [_vehicle, _position, [], 0, "NONE"];
		_vehicle setDir (random 360);
		[_vehicle] call WC_fnc_alignToTerrain;
		_handler = true;
		_camo = true;
		_crew = true;
	};

	case 3: {
		_mission_type = "sabotage";
		_vehicle = missionNamespace getVariable format ["wcmissionvehicle%1", _mission_number];
		_name = [_vehicle] call WC_fnc_getDisplayName;
		_mission_text = [_mission_name, "Sabotage a " + _name];
		_vehicle = createVehicle [_vehicle, _position, [], 0, "NONE"];
		_vehicle setDir (random 360);
		[_vehicle] call WC_fnc_alignToTerrain;
		_handler = true;
		_camo = true;
		_crew = true;
	};

	// Enemy random airplanes.
	case 4: {
		_mission_type = "destroy";
		_vehicle = missionNamespace getVariable format ["wcmissionvehicle%1", _mission_number];
		_name = [_vehicle] call WC_fnc_getDisplayName;
		_mission_text = [_mission_name, "Destroy a " + _name];
		_hangar = (_position nearObjects ["Land_SS_hangar", 300]) call WC_fnc_selectRandom;
		_vehicle = createVehicle [_vehicle, getPos _hangar, [], 0, "NONE"];
		_vehicle setDir (getDir _hangar + 180);
		[_vehicle] call WC_fnc_alignToTerrain;
		_handler = true;
		_protect = true;
		_crew = true;
	};

	case 5: {
		_mission_type = "rob";
		_vehicle = missionNamespace getVariable format ["wcmissionvehicle%1", _mission_number];
		_name = [_vehicle] call WC_fnc_getDisplayName;
		_mission_text = [_mission_name, "Rob a " + _name];
		_hangar = (_position nearObjects ["Land_SS_hangar", 300]) call WC_fnc_selectRandom;
		_vehicle = createVehicle [_vehicle, getPos _hangar, [], 0, "NONE"];
		_vehicle setDir (getDir _hangar + 180);
		[_vehicle] call WC_fnc_alignToTerrain;
		_handler = true;
		_crew = true;
	};

	case 6: {
		_mission_type = "sabotage";
		_vehicle = missionNamespace getVariable format ["wcmissionvehicle%1", _mission_number];
		_name = [_vehicle] call WC_fnc_getDisplayName;
		_mission_text = [_mission_name, "Sabotage a " + _name];
		_hangar = (_position nearObjects ["Land_SS_hangar", 300]) call WC_fnc_selectRandom;
		_vehicle = createVehicle [_vehicle, getPos _hangar, [], 0, "NONE"];
		_vehicle setDir (getDir _hangar + 180);
		[_vehicle] call WC_fnc_alignToTerrain;
		_handler = true;
		_crew = true;
	};

	// Friendly random mission.
	case 7: {
		_mission_type = "destroy";
		_vehicle = missionNamespace getVariable format ["wcmissionvehicle%1", _mission_number];
		_name = [_vehicle] call WC_fnc_getDisplayName;
		_mission_text = [_mission_name, "Destroy a " + _name];
		_vehicle = createVehicle [_vehicle, _position, [], 0, "NONE"];
		_vehicle setDir (random 360);
		[_vehicle] call WC_fnc_alignToTerrain;
		_handler = true;
		_protect = true;
		_camo = true;
		_crew = true;
	};

	case 8: {
		_mission_type = "rob";
		_vehicle = missionNamespace getVariable format ["wcmissionvehicle%1", _mission_number];
		_name = [_vehicle] call WC_fnc_getDisplayName;
		_mission_text = [_mission_name, "Rob a " + _name];
		_vehicle = createVehicle [_vehicle, _position, [], 0, "NONE"];
		_vehicle setDir (random 360);
		[_vehicle] call WC_fnc_alignToTerrain;
		_handler = true;
		if (_vehicle isKindOf "Air") then {
			_crew = true;
		} else {
			_camo = true;
			_crew = true;
		};
	};

	case 9: {
		_mission_type = "sabotage";
		_vehicle = missionNamespace getVariable format ["wcmissionvehicle%1", _mission_number];
		_name = [_vehicle] call WC_fnc_getDisplayName;
		_mission_text = [_mission_name, "Sabotage a " + _name];
		_vehicle = createVehicle [_vehicle, _position, [], 0, "NONE"];
		_vehicle setDir (random 360);
		[_vehicle] call WC_fnc_alignToTerrain;
		_handler = true;
		_camo = true;
		_crew = true;
	};

	// Friendly random airplanes.
	case 10: {
		_mission_type = "destroy";
		_vehicle = missionNamespace getVariable format ["wcmissionvehicle%1", _mission_number];
		_name = [_vehicle] call WC_fnc_getDisplayName;
		_mission_text = [_mission_name, "Destroy a " + _name];
		_hangar = (_position nearObjects ["Land_SS_hangar", 300]) call WC_fnc_selectRandom;
		_vehicle = createVehicle [_vehicle, getPos _hangar, [], 0, "NONE"];
		_vehicle setDir (getDir _hangar + 180);
		[_vehicle] call WC_fnc_alignToTerrain;
		_handler = true;
		_protect = true;
		_crew = true;
	};

	case 11: {
		_mission_type = "rob";
		_vehicle = missionNamespace getVariable format ["wcmissionvehicle%1", _mission_number];
		_name = [_vehicle] call WC_fnc_getDisplayName;
		_mission_text = [_mission_name, "Rob a " + _name];
		_hangar = (_position nearObjects ["Land_SS_hangar", 300]) call WC_fnc_selectRandom;
		_vehicle = createVehicle [_vehicle, getPos _hangar, [], 0, "NONE"];
		_vehicle setDir (getDir _hangar + 180);
		[_vehicle] call WC_fnc_alignToTerrain;
		_handler = true;
		_crew = true;
	};

	case 12: {
		_mission_type = "sabotage";
		_vehicle = missionNamespace getVariable format ["wcmissionvehicle%1", _mission_number];
		_name = [_vehicle] call WC_fnc_getDisplayName;
		_mission_text = [_mission_name, "Sabotage a " + _name];
		_hangar = (_position nearObjects ["Land_SS_hangar", 300]) call WC_fnc_selectRandom;
		_vehicle = createVehicle [_vehicle, getPos _hangar, [], 0, "NONE"];
		_vehicle setDir (getDir _hangar + 180);
		[_vehicle] call WC_fnc_alignToTerrain;
		_handler = true;
		_crew = true;
	};

	// Random map buildings missions.
	case 13: {
		_mission_type = "destroy";
		_mission_text = [_mission_name, "Destroy a fuel station"];
		_vehicle = (_position nearObjects ["Land_A_FuelStation_Feed", 300]) call WC_fnc_selectRandom;
		wcbonusfuel = 0.1;
		_protect = true;
	};

	case 14: {
		_mission_type = "destroy";
		_mission_text = [_mission_name, "Destroy a fuel tank"];
		_vehicle = (_position nearObjects ["Land_Ind_TankBig", 300]) call WC_fnc_selectRandom;
		wcbonusfuel = 0.1;
		_protect = true;
	};

	case 15: {
		_mission_type = "destroy";
		_mission_text = [_mission_name, "Destroy a barrack"];
		_vehicle = (_position nearObjects ["Land_Mil_Barracks", 300]) call WC_fnc_selectRandom;
		_protect = true;
	};

	case 16: {
		_mission_type = "eliminate";
		_mission_text = [_mission_name, "Kill a Russian commander"];
		_group = createGroup east;
		_vehicle = _group createUnit ["RU_Commander", _position, [], 0, "NONE"];
		_position = ([_position, "bot"] call WC_fnc_gethousespositions) call WC_fnc_selectRandom;
		_skill = true;
		_protect = true;
	};

	case 17: {
		_mission_type = "eliminate";
		_mission_text = [_mission_name, "Kill a Insurgent commander"];
		_group = createGroup east;
		_vehicle = _group createUnit ["Ins_Commander", _position, [], 0, "NONE"];
		_position = ([_position, "bot"] call WC_fnc_gethousespositions) call WC_fnc_selectRandom;
		wcbonusfame = -0.1;
		_skill = true;
		_protect = true;
	};

	case 18: {
		_mission_type = "eliminate";
		_mission_text = [_mission_name, "Kill a Russian officer"];
		_group = createGroup east;
		_vehicle = _group createUnit ["RU_Soldier_Officer", _position, [], 0, "NONE"];
		_position = ([_position, "bot"] call WC_fnc_gethousespositions) call WC_fnc_selectRandom;
		_skill = true;
		_protect = true;
	};

	case 19: {
		_mission_type = "eliminate";
		_mission_text = [_mission_name, "Kill a Insurgent officer"];
		_group = createGroup east;
		_vehicle = _group createUnit ["Ins_Bardak", _position, [], 0, "NONE"];
		_position = ([_position, "bot"] call WC_fnc_gethousespositions) call WC_fnc_selectRandom;
		wcbonusfame = -0.1;
		_skill = true;
		_protect = true;
	};

	case 20: {
		_mission_type = "jail";
		_mission_text = [_mission_name, "Capture a Russian commander"];
		_group = createGroup east;
		_vehicle = _group createUnit ["RU_Commander", _position, [], 0, "NONE"];
	};

	case 21: {
		_mission_type = "jail";
		_mission_text = [_mission_name, "Capture a Insurgent commander"];
		_group = createGroup east;
		_vehicle = _group createUnit ["Ins_Commander", _position, [], 0, "NONE"];
		wcbonusfame = -0.1;
	};

	case 22: {
		_mission_type = "jail";
		_mission_text = [_mission_name, "Capture a Russian officer"];
		_group = createGroup east;
		_vehicle = _group createUnit ["RU_Soldier_Officer", _position, [], 0, "NONE"];
	};

	case 23: {
		_mission_type = "jail";
		_mission_text = [_mission_name, "Capture a Insurgent officer"];
		_group = createGroup east;
		_vehicle = _group createUnit ["Ins_Bardak", _position, [], 0, "NONE"];
		wcbonusfame = -0.1;
	};

	case 24: {
		_mission_type = "eliminate";
		_mission_text = [_mission_name, "Kill the spy"];
		_group = createGroup east;
		_vehicle = _group createUnit ["Citizen4", _position, [], 0, "NONE"];
		_position = ([_position, "all"] call WC_fnc_gethousespositions) call WC_fnc_selectRandom;
		wcbonusfame = -0.1;
		_skill = true;
		_protect = true;
	};

	case 25: {
		_mission_type = "eliminate";
		_mission_text = [_mission_name, "Eliminate suicide bomber"];
		_group = createGroup east;
		_type = ["Citizen1","Priest","Worker2","Profiteer3","SchoolTeacher","Madam5","WorkWoman1"] call WC_fnc_selectRandom;
		_vehicle = _group createUnit [_type, _position, [], 0, "NONE"];
		_position = ([_position, "all"] call WC_fnc_gethousespositions) call WC_fnc_selectRandom;
		[_vehicle] spawn WC_fnc_createied;
		wcbonusfame = 0.1;
		_skill = true;
	};

	case 26: {
		_mission_type = "eliminate";
		_mission_text = [_mission_name, "Kill a civilian"];
		_group = createGroup civilian;
		_type = ["Citizen1","Priest","Worker2","Profiteer3","SchoolTeacher","Madam5","WorkWoman1"] call WC_fnc_selectRandom;
		_vehicle = _group createUnit [_type, _position, [], 0, "NONE"];
		_position = ([_position, "bot"] call WC_fnc_gethousespositions) call WC_fnc_selectRandom;
		wcbonusfame = -0.1;
		_skill = true;
	};

	case 27: {
		_mission_type = "jail";
		_mission_text = [_mission_name, "Capture a civilian"];
		_group = createGroup east;
		_type = ["Citizen1","Priest","Worker2","Profiteer3","SchoolTeacher","Madam5","WorkWoman1"] call WC_fnc_selectRandom;
		_vehicle = _group createUnit [_type, _position, [], 0, "NONE"];
		wcbonusfame = -0.1;
	};

	case 28: {
		_mission_type = "liberate";
		_mission_text = [_mission_name, "Rescue a UH1 pilot"];
		createVehicle ["UH1Wreck", _position, [], 0, "NONE"];
		_group = createGroup west;
		_vehicle = _group createUnit ["USMC_Soldier_Pilot", _position, [], 0, "NONE"];
	};

	case 29: {
		_mission_type = "liberate";
		_mission_text = [_mission_name, "Rescue a C130 pilot"];
		createVehicle ["C130J_wreck_EP1", _position, [], 0, "NONE"];
		_group = createGroup west;
		_vehicle = _group createUnit ["USMC_Soldier_Pilot", _position, [], 0, "NONE"];
	};

	case 30: {
		_mission_type = "liberate";
		_mission_text = [_mission_name, "Rescue an officer"];
		_group = createGroup west;
		_vehicle = _group createUnit ["USMC_Soldier_Officer", _position, [], 0, "NONE"];
	};

	// Defend missions.
	case 31: {
		_mission_type = "defend";
		_mission_text = [_mission_name, "Defend the bunker"];
		_vehicle = createVehicle ["Land_fortified_nest_big", _position, [], 0, "NONE"];
		[_vehicle] call WC_fnc_alignToTerrain;
		_vehicle = createVehicle ["FlagCarrierUSA_EP1", _position, [], 0, "NONE"];
		_vehicle setFlagTexture "pics\teamtag.paa";
	};

	case 32: {
		_mission_type = "defend";
		_mission_text = [_mission_name, "Defend the communications tower"];
		_vehicle = (_position nearObjects ["Land_A_TVTower_Base", 300]) call WC_fnc_selectRandom;
	};

	case 33: {
		_mission_type = "defend";
		_mission_text = [_mission_name, "Defend the control tower"];
		_vehicle = (_position nearObjects ["Land_Mil_ControlTower", 300]) call WC_fnc_selectRandom;
	};

	case 34: {
		_mission_type = "defend";
		_mission_text = [_mission_name, "Defend the factory"];
		_vehicle = (_position nearObjects ["Land_A_BuildingWIP", 300]) call WC_fnc_selectRandom;
	};

	case 35: {
		_mission_type = "defend";
		_mission_text = [_mission_name, "Defend the castle"];
		_vehicle = (_position nearObjects ["Land_A_Castle_Bergfrit", 300]) call WC_fnc_selectRandom;
	};

	case 36: {
		_mission_type = "replaceguard";
		_mission_text = [_mission_name, "Secure a control tower"];
		_vehicle = (_position nearObjects ["Land_Mil_ControlTower", 300]) call WC_fnc_selectRandom;
		_position = getPos _vehicle;
		_group = createGroup west;
		{
			_unit = _group createUnit [_x, _position, [], 20, "NONE"];
		} forEach ["FR_Cooper","FR_Miles","FR_OHara","FR_Rodriguez","FR_Sykes"];
		[_group, getPos (leader _group), 50, false] spawn WC_fnc_patrol;
	};

	case 37: {
		_mission_type = "destroy";
		_mission_text = [_mission_name, "Destroy a radio tower"];
		_vehicle = wcradio;
	};

	case 38: {
		_mission_type = "sabotage";
		_mission_text = [_mission_name, "Sabotage a radio tower"];
		_vehicle = wcradio;
	};

	case 39: {
		_mission_type = "destroy";
		_mission_text = [_mission_name, "Destroy an electrical generator"];
		_vehicle = createVehicle ["PowGen_Big_EP1", _position, [], 0, "NONE"];
		_vehicle setDir (random 360);
		[_vehicle] call WC_fnc_alignToTerrain;
		wcbonuselectrical = 0.1;
		_protect = true;
	};

	case 40: {
		_mission_type = "destroy";
		_mission_text = [_mission_name, "Destroy an UAV terminal"];
		_vehicle = createVehicle ["RU_WarfareBUAVterminal", _position, [], 0, "NONE"];
		_vehicle setDir (random 360);
		[_vehicle] call WC_fnc_alignToTerrain;
		_handler = true;
		_protect = true;
	};

	case 41: {
		_mission_type = "build";
		_mission_text = [_mission_name, "Build a military hospital"];
		_vehicle = createVehicle ["Misc_Cargo1B_military", _position, [], 0, "NONE"];
		_vehicle setDir (random 360);
		[_vehicle] call WC_fnc_alignToTerrain;
		_vehicle_2 = "CDF_WarfareBFieldhHospital";
		wcbonusfame = 0.1;
	};

	case 42: {
		_mission_type = "build";
		_mission_text = [_mission_name, "Build a radar"];
		_vehicle = createVehicle ["Misc_Cargo1B_military", _position, [], 0, "NONE"];
		_vehicle setDir (random 360);
		[_vehicle] call WC_fnc_alignToTerrain;
		_vehicle_2 = "USMC_WarfareBAntiAirRadar";
	};

	case 43: {
		_mission_type = "build";
		_mission_text = [_mission_name, "Build a service point"];
		_vehicle = createVehicle ["Misc_Cargo1B_military", _position, [], 0, "NONE"];
		_vehicle setDir (random 360);
		[_vehicle] call WC_fnc_alignToTerrain;
		_vehicle_2 = "USMC_WarfareBVehicleServicePoint";
	};

	case 44: {
		_mission_type = "build";
		_mission_text = [_mission_name, "Build a bunker"];
		_vehicle = createVehicle ["Misc_Cargo1B_military", _position, [], 0, "NONE"];
		_vehicle setDir (random 360);
		[_vehicle] call WC_fnc_alignToTerrain;
		_vehicle_2 = "Land_Fort_Watchtower";
	};

	// Secure zone missions.
	case 45: {
		_mission_type = "secure";
		_mission_text = [_mission_name, "Secure the airfield zone"];
		_vehicle = (_position nearObjects ["Land_SS_hangar", 300]) call WC_fnc_selectRandom;
	};

	case 46: {
		_mission_type = "secure";
		_mission_text = [_mission_name, "Secure a dam zone"];
		_vehicle = (_position nearObjects ["Land_Dam_Conc_20", 300]) call WC_fnc_selectRandom;
	};

	case 47: {
		_mission_type = "secure";
		_mission_text = [_mission_name, "Secure the castle zone"];
		_vehicle = (_position nearObjects ["Land_A_Castle_Bergfrit", 300]) call WC_fnc_selectRandom;
	};

	// Destroy objects missions.
	case 48: {
		_mission_type = "destroy";
		_mission_text = [_mission_name, "Destroy a Russian HQ"];
		_vehicle = createVehicle ["BTR90_HQ_unfolded", _position, [], 0, "NONE"];
		_vehicle setDir (random 360);
		[_vehicle] call WC_fnc_alignToTerrain;
		_handler = true;
		_protect = true;
	};

	case 49: {
		_mission_type = "destroy";
		_mission_text = [_mission_name, "Destroy a Insurgent HQ"];
		_vehicle = createVehicle ["BMP2_HQ_INS_unfolded", _position, [], 0, "NONE"];
		_vehicle setDir (random 360);
		[_vehicle] call WC_fnc_alignToTerrain;
		_handler = true;
		_protect = true;
	};

	case 50: {
		_mission_type = "destroy";
		_mission_text = [_mission_name, "Destroy the Russian heavy factory"];
		_vehicle = createVehicle ["RU_WarfareBHeavyFactory", _position, [], 0, "NONE"];
		_vehicle setDir (random 360);
		[_vehicle] call WC_fnc_alignToTerrain;
		_handler = true;
		_protect = true;
	};

	case 51: {
		_mission_type = "destroy";
		_mission_text = [_mission_name, "Destroy the Insurgent heavy factory"];
		_vehicle = createVehicle ["Ins_WarfareBHeavyFactory", _position, [], 0, "NONE"];
		_vehicle setDir (random 360);
		[_vehicle] call WC_fnc_alignToTerrain;
		_handler = true;
		_protect = true;
	};

	case 52: {
		_mission_type = "destroy";
		_mission_text = [_mission_name, "Destroy the Russian light factory"];
		_vehicle = createVehicle ["RU_WarfareBLightFactory", _position, [], 0, "NONE"];
		_vehicle setDir (random 360);
		[_vehicle] call WC_fnc_alignToTerrain;
		_handler = true;
		_protect = true;
	};

	case 53: {
		_mission_type = "destroy";
		_mission_text = [_mission_name, "Destroy the Insurgent light factory"];
		_vehicle = createVehicle ["Ins_WarfareBLightFactory", _position, [], 0, "NONE"];
		_vehicle setDir (random 360);
		[_vehicle] call WC_fnc_alignToTerrain;
		_handler = true;
		_protect = true;
	};

	case 54: {
		_mission_type = "destroy";
		_mission_text = [_mission_name, "Destroy the vehicle service point"];
		_vehicle = createVehicle ["RU_WarfareBVehicleServicePoint", _position, [], 0, "NONE"];
		_vehicle setDir (random 360);
		[_vehicle] call WC_fnc_alignToTerrain;
		wcbonusfuel = 0.1;
		_handler = true;
		_protect = true;
	};

	case 55: {
		_mission_type = "destroy";
		_mission_text = [_mission_name, "Destroy the Russian barrack"];
		_vehicle = createVehicle ["RU_WarfareBBarracks", _position, [], 0, "NONE"];
		_vehicle setDir (random 360);
		[_vehicle] call WC_fnc_alignToTerrain;
		_handler = true;
		_protect = true;
	};

	case 56: {
		_mission_type = "destroy";
		_mission_text = [_mission_name, "Destroy the Russian field hospital"];
		_vehicle = createVehicle ["RU_WarfareBFieldhHospital", _position, [], 0, "NONE"];
		_vehicle setDir (random 360);
		[_vehicle] call WC_fnc_alignToTerrain;
		_handler = true;
		_protect = true;
	};

	case 57: {
		_mission_type = "destroy";
		_mission_text = [_mission_name, "Destroy the Russian air factory"];
		_vehicle = createVehicle ["RU_WarfareBAircraftFactory", _position, [], 0, "NONE"];
		_vehicle setDir (random 360);
		[_vehicle] call WC_fnc_alignToTerrain;
		_handler = true;
		_protect = true;
	};

	case 58: {
		_mission_type = "destroy";
		_mission_text = [_mission_name, "Destroy the Russian anti-air radar"];
		_vehicle = createVehicle ["RU_WarfareBAntiAirRadar", _position, [], 0, "NONE"];
		_vehicle setDir (random 360);
		[_vehicle] call WC_fnc_alignToTerrain;
		_handler = true;
		_protect = true;
	};

	case 59: {
		_mission_type = "destroy";
		_mission_text = [_mission_name, "Destroy a fuel tank"];
		_vehicle = createVehicle ["Land_Fuel_tank_big", _position, [], 0, "NONE"];
		_vehicle setDir (random 360);
		[_vehicle] call WC_fnc_alignToTerrain;
		wcbonusfuel = 0.1;
		_handler = true;
		_protect = true;
	};

	// Destroy group missions.
	case 60: {
		_mission_type = "destroygroup";
		_mission_text = [_mission_name, "Destroy a Spetsnaz group"];
		_vehicle = createVehicle ["ACE_Mi17_RU", _position, [], 0, "NONE"];
		_vehicle setDir (random 360);
		[_vehicle] call WC_fnc_alignToTerrain;
		_handler = true;
		_camo = true;
		_crew = true;
	};

	case 61: {
		_mission_type = "destroygroup";
		_mission_text = [_mission_name, "Destroy a apc group"];
		_vehicle = createVehicle ["BTR90", _position, [], 0, "NONE"];
		_vehicle setDir (random 360);
		[_vehicle] call WC_fnc_alignToTerrain;
		_handler = true;
		_camo = true;
		_crew = true;
	};

	case 62: {
		_mission_type = "steal";
		_mission_text = [_mission_name, "Steal a secret document"];
		_house = (_position nearObjects ["House", 500]) call WC_fnc_selectRandom;
		_vehicle = createVehicle ["EvMoscow", getPos _house, [], 0, "NONE"];
		_position = ([_position, "all"] call WC_fnc_gethousespositions) call WC_fnc_selectRandom;
		_vehicle setPos _position;
	};

	// Civilian missions.
	case 63: {
		_mission_type = "heal";
		_mission_text = [_mission_name, "Heal a civilian"];
		_type = ["Citizen1","Priest","Worker2","Profiteer3","SchoolTeacher","Madam5","WorkWoman1"] call WC_fnc_selectRandom;
		_group = createGroup civilian;
		_vehicle = _group createUnit [_type, _position, [], 0, "NONE"];
		[_vehicle] spawn WC_fnc_heal;
		wcbonusfame = 0.1;
	};

	case 64: {
		_mission_type = "rescuecivil";
		_mission_text = [_mission_name, "Rescue 10 civilians"];
		_vehicle = createVehicle ["MASH", _position, [], 0, "NONE"];
		_vehicle setDir (random 360);
		[_vehicle] call WC_fnc_alignToTerrain;
		wcbonusfame = 0.1;
	};

	// IED missions.
	case 65: {
		_mission_type = "ied";
		_mission_text = [_mission_name, "Defuse a IED"];
		_type = ["Lada1","Lada2","Skoda","SkodaBlue","SkodaGreen","SkodaRed","UralCivil","car_hatchback","car_sedan","datsun1_civil_2_covered","hilux1_civil_2_covered","HMMWVWreck","UH1Wreck","Barrel1","Barrel4","Barrel5","Barrels","Garbage_can","Garbage_container","Land_Toilet","Misc_TyreHeap"] call WC_fnc_selectRandom;
		_vehicle = createVehicle [_type, _position, [], 0, "NONE"];
		_vehicle setDir (random 360);
		[_vehicle] call WC_fnc_alignToTerrain;
		wcbonusfame = 0.1;
	};

	// Convoy missions.
	case 66: {
		_mission_type = "bring";
		_mission_text = [_mission_name, "Bring an ammo truck"];
		_vehicle = createVehicle ["MtvrReammo", getMarkerPos "convoystart", [], 0, "NONE"];
		[_vehicle] call WC_fnc_alignToTerrain;
		_vehicle setVehicleVarName "ammotruck";
		_vehicle_2 = createVehicle ["RU_WarfareBBarracks", _position, [], 0, "NONE"];
		_vehicle_2 setDir (random 360);
		[_vehicle] call WC_fnc_alignToTerrain;
		_handler = true;
	};

	case 67: {
		_mission_type = "bringunit";
		_mission_text = [_mission_name, "Escort a doctor"];
		_group = createGroup civilian;
		_vehicle = _group createUnit ["Doctor", getMarkerPos "convoystart", [], 0, "NONE"];
		_vehicle_2 = createVehicle ["MASH", _position, [], 0, "NONE"];
		_vehicle_2 setDir (random 360);
		[_vehicle] call WC_fnc_alignToTerrain;
		wcbonusfame = 0.1;
	};

	case 68: {
		_mission_type = "record";
		_mission_text = [_mission_name, "Record a conversation"];
		_group = createGroup east;
		_vehicle = _group createUnit ["RU_Commander", _position, [], 0, "NONE"];
		_vehicle_2 = _group createUnit ["Ins_Lopotev", _position, [], 0, "NONE"];
	};

	// Destroy multiple objects missions.
	case 69: {
		_mission_type = "destroyobjects";
		_vehicle = missionNamespace getVariable format ["wcmissionvehicle%1", _mission_number];
		_name = [_vehicle] call WC_fnc_getDisplayName;
		_mission_text = [_mission_name, "Destroy a " + _name + " armor group"];
		_vehicle = createVehicle [_vehicle, _position, [], 0, "NONE"];
		_vehicle setDir (random 360);
		[_vehicle] call WC_fnc_alignToTerrain;
		_handler = true;
		_camo = true;
		_crew = true;
	};

	case 70: {
		_mission_type = "destroyobjects";
		_vehicle = missionNamespace getVariable format ["wcmissionvehicle%1", _mission_number];
		_name = [_vehicle] call WC_fnc_getDisplayName;
		_mission_text = [_mission_name, "Destroy a " + _name + " apc group"];
		_vehicle = createVehicle [_vehicle, _position, [], 0, "NONE"];
		_vehicle setDir (random 360);
		[_vehicle] call WC_fnc_alignToTerrain;
		_handler = true;
		_camo = true;
		_crew = true;
	};

	case 71: {
		_mission_type = "destroyobjects";
		_mission_text = [_mission_name, "Destroy the enemy ammo caches"];
		_vehicle = createVehicle ["RUVehicleBox", _position, [], 0, "NONE"];
		_vehicle setDir (random 360);
		[_vehicle] call WC_fnc_alignToTerrain;
		_handler = true;
	};

	case 72: {
		_mission_type = "destroyobjects";
		_mission_text = [_mission_name, "Destroy the fire base"];
		_vehicle = createVehicle ["D30_RU", _position, [], 0, "NONE"];
		_vehicle setDir (random 360);
		[_vehicle] call WC_fnc_alignToTerrain;
		_handler = true;
		_camo = true;
	};

	case 100: {
		_mission_type = "finalmission";
		_mission_text = [_mission_name, "Kill the Russian General"];
		_vehicle = imam;
		_skill = true;
		_protect = true;
	};
};

_minute = [format ["%1", (date select 4)]] call WC_fnc_feelwithzero;
_hour   = [format ["%1", (date select 3)]] call WC_fnc_feelwithzero;
_day    = [format ["%1", (date select 2)]] call WC_fnc_feelwithzero;
_month  = [format ["%1", (date select 1)]] call WC_fnc_feelwithzero;

_date = _hour + ":" + _minute + " " + _day  + "/" + _month + "/" + format ["%1", (date select 0)];
_mission_text = [_date] + _mission_text;

["INFO", format ["Mission: %1 : Type: %2 : Description: %3", _mission_number, _mission_type, _mission_text]] call WC_fnc_log;

// For debug purpose.
wctarget = _vehicle;

if (_camo) then {
	_camo_net = createVehicle ["Land_CamoNetB_EAST", [0,0,0], [], 0, "NONE"];
	_camo_net setDir (getDir _vehicle + 180);
	[_vehicle] call WC_fnc_alignToTerrain;
	wcobjecttodelete set [count wcobjecttodelete, _camo_net];
};

if (_crew) then {
	_vehicle spawn {
		private ["_crew_size", "_new_pos", "_crew_group", "_crew_unit"];

		_crew_size = [1, 3] call WC_fnc_randomMinMax;
		_new_pos = [_this, 0, 30, sizeOf "RU_Soldier", 0.2] call WC_fnc_getEmptyPosition;

		_crew_group = createGroup east;
		for "_i" from 1 to _crew_size do {
			_crew_unit = _crew_group createUnit [wccrewforces call WC_fnc_selectRandom, _new_pos, [], 10, "NONE"];
			sleep 0.1;
		};

		[_crew_group, east] spawn WC_fnc_grouphandler;
		[_crew_group, getPos _this, 30, false] spawn WC_fnc_patrol;
	};
};
/*
if (_skill) then {
	[_vehicle, wcskill] spawn WC_fnc_setskill;
};
*/
if (_protect) then {
	[_vehicle, 1, 150, 7] spawn WC_fnc_protectobject;
};

switch (_mission_type) do {
	case "destroy": {
		if (_handler) then {
			[_vehicle, civilian] spawn WC_fnc_vehiclehandler;
		};

		_vehicle lock true;
		_vehicle setFuel 0;

		[_vehicle] spawn WC_fnc_destroyvehicle;
	};

	case "eliminate": {
		_vehicle removeAllEventHandlers "HandleDamage";
		_vehicle addEventHandler ["HandleDamage", {
			if (isPlayer (_this select 3)) then {
				(_this select 0) setDamage 1;
			};
		}];

		[_vehicle] spawn {
			private ["_unit"];
			_unit = _this select 0;
			while {wcalert < 99} do {
				sleep 5;
			};
			_unit stop false;
			[group _unit, getPos _unit, 50, false] spawn WC_fnc_patrol;
		};

		_vehicle setPos _position;
		_vehicle setUnitPos "Up";
		_vehicle stop true;

		[_vehicle] spawn WC_fnc_eliminate;
	};

	case "ied": {
		[_vehicle] spawn WC_fnc_createied;
		[_vehicle] spawn WC_fnc_defuseIED;
	};

	case "jail": {
		_vehicle removeAllEventHandlers "HandleDamage";
		_vehicle addEventHandler ["HandleDamage", {
			if (isPlayer (_this select 3)) then {
				if (wckindofgame == 1) then {
					(_this select 0) setDamage ((getDammage (_this select 0)) + 0.1);
				} else {
					(_this select 0) setDamage 1;
				};
			};
		}];

		[_vehicle] spawn WC_fnc_jail;
	};

	case "sabotage": {
		if (_handler) then {
			[_vehicle, civilian] spawn WC_fnc_vehiclehandler;
		};

		[_vehicle] spawn WC_fnc_sabotage;
	};

	case "steal": {
		[_vehicle] spawn WC_fnc_steal;
	};

	case "rob": {
		if (_handler) then {
			[_vehicle, west] spawn WC_fnc_vehiclehandler;
		};

		[_vehicle] spawn WC_fnc_rob;
	};

	case "defend": {
		wcradio setDamage 1;

		wcaddactions = [_vehicle, "DEFEND_AREA"];
		["wcaddactions", "client"] call WC_fnc_publicvariable;

		[_vehicle] spawn WC_fnc_defend;
	};

	case "build": {
		[_vehicle, _vehicle_2] spawn WC_fnc_build;
	};

	case "secure": {
		[_vehicle] spawn WC_fnc_securezone;
	};

	case "destroygroup": {
		if (_handler) then {
			[_vehicle, civilian] spawn WC_fnc_vehiclehandler;
		};

		_vehicle lock true;
		_vehicle setFuel 0;

		[_vehicle] spawn WC_fnc_destroygroup;
	};

	case "bring": {
		if (_handler) then {
			[_vehicle, west] spawn WC_fnc_vehiclehandler;
		};

		[_vehicle, getPos _vehicle_2] spawn WC_fnc_bringvehicle;
	};

	case "bringunit": {
		wcaddactions = [_vehicle, "FOLLOW_ME"];
		["wcaddactions", "client"] call WC_fnc_publicvariable;

		[_vehicle] spawn WC_fnc_createmedic;
		[_vehicle, getPos _vehicle_2] spawn WC_fnc_bringunit;
	};

	case "record": {
		[_group] spawn WC_fnc_record;
	};

	case "rescuecivil": {
		[_vehicle, 10] spawn WC_fnc_rescuecivil;
	};

	case "replaceguard": {
		wcradio setDamage 1;

		wcaddactions = [leader _group, "REPLACE_GUARD"];
		["wcaddactions", "client"] call WC_fnc_publicvariable;

		[_vehicle] spawn WC_fnc_defend;
	};

	case "liberate": {
		[_vehicle] spawn WC_fnc_liberatehotage;
	};

	case "destroyobjects": {
		if (_handler) then {
			[_vehicle, civilian] spawn WC_fnc_vehiclehandler;
		};

		if ({_vehicle isKindOf _x} count ["Car", "Tank", "Motorcycle", "Air"] > 0) then {
			_vehicle lock true;
			_vehicle setFuel 0;
		};

		[_vehicle, _position, ceil (random 3), 100, _camo, _crew] spawn WC_fnc_destroyObjects;
	};

	case "finalmission": {
		_vehicle removeAllEventHandlers "HandleDamage";
		_vehicle addEventHandler ["HandleDamage", {
			if (isPlayer (_this select 3)) then {
				(_this select 0) setDamage 1;
			};
		}];

		_vehicle addWeapon "AKS_74";
		_vehicle addMagazine "30Rnd_545x39_AK";
		_vehicle addEventHandler ["Fired", {(_this select 0) setVehicleAmmo 1}];

		_new_pos = ([_position, "all", 300] call WC_fnc_gethousespositions) call WC_fnc_selectRandom;
		if (count _new_pos == 0) then {
			_new_pos = [_position, 0, 150, sizeOf "RU_Soldier", 0.2] call WC_fnc_getEmptyPosition;
		};

		_vehicle setPos _position;
		_vehicle allowDamage true;

		[group _vehicle, _position, 150, false] spawn WC_fnc_patrol;
	};
};

sleep 30;

wcobjective = [wcobjectiveindex, _vehicle, _mission_number, _mission_name, _mission_text];
["wcobjective", "client"] call WC_fnc_publicvariable;

if (wcwithmarkerongoal > 0) then {
	["operationtext", _marker_pos, 0.5, "ColorRed", "ICON", "FDIAGONAL", "flag", 0, localize format ["STR_WCSHORT_MISSION%1", _mission_number], 1] call WC_fnc_createmarker;

	if (wcwithmarkerongoal == 2) then {
		"operationtext" setMarkerPos (getPos _vehicle);
	};
};
