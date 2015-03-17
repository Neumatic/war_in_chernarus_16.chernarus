// -----------------------------------------------
// Author:     code34 nicolas_boiteux@yahoo.fr
// Edited by:  Neumatic
// Warcontext: Create a nuclear zone
// -----------------------------------------------

private ["_position", "_effect"];

// If in an air vehicle then exit.
if ((vehicle player) isKindOf "Air") exitWith {};

_position = _this select 0;

wcplayerinnuclearzone = true;

["Nuclear zone", "Nuclear zone injures soldiers.", "Go away from this zone as soon as possible.", 10] spawn WC_fnc_playerhint;

while {alive player && {([player, _position] call WC_fnc_getDistance) < 500}} do {
	"colorCorrections" ppEffectAdjust [1, 0.5, 0, [1,1,1,0], [1,1,1,-1], [1,1,1,1]];
	"colorCorrections" ppEffectCommit 0;
	"colorCorrections" ppEffectEnable true;
	1 setFog 0.1;

	"FilmGrain" ppEffectAdjust [0.17, 3.65, 3.42, 10, 8.5, false];
	"FilmGrain" ppEffectCommit 0;
	"FilmGrain" ppEffectEnable true;
	_effect = getDammage player;

	"dynamicBlur" ppEffectEnable true;
	"dynamicBlur" ppEffectAdjust [_effect];
	"dynamicBlur" ppEffectCommit 1;

	playSound "geiger";
	addCamShake [0.05, 5, 500];
	sleep 4.5;
};

wcplayerinnuclearzone = false;
"FilmGrain" ppEffectEnable false;
"dynamicBlur" ppEffectEnable true;
"dynamicBlur" ppEffectAdjust [0];
"dynamicBlur" ppEffectCommit 1;
