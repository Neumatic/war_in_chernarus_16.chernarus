// -----------------------------------------------
// Author:     code34 nicolas_boiteux@yahoo.fr
// Edited by:  Neumatic
// Warcontext: Creates animals on road
// -----------------------------------------------

private ["_position", "_roads", "_active", "_back", "_max", "_road", "_number", "_type", "_rand_type", "_text", "_group", "_civil"];

_position = _this select 0;

_roads = _position nearRoads 500;
{
	if !((count (roadsConnectedTo _x) > 1) && {(count (nearestObjects [_x, ["House"], 20]) > 0)}) then {
		_roads = _roads - [_x];
	};
} forEach _roads;

if (count _roads == 0) exitWith {};

_active = createTrigger ["EmptyDetector", _position];
_active setTriggerArea [wccivildistancepop, wccivildistancepop, 0, false];
_active setTriggerActivation ["ANY", "PRESENT", true];
_active setTriggerStatements ["", "", ""];

_back = [];

_max = [1, 3] call WC_fnc_randomMinMax;

for "_i" from 1 to _max do {
	_road = _roads call WC_fnc_selectRandom;

	if (random 1 > 0.1) then {
		_position = ((selectBestPlaces [[_road] call WC_fnc_getPos, 100, "hills", 1, 10] select 0) select 0);
	} else {
		_position = [_road] call WC_fnc_getPos;
	};

	_number = [1, 5] call WC_fnc_randomMinMax;

	switch (_number) do {
		case 1: {
			_type = ["Cock","Hen"];
		};

		case 2: {
			_type = ["Cow01","Cow02","Cow03","Cow04"];
		};

		case 3: {
			_type = ["Sheep","Sheep01_EP1","Sheep02_EP1"];
		};

		case 4: {
			_type = ["Goat"];
		};

		case 5: {
			_type = ["WildBoar"];
		};
	};

	_number = [3, 12] call WC_fnc_randomMinMax;

	for "_x" from 1 to _number do {
		_rand_type = _type call WC_fnc_selectRandom;
		_back set [count _back, [_rand_type, _position]];
	};
};

_text = [_position] call WC_fnc_getLocationText;
["INFO", format ["Created %1 animal groups of %2 type near %3", _max, _type, _text]] call WC_fnc_log;

while {true} do {
	waitUntil {sleep 1; {isPlayer _x} count list _active > 0};

	_group = createGroup civilian;
	{
		_civil = _group createUnit [_x select 0, _x select 1, [], 0, "NONE"];
		_civil setDir (random 360);
		_civil setVariable ["wcprotected", true, false];
		_civil setVariable ["civilrole", "animal", true];
	} forEach _back;

	[_group, civilian] call WC_fnc_grouphandler;
	[_group] call WC_fnc_moveAnimals;

	_back = [];

	waitUntil {sleep 1; {isPlayer _x} count list _active == 0};

	{
		if (alive _x) then {
			_back set [count _back, [typeOf _x, [_x] call WC_fnc_getPos]];
			[_x] call WC_fnc_deleteObject;
		};
	} forEach units _group;

	deleteGroup _group;
};
