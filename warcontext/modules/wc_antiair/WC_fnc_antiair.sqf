// -----------------------------------------------
// Author:     code34 nicolas_boiteux@yahoo.fr
// Edited by:  Neumatic
// Warcontext: Create an antiair site at random position on map
// -----------------------------------------------

private [
	"_hills", "_count", "_check", "_exit", "_blue_for", "_position", "_type", "_vehicle_array", "_vehicle", "_group",
	"_gunner", "_marker", "_recheck", "_cible"
];

_hills = nearestLocations [wcmapcenter, ["Hill"], 20000];
if (count _hills < (wcaalevel + 1)) exitWith {
	["ERROR", "WC_fnc_antiair", format ["Not enough hills on the map : count=%1", count _hills]] call WC_fnc_log;
};

sleep 1;

_count = 0;
_check = false;
_exit = false;

_blue_for = getMarkerPos "bluefor";

while {!_check} do {
	_check = true;
	_position = [position (_hills call WC_fnc_selectRandom), 0, 150, sizeOf "2S6M_Tunguska", 0.2] call WC_fnc_getEmptyPosition;

	if (count _position > 0) then {
		if (_position distance _blue_for > 600) then {
			{
				if (_position distance _x < 300) then {
					_check = false;
				};
			} forEach wcallaaposition;
		} else {_check = false};
	} else {_check = false};

	if (_count > 10) then {
		_exit = true; _check = true;
	} else {
		_count = _count + 1; sleep 0.1;
	};
};

if (_exit) exitWith {};

wcallaaposition set [count wcallaaposition, _position];

_type = wcaavehicles call WC_fnc_selectRandom;
_vehicle_array = [_position, random 360, _type, east] call WC_fnc_spawnVehicle;
_vehicle = _vehicle_array select 0;
_group   = _vehicle_array select 2;

[_vehicle, east] spawn WC_fnc_vehiclehandler;
[_group, east] spawn WC_fnc_grouphandler;

_gunner = gunner _vehicle;
_gunner disableAI "AUTOTARGET";

if (wcwithaamarkers == 1) then {
	_marker = [format ["antiair%1", wcaaindex], _gunner, 0.5, "ColorRed", "ICON", "FDIAGONAL", "mil_triangle", 0, "AA site", 1] call WC_fnc_createmarker;
	wcaaindex = wcaaindex + 1;
};

WC_fnc_defineaacible = {
	private ["_gunner", "_ghost", "_cible", "_enemys", "_exit", "_group"];

	_gunner = _this select 0;

	_ghost = false;
	_cible = objNull;

	_enemys = ([_gunner] call WC_fnc_getPos) nearEntities ["Air", 3000];
	if (count _enemys > 0) then {
		_exit = false;
		while {!_exit && {count _enemys > 0}} do {
			_cible = ([_gunner, _enemys] call EXT_fnc_SortByDistance) select 0;
			if ((([_cible] call WC_fnc_getPos) select 2) > 20) then {
				{
					if (isPlayer _x || {side _x in wcside}) exitWith {
						if !(side _x in west) then {
							_ghost = true;
						};
						_exit = true;
					};
				} forEach crew _cible;
			};
			if (!_exit) then {
				_enemys = _enemys - [_cible];
			};
			sleep 0.5;
		};
		if (!_exit) then {_cible = objNull};
		if (_ghost) then {
			// Unauthorized civil fly
			_group = createGroup west;
			{
				[_x] joinSilent _group;
			} forEach crew _cible;
		};
	} else {_cible = objNull};

	_cible
};

_recheck = 0;
_cible = objNull;

// Vehicle can be not alive and damage can be at 0
while {alive _gunner && {alive _vehicle}} do {
	if (isNull _cible || {!alive _cible}) then {
		_cible = [_gunner] call WC_fnc_defineaacible;
	} else {
		_gunner doTarget _cible;
		_gunner doFire _cible;
		_gunner reveal _cible;

		_recheck = _recheck + 1;

		// After 3 loop we recheck that cible is the nearest
		if (_recheck >= 3) then {
			_cible = [_gunner] call WC_fnc_defineaacible;
			_recheck = 0;
		};
	};

	sleep 10;
};

if (!isNil "_marker") then {
	[_marker] call WC_fnc_deletemarker;
};
