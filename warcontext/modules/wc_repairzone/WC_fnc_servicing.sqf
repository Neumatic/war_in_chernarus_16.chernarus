// -----------------------------------------------
// Author:     code34 nicolas_boiteux@yahoo.fr
// Edited by:  Neumatic
// Warcontext: Repair vehicle
// -----------------------------------------------

private [
	"_vehicle", "_fuel", "_damage", "_type", "_text", "_percentage", "_selections", "_get_hit", "_magazines", "_removed",
	"_count", "_config", "_count_other", "_config_2"
];

_vehicle = _this select 3;

if (_vehicle == player) exitWith {
	[localize "STR_WC_MENUREPAIRVEHICLE", localize "STR_WC_MESSAGETRYTOMOVEIN", localize "STR_WC_MESSAGENOVEHICLENEARYOU", 10] spawn WC_fnc_playerhint;
};

_fuel = fuel _vehicle;
_damage = damage _vehicle;

_type = typeOf _vehicle;
_text = [_type] call WC_fnc_getDisplayName;

_vehicle setFuel 0;
_vehicle vehicleChat format ["Servicing %1... Please stand by...", _text];
sleep 5;

if (isNull _vehicle || {!alive _vehicle}) exitWith {};

// Repair vehicle text loop.
while {_damage > 0} do {
	sleep 0.1 + random 0.4;
	_percentage = 100 - (_damage * 100);
	_vehicle vehicleChat format ["Repairing (%1", floor _percentage] + "%)...";
	if ((_damage - 0.01) <= 0) then {
		_damage = 0;
	} else {
		_vehicle setDamage (_damage - 0.01);
		_damage = _damage - 0.01;
	};
};

if (isNull _vehicle || {!alive _vehicle}) exitWith {};

_vehicle setDamage 0;

_selections = _vehicle getVariable ["EH_Selections", []];
if (count _selections > 0) then {
	{
		_selections set [_forEachIndex, 0];
	} forEach _selections;
};

_get_hit = _vehicle getVariable ["EH_GetHit", []];
if (count _get_hit > 0) then {
	{
		_get_hit set [_forEachIndex, 0];
	} forEach _get_hit;
};

_vehicle vehicleChat "Repaired (100%)";
sleep 5;

if (isNull _vehicle || {!alive _vehicle}) exitWith {};

_magazines = getArray (configFile >> "CfgVehicles" >> _type >> "magazines");
if (count _magazines > 0) then {
	_removed = [];
	{
		if !(_x in _removed) then {
			_vehicle removeMagazines _x;
			_removed set [count _removed, _x];
		};
	} forEach _magazines;
	{
		_vehicle vehicleChat format ["Reloading %1", _x];
		sleep 0.1;
		_vehicle addMagazine _x;
		sleep 0.1;
	} forEach _magazines;
};

_count = count (configFile >> "CfgVehicles" >> _type >> "Turrets");
if (_count > 0) then {
	for "_i" from 0 to (_count - 1) do {
		_config = (configFile >> "CfgVehicles" >> _type >> "Turrets") select _i;
		_magazines = getArray (_config >> "magazines");
		_removed = [];
		{
			if !(_x in _removed) then {
				_vehicle removeMagazines _x;
				_removed set [count _removed, _x];
			};
		} forEach _magazines;
		{
			_vehicle vehicleChat format ["Reloading %1", _x];
			sleep 0.1;
			_vehicle addMagazine _x;
			sleep 0.1;
		} forEach _magazines;
		_count_other = count (_config >> "Turrets");
		if (_count_other > 0) then {
			for "_i" from 0 to (_count_other - 1) do {
				_config_2 = (_config >> "Turrets") select _i;
				_magazines = getArray (_config_2 >> "magazines");
				_removed = [];
				{
					if !(_x in _removed) then {
						_vehicle removeMagazines _x;
						_removed set [count _removed, _x];
					};
				} forEach _magazines;
				{
					_vehicle vehicleChat format ["Reloading %1", _x];
					sleep 0.1;
					_vehicle addMagazine _x;
					sleep 0.1;
				} forEach _magazines;
			};
		};
	};
};

_vehicle setVehicleAmmo 1;
_vehicle vehicleChat "Ammunition (100%)";
sleep 5;

if (isNull _vehicle || {!alive _vehicle}) exitWith {};

// Refuel vehicle text loop.
while {_fuel < 1} do {
	sleep 0.1 + random 0.4;
	_percentage = (_fuel * 100);
	_vehicle vehicleChat format ["Refuelling (%1", floor _percentage] + "%)...";
	if ((_fuel + 0.01) >= 1) then {
		_fuel = 1;
	} else {
		_fuel = _fuel + 0.01;
	};
};

if (isNull _vehicle || {!alive _vehicle}) exitWith {};

_vehicle vehicleChat "Refuelled (100%)";
sleep 5;

if (isNull _vehicle || {!alive _vehicle}) exitWith {};

_vehicle vehicleChat format ["Vehicle %1 is repaired, reloaded, and refuelled", _text];
_vehicle setFuel 1;
