// -----------------------------------------------
// Author:     code34 nicolas_boiteux@yahoo.fr
// Edited by:  Neumatic
// Warcontext: Send variables to join players (JIP)
// -----------------------------------------------

private ["_id", "_uid", "_name", "_count", "_ok", "_player_id", "_variables"];

_id   = _this select 0;
_uid  = _this select 1;
_name = _this select 2;

if (_name == "__SERVER__" || {_uid == ""}) exitWith {};

["INFO", format ["Player %1 connecting...", _name]] call WC_fnc_log;

_ok = true;
_count = 0;

// Wait that jip client is initialized
while {_ok} do {
	if (_name in wcplayerready) then {
		_ok = false;
	} else {
		if (_count > 600) then {
			_ok = false;
		} else {
			_count = _count + 1; sleep 1;
		};
	};
};

{
	if (getPlayerUID _x == _uid || {name _x == _name}) exitWith {
		_player_id = owner _x;
	};
} forEach playableUnits;

if (!isNil "_player_id") then {
	_variables = [
		"wcobjective",
		"wcnuclearzone",
		"wchostage",
		"wccfgpatches",
		"wcday",
		"wcweather",
		"wcselectedzone",
		"wcradioalive",
		"wcskill",
		"wclevel",
		"wcmissioncount",
		"wcalert",
		"wcmotd",
		"wcenemykilled",
		"wccivilkilled",
		"wconelife",
		"wcinteam",
		"wcteleport",
		"wcmainflag",
		"wcflag"
	];

	{
		[_x, "client", _player_id] call WC_fnc_publicvariable;
		sleep 0.1;
	} forEach _variables;

	["INFO", format ["Player %1 connected", _name]] call WC_fnc_log;
} else {
	["INFO", format ["Player %1 failed to connect", _name]] call WC_fnc_log;
};
