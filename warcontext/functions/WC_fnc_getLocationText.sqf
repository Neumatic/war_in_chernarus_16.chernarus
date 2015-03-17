/*
	Author: Neumatic
	Description: Get the nearest location text.

	Parameter(s):
		0: [Array] Position from.

	Example(s):
		_text = [_position] call WC_fnc_getLocationText;

	Returns:
		String
*/

#define MAX_DISTANCE 3000
#define LOCATION_TYPES ["NameCityCapital","NameCity","NameVillage","NameLocal","Hill"]

private ["_position", "_location", "_text"];

_position = _this select 0;

_location = [_position, 0, MAX_DISTANCE, false, LOCATION_TYPES] call WC_fnc_getLocation;
if (isNil "_location") then {
	_location = nearestLocation [_position, "NameCity"];
};

_text = text _location;
if (format ["%1", _text] == "") then {
	_location = nearestLocation [_position, "NameCity"];
	_text = text _location;
};

_text
