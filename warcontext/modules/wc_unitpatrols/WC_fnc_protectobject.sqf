// -----------------------------------------------
// Author:     code34 nicolas_boiteux@yahoo.fr
// Edited by:  Neumatic
// Warcontext: Defend an objet
// -----------------------------------------------

private ["_object", "_number", "_area_size", "_group_size", "_position", "_new_pos","_group", "_unit", "_type", "_dog"];

_object     = _this select 0;
_number     = if (count _this > 1) then {_this select 1} else {2};
_area_size  = if (count _this > 2) then {_this select 2} else {150};
_group_size = if (count _this > 3) then {_this select 3} else {[4,7] select (random 1)};

_position = getPos _object;

for "_i" from 1 to ceil (random _number) do {
	_new_pos = [_position, 5, _area_size, sizeOf "RU_Soldier", 0.2] call WC_fnc_getEmptyPosition;

	_group = createGroup east;
	for "_x" from 1 to _group_size do {
		_unit = _group createUnit [wcspecialforces call WC_fnc_selectRandom, _new_pos, [], 10, "NONE"];
		sleep 0.1;
	};

	[_group, east] spawn WC_fnc_grouphandler;
	[_group, _position, _area_size, false] spawn WC_fnc_patrol;

	["INFO", format ["Created a special forces group of %1 to protect object", count units _group]] call WC_fnc_log;
};

// Create dog
if (wcpatrolwithdogs && {random 1 > 0.75}) then {
	_type = wcdogclass call BIS_fnc_selectRandom;

	_group = createGroup civilian;
	_dog = _group createUnit [_type, _position, [], 3, "NONE"];

	[_dog] spawn WC_fnc_dogpatrol;

	["INFO", format ["Created a dog patrol %1 to protect object", _type]] call WC_fnc_log;
};
