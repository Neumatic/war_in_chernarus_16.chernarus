// -----------------------------------------------
// Author:     code34 nicolas_boiteux@yahoo.fr
// Edited by:  Neumatic
// Warcontext: Create civils car in a location
// -----------------------------------------------

private ["_position", "_roads", "_max", "_cars_array", "_cars", "_road", "_dir", "_pos", "_rand_car", "_car", "_marker", "_text"];

_position = _this select 0;

_roads = _position nearRoads 500;
{
	if !((count (roadsConnectedTo _x) > 1) && {(count (([_x] call WC_fnc_getPos) nearObjects ["House", 20]) > 0)}) then {
		_roads = _roads - [_x];
	};
} forEach _roads;

if (count _roads == 0) exitWith {};

_max = [1, wcwithcivilcar] call WC_fnc_randomMinMax;
if (_max > count _roads) then {_max = count _roads};

_cars_array = [];
_cars = +wcvehicleslistC;

for "_i" from 1 to _max do {
	_road = _roads call WC_fnc_selectRandom;
	_roads = _roads - [_road];

	_dir = getDir _road;
	_pos = [[_road] call WC_fnc_getPos, (_dir + 90), ceil (random 3)] call WC_fnc_PDB;

	_rand_car = _cars call WC_fnc_selectRandom;
	_cars = _cars - [_rand_car];

	_car = createVehicle [_rand_car, _pos, [], 0, "NONE"];
	_car setDir _dir;
	[_car] call WC_fnc_alignToTerrain;
	_cars_array set [count _cars_array, typeOf _car];

	[_car, civilian] call WC_fnc_vehiclehandler;

	if (WC_MarkerAlpha > 0) then {
		_marker = [format ["mrkcivilcar%1", wccivilcarindex], _car, 0.5, "ColorBlack", "ICON", "FDIAGONAL", "dot", 0, "", WC_MarkerAlpha] call WC_fnc_createmarkerlocal;
		wcambiantmarker set [count wcambiantmarker, _marker];
		wccivilcarindex = wccivilcarindex + 1;
	};

	if (wckindofgame == 2) then {
		_car setFuel (0.2 + random 0.8);
		_car setDamage (0.2 + random 0.8);
	};

	if (random 1 > 0.6) then {
		clearMagazineCargo _car;
		clearWeaponCargo _car;
	};

	if (random 1 > 0.5) then {
		_car lock true;
	};

	if (random 1 > 0.75) then {
		[_car] spawn WC_fnc_nastyvehicleevent;
	} else {
		if (random 1 > 0.95) then {
			_car setVectorUp [1,0,0];
		};
	};

	wcvehicles set [count wcvehicles, _car];

	sleep 0.1;
};

_text = [_pos] call WC_fnc_getLocationText;
["INFO", format ["Created %1 civilian cars %2 near %3", _max, _cars_array, _text]] call WC_fnc_log;
