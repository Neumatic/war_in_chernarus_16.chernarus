// -----------------------------------------------
// Author:     code34 nicolas_boiteux@yahoo.fr
// Edited by:  Neumatic
// Warcontext: Serverside logic
// -----------------------------------------------

// Protection from ACE mod.
if (WC_ModProtection) then {
	while {true} do {
		if (wcwithACE == 1) then {
			hint "Server without ACE or CBA:\n check your addons!";
			["ERROR", "WC_fnc_serverside", "WIC wont start - server missing ACE or CBA addons"] call WC_fnc_log;
		} else {
			hint "Server with ACE:\n check your addons!";
			["ERROR", "WC_fnc_serverside", "WIC wont start - server using ACE with non ACE version"] call WC_fnc_log;
		};
		sleep 30;
	};
};

["INFO", "Initializing server side..."] call WC_fnc_log;

// Create main base flag.
objNull spawn {
	private ["_var_name"];

	wcmainflag = createVehicle ["FlagCarrierUSA_EP1", getMarkerPos "teleporter", [], 0, "NONE"];
	wcmainflag allowDamage false;
	wcmainflag setFlagTexture "pics\teamtag.paa";

	_var_name = objNull call WC_fnc_createObjName;
	[wcmainflag, _var_name] call WC_fnc_setVehicleVarName;

	waitUntil {sleep 1; !isNil "WC_fnc_publicvariable"};

	["wcmainflag", "client"] call WC_fnc_publicvariable;
};

// Init server functions and variables.
objNull call WC_fnc_serverinitconfig;

// Init server functions.
objNull call WC_fnc_serverhandler;

// Init eventhandler.
if (WC_isDedicated) then {
	objNull call WC_fnc_eventhandler;
};

// Init debugger.
objNull call WC_fnc_debug;

onPlayerConnected {[_id, _uid, _name] spawn WC_fnc_publishmission};
onPlayerDisconnected {[_id, _uid, _name] call WC_fnc_onPlayerDisconnected};

// Load garbage collector.
objNull spawn WC_fnc_garbagecollector;

// Init weather.
if (wcwithweather == 1) then {
	[wcrainrate] spawn WC_fnc_weather;
};

objNull spawn {
	private ["_marker_size", "_marker_pos", "_temp_array", "_tower", "_positions", "_light"];

	_marker_size = ["bluefor"] call WC_fnc_getMarkerSize;
	_marker_pos = getMarkerPos "bluefor";

	// Landing zone pads lights.
	_temp_array = nearestObjects [_marker_pos, ["HeliHRescue","HeliH"], _marker_size];
	{
		_tower = _x;
		if (vehicleVarName _tower != "") then {
			_positions = [[_tower] call WC_fnc_getPos, 7, 360, getDir _tower, 7] call WC_fnc_createcircleposition;
			{
				_light = createVehicle ["Land_runway_edgelight", _x, [], 0, "NONE"];
				_light setPos _x;
				_light allowDamage false;
				sleep 0.05;
			} forEach _positions;
		};
		sleep 0.5;
	} forEach _temp_array;

	// Respawnable vehicles.
	_temp_array = nearestObjects [_marker_pos, ["Air","LandVehicle"], _marker_size];
	{
		if !(vehicleVarName _x == "" && {_x isKindOf "StaticWeapon"}) then {
			wcrespawnablevehicles set [count wcrespawnablevehicles, _x];
		};
	} forEach _temp_array;

	{
		[_x] spawn WC_fnc_respawnvehicle;
		sleep 0.5;
	} forEach wcrespawnablevehicles;

	// Base statics.
	_temp_array = nearestObjects [_marker_pos, ["TOW_TriPod","M2StaticMG"], _marker_size];
	{
		if (vehicleVarName _x != "" && {count crew _x > 0}) then {
			[_x] spawn WC_fnc_baseStatic;
		};
		sleep 0.5;
	} forEach _temp_array;
};

// Load mortuary.
[getMarkerPos "mortuary"] spawn WC_fnc_createmortuary;

// Load player score.
if (wckindofserver != 3) then {
	objNull spawn WC_fnc_playerscore;
};

// Load radiation on nuclear zone.
objNull spawn WC_fnc_radiationzone;

//--- Spawns server side loop.
objNull spawn {
	private [
		"_nuclear_check", "_nuclear_check_sleep", "_last_alert_check", "_last_alert", "_last_team_score",
		"_decrease_alert_check", "_decrease_alert_last", "_known_players_check", "_known_players_array",
		"_rank_sync_check", "_rank_sync_last", "_decrease_alert_enemys", "_known_players_temp", "_player",
		"_last_in_team"
	];

	//--- Nuclear fire.
	_nuclear_check = 0;
	_nuclear_check_sleep = 3800 + random 3800;

	//--- Teamscore and detection.
	_last_alert_check = 0;
	_last_alert = 0;
	_last_team_score = 0;

	//--- Decrease alert level.
	_decrease_alert_check = 0;
	_decrease_alert_last = 0;

	//--- Insert JIP players in team members.
	_known_players_check = 0;
	_known_players_array = [];

	//--- Players rank sync.
	_rank_sync_check = 0;
	_rank_sync_last = [];

	while {true} do {
		//--- Nuclear fire.
		if (wcwithnuclear == 1) then {
			if (_nuclear_check > _nuclear_check_sleep) then {
				if (random 1 > wcnuclearprobability) then {
					[imam, 1] spawn WC_fnc_createnuclearfire;
				};

				_nuclear_check = 0;
				_nuclear_check_sleep = 3800 + random 3800;
			};
		};

		//--- Teamscore and detection.
		if (_last_alert_check > 5) then {
			if (wcalert > 100) then {wcalert = 100};
			if (wcfame < 0) then {wcfame = 0};

			if (wcteamscore != _last_team_score) then {
				["wcteamscore", "client"] call WC_fnc_publicvariable;
				_last_team_score = wcteamscore;
			};

			if (wcalert != _last_alert) then {
				["wcalert", "client"] call WC_fnc_publicvariable;
				_last_alert = wcalert;
			};

			_last_alert_check = 0;
		};

		//--- Decrease alert level.
		if (_decrease_alert_check > 60) then {
			_decrease_alert_enemys = wcselectedzone nearEntities ["CAManBase", wcdistance];
			if ({side _x in wcside} count _decrease_alert_enemys == 0) then {
				wcalert = wcalert - ceil (random 10);
				if (wcalert < 0) then {wcalert = 0};

				if (_decrease_alert_last != wcalert) then {
					["wcalert", "client"] call WC_fnc_publicvariable;
					_decrease_alert_last = wcalert;
				};
			};

			_decrease_alert_check = 0;
		};

		//--- Insert JIP players in team members.
		if (wckindofserver != 1) then {
			if (_known_players_check > 60) then {
				_known_players_temp = [];

				{
					_player = name _x;
					if !(_player in _known_players_array) then {
						_known_players_temp set [count _known_players_temp, _player];
						_known_players_array set [count _known_players_array, _player];
					};
					sleep 0.01;
				} forEach playableUnits;

				_last_in_team = wcinteam + _known_players_temp;

				if !([wcinteam, _last_in_team] call WC_fnc_isEqual) then {
					wcinteam = _last_in_team;
					["wcinteam", "client"] call WC_fnc_publicvariable;
				};

				_known_players_check = 0;
			};
		};

		//--- Players rank sync.
		if (_rank_sync_check > 60) then {
			wcranksync = [];

			{
				wcranksync set [count wcranksync, [_x, rank _x]];
				sleep 0.01;
			} forEach playableUnits;

			if !([_rank_sync_last, wcranksync] call WC_fnc_isEqual) then {
				_rank_sync_last = wcranksync;
				["wcranksync", "client"] call WC_fnc_publicvariable;
			};

			_rank_sync_check = 0;
		};

		sleep 1;

		_nuclear_check = _nuclear_check + 1;
		_last_alert_check = _last_alert_check + 1;
		_decrease_alert_check = _decrease_alert_check + 1;
		_known_players_check = _known_players_check + 1;
		_rank_sync_check = _rank_sync_check + 1;
	};
};

private ["_handle"];

// Enum town locations.
_handle = objNull spawn WC_fnc_enumvillages;
waitUntil {sleep 1; scriptDone _handle};

// Load civilians and animals.
objNull spawn {
	private ["_town_pos"];
	{
		_town_pos = position _x;
		if (wcwithcivilian > 0) then {
			[_town_pos] spawn WC_fnc_popcivilian;
		};
		if (wcwithsheeps == 1 && {random 1 > 0.9}) then {
			[_town_pos] spawn WC_fnc_createsheep;
		};
		sleep 0.5;
	} forEach wctownlocations;
};

// Load airpatrol.
if (wcairopposingforce > 0) then {
	[[1, wcairopposingforce] call WC_fnc_randomMinMax] spawn WC_fnc_initairpatrol;
};

// Load road patrol convoys.
if (wcconvoylevel > 0) then {
	objNull spawn WC_fnc_initRoadPatrols;
};

// Load sea patrols.
if (wcwithseapatrol > 0) then {
	[[1, wcwithseapatrol] call WC_fnc_randomMinMax] spawn WC_fnc_createseapatrol;
};

// Init UPSMON.
objNull execVM "extern\Init_UPSMON.sqf";

// Init tpwcas ai suppression.
if (wcaisuppression == 1) then {
	[2] execVM "extern\tpwcas\tpwcas_script_init.sqf";
};

//////////////////////////
// INIT GAME - MAIN LOOP
//////////////////////////
objNull spawn WC_fnc_mainloop;

// Get server patches
wccfgpatchesserver = objNull call WC_fnc_enumcfgpatches;
wccfgpatches = wccfgpatchesserver - wccfgpatchesoa;

// Send patches data
["wccfgpatches", "client"] call WC_fnc_publicvariable;
