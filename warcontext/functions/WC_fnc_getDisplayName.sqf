/*
	Author: Neumatic
	Description: Gets the display name of an object.

	Parameter(s):
		0: [Object/String] Object or string.

	Example(s):
		_name = [vehicle player] call WC_fnc_getDisplayName;

	Returns:
		String
*/

#define CONFIG_TYPES ["CfgVehicles","CfgWeapons","CfgMagazines"]

private ["_object", "_name"];

_object = _this select 0;

if (typeName _object != "STRING") then {
	_object = typeOf _object;
};

_name = "";

for "_i" from 0 to (count CONFIG_TYPES - 1) do {
	if (isClass (configFile >> (CONFIG_TYPES select _i) >> _object)) exitWith {
		_name = getText (configFile >> (CONFIG_TYPES select _i) >> _object >> "DisplayName");
	};
};

_name
