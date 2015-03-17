// -----------------------------------------------
// Author:     code34 nicolas_boiteux@yahoo.fr
// Edited by:  Neumatic
// Warcontext: ACE SYS WEAPONS reworks
// -----------------------------------------------

private ["_weapons", "_result", "_count", "_weapon", "_config", "_muzzles", "_magazines", "_name", "_display_name"];

_weapons = _this select 0;

_result = [];

_count = (count _weapons) - 1;
for "_i" from 0 to _count do {
	_weapon = _weapons select (_count - _i);
	_config = (configFile >> "CfgWeapons" >> _weapon);

	if (isArray (_config >> "muzzles")) then {
		_muzzles = getArray (_config >> "muzzles");
		if (count _muzzles > 0) then {
			_magazines = [];
			{
				if (_x == "this") then {
					_magazines = getArray (_config >> "magazines");
				} else {
					_magazines = _magazines + (getArray (_config >> _x >> "magazines"));
				};
			} forEach _muzzles;
		} else {
			_magazines = getArray (_config >> "magazines");
		};
	} else {
		_magazines = getArray (_config >> "magazines");
	};

	{
		_config = (configFile >> "CfgMagazines" >> _x);
		if ((getNumber (_config >> "scope")) == 2) then {
			_name = format ["%1", toLower _x];
			if !(_name in _result) then {
			 	if (getNumber (_config >> "Armory" >> "disabled") == 1) exitWith {};
				if (getNumber (_config >> "ace_hide") == 1) exitWith {};
				_display_name = getText (_config >> "DisplayName");
				if (_display_name != "") then {
					_result set [count _result, _name];
				};
			};
		};
	} forEach _magazines;
};

_result
