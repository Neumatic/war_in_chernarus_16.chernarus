/*
	Author: Neumatic
	Description: Get a vehicle of the passed parameters from the vehicles weighed
	list. Weighed as in how hard the vehicle is to kill. For example a T90 is set
	for 3 where as a UAZ mg truck is set for 1.

	Parameter(s):
		0: [Array] Position.
		1: [Number] Direction.
		2: [Number] Hardnest.
		3: [Side/Group] Side or Group.

	Example(s):
		_vehicle = [[[1,"ACE_UAZ_MG_RU"],[1,"UAZ_AGS30_RU"]], 20, 1, east] call WC_fnc_spawnIntVehicle;

	Returns:
		Array or nil
*/

private ["_position", "_dir", "_weight", "_side", "_vehicles", "_vehicle"];

_position = _this select 0;
_dir      = _this select 1;
_weight   = _this select 2;
_side     = _this select 3;

_vehicles = [];

{
	if ((_x select 0) == _weight) then {
		_vehicles set [count _vehicles, _x select 1];
	};
} forEach wcvehicleslistweighedE;

if (count _vehicles == 0) exitWith {
	["ERROR", "WC_fnc_spawnIntVehicle", format ["No vehicles in ARRAY : count=%1", count _vehicles]] call WC_fnc_log;
	nil
};

_vehicle = [_position, _dir, _vehicles call WC_fnc_selectRandom, _side] call WC_fnc_spawnVehicle;

_vehicle
