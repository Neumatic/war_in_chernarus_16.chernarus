// -----------------------------------------------
// Author:     code34 nicolas_boiteux@yahoo.fr
// Edited by:  Neumatic
// Warcontext: Camera focus on object
// -----------------------------------------------

private ["_player", "_dir", "_position", "_text", "_texts", "_team_promote", "_music", "_date"];

waitUntil {isNull wccam};
waitUntil {!(player getVariable "deadmarker")};

_position = [getMarkerPos "respawn_west", 0, 150, sizeOf "RU_Soldier", 0.2] call WC_fnc_getEmptyPosition;
if (count _position == 0) then {
	player setPos wcmapcenter;
} else {
	player setPos _position;
};

disableSerialization;

wccam = "camera" camCreate [0,0,1000];
wccam cameraEffect ["internal", "back"];
showCinemaBorder true;
_player = player;
_dir = getDir _player;
_position =  [(([_player] call WC_fnc_getPos) select 0) + ((sin _dir) * 2), (([_player] call WC_fnc_getPos) select 1) + ((cos _dir) * 2), (([_player] call WC_fnc_getPos) select 2) + 1.5];
wccam camSetPos _position;
wccam camSetTarget _player;
wccam camSetFOV 0.900;
wccam camCommit 0;

_team_promote = localize format ["STR_WC_TEAM%1", wcteamlevel];
_text = format ["Congratulations.\nYou finish the campaign: War In %1: operation iron rains.\n\nYou win your tickets to return home after %2 days.\nYour team level was: %3", worldName, wcday, _team_promote];

titleText [_text, "BLACK FADED"];
sleep 6;

titleText ["", "PLAIN"];

_music = wcjukebox call WC_fnc_selectRandom;
playMusic _music;

sleep 4;

_date = date;
setDate [1986, 2, 25, 17, 0];

_texts = [
	localize "STR_WC_TITLE_MISSION",
	"External Scripts",
	"UPS, UPSMON: patrol IA scripting by Kronzky & Monsada",
	"Revive, Artillery, Debug by R3F Team,",
	"Domination by Xeno",
	"Atot By Miguel Rodriguez, Base by Ei8ght,",
	"Nuclear Nuke by Benny Warfare",
	"ACE: Magic Box",
	"Spectator by Kegetys",
	"Takistan Force by Bon: Loadout Preset",
	"ValHalla mission: crew informations",
	"FlashpointChernarus107 mission: civil cars idea",
	"and all others that i can forgot (..)",
	"Thanks to Slerbal for his english translation",
	"Thanks to Fruity Rudy",
	"Thanks to Ei8ght, Mario",
	"Thanks to my friends",
	"You can find more information about WIT at BIS FORUM"
];

while {count _texts > 0} do {
	_text = _texts select 0;
	_texts = _texts - [_text];

	titleText [_text, "BLACK FADED"];
	sleep 2;

	titleText ["", "PLAIN"];

	_player = allUnits call WC_fnc_selectRandom;
	while {format ["%1", [_player] call WC_fnc_getPos] == "[0,0,0]"} do {
		_player = allUnits call WC_fnc_selectRandom;
	};

	cutText [format ["%1", name _player], "PLAIN DOWN", 0];

	if (random 1 > 0.5) then {
		_dir = getDir _player;
		_position =  [(([_player] call WC_fnc_getPos) select 0) + ((sin _dir) * 2), (([_player] call WC_fnc_getPos) select 1) + ((cos _dir) * 2), (([_player] call WC_fnc_getPos) select 2) + 1.5];
		wccam camSetPos _position;
		wccam camSetTarget _player;
		wccam camSetFOV 0.900;
		wccam camCommit 0;
	} else {
		wccam camSetTarget _player;
	 	_player setCameraInterest 50;
		wccam camSetRelPos [-4, -14, 1.65];
		wccam camCommit 0;
		wccam camSetRelPos [10, -4, random 20];
		wccam camCommit 7;
	};

	sleep 7;
};

setDate _date;

wccam cameraEffect ["terminate", "back"];
camDestroy wccam;
wccam = objNull;
