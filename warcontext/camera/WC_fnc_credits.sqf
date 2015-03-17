// -----------------------------------------------
// Author:     code34 nicolas_boiteux@yahoo.fr
// Edited by:  Neumatic
// Warcontext: Camera focus on object
// -----------------------------------------------

private ["_player", "_dir", "_position", "_credit_send", "_text", "_texts"];

waitUntil {isNull wccam};

disableSerialization;

wccam = "camera" camCreate [0,0,1000];
wccam cameraEffect ["internal", "back"];
ShowCinemaBorder true;

_credit_send = false;

playMusic "EP1_Track06";

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
	"Thanks to Air Commando Team",
	"You can find more information about WIT at BIS FORUM"
];

2 cutRsc ["warcontextlabel","PLAIN"];

while {!_credit_send} do {
	_text = _texts select 0;
	_texts = _texts - [_text];

	_player = allUnits call WC_fnc_selectRandom;
	while {format ["%1", [_player] call WC_fnc_getPos] == "[0,0,0]"} do {
		_player = allUnits call WC_fnc_selectRandom;
	};

	titleText [_text, "BLACK FADED"];
	sleep 2;
	waitUntil {preloadCamera ([_player] call WC_fnc_getPos)};
	titleText ["", "PLAIN"];

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
		wccam camSetRelPos [random 4, random 4, random 2.5];
		wccam camCommit 0;
		wccam camSetRelPos [2, 1, 1.65];
		wccam camCommit 7;
	};

	sleep 7;

	if (count _texts == 0) then {
		_credit_send = true;
	};
};

_text = "A mission designed by code34";
titleText [_text, "BLACK FADED"];
sleep 2;

titleText ["", "PLAIN"];

wccam cameraEffect ["terminate","back"];
camDestroy wccam;
wccam = objNull;
