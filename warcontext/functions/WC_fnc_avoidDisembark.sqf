/*
	Author: Monsada?
	Edited by: Neumatic
	Description: Units in vehicles try to advoid disembarking from the vehicle.

	Parameter(s):
		0: [Object] Unit to spawn script for.

	Optional parameter(s):
		1: [Number] Timeout

	Example(s):
		[_unit, 60] spawn WC_fnc_avoidDisembark;

	Returns:
		nil
*/

private ["_time", "_time_out", "_unit", "_vehicle"];

_unit = _this select 0;
_time = if (count _this > 1) then {_this select 1} else {180};

_time_out = time + _time;

waitUntil {sleep 1; !alive _unit || {vehicle _unit != _unit} || {time > _time_out}};

if (!alive _unit || {time > _time_out}) exitWith {};

_unit stop true;
_vehicle = vehicle _unit;

waitUntil {sleep 1; !alive _unit || {!alive _vehicle} || {!canMove _vehicle} || {vehicle _unit != _vehicle}};

if (!alive _unit) exitWith {};

_unit stop false;
