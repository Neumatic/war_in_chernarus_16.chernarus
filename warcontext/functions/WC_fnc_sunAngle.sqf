/*
	Author: CarlGustaffa
	Edited by: Neumatic
	Description: Checks if it is currently night or day.

	Parameter(s):
		nil

	Example:
		_bool = [] call WC_fnc_sunAngle;
		-> _bool = true or false;

	Returns:
		Bool
*/

private ["_night", "_lat", "_day", "_hour", "_sun_angle"];

_night = false;

_lat = -1 * getNumber (configFile >> "CfgWorlds" >> worldName >> "latitude");
_day = 360 * (dateToNumber date);
_hour = (daytime / 24) * 360;
_sun_angle = ((12 * cos(_day) - 78) * cos(_lat) * cos(_hour)) - (24 * sin(_lat) * cos(_day));

if (_sun_angle < 0) then {_night = true};
if (_sun_angle > 0) then {_night = false};

_night
