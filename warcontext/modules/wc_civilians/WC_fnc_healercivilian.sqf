// -----------------------------------------------
// Author:     code34 nicolas_boiteux@yahoo.fr
// Edited by:  Neumatic
// Warcontext: Civilian heal
// -----------------------------------------------

private ["_unit", "_position", "_spawn_pos", "_heal_msg", "_target", "_side", "_targets", "_near_units", "_distance", "_msg"];

_unit = _this select 0;

["INFO", format ["Created a civlian healer : fame=%1", wcfame]] call WC_fnc_log;

_position = [_unit, 0, 150, sizeOf "RU_Soldier", 0.2] call WC_fnc_getEmptyPosition;
_unit setPos _position;

_spawn_pos = [_unit] call WC_fnc_getPos;

_heal_msg = [
	"Let me help you with this.",
	"Please remember that I helped you.",
	"I use to work at a local hospital"
];

_target = objNull;
_side = [east,west,resistance] call WC_fnc_selectRandom;

while {alive _unit} do {

	_targets = [];

	_near_units = ([_unit] call WC_fnc_getPos) nearEntities ["CAManBase", 300];
	{
		if (side _x == _side && {damage _x > 0.1}) then {
			_targets set [count _targets, _x];
		};
	} forEach _near_units;

	if (count _targets > 0) then {
		_target = objNull;
		_distance = 1000;

		{
			if (alive _x && {([_unit, _x] call WC_fnc_getDistance) < _distance}) then {
				_distance = [_unit, _x] call WC_fnc_getDistance;
				_target = _x;
			};
		} forEach _targets;

		if (isNull _target && {alive _target}) then {
			while {alive _unit && {alive _target} && {([_unit, _target] call WC_fnc_getDistance) < 300} && {([_unit, _target] call WC_fnc_getDistance) > 5}} do {
				_position = [_target] call WC_fnc_getPos;
				_unit setVariable ["destination", _position, false];
				_unit doMove _position;
				sleep 5;
			};

			if (alive _unit && {alive _target} && {([_unit, _target] call WC_fnc_getDistance) < 5}) then {
				if (isPlayer _target) then {
					_msg = _heal_msg call WC_fnc_selectRandom;
					wchintW = parseText format ["<t color='#33CC00'>%1</t> %2", name _unit, _msg];
					["wchintW", "client", owner _target] call WC_fnc_publicvariable;
				};

				_unit doWatch _target;
				sleep 3;

				_unit playMove "AinvPknlMstpSlayWrflDnon_medic";
				sleep 4;

				if (alive _unit && {alive _target} && {([_unit, _target] call WC_fnc_getDistance) < 5}) then {
					_unit action ["Heal", _target];
					_target setDamage 0;
					_target setMimic "";
					_unit doWatch objNull;
				};
			};
		};
	} else {
		if (([_unit, _unit getVariable "destination"] call WC_fnc_getDistance) < 5) then {
			_position = ([_spawn_pos, "all", 300] call WC_fnc_gethousespositions) call WC_fnc_selectRandom;
			_unit setVariable ["destination", _position, false];
			_unit doWatch objNull;
		};

		_unit doMove _position;

		sleep 30;
	};
};
