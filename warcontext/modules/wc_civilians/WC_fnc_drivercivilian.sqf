// -----------------------------------------------
// Author:     code34 nicolas_boiteux@yahoo.fr
// Edited by:  Neumatic
// Warcontext: Civil drive car across the map
// -----------------------------------------------

private ["_unit", "_vehicles", "_exit", "_old_group", "_find", "_vehicle", "_position", "_type_of", "_group", "_target"];

_unit = _this select 0;

_vehicles = nearestObjects [[_unit] call WC_fnc_getPos, ["Car","Motorcycle"], 500];
if ({alive _x && {typeOf _x in wcvehicleslistC}} count _vehicles == 0) exitWith {
	_unit setVariable ["civilrole", "civil", true];
};

["INFO", format ["Created a civilian driver : fame=%1", wcfame]] call WC_fnc_log;

_exit = false;
_old_group = group _unit;

while {!_exit && {alive _unit}} do {
	if (vehicle _unit == _unit) then {
		_find = false;

		{
			if (alive _x && {typeOf _x in wcvehicleslistC} && {count crew _x == 0} && {!locked _x}) exitWith {
				_vehicle = _x;
				_find = true;
			};
		} forEach nearestObjects [[_unit] call WC_fnc_getPos, ["Car","Motorcycle"], 500];

		if (_find) then {
			_unit setVariable ["destination", [_vehicle] call WC_fnc_getPos, false];

			while {alive _unit && {alive _vehicle} && {count crew _vehicle == 0} && {([_unit, _vehicle] call WC_fnc_getDistance) > 10}} do {
				_unit doMove ([_vehicle] call WC_fnc_getPos);
				sleep 5;
			};

			if (alive _unit && {alive _vehicle} && {count crew _vehicle == 0}) then {
				_position = [_unit] call WC_fnc_getPos;
				_type_of = typeOf _unit;
				[_unit] call WC_fnc_deleteObject;

				_group = createGroup civilian;
				_unit = _group createUnit [_type_of, _position, [], 0, "NONE"];
				_vehicle setFuel 1;
				_vehicle setDamage 0;

				_unit assignAsDriver _vehicle;
				[_unit] orderGetIn true;
				_unit moveInDriver _vehicle;

				[_group, civilian] spawn WC_fnc_grouphandler;

				_target = position (wctownlocations call WC_fnc_selectRandom);
				_position = position ((_target nearRoads 500) call WC_fnc_selectRandom);
				_unit setVariable ["destination", _position, false];
			};
		} else {
			if (group _unit != _old_group && {!isNull _old_group}) then {
				[_unit] joinSilent _old_group;
			};

			_unit setVariable ["civilrole", "civil", true];
			_exit = true;
		};
	} else {
		_position = _unit getVariable "destination";
		if (([_unit, _position] call WC_fnc_getDistance) > 50) then {
			_unit doMove _position;
			sleep 30;
		} else {
			_target = position (wctownlocations call WC_fnc_selectRandom);
			_position = position ((_target nearRoads 500) call WC_fnc_selectRandom);
			_unit setVariable ["destination", _position, false];
			_vehicle setFuel 1;
			_vehicle setDamage 0;
		};
	};
};

if (alive _unit && {group _unit != _old_group}) then {
	if ({([_x, _unit] call WC_fnc_getDistance) < 500} count ([] call BIS_fnc_listPlayers) > 0) then {
		_exit = false;

		if (count (([_unit] call WC_fnc_getPos) nearObjects ["House", 500]) > 0) then {
			_position = ([[_unit] call WC_fnc_getPos, "all", 500] call WC_fnc_gethousespositions) call WC_fnc_selectRandom;
		} else {
			_target = nearestLocation [[_unit] call WC_fnc_getPos, "NameVillage"];
			_position = position _target;
		};

		_unit setVariable ["destination", _position, false];

		while {!_exit && {alive _unit}} do {
			_unit doMove (_unit getVariable "destination");
			sleep 30;

			if (([_unit, _unit getVariable "destination"] call WC_fnc_getDistance) < 5) then {
				if ({([_x, _unit] call WC_fnc_getDistance) < 500} count ([] call BIS_fnc_listPlayers) == 0) then {
					_exit = true;
				} else {
					if (count (([_unit] call WC_fnc_getPos) nearObjects ["House", 500]) > 0) then {
						_position = ([[_unit] call WC_fnc_getPos, "all", 500] call WC_fnc_gethousespositions) call WC_fnc_selectRandom;
					} else {
						_target = nearestLocation [[_unit] call WC_fnc_getPos, "NameVillage"];
						_position = position _target;
					};

					_unit setVariable ["destination", _position, false];
				};
			};
		};
	};

	[_unit] call WC_fnc_deleteObject;
};
