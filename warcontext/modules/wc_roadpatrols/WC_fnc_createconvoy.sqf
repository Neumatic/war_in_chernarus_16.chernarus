// -----------------------------------------------
// Author:     code34 nicolas_boiteux@yahoo.fr
// Edited by:  Neumatic
// Warcontext: Create a enemy convoy
// -----------------------------------------------

private [
	"_armed_vehs", "_supply_vehs", "_num_of_vehs", "_respawn_west", "_run", "_position", "_sleep", "_roads", "_vehicles",
	"_convoy_group", "_vehicle_array", "_vehicle", "_crew", "_group"
];

_armed_vehs  = _this select 0;
_supply_vehs = _this select 1;
_num_of_vehs = if (count _this > 2) then {_this select 2} else {[1, 3] call WC_fnc_randomMinMax};

_respawn_west = getMarkerPos "respawn_west";

_run = true;

while {_run} do {
	_position = position (wctownlocations call WC_fnc_selectRandom);
	_sleep = false;

	if (_position distance _respawn_west > 1000) then {
		if ({([_x, _position] call WC_fnc_getDistance) < 1000} count ([] call BIS_fnc_listPlayers) == 0) then {
			_roads = _position nearRoads 300;
			if (count _roads > 0) then {
				_position = [_roads call WC_fnc_selectRandom] call WC_fnc_getPos;
				_run = false;
			} else {_sleep = true};
		} else {_sleep = true};
	} else {_sleep = true};

	if (_sleep) then {sleep 0.1};
};

_vehicles = [];

_convoy_group = createGroup east;
for "_i" from 1 to _num_of_vehs do {
	if (_num_of_vehs > 1 && {random 1 > 0.5} && {_i > 1}) then {
		_vehicle_array = [_position, random 360, _supply_vehs call WC_fnc_selectRandom, east] call WC_fnc_spawnVehicle;
	} else {
		_vehicle_array = [_position, random 360, _armed_vehs call WC_fnc_selectRandom, east] call WC_fnc_spawnVehicle;
	};

	_vehicle = _vehicle_array select 0;
	_crew    = _vehicle_array select 1;
	_group   = _vehicle_array select 2;

	_vehicle lock true;
	_vehicle setFuel wcenemyglobalfuel;

	[_vehicle, east] spawn WC_fnc_vehiclehandler;
	[_vehicle] spawn EXT_fnc_atot;

	_vehicles set [count _vehicles, _vehicle];

	_crew joinSilent _convoy_group;
	deleteGroup _group;

	sleep 1;
};

[_convoy_group, east] spawn WC_fnc_grouphandler;
[_convoy_group] spawn WC_fnc_roadpatrol;

WC_RoadConvoys set [count WC_RoadConvoys, [_convoy_group, _vehicles]];
