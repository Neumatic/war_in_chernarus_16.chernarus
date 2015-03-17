// -----------------------------------------------
// Author:     code34 nicolas_boiteux@yahoo.fr
// Edited by:  Neumatic
// Warcontext: Camera focus on object
// -----------------------------------------------

if (wcwithcam == 1) exitWith {};

private [
	"_object", "_mission_text", "_exit", "_distance", "_x_sign", "_y_sign", "_object_pos", "_alt", "_x", "_y", "_new_x",
	"_new_y", "_sleep", "_size", "_music"
];

_object = _this select 0;

waitUntil {isNull wccam};

_sleep = 0;
_exit = false;
_size = round (sizeOf (typeOf _object));

if (!wccamgoalwithcolor) then {
	wccameffect = ppEffectCreate ["ColorCorrections", 1999];
	wccameffect ppEffectEnable true;
	wccameffect ppEffectAdjust [0.5, 0.7, 0.0, [1.0,1.0,1.0,0.0], [1.0,1.0,1.0,0.0], [1.0,1.0,1.0,1.0]];
	wccameffect ppEffectCommit 0;
};

if (isNil "_object") then {
	_object = anim;
	_mission_text = [localize "STR_WC_MESSAGEMISSIONCOMMANDEMENT", localize "STR_WC_MESSAGNEXTSTEP"];
} else {
	_mission_text = wcobjective select 4;
};

if (!alive _object) then {
	_object = anim;
	_mission_text = [localize "STR_WC_MESSAGEMISSIONCOMMANDEMENT", localize "STR_WC_MESSAGNEXTSTEP"];
};

waitUntil {isNull wccam};
waitUntil {preloadCamera ([_object] call WC_fnc_getPos)};

#ifdef _MISSIONVOIDS_
	_sound = format ["missionvoid%1", wcobjective select 2];
	playSound _sound;
#else
	_music = wcjukebox call WC_fnc_selectRandom;
	playMusic _music;
#endif

wccam = "camera" camCreate [0,0,1000];
wccam cameraEffect ["internal", "back"];
showCinemaBorder true;

switch (wcwithcam) do {
	case 1: {
		_exit = true;
	};

	case 2: {
		wccam camSetTarget _object;
		_object setCameraInterest 50;
		wccam camSetRelPos [-2, -2, 2];
		wccam camCommit 0;
		_distance = 10;
	};

	case 3: {
		wccam camSetTarget _object;
		_object setCameraInterest 50;
		wccam camSetRelPos [-50, -50, 15];
		wccam camCommit 0;
		_distance = 200;
	};

	case 4: {
		wccam camSetTarget _object;
		_object setCameraInterest 50;
		wccam camSetRelPos [-2, -2, 500];
		wccam camCommit 0;
		_distance = 200;
	};
};

"FilmGrain" ppEffectEnable true;

// Print mission text
_mission_text spawn EXT_fnc_infotext;

while {(format ["%1", wcanim] != "") && {(_sleep < 60)}} do {
	_x = 2 + (random _distance) + _size;
	_y = 2 + (random _distance) + _size;
	if (random 1 > 0.5) then {_x_sign = 1} else {_x_sign = -1};
	if (random 1 > 0.5) then {_y_sign = 1} else {_y_sign = -1};

	_object_pos = [_object] call WC_fnc_getPos;

	if (_distance == 10) then {
		_alt = 1 + (random 2) + (_object_pos select 2);
	} else {
		_alt = 2 + (random 20);
	};

	if (wcwithcam == 4) then {
		_alt = 300 + (random 200);
	};

	_new_x = (_object_pos select 0) + (_x * _x_sign);
	_new_y = (_object_pos select 1) + (_y * _y_sign);

	if (!wccamgoalanimate) then {
		wccam camSetPos [_new_x, _new_y, _alt];
		wccam CamCommit 0;
	} else {
		wccam camSetRelPos [(_x * _x_sign), (_y * _y_sign), _alt];
		wccam CamCommit 10;
	};

	"FilmGrain" ppEffectAdjust [random 0.2, 5, 3.42, 10, 8.5, false];
	"FilmGrain" ppEffectCommit 0;
	sleep 5;

	"FilmGrain" ppEffectAdjust [1, 1, 3.42, 10, 8.5, false];
	"FilmGrain" ppEffectCommit 0.2;

	sleep (random 0.2);
	_sleep = _sleep + 5;
};

"FilmGrain" ppEffectEnable false;

ppEffectDestroy wccameffect;
wccam cameraEffect ["terminate","back"];
camDestroy wccam;
wccam = objNull;
camUseNVG false;
