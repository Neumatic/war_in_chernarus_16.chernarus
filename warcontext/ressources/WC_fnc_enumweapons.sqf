// -----------------------------------------------
// Author:     code34 nicolas_boiteux@yahoo.fr
// Edited by:  Neumatic
// Warcontext: Enums weapons
// -----------------------------------------------

private ["_weapons", "_display_names", "_count", "_object", "_display_name", "_object_name"];

_weapons = [];
_display_names = [];

_count = count (configFile >> "CfgWeapons");
for "_i" from 0 to (_count - 1) do {
	_object = (configFile >> "CfgWeapons") select _i;
	if (isClass _object) then {
		if (getNumber (_object >> "scope") == 2) then {
			_display_name = toLower (getText (_object >> "displayName"));
			if !(_display_name in _display_names) then {
				_object_name = configName _object;
				_display_names set [count _display_names, _display_name];
				_weapons set [count _weapons, _object_name];
			};
		};
	};
};

_weapons
