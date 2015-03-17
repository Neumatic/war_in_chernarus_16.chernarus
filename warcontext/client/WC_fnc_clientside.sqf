// -----------------------------------------------
// Author:     code34 nicolas_boiteux@yahoo.fr
// Edited by:  Neumatic
// Warcontext: Clientside logic
// -----------------------------------------------

#define DISPLAY_MAIN (findDisplay 46)

waitUntil {!isNil {player} && !isNull player && player == player};

// Protection from ACE mod.
if (WC_ModProtection) then {
	player setPos [0,0,0];
	removeAllItems player;
	removeAllWeapons player;
	player enableSimulation false;

	while {true} do {
		if (wcwithACE == 1) then {
			hint "Player without ACE or CBA:\n check your addons!";
		} else {
			hint "Player with ACE:\n check your addons!";
		};
		sleep 30;
	};
};

["INFO", "Initializing client side..."] call WC_fnc_log;

// Init client functions and variables.
objNull call WC_fnc_clientinitconfig;

// Init client functions.
objNull call WC_fnc_clienthandler;

// Init eventhandler.
objNull call WC_fnc_eventhandler;

// Init player handlers.
objNull call WC_fnc_clienteventhandler;

// Add keymapper.
objNull spawn {
	waitUntil {!isNil {DISPLAY_MAIN} && !isNull DISPLAY_MAIN};

	DISPLAY_MAIN displayAddEventHandler ["KeyDown", "[""KeyDown"", _this] call WC_fnc_keyHandler"];
	DISPLAY_MAIN displayAddEventHandler ["KeyUp", "[""KeyUp"", _this] call WC_fnc_keyHandler"];

	objNull call WC_fnc_keymapper;
};

// Load intro cam.
wcanim = objNull spawn WC_fnc_intro;

// Init action menu.
objNull call WC_fnc_restoreactionmenu;

// Init music.
wcjukebox = objNull call WC_fnc_enummusic;

// Init light light.
if (wcwithlight == 1) then {
	objNull spawn WC_fnc_light;
};

// Call R3F revive.
if (true) then {
	["extern\R3F_revive\revive_init.sqf"] call WC_fnc_compile;
} else {
	R3F_REV_nb_reanimations = 0;
	player addEventHandler ["Killed", {_this spawn WC_fnc_onkilled}];
};

// Load player HUD.
objNull spawn WC_fnc_lifeslider;

private ["_marker", "_end", "_end_2", "_end_3", "_menu_option", "_kind_of_game"];

// Load player goal zone marker hint.
_marker = ["rescue", [0,0,0], 0.01, "ColorRed", "ICON", "FDIAGONAL", "Selector_selectedMission", 0, "", 0] call WC_fnc_createmarkerlocal;
[_marker] spawn WC_fnc_markerhintlocal;

// Add respawn marker.
wcrespawnmarker = ["respawn", [0,0,0], 0.5, "ColorRed", "ICON", "FDIAGONAL", "Camp", 0, "", 1] call WC_fnc_createmarkerlocal;
wcrespawnmarker setMarkerSizeLocal [0.5,0.5];
wcrespawnmarker setMarkerAlphaLocal 0;

// Load player 3d hints.
if (wckindofgame == 1) then {
	["Hospital", getMarkerPos "hospital"] spawn BIS_fnc_3dcredits;
	["Weapons", getMarkerPos "crate1"] spawn BIS_fnc_3dcredits;
	if (wcautoloadweapons == 1) then {
		["Addons Weapons", getMarkerPos "autoloadcrate"] spawn BIS_fnc_3dcredits;
	};
	["Presets", [preset] call WC_fnc_getPos] spawn BIS_fnc_3dcredits;
	["Repair center", getMarkerPos "repair"] spawn BIS_fnc_3dcredits;
	["Recruitment", getMarkerPos "recruit1"] spawn BIS_fnc_3dcredits;
	["Hall of fames", [teammanage] call WC_fnc_getPos] spawn BIS_fnc_3dcredits;
	["Clothes", getMarkerPos "clothes"] spawn BIS_fnc_3dcredits;
	["Jail", getMarkerPos "jail"] spawn BIS_fnc_3dcredits;
	["Headquarters", [anim] call WC_fnc_getPos] spawn BIS_fnc_3dcredits;
	["Ied training", [iedtraining] call WC_fnc_getPos] spawn BIS_fnc_3dcredits;
};

// Create a light in base.
if (!isNull tower1) then {
	objNull spawn {
		private ["_light"];
		_light = "#lightpoint" createVehicleLocal ([tower1] call WC_fnc_getPos);
		_light setLightBrightness 0.4;
		_light setLightAmbient [0.0,0.0,0.0];
		_light setLightColor [1.0,1.0,1.0];
		_light lightAttachObject [tower1, [0,0,15]];
		while {!isNull tower1} do {
			sleep 60;
		};
		deleteVehicle _light;
	};
};

// Outro loser.
_end = createTrigger ["EmptyDetector", wcmapcenter];
_end setTriggerArea [10, 10, 0, false];
_end setTriggerActivation ["CIV", "PRESENT", true];
_end setTriggerStatements [
	"(wcteamscore < wcscorelimitmin)",
	"wcanim = objNull spawn WC_fnc_outrolooser;",
	""
];

// Outro score winner.
_end_2 = createTrigger ["EmptyDetector", wcmapcenter];
_end_2 setTriggerArea [10, 10, 0, false];
_end_2 setTriggerActivation ["CIV", "PRESENT", true];
_end_2 setTriggerStatements [
	"(wcteamscore > wcscorelimitmax)",
	"wcanim = objNull spawn WC_fnc_outro;",
	""
];

// Outro level winner.
_end_3 = createTrigger ["EmptyDetector", wcmapcenter];
_end_3 setTriggerArea [10, 10, 0, false];
_end_3 setTriggerActivation ["CIV", "PRESENT", true];
_end_3 setTriggerStatements [
	"(wclevel > (wclevelmax - 1))",
	"wcanim = objNull spawn WC_fnc_outro;",
	""
];

// Menu options when player is in vehicle.
_menu_option = createTrigger ["EmptyDetector", [player] call WC_fnc_getPos];
_menu_option setTriggerArea [0, 0, 0, false];
_menu_option setTriggerActivation ["NONE", "PRESENT", true];
_menu_option setTriggerTimeout [5, 5, 5, false];
_menu_option setTriggerStatements [
	"vehicle player != player",
	"wcvehicle = vehicle player;
	wcactionmenuoption = wcvehicle addAction ['<t color=''#ff4500''>Mission Info</t>', 'warcontext\dialogs\WC_fnc_createmenumissioninfo.sqf', [], 5, false];
	objNull spawn WC_fnc_checkpilot; enableEnvironment false;",
	"wcvehicle removeAction wcactionmenuoption;
	if (wcwithenvironment == 1) then {enableEnvironment true};"
];

// Load player items and diary.
objNull spawn WC_fnc_clientitems;
objNull spawn WC_fnc_creatediary;

/*
	Add ammobox.
	If autoload weapons then add addons ammobox.
*/
[getMarkerPos "crate1", "base"] spawn WC_fnc_createammobox;
if (wcautoloadweapons == 1) then {
	[getMarkerPos "autoloadcrate", "addons"] spawn WC_fnc_createammobox;
};

// Load player markers.
if (wcwithmarkers == 1) then {
	objNull spawn WC_fnc_playersmarkers;
	//objNull spawn WC_fnc_vehiclesmarkers;
};

// Load player rank.
objNull spawn WC_fnc_playerranking;

// Load base hospital.
objNull spawn {
	private ["_marker", "_message"];
	_marker = getMarkerPos "hospital";
	while {true} do {
		if (([player, _marker] call WC_fnc_getDistance) <= 5) then {
			_message = ["You retrieved", format ["your %1 revives", R3F_REV_CFG_nb_reanimations]];
			_message spawn EXT_fnc_infotext;
			R3F_REV_nb_reanimations = R3F_REV_CFG_nb_reanimations;
			player setDamage 0;
			wcclientlogs set [count wcclientlogs, format ["Hospital: you retrieved your %1 revives", R3F_REV_CFG_nb_reanimations]];
			waitUntil {sleep 60; ([player, _marker] call WC_fnc_getDistance) > 5};
		};
		sleep 10;
	};
};

// Addaction target grabber.
objNull spawn WC_fnc_targetaction;

// Load ied detector.
objNull spawn WC_fnc_ieddetector;

// Load addaction medic menu.
if (wceverybodymedic == 1 || {(typeOf player) in wcmedicclass}) then {
	objNull spawn {
		private ["_medic_menu", "_medic_target"];
		_medic_menu = -1;
		while {true} do {
			_medic_target = cursorTarget;
			if (([player, _medic_target] call WC_fnc_getDistance) < 5 && {_medic_target == cursorTarget && {_medic_target isKindOf "CAManBase"} && {alive _medic_target} && {damage _medic_target >= 0.1}}) then {
				if (_medic_menu < 0) then {
					_medic_menu = player addAction [format ["<t color='#dddd00'>Heal %1</t>", name _medic_target], "warcontext\actions\WC_fnc_doheal.sqf", _medic_target, 6, false];
				};
				waitUntil {sleep 0.5; ([player, _medic_target] call WC_fnc_getDistance) > 5 || {_medic_target != cursorTarget || {!(_medic_target isKindOf "CAManBase")} || {!alive _medic_target} || {damage _medic_target < 0.1}}};
				if (_medic_menu >= 0) then {
					player removeAction _medic_menu;
					_medic_menu = -1;
				};
			} else {
				sleep 0.5;
			};
		};
	};
};

// If player dies, end of game for one life mission.
if (wcwithonelife == 1) then {
	_end = createTrigger ["EmptyDetector", wcmapcenter];
	_end setTriggerArea [10, 10, 0, false];
	_end setTriggerActivation ["CIV", "PRESENT", true];
	_end setTriggerStatements [
		"!alive player && local player",
		"tskExample1 = player createSimpleTask ['Task Message'];
		tskExample1 setSimpleTaskDescription ['Task Message', 'You have been killed', 'You have been killed'];
		wctoonelife = name player; ['wctoonelife', 'server'] call WC_fnc_publicvariable;",
		""
	];
	_end setTriggerType "END1";
	objNull spawn {
		while {true} do {
			if ((name player) in wconelife) then {
				removeAllWeapons player;
				removeAllItems player;
				player enableSimulation false;
			};
			sleep 10;
		};
	};
};

//--- Spawns client side loop.
objNull spawn {
	private [
		"_team_level_check", "_team_level_old_level", "_team_level_ranked", "_player_rating_check", "_teamplay_score_check",
		"_teamplay_score_sleep", "_admin_check", "_attached_count", "_attached_bool", "_attached_animation","_attached_drag_menu",
		"_menu_radio", "_hostage_count_scream", "_team_level_promote", "_message", "_playable_units", "_attached_units",
		"_attached_unit", "_distance", "_all_units"
	];

	//--- Team level.
	_team_level_check = 0;
	_team_level_old_level = 5;

	if (wckindofgame == 1) then {
		_team_level_ranked = [
			-60,
			-40,
			-20,
			0,
			20,
			40,
			60,
			80
		];
	} else {
		_team_level_ranked = [
			-15,
			-10,
			-5,
			0,
			5,
			10,
			15,
			20
		];
	};

	//--- Player rating.
	_player_rating_check = 0;

	//--- Teamplay score.
	_teamplay_score_check = 0;
	_teamplay_score_sleep = 60;

	//--- Admin check.
	_admin_check = 0;

	//--- Drag wounded.
	_attached_count = 0;
	_attached_bool = false;
	_attached_animation = ["AmovPpneMstpSnonWnonDnon_healed","AmovPpneMstpSnonWnonDnon_injured"];
	_attached_drag_menu = -1;

	//--- Radio menu.
	_menu_radio = -1;

	//--- Hostage scream.
	_hostage_count_scream = 0;

	while {true} do {
		//--- Team level.
		if (_team_level_check > 5) then {
			wcteamlevel = switch (true) do {
				case (wcteamscore >= (_team_level_ranked select 7)): {1};
				case (wcteamscore >= (_team_level_ranked select 6)): {2};
				case (wcteamscore >= (_team_level_ranked select 5)): {3};
				case (wcteamscore >= (_team_level_ranked select 4)): {4};
				case (wcteamscore >= (_team_level_ranked select 3)): {5};
				case (wcteamscore >= (_team_level_ranked select 2)): {6};
				case (wcteamscore >= (_team_level_ranked select 1)): {7};
				default {8};
			};

			if (_team_level_old_level != wcteamlevel) then {
				_team_level_old_level = wcteamlevel;

				_team_level_promote = localize format ["STR_WC_TEAM%1", wcteamlevel];

				if (_team_level_old_level > wcteamlevel) then {
					_message = [localize "STR_WC_MESSAGETEAMPROMOTED", format ["to %1 !", _team_level_promote]];
				} else {
					_message = [localize "STR_WC_MESSAGETEAMDEGRADED", format ["to %1 !", _team_level_promote]];
				};

				_message spawn EXT_fnc_infotext;
				playSound "drum";
			};

			_team_level_check = 0;
		};

		//--- Player rating.
		if (_player_rating_check > 4) then {
			if (rating player < 0) then {
				if (driver (vehicle player) == player) then {
					player addRating (rating player * -1);
					["You have got a blame"] call BIS_fnc_dynamicText;

					wctk = name player;
					["wctk", "server"] call WC_fnc_publicvariable;
				};
			} else {
				if (rating player < 3000) then {
					player addRating 3000;
				};
			};

			_player_rating_check = 0;
		};

		//--- Teamplay bonus.
		_playable_units = playableUnits - [player];
		{
			if (([player, _x] call WC_fnc_getDistance) <= 100) then {
				wcbonus = wcbonus + 1;
			};
			sleep 0.01;
		} forEach _playable_units;

		if (wcbonus > 10000) then {
			_message = ["You have won", "10 points Teamplay bonus"];
			_message spawn EXT_fnc_infotext;

			wcbonus = 0;

			wcplayeraddscore = [player, 10];
			["wcplayeraddscore", "server"] call WC_fnc_publicvariable;

			wcclientlogs set [count wcclientlogs, "Teamplay bonus: 10 personnal points"];
		};

		//--- Teamplay score.
		if (_teamplay_score_check > _teamplay_score_sleep) then {
			if (wcteamplayscore > 0) then {
				["Share points", format [localize "STR_WC_TRANSFERTPOINT", wcteamplayscore], localize "STR_WC_SHAREPOINTS", 10] spawn WC_fnc_playerhint;
				_teamplay_score_sleep = 60;
			} else {
				_teamplay_score_sleep = 180;
			};

			_teamplay_score_check = 0;
		};

		//--- Admin check.
		if (_admin_check > 5) then {
			if (serverCommandAvailable "#kick") then {
				wcadmin = true;
			} else {
				if ((getPlayerUID player) in wcteammembers) then {
					wcadmin = true;
				} else {
					wcadmin = false;
				};
			};

			_admin_check = 0;
		};

		//--- Drag wounded.
		if (!_attached_bool) then {
			_attached_units = (nearestObjects [[player] call WC_fnc_getPos, ["CAManBase"], 2]) - [player];
			if (count _attached_units > 0) then {
				{
					if ((animationState _x) in _attached_animation) exitWith {
						if (_attached_drag_menu < 0) then {
							_attached_drag_menu = player addAction [format ["<t color='#dddd00'>Drag %1</t>", name _x], "warcontext\actions\WC_fnc_dodrag.sqf", [], -1, false];
						};
						if (wcdragged) then {
							player playMove "acinpknlmstpsraswrfldnon";
							_x attachTo [player, [0.1,1.01,0]];
							_attached_bool = true;
							_attached_unit = _x;
						};
					};
				} forEach _attached_units;
			} else {
				if (_attached_drag_menu >= 0) then {
					player removeAction _attached_drag_menu;
					_attached_drag_menu = -1;
				};
			};
		} else {
			_attached_count = _attached_count + 1;

			if (_attached_count > 10) then {
				wcdragged = false;
				_attached_bool = false;
				detach _attached_unit;
				_attached_count = 0;
				player playAction "released";
			};
		};

		//--- Radio menu.
		if (wcwithACE == 1) then {
			if ([player] call ACE_fnc_HasRadio) then {
				if (_menu_radio < 0) then {
					_menu_radio = player addAction [("<t color=""#dddd00"">" + STR_R3F_ARTY_action_ouvrir_dlg_SM + "</t>"), "extern\R3F_ARTY_AND_LOG\R3F_ARTY\poste_commandement\ouvrir_dlg_saisie_mission.sqf", nil, 6, true, true, "", "vehicle player == player"];
				};
			} else {
				if (_menu_radio >= 0) then {
					player removeAction _menu_radio;
					_menu_radio = -1;
				};
			};
		};

		//--- Nuclear zone.
		if (wcwithnuclear == 1) then {
			if (!wcplayerinnuclearzone) then {
				if (count wcnuclearzone > 0) then {
					{
						if (([player, _x] call WC_fnc_getDistance) < 500) exitWith {
							[_x] spawn WC_fnc_createnuclearzone;
						};
						sleep 0.01;
					} forEach wcnuclearzone;
				};
			};
		};

		//--- Alarm sound.
		if (wcradioalive) then {
			if (wcalert > 99) then {
				if (!wcdetected) then {
					_distance = [player, wcselectedzone] call WC_fnc_getDistance;

					if (_distance < 150) then {
						playSound "alarm1";
					} else {
						if (_distance < 300) then {
							playSound "alarm2";
						} else {
							if (_distance < 450) then {
								playSound "alarm3";
							};
						};
					};

					wcdetected = true;
				};
			} else {
				wcdetected = false;
			};
		};

		//--- Hostage scream.
		_all_units = ([player] call WC_fnc_getPos) nearEntities ["CAManBase", 100];
		{
			if (_x getVariable ["wchostage", false]) exitWith {
				_hostage_count_scream = _hostage_count_scream + 1;

				if (_hostage_count_scream > 10) then {
					_hostage_count_scream = 0;

					_distance = [player, _x] call WC_fnc_getDistance;

					if (_distance > 60) then {
						playSound "help3";
					} else {
						if (_distance > 20) then {
							playSound "help2"
						} else {
							playSound "help1"
						};
					};
				};
			};
			sleep 0.01;
		} forEach _all_units;

		sleep 1;

		_team_level_check = _team_level_check + 1;
		_player_rating_check = _player_rating_check + 1;
		_teamplay_score_check = _teamplay_score_check + 1;
		_admin_check = _admin_check + 1;
	};
};

_kind_of_game = switch (wckindofgame) do {
	case 1: {"ARCADE"};
	case 2: {"SIMULATION"};
	case 3: {"PRACTICE"};
};

wcclientlogs set [count wcclientlogs, localize "STR_WC_MESSAGEMISSIONINITIALIZED"];

sleep 30;

[localize "STR_WC_MENUWELCOMEBASE", localize "STR_WC_MENUTAKEWEAPONS", format [localize "STR_WC_MENUKINDOFGAME", _kind_of_game], 10] spawn WC_fnc_playerhint;

// Initialize player score on server.
wcplayeraddscore = [player, -1];
["wcplayeraddscore", "server"] call WC_fnc_publicvariable;

// Notify server that player is ready.
wcplayerreadyadd = name player;
["wcplayerreadyadd", "server"] call WC_fnc_publicvariable;

// Init tpwcas ai suppression.
if (wcaisuppression == 1 && !WC_isServer) then {
	[2] execVM "extern\tpwcas\tpwcas_script_init.sqf";
};

// Refresh persistent markers
objNull call WC_fnc_refreshmarkers;

// Load vehicle manager.
if (wcvehiclemanager == 1) then {
	objNull spawn WC_fnc_vehicleManager;
};
