// -----------------------------------------------
// Author:     code34 nicolas_boiteux@yahoo.fr, Xeno - domination
// Edited by:  Neumatic
// Warcontext: Create a mission info dialog box
// -----------------------------------------------

private ["_mission_number", "_objective", "_info", "_team_promote"];

disableSerialization;
(findDisplay 10000) displayCtrl 10004;

if (isNil "WC_fnc_fixheadbug") then {
	WC_fnc_fixheadbug = {
		private ["_pos", "_vehicle"];

		closeDialog 0;
		titleCut ["", "BLACK IN", 1];

		_pos = [player] call WC_fnc_getPos;
		_vehicle = "Lada1" createVehicleLocal [0,0,0];
		player moveInCargo _vehicle;
		deleteVehicle _vehicle;
		player setPos _pos;
	};
};

//playSound "paper";

ctrlSetText [10001, format [localize "STR_WC_BRIEFING", (wclevelmax - 1)]];

if (!isNil "wcenemykilled") then {
	ctrlSetText [10005, format [localize "STR_WC_ENNEMYKILLED", wcenemykilled]];
} else {
	wcenemykilled = 0;
	ctrlSetText [10005, format [localize "STR_WC_ENNEMYKILLED", wcenemykilled]];
};

ctrlSetText [10007, format [localize "STR_WC_IASKILL", (wcskill * 100)] + "%"];
ctrlSetText [10012, format [localize "STR_WC_TEAMSCORE", wcteamscore]];
ctrlSetText [10011, format [localize "STR_WC_AMMOUSED", (wcammoused - 1)]];
ctrlSetText [10013, format [localize "STR_WC_REVIVELEFT", R3F_REV_nb_reanimations]];

if (!isNil "wcobjective") then {
	_mission_number = (wcobjective select 2);

	switch (_mission_number) do {
		case 1: {
			_objective = format [localize "STR_WC_MISSION1", [wcobjective select 1] call WC_fnc_getDisplayName];
		};

		case 2: {
			_objective = format [localize "STR_WC_MISSION2", [wcobjective select 1] call WC_fnc_getDisplayName];
		};

		case 3: {
			_objective = format [localize "STR_WC_MISSION3", [wcobjective select 1] call WC_fnc_getDisplayName];
		};

		case 4: {
			_objective = format [localize "STR_WC_MISSION1", [wcobjective select 1] call WC_fnc_getDisplayName];
		};

		case 5: {
			_objective = format [localize "STR_WC_MISSION1", [wcobjective select 1] call WC_fnc_getDisplayName];
		};

		case 6: {
			_objective = format [localize "STR_WC_MISSION1", [wcobjective select 1] call WC_fnc_getDisplayName];
		};

		case 7: {
			_objective = format [localize "STR_WC_MISSION7", [wcobjective select 1] call WC_fnc_getDisplayName];
		};

		case 8: {
			_objective = format [localize "STR_WC_MISSION8", [wcobjective select 1] call WC_fnc_getDisplayName];
		};

		case 9: {
			_objective = format [localize "STR_WC_MISSION9", [wcobjective select 1] call WC_fnc_getDisplayName];
		};

		case 10: {
			_objective = format [localize "STR_WC_MISSION10", [wcobjective select 1] call WC_fnc_getDisplayName];
		};

		case 11: {
			_objective = format [localize "STR_WC_MISSION11", [wcobjective select 1] call WC_fnc_getDisplayName];
		};

		case 12: {
			_objective = format [localize "STR_WC_MISSION12", [wcobjective select 1] call WC_fnc_getDisplayName];
		};

		case 70: {
			_objective = format [localize "STR_WC_MISSION70", [wcobjective select 1] call WC_fnc_getDisplayName];
		};

		case 71: {
			_objective = format [localize "STR_WC_MISSION71", [wcobjective select 1] call WC_fnc_getDisplayName];
		};

		default {
			_objective = localize format ["STR_WC_MISSION%1", _mission_number];
		};
	};

	ctrlSetText [10006, format ["%1\n\n%2", wcobjective select 3, _objective]];
} else {
	ctrlSetText [10006, format [localize "STR_WC_OPERATIONGOAL", localize "STR_WC_NOTYETDEFINE"]];
};

_info = switch (wcteamlevel) do {
	case 1: {localize "STR_WC_HEROETEAM"};
	case 2: {localize "STR_WC_ELITETEAM"};
	case 3: {localize "STR_WC_EXPERIENCEDTEAM"};
	case 4: {localize "STR_WC_CONFIRMEDTEAM"};
	case 5: {localize "STR_WC_NOOBTEAM"};
	case 6: {localize "STR_WC_CALAMITYTEAM"};
	case 7: {localize "STR_WC_BASTARDTEAM"};
	case 8: {localize "STR_WC_ASSHOLETEAM"};
};

if (wckindofserver != 3) then {
	if (name player in wcinteam) then {
		_team_promote = localize format ["STR_WC_TEAM%1", wcteamlevel];
		ctrlSetText [10009, format ["%3 : %1\n\n%2", _team_promote, _info, localize "STR_WC_ACTUALLYYOURTEAMRANK"]];
	};
};
