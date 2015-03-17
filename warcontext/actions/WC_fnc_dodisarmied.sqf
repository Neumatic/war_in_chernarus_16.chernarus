// -----------------------------------------------
// Author:     code34 nicolas_boiteux@yahoo.fr
// Edited by:  Neumatic
// Warcontext: Ied keypad challenge
// -----------------------------------------------

private [
	"_object", "_caller", "_param", "_training", "_count", "_letters", "_last_letter", "_last_count", "_letter", "_time",
	"_pos"
];

_object = _this select 0;
_caller = _this select 1;
_param  = _this select 3;

_training = if (count _param == 0) then {false} else {true};

// Arcade = 1
if (wckindofgame == 1) then {
	_count = 0;
} else {
	_count = ceil (wclevel + random 10);
};

_letters = ["1","2","3","4","5","6","7","8","9"];

wciedexplosed = false;
wciedcount = 0;
wciedchallenge = true;

["Disarm Ied", "Complete the combo keys sequence to disarm ied.", "Press the same numpad keys printed on the screen", 10] spawn WC_fnc_playerhint;
sleep 6;

_caller playMove "AinvPknlMstpSlayWrflDnon_medic";
["GO"] spawn BIS_fnc_dynamicText;
sleep 1;

[""] spawn BIS_fnc_dynamicText;

_last_letter = "";

while {wciedcount < _count && {!wciedexplosed}} do {
	_last_count = wciedcount;
	if (animationState _caller != "AinvPknlMstpSlayWrflDnon_medic") then {
		_caller switchMove "AinvPknlMstpSlayWrflDnon_medic";
	};
	waitUntil {_letter = _letters call WC_fnc_selectRandom; _letter != _last_letter};
	_last_letter = _letter;
	iedkey = _letter;
	_time = ceil (random 4);
	2 cutRsc [format ["keypad%1", _letter], "PLAIN"];
	2 cutFadeOut _time;
	sleep _time;
	if ((wciedcount - _last_count) != 1) then {wciedexplosed = true};
};

if (wciedexplosed) then {
	["FAILED"] spawn BIS_fnc_dynamicText;

	if (!_training) then {
		wchintW = format ["An ied has exploded near %1", name _caller];
		["wchintW", "client"] call WC_fnc_publicvariable;
		_pos = [_caller] call WC_fnc_getPos;
		createVehicle ["ARTY_R_227mm_HE", _pos, [], 0, "NONE"];
		createVehicle ["Bo_GBU12_LGB", _pos, [], 0, "NONE"];
		wcteambonusaddscore = -1;
		["wcteambonusaddscore", "server"] call WC_fnc_publicvariable;
	};
} else {
	["SUCCESS"] spawn BIS_fnc_dynamicText;

	if (!_training) then {
		wchintW = format ["An ied has been disarm by %1", name _caller];
		["wchintW", "client"] call WC_fnc_publicvariable;
		wcteambonusaddscore = 3;
		["wcteambonusaddscore", "server"] call WC_fnc_publicvariable;
	};
};

if (!_training) then {
	_object setVariable ["wciedactivate", false, true];

	wcremoveaction = [_object, "Action_IED"];
	["wcremoveaction", "client"] call WC_fnc_publicvariable;
};

wciedchallenge = false;
