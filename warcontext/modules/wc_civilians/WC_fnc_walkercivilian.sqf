// -----------------------------------------------
// Author:     code34 nicolas_boiteux@yahoo.fr
// Edited by:  Neumatic
// Warcontext: Walker civilian
// -----------------------------------------------

private ["_group", "_town_pos", "_all_units", "_positions", "_behaviour", "_speed_mode", "_civil", "_position"];

_group    = _this select 0;
_town_pos = _this select 1;

_all_units = [];
_positions = [];

_behaviour = "CARELESS";
_speed_mode = "LIMITED";

_group setBehaviour _behaviour;
_group setSpeedMode _speed_mode;

{
	_x allowFleeing 0;
	_x forceWalk true;
	_x setUnitPos "UP";
	_x setVariable ["lastpos", [_x] call WC_fnc_getPos, false];
	_x setVariable ["destination", [_x] call WC_fnc_getPos, false];
	_x setVariable ["moveretry", 0, false];
} forEach units _group;

_positions = [_town_pos, "all", 500] call WC_fnc_gethousespositions;

while {{alive _x} count units _group > 0} do {
	if (count _all_units == 0) then {
		_all_units = units _group;
	};

	_civil = _all_units select 0;
	_all_units = _all_units - [_civil];

	// Exclude all non civilian
	if (_civil getVariable "civilrole" == "civil") then {
		if (([_civil, _civil getVariable "destination"] call WC_fnc_getDistance) < 5) then {
			_position = _positions call WC_fnc_selectRandom;
			_civil setVariable ["destination", _position, false];
			_civil stop false;
			_civil doMove _position;
			_civil setBehaviour _behaviour;
			_civil setSpeedMode _speed_mode;
			_civil setVariable ["moveretry", 0, false];
		} else {
			_civil stop false;
			_civil doMove (_civil getVariable "destination");
			_civil setBehaviour _behaviour;
			_civil setSpeedMode _speed_mode;
		};

		if (format ["%1", _civil getVariable "lastpos"] == format ["%1", [_civil] call WC_fnc_getPos]) then {
			_civil setVariable ["moveretry", (_civil getVariable "moveretry") + 1, false];
		};

		_civil setVariable ["lastpos", [_civil] call WC_fnc_getPos, false];

		if (_civil getVariable "moveretry" > 3) then {
			_position = _positions call WC_fnc_selectRandom;
			_civil stop false;
			_civil setVariable ["destination", _position, false];
			_civil doMove _position;
			_civil setBehaviour _behaviour;
			_civil setSpeedMode _speed_mode;
			_civil setVariable ["moveretry", 0, false];
		};
	};

	sleep 5;
};
