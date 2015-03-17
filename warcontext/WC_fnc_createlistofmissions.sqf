// -----------------------------------------------
// Author:     code34 nicolas_boiteux@yahoo.fr
// Edited by:  Neumatic
// Warcontext: Compute list of missions
// -----------------------------------------------

#define MISSION_BLACKLIST [16,17,18,19,20,21,22,23,24,25,26,27,30,63,64,65,66,68,69]

private [
	"_mission_list", "_max_num_of_missions", "_mission_count", "_respawn_west", "_mission_east_vehs", "_mission_west_vehs",
	"_mission_east_air", "_mission_west_air", "_mission_east_tanks", "_mission_east_apcs", "_mission_blacklist",
	"_num_of_groups", "_num_of_vehicles", "_get_intel", "_weight", "_intel", "_position", "_count", "_buildings",
	"_mission_number", "_name", "_objective", "_vehicle", "_object", "_time", "_city"
];

_mission_list = [];

_max_num_of_missions = 73;

if (wclevel < 10) then {
	_mission_count = [1, 10] call WC_fnc_randomMinMax;
} else {
	_mission_count = 1;
};

_respawn_west = getMarkerPos "respawn_west";
_mission_east_vehs = +wcvehicleslistE;
_mission_west_vehs = +WC_FriendlyVehicles;
_mission_east_air = +wcairpatroltype;
_mission_west_air = +WC_FriendlyJets;
_mission_east_tanks = +WC_EnemyTanks;
_mission_east_apcs = +WC_EnemyApcs;

for "_i" from 1 to _mission_count do {
	_mission_blacklist = [];

	if (wckindofserver != 3) then {
		_num_of_groups = [wclevelmaxincity * 0.50, wclevelmaxincity] call WC_fnc_randomMinMax;
		_num_of_vehicles = [wclevelmaxincity * 0.25, wclevelmaxincity * 0.50] call WC_fnc_randomMinMax;
		_get_intel = [objNull] call WC_fnc_getVehicleIntel;
	} else {
		_num_of_groups = 20;
		_num_of_vehicles = 10;
		_get_intel = [true] call WC_fnc_getVehicleIntel;
	};

	if (wcwithenemyvehicle == 0) then {
		_num_of_vehicles = 0;
		_get_intel = [true] call WC_fnc_getVehicleIntel;
	};

	_position = position (wctownlocations call WC_fnc_selectRandom);
	_position = [_position] call WC_fnc_relocateposition;
	while {_position distance _respawn_west < 1000 || {_position distance wclastmissionposition < 1500}} do {
		_position = position (wctownlocations call WC_fnc_selectRandom);
		_count = count (_position nearObjects ["House", 150]);
		if (_count > 0) then {
			_position = [_position] call WC_fnc_relocateposition;
		};
		sleep 0.05;
	};

	// Blacklist some missions if they are not in town.
	_buildings = _position nearObjects ["House", wcdistance];
	if (count _buildings < 20) then {
		_mission_blacklist = MISSION_BLACKLIST;
	};

	if (wclevel < (wclevelmax - 1)) then {
		_mission_number = floor (random _max_num_of_missions);
		while {_mission_number in wcmissiondone || {_mission_number in _mission_list} || {_mission_number in _mission_blacklist}} do {
			_mission_number = floor (random _max_num_of_missions);
		};
	} else {
		_mission_number = 100;
	};

	_mission_list set [count _mission_list, _mission_number];

	// Compute name of mission.
	_name = objNull call WC_fnc_missionname;
	_objective = localize format ["STR_WC_MISSION%1", _mission_number];

	switch (_mission_number) do {
		// Random mission vehicles.
		case 1: {
			_vehicle = _mission_east_vehs call WC_fnc_selectRandom;
			_mission_east_vehs = _mission_east_vehs - [_vehicle];
			_objective = format [localize "STR_WC_MISSION1", [_vehicle] call WC_fnc_getDisplayName];
			missionNamespace setVariable [format ["wcmissionvehicle%1", _mission_number], _vehicle];
		};

		case 2: {
			_vehicle = _mission_east_vehs call WC_fnc_selectRandom;
			_mission_east_vehs = _mission_east_vehs - [_vehicle];
			_objective = format [localize "STR_WC_MISSION2", [_vehicle] call WC_fnc_getDisplayName];
			missionNamespace setVariable [format ["wcmissionvehicle%1", _mission_number], _vehicle];
		};

		case 3: {
			_vehicle = _mission_east_vehs call WC_fnc_selectRandom;
			_mission_east_vehs = _mission_east_vehs - [_vehicle];
			_objective = format [localize "STR_WC_MISSION3", [_vehicle] call WC_fnc_getDisplayName];
			missionNamespace setVariable [format ["wcmissionvehicle%1", _mission_number], _vehicle];
		};

		// Random mission airplanes.
		case 4: {
			_vehicle = _mission_east_air call WC_fnc_selectRandom;
			_mission_east_air = _mission_east_air - [_vehicle];
			_objective = format [localize "STR_WC_MISSION4", [_vehicle] call WC_fnc_getDisplayName];
			missionNamespace setVariable [format ["wcmissionvehicle%1", _mission_number], _vehicle];
			_object = wcallhangars call WC_fnc_selectRandom;
			_position = [_object] call WC_fnc_getPos;
		};

		case 5: {
			_vehicle = _mission_east_air call WC_fnc_selectRandom;
			_mission_east_air = _mission_east_air - [_vehicle];
			_objective = format [localize "STR_WC_MISSION5", [_vehicle] call WC_fnc_getDisplayName];
			missionNamespace setVariable [format ["wcmissionvehicle%1", _mission_number], _vehicle];
			_object = wcallhangars call WC_fnc_selectRandom;
			_position = [_object] call WC_fnc_getPos;
		};

		case 6: {
			_vehicle = _mission_east_air call WC_fnc_selectRandom;
			_mission_east_air = _mission_east_air - [_vehicle];
			_objective = format [localize "STR_WC_MISSION6", [_vehicle] call WC_fnc_getDisplayName];
			missionNamespace setVariable [format ["wcmissionvehicle%1", _mission_number], _vehicle];
			_object = wcallhangars call WC_fnc_selectRandom;
			_position = [_object] call WC_fnc_getPos;
		};

		// Random mission friendly vehicles.
		case 7: {
			_vehicle = _mission_west_vehs call WC_fnc_selectRandom;
			_mission_west_vehs = _mission_west_vehs - [_vehicle];
			_objective = format [localize "STR_WC_MISSION7", [_vehicle] call WC_fnc_getDisplayName];
			missionNamespace setVariable [format ["wcmissionvehicle%1", _mission_number], _vehicle];
		};

		case 8: {
			_vehicle = _mission_west_vehs call WC_fnc_selectRandom;
			_mission_west_vehs = _mission_west_vehs - [_vehicle];
			_objective = format [localize "STR_WC_MISSION8", [_vehicle] call WC_fnc_getDisplayName];
			missionNamespace setVariable [format ["wcmissionvehicle%1", _mission_number], _vehicle];
		};

		case 9: {
			_vehicle = _mission_west_vehs call WC_fnc_selectRandom;
			_mission_west_vehs = _mission_west_vehs - [_vehicle];
			_objective = format [localize "STR_WC_MISSION9", [_vehicle] call WC_fnc_getDisplayName];
			missionNamespace setVariable [format ["wcmissionvehicle%1", _mission_number], _vehicle];
		};

		// Random mission friendly airplanes.
		case 10: {
			_vehicle = _mission_west_air call WC_fnc_selectRandom;
			_mission_west_air = _mission_west_air - [_vehicle];
			_objective = format [localize "STR_WC_MISSION10", [_vehicle] call WC_fnc_getDisplayName];
			missionNamespace setVariable [format ["wcmissionvehicle%1", _mission_number], _vehicle];
			_object = wcallhangars call WC_fnc_selectRandom;
			_position = [_object] call WC_fnc_getPos;
		};

		case 11: {
			_vehicle = _mission_west_air call WC_fnc_selectRandom;
			_mission_west_air = _mission_west_air - [_vehicle];
			_objective = format [localize "STR_WC_MISSION11", [_vehicle] call WC_fnc_getDisplayName];
			missionNamespace setVariable [format ["wcmissionvehicle%1", _mission_number], _vehicle];
			_object = wcallhangars call WC_fnc_selectRandom;
			_position = [_object] call WC_fnc_getPos;
		};

		case 12: {
			_vehicle = _mission_west_air call WC_fnc_selectRandom;
			_mission_west_air = _mission_west_air - [_vehicle];
			_objective = format [localize "STR_WC_MISSION12", [_vehicle] call WC_fnc_getDisplayName];
			missionNamespace setVariable [format ["wcmissionvehicle%1", _mission_number], _vehicle];
			_object = wcallhangars call WC_fnc_selectRandom;
			_position = [_object] call WC_fnc_getPos;
		};

		// Destroy objects on map.
		case 13: {
			_object = wcallfuelstations call WC_fnc_selectRandom;
			_position = [_object] call WC_fnc_getPos;
		};

		case 14: {
			_object = wcallfueltanks call WC_fnc_selectRandom;
			_position = [_object] call WC_fnc_getPos;
		};

		case 15: {
			_object = wcallbaracks call WC_fnc_selectRandom;
			_position = [_object] call WC_fnc_getPos;
		};

		// Defend missions.
		case 31: {
			_num_of_groups = 0;
			_num_of_vehicles = 0;
			_get_intel = [true] call WC_fnc_getVehicleIntel;
		};

		case 32: {
			_object = (wcmapcenter nearObjects ["Land_A_TVTower_Base", 20000]) call WC_fnc_selectRandom;
			_position = [_object] call WC_fnc_getPos;
			_num_of_groups = 0;
			_num_of_vehicles = 0;
			_get_intel = [true] call WC_fnc_getVehicleIntel;
		};

		case 33: {
			_object = wcallcontroltowers call WC_fnc_selectRandom;
			_position = [_object] call WC_fnc_getPos;
			_num_of_groups = 0;
			_num_of_vehicles = 0;
			_get_intel = [true] call WC_fnc_getVehicleIntel;
		};

		case 34: {
			_object = wcallfactory call WC_fnc_selectRandom;
			_position = [_object] call WC_fnc_getPos;
			_num_of_groups = 0;
			_num_of_vehicles = 0;
			_get_intel = [true] call WC_fnc_getVehicleIntel;
		};

		case 35: {
			_object = wcallcastle call WC_fnc_selectRandom;
			_position = [_object] call WC_fnc_getPos;
			_num_of_groups = 0;
			_num_of_vehicles = 0;
			_get_intel = [true] call WC_fnc_getVehicleIntel;
		};

		case 36: {
			_object = wcallcontroltowers call WC_fnc_selectRandom;
			_position = [_object] call WC_fnc_getPos;
			_num_of_groups = 0;
			_num_of_vehicles = 0;
			_get_intel = [true] call WC_fnc_getVehicleIntel;
		};

		// Secure missions
		case 45: {
			_object = wcallhangars call WC_fnc_selectRandom;
			_position = [_object] call WC_fnc_getPos;
		};

		case 46: {
			_object = wcalldam call WC_fnc_selectRandom;
			_position = [_object] call WC_fnc_getPos;
		};

		case 47: {
			_object = wcallcastle call WC_fnc_selectRandom;
			_position = [_object] call WC_fnc_getPos;
		};

		// Destroy multiple objects missions.
		case 69: {
			_vehicle = _mission_east_tanks call WC_fnc_selectRandom;
			_mission_east_tanks = _mission_east_tanks - [_vehicle];
			_objective = format [localize "STR_WC_MISSION69", [_vehicle] call WC_fnc_getDisplayName];
			missionNamespace setVariable [format ["wcmissionvehicle%1", _mission_number], _vehicle];
		};

		case 70: {
			_vehicle = _mission_east_apcs call WC_fnc_selectRandom;
			_mission_east_apcs = _mission_east_apcs - [_vehicle];
			_objective = format [localize "STR_WC_MISSION70", [_vehicle] call WC_fnc_getDisplayName];
			missionNamespace setVariable [format ["wcmissionvehicle%1", _mission_number], _vehicle];
		};

		case 100: {
			_num_of_groups = 16;
			_num_of_vehicles = 10;
			_get_intel = [true] call WC_fnc_getVehicleIntel;
		};
	};

	// Generate the mission date.
	_time = objNull call WC_fnc_newdate;

	// If autoload vehicles then we can not use use intel.
	if (wcautoloadvehicles == 1) then {
		_get_intel = [true] call WC_fnc_getVehicleIntel;
	};

	// Get the mission intel.
	_weight = _get_intel select 0;
	_intel  = _get_intel select 1;

	// Get the nearest location text.
	_city = [_position] call WC_fnc_getLocationText;

	wclistofmissions set [count wclistofmissions, [_mission_number, _name, _objective, _city, _num_of_groups, _num_of_vehicles, _position, _time, _weight, _intel]];
};

["INFO", format ["Mission list : %1", _mission_list]] call WC_fnc_log;

if (wckindofserver != 3) then {
	if (wcwithhq == 1) then {
		// Players choose the mission.
		["wclistofmissions", "client"] call WC_fnc_publicvariable;
	} else {
		// Random mission.
		wccurrentmission = wclistofmissions call WC_fnc_selectRandom;
	};
} else {
	wccurrentmission = wclistofmissions call WC_fnc_selectRandom;
};
