// -----------------------------------------------
// Author:     code34 nicolas_boiteux@yahoo.fr
// Edited by:  Neumatic
// Warcontext: Create a mission dialog box
// -----------------------------------------------

private [
	"_players", "_temp", "_new_players", "_recruitment_list", "_original_team", "_name", "_kind_of_game", "_text", "_rank",
	"_ctrl", "_index", "_type", "_member_fired"
];

// If noteam server
if (wckindofserver == 3) exitWith {
	[localize "STR_WC_MENUTEAMMANAGEMENT", "Restart the game with team parameter ON to manage team", "There is no team", 10] spawn WC_fnc_playerhint;
	closeDialog 0;
};

waitUntil {isNull wccam};

wccam = "camera" camCreate [0,0,1000];
wccam cameraEffect ["internal", "back"];

showCinemaBorder false;
wccam camSetTarget clothes;
wccam camSetRelPos [-5, -10, 2.5];
wccam camCommit 0;
wccameffect = ppEffectCreate ["ColorCorrections", 1999];
wccameffect ppEffectEnable true;
wccameffect ppEffectAdjust [0.5, 0.7, 0.0, [1.0,1.0,1.0,0.0], [1.0,1.0,1.0,0.0], [1.0,1.0,1.0,1.0]];
wccameffect ppEffectCommit 0;

_players = [];
_temp = [];
_new_players = [];
_recruitment_list = [];
_original_team = wcinteam;

// Only a trick to delete disconnect players
{
	_name = name _x;
	if (_name in _original_team) then {
		_temp set [count _temp, _name];
	};
} forEach allUnits;
_original_team = _temp;

disableSerialization;
(uiNamespace getVariable "wcdisplay") displayCtrl 6001;

{
	if (isPlayer _x && {!(name _x in _original_team)} && {side _x == west}) then {
		_players set [count _players, _x];
	};
} forEach allUnits;

{
	lbAdd [6002, name _x];
} forEach _players;
lbSetCurSel [6002, 0];

if (!wcadmin) then {
	ctrlShow [6004, false];
	ctrlShow [6001, false];
	ctrlShow [6002, false];
	ctrlShow [6005, false];
};

_kind_of_game = if (wckindofgame == 1) then {"arcade"} else {"simulation"};

menuaction = -1;

while {dialog && {alive player}} do {
	_text = format ["MEMBERS OF TEAM v%1<br/>", wcversion];
	_text = _text + localize format ["STR_WC_TEAM%1", wcteamlevel] + "<br/>" + format ["%1", _kind_of_game] + " game" + "<br/>" + format ["Day:%1 EKilled:%2 Lvl:%3 Mission:%4 Team score:%5", wcday, wcenemykilled, wclevel, (wcmissioncount - wclevel), wcteamscore] + "<br/><br/>";
	_text = _text + format ["Members of team: %1<br/>", count _original_team];

	{
		_rank = _x;
		{
			_name = name _x;
			if ((format ["%1", _name] != "") && {(format ["%1", _name] != "Error: No unit")}) then {
				if (_name in _original_team && {_rank == rank _x} && {!(_name in _recruitment_list)}) then {
					lbAdd [6008, _name];
					_recruitment_list set [count _recruitment_list, _name];
				};
			};
		} forEach playableUnits;
	} forEach ["COLONEL","MAJOR","CAPTAIN","LIEUTENANT","SERGEANT","CORPORAL","PRIVATE"];

	_ctrl = (uiNamespace getVariable "wcdisplay") displayCtrl 6003;
	_ctrl ctrlSetStructuredText (parseText _text);

	_index = lbCurSel 6002;
	_type = lbText [6002, _index];

	if (menuaction > 0) then {
		switch (menuaction) do {
			case 1: {
				if (wcadmin) then {
					if (!isNil "_type") then {
						_original_team set [count _original_team, _type];
						_new_players set [count _new_players, _type];
						lbClear 6002;

						_players = [];
						{
							if (isPlayer _x && {!(name _x in _original_team)}) then {
								_players set [count _players, _x];
							};
						} forEach allUnits;

						{
							lbAdd [6002, name _x];
						} forEach _players;
					};
				} else {
					closeDialog 0;
				};
			};

			case 2: {
				if (wcadmin) then {
					_index = lbCurSel 6008;
					_type = lbText [6008, _index];
					lbDelete [6008, _index];
					lbAdd [6002, _type];

					if (!isNil "_type") then {
						_original_team = _original_team - [_type];
						_recruitment_list = _recruitment_list - [_type];
					};
				} else {
					closeDialog 0;
				};
			};
		};

		_type = nil;
		menuaction = -1;
	};

	sleep 0.1;
};

if (!wcadmin) then {
	[localize "STR_WC_MENUTEAMMANAGEMENT", "Log you as server admin", "You can not recruit team members", 10] spawn WC_fnc_playerhint;
} else {
	_member_fired = wcinteam - _original_team;
	wcinteam = _original_team;
	["wcinteam", "server"] call WC_fnc_publicvariable;

	{
		wcinteamintegration = _x;
		["wcinteamintegration", "client"] call WC_fnc_publicvariable;
		sleep 1;
	} forEach _new_players;

	{
		wcinteamfired = _x;
		["wcinteamfired", "client"] call WC_fnc_publicvariable;
		sleep 1;
	} forEach _member_fired;
};

ppEffectDestroy wccameffect;
wccam cameraEffect ["terminate", "back"];
camDestroy wccam;
wccam = objNull;
