// -----------------------------------------------
// Author:     code34 nicolas_boiteux@yahoo.fr
// Edited by:  Neumatic
// Warcontext: Create an AI medic
// -----------------------------------------------

private ["_unit", "_target", "_distance", "_targets"];

_unit = _this select 0;

_target = objNull;

while {alive _unit} do {
	if (vehicle _unit == _unit) then {
		if (damage _unit > 0.1) then {
			_unit action ["Heal", _unit];
			wcresetgethit = _unit;
			["wcresetgethit", "server"] call WC_fnc_publicvariable;
			sleep 8;
		};

		if (isNull _target || {!alive _target} || {damage _target < 0.1} || {vehicle _target != _target} || {([_unit, _target] call WC_fnc_getDistance) > 100}) then {
			_target = objNull;
		};

		if (isNull _target) then {
			_targets = [];

			{
				if (alive _x && {damage _x > 0.1} && {vehicle _x == _x} && {([_unit, _x] call WC_fnc_getDistance) < 100}) then {
					_targets set [count _targets, _x];
				};
			} forEach units group _unit;

			_distance = 100000;

			{
				if (alive _x && {([_unit, _x] call WC_fnc_getDistance) < _distance}) then {
					_distance = [_unit, _x] call WC_fnc_getDistance;
					_target = _x;
				};
			} forEach _targets;
		};

		if (!isNull _target && {alive _target} && {damage _target > 0.1} && {vehicle _target == _target} && {([_unit, _target] call WC_fnc_getDistance) < 100} && {([_unit, _target] call WC_fnc_getDistance) <= 3}) then {
			_target action ["Heal", _unit];
			wcresetgethit = _unit;
			["wcresetgethit", "server"] call WC_fnc_publicvariable;
			sleep 8;
		} else {
			_unit doMove ([_target] call WC_fnc_getPos);
		};
	};

	sleep 30;
};
