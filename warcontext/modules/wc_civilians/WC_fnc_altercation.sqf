// -----------------------------------------------
// Author:     code34 nicolas_boiteux@yahoo.fr
// Edited by:  Neumatic
// Warcontext: Altercation
// -----------------------------------------------

private [
	"_unit", "_spawn_pos", "_count", "_exit", "_check", "_targets", "_near_units", "_mission_complete", "_jail_pos",
	"_target", "_position", "_old_role", "_positions"
];

_unit = _this select 0;

["INFO", format ["Created a civlian altercation : fame=%1", wcfame]] call WC_fnc_log;

_spawn_pos = [_unit] call WC_fnc_getPos;

_count = 0;
_exit = false;
_check = false;

while {!_check && {alive _unit}} do {
	if ({isPlayer _x && {side _x in wcside}} count (([_unit] call WC_fnc_getPos) nearEntities ["CAManBase", 300]) > 0) then {
		_check = true;
	} else {
		if (_count >= 60) then {
			_check = true; _exit = true;
		} else {
			_count = _count + 1; sleep 1;
		};
	};
};

if (!alive _unit) exitWith {};
if (_exit) exitWith {_unit setVariable ["civilrole", "civil", true]};

_targets = [];

_near_units = (([_unit] call WC_fnc_getPos) nearEntities ["CAManBase", 300]) - [_unit];
{
	if (isPlayer _x) then {
		_targets set [count _targets, _x];
	};
} forEach _near_units;

_count = 0;
_mission_complete = false;
_jail_pos = getMarkerPos "jail";
_target = _targets call WC_fnc_selectRandom;

// Create a crowd around an alone player
while {alive _unit && {alive _target} && {([_target, _unit] call WC_fnc_getDistance) < 300} && {!_mission_complete}} do {

	_count = {isPlayer _x && {side _x in wcside}} count (([_unit] call WC_fnc_getPos) nearEntities ["CAManBase", 20]);
	if (_count == 0) then {
		_unit stop false;
		_position = [_target] call WC_fnc_getPos;
		_unit doMove _position;

		_near_units = (([_target] call WC_fnc_getPos) nearEntities ["CAManBase", 300]) - [_unit];
		{
			if (side _x == civilian && {_x getVariable "civilrole" == "crowd"}) then {
				_old_role = _x getVariable "oldcivilrole";
				_x setVariable ["civilrole", _old_role, true];
			};
		} forEach _near_units;
	} else {
		// If less than 4 players - crowd
		if (_count < 4) then {
			_unit stop true;
			_position = [_target] call WC_fnc_getPos;
			_positions = [_position, 10, 360, getDir _target, 12] call WC_fnc_createcircleposition;

			_near_units = (([_target] call WC_fnc_getPos) nearEntities ["CAManBase", 300]) - [_unit];
			{
				if (side _x == civilian && {(_x getVariable "civilrole" == "civil" || {_x getVariable "civilrole" == "crowd"})}) then {
					if (([_x, _target] call WC_fnc_getDistance) > 10) then {
						_position = _positions call WC_fnc_selectRandom;
						_x setVariable ["destination", _position, false];
						_old_role = _x getVariable "civilrole";
						_x setVariable ["oldcivilrole", _old_role, false];
						_x setVariable ["civilrole", "crowd", true];
						_x setVariable ["target", _target, false];
						_x stop false;
						_x doMove _position;
					} else {
						_x doWatch _target;
						sleep 3;
						_x stop true;
					};
				};
			} forEach _near_units;
		} else {
			_near_units = (([_target] call WC_fnc_getPos) nearEntities ["CAManBase", 300]) - [_unit];
			{
				if (side _x == civilian && {_x getVariable "civilrole" == "crowd"}) then {
					_old_role = _x getVariable "oldcivilrole";
					_x setVariable ["civilrole", _old_role, true];
				};
			} forEach _near_units;

			_position = ([_spawn_pos, "all", 300] call WC_fnc_gethousespositions) call WC_fnc_selectRandom;
			_unit stop false;
			_unit doMove _position;
		};
	};

	if (([_unit, _jail_pos] call WC_fnc_getDistance) < 50) then {
		wcmessageW = ["Altercation", "A prisoner is in jail"];
		["wcmessageW", "client"] call WC_fnc_publicvariable;
		_mission_complete = true;
	};

	sleep 15;
};

if (alive _unit && {!_mission_complete}) then {
	[_unit] spawn WC_fnc_altercation;
};

_near_units = (_spawn_pos nearEntities ["CAManBase", 300]) - [_unit];
{
	if (side _x == civilian && {_x getVariable "civilrole" == "crowd"}) then {
		_old_role = _x getVariable "oldcivilrole";
		_x setVariable ["civilrole", _old_role, true];
	};
} forEach _near_units;
