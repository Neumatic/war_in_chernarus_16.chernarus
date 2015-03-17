// -----------------------------------------------
// Author:     code34 nicolas_boiteux@yahoo.fr
// Edited by:  Neumatic
// Warcontext: Dogs attack script
// -----------------------------------------------

private ["_cible", "_group", "_position", "_old_group", "_recheck", "_unit"];

_unit = _this select 0;

_position = [0,0,0];
_old_group = group _unit;
_unit setVariable ["destination", _position, false];
wcunits set [count wcunits, _unit];

WC_fnc_definedogcible = {
	private ["_dog", "_cible", "_cibles", "_list", "_old_group"];

	_dog       = _this select 0;
	_old_group = _this select 1;

	_cibles = [];

	_list = ([_dog] call WC_fnc_getPos) nearEntities ["CAManBase", 50];
	if (count _list > 0) then {
		{
			if (isPlayer _x) then {
				_cibles set [count _cibles, _x];
			};
		} forEach _list;
	};

	if (count _cibles == 0) then {
		_cible = objNull;
	} else {
		_cible = ([_dog, _cibles] call EXT_fnc_SortByDistance) select 0;
		// Master of dogs discover cibles
		_old_group setBehaviour "COMBAT";
		_old_group reveal _cible;
	};

	_cible;
};

_recheck = 0;
_cible = objNull;

while {alive _unit} do {
	if (isNull _cible || {!alive _cible} || {([_unit, _cible] call WC_fnc_getDistance) > 100}) then {
		_cible = [_unit, _old_group] call WC_fnc_definedogcible;
	};

	// If no cible
	if (isNull _cible) then {
		if (count units _old_group > 0 && {group _unit != _old_group}) then {
			[_unit] joinSilent _old_group;
		};
	} else {
		if (group _unit == _old_group) then {
			_group = createGroup east;
			[_unit] joinSilent _group;
		};

		if (([_unit, _cible] call WC_fnc_getDistance) > 3) then {
			_position = [_cible] call WC_fnc_getPos;
			_unit setVariable ["destination", _position, false];
			_unit setSpeedMode "FULL";
			_unit setBehaviour "SAFE";
			_unit doMove _position;
			if (random 1 > 0.9) then {
				wcdoggrognement = true;
				["wcdoggrognement", "client", owner _cible] call WC_fnc_publicvariable;
			};
		} else {
			_unit doWatch _cible;
			wcdogbark = true;
			["wcdogbark", "client", owner _cible] call WC_fnc_publicvariable;
			_cible setDamage (damage _cible + 0.05);
			sleep ceil (random 3);
		};

		_recheck = _recheck + 1;

		if (_recheck > 3) then {
			_cible = [_unit, _old_group] call WC_fnc_definedogcible;
			_recheck = 0;
		};
	};

	sleep 1;
};

sleep wctimetogarbagedeadbody;

deleteVehicle _unit;
