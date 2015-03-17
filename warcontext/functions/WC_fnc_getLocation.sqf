/*
	Author: Neumatic
	Description: Get a location using parameters.

	Parameter(s):
		0: [Array] Position.
		1: [Number] Minimum distance.
		2: [Number] Maximum distance.
		3: [Bool] Random location.
		4: [Array] Array of location string types.

	Example(s):
		_location = [getPos player, 500, 6000, false, ["NameCity","NameVillage"]] call WC_fnc_getLocation;

	Returns:
		Location or nil
*/

private ["_position", "_min_dist", "_max_dist", "_random", "_params", "_types", "_location_types", "_locations", "_location"];

_position = _this select 0;
_min_dist = _this select 1;
_max_dist = _this select 2;
_random   = _this select 3;
_params   = _this select 4;

// If _position is an object then get a position.
if (typeName _position == "OBJECT") then {_position = [_this select 0] call WC_fnc_getPos};

_types = [];
_location_types = [];

// Convert the strings to lower case.
_types = [_params, "tolower"] call WC_fnc_convertStrings;

// Add location types to array if they are in the parameters.
if ("strategic" in _types) then {          _location_types set [count _location_types, "Strategic"]};
if ("strongpointarea" in _types) then {    _location_types set [count _location_types, "StrongpointArea"]};
if ("flatarea" in _types) then {           _location_types set [count _location_types, "FlatArea"]};
if ("flatareacity" in _types) then {       _location_types set [count _location_types, "FlatAreaCity"]};
if ("flatareacitysmall" in _types) then {  _location_types set [count _location_types, "FlatAreaCitySmall"]};
if ("citycenter" in _types) then {         _location_types set [count _location_types, "CityCenter"]};
if ("airport" in _types) then {            _location_types set [count _location_types, "Airport"]};
if ("namemarine" in _types) then {         _location_types set [count _location_types, "NameMarine"]};
if ("namecitycapital" in _types) then {    _location_types set [count _location_types, "NameCityCapital"]};
if ("namecity" in _types) then {           _location_types set [count _location_types, "NameCity"]};
if ("namevillage" in _types) then {        _location_types set [count _location_types, "NameVillage"]};
if ("namelocal" in _types) then {          _location_types set [count _location_types, "NameLocal"]};
if ("hill" in _types) then {               _location_types set [count _location_types, "Hill"]};
if ("viewpoint" in _types) then {          _location_types set [count _location_types, "ViewPoint"]};
if ("rockarea" in _types) then {           _location_types set [count _location_types, "RockArea"]};
if ("bordercrossing" in _types) then {     _location_types set [count _location_types, "BorderCrossing"]};
if ("vegetationbroadleaf" in _types) then {_location_types set [count _location_types, "VegetationBroadleaf"]};
if ("vegetationfir" in _types) then {      _location_types set [count _location_types, "VegetationFir"]};
if ("vegetationpalm" in _types) then {     _location_types set [count _location_types, "VegetationPalm"]};
if ("vegetationvineyard" in _types) then { _location_types set [count _location_types, "VegetationVineyard"]};

if (count _location_types == 0) exitWith {["ERROR", "WC_fnc_getLocation", format ["No location types : count=%1", count _location_types]] call WC_fnc_log; nil};

// Switch params if minDist is more then maxDist.
if (_min_dist > _max_dist) then {_min_dist = _this select 2; _max_dist = _this select 1};

_locations = nearestLocations [_position, _location_types, _max_dist];

// Remove locations before minDist.
if (_min_dist > 0) then {
	{
		if (_position distance (position _x) < _min_dist) then {
			_locations = _locations - [_x];
		};
	} forEach _locations;
};

// If no locations then return nil.
if (count _locations == 0) exitWith {nil};

// If true then get a random location. If false get the closest location to the position.
if (_random) then {
	_location = _locations call WC_fnc_selectRandom;
} else {
	_location = _locations select 0;
};

_location
