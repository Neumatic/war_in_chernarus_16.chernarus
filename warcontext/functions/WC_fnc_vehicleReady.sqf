/*
	Author: Rübe
	Edited by: Neumatic
	Description: Checks if the vehicle is ready by checking if crew members
	of a vehicle are ready. If the vehicle is empty then it returns true as
	a default.

	Parameter(s):
		0: [Object] Vehicle object.

	Example(s):
		_ready = [vehicle player] call WC_fnc_vehicleReady;
		-> _ready = true;

	Returns:
		Bool
*/

private ["_vehicle", "_ready"];

_vehicle = _this select 0;

_ready = true;

if ({!isNull _x && {alive _x} && {!unitReady _x}} count [commander _vehicle, driver _vehicle, gunner _vehicle] > 0) exitWith {
	_ready = false;
};

_ready
