// -----------------------------------------------
// Author:     code34 nicolas_boiteux@yahoo.fr
// Edited by:  Neumatic
// Warcontext: Sentinelle in static weapon
// -----------------------------------------------

private ["_max_dist", "_cible", "_count", "_position", "_counter", "_unit", "_enemy_side", "_grid_of_pos", "_init_pos"];

_unit       = _this select 0;
_enemy_side = _this select 1;

if (format ["%1", _unit] == "any") exitWith {};

_count = 0;
_counter = 0;
_position = [_unit] call WC_fnc_getPos;
_grid_of_pos = [_position, 100, 360, getDir _unit, 10] call WC_fnc_createcircleposition;

_init_pos = [_unit] call WC_fnc_getPos;

while {alive _unit} do {
	_counter = _counter + 1;

	_max_dist = 1000;

	{
		if ((random 1 > 0.97) || {(wcalert > 99)}) then {
			_unit reveal _x;
		};
		if ((side _x in _enemy_side) && {(_unit knowsAbout _x > 0.5)}) then {
			if (([_unit, _x] call WC_fnc_getDistance) < _max_dist) then {_max_dist = [_unit, _x] call WC_fnc_getDistance; _cible = _x};
			_count = _count + 1;
		};
	} forEach (([_unit] call WC_fnc_getPos) nearEntities ["CAManBase", 200]);

	if (_count == 0) then {
		_unit setBehaviour "SAFE";
		_unit setCombatMode "WHITE";
		_unit setSpeedMode "LIMITED";

		if (([_unit, _init_pos] call WC_fnc_getDistance) < 100) then {
			if (vehicle _unit == _unit) then {
				if (_counter > 6) then {
					_position = [(([_unit] call WC_fnc_getPos) select 0) + ([5,20] call WC_fnc_seed), (([_unit] call WC_fnc_getPos) select 1) + ([5,20] call WC_fnc_seed)];
					_unit doMove _position;
					_counter = 0;
				} else {
					_unit doWatch (_grid_of_pos call WC_fnc_selectRandom);
				};
			} else {
				_unit doWatch (_grid_of_pos call WC_fnc_selectRandom);
			};
		} else {
			_unit doMove _init_pos;
		};
	} else {
		_unit doWatch _cible;
		_unit doFire _cible;
		_unit doTarget _cible;

		if (vehicle _unit == _unit) then {
			if (([_cible, _unit getHideFrom _cible] call WC_fnc_getPos) < 10) then {
				_unit setBehaviour "STEALTH";
				_unit setSpeedMode "LIMITED";
			} else {
				_unit setBehaviour "COMBAT";
				_unit setCombatMode "RED";
				_unit setSpeedMode "FULL";
				_unit doMove ([_cible] call WC_fnc_getPos);
			};
		} else {
			_unit setBehaviour "COMBAT";
			_unit setCombatMode "RED";
			_unit setSpeedMode "FULL";
		};

		{
			_x reveal _cible;
		} forEach units group _unit;
	};

	_count = 0;
	sleep 5;
};
