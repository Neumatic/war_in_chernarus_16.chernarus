// -----------------------------------------------
// Author:     code34 nicolas_boiteux@yahoo.fr
// Edited by:  Neumatic
// Warcontext: Creates groups in zones around target
// -----------------------------------------------

#define LOCATION_TYPES ["FlatArea","FlatAreaCity","FlatAreaCitySmall","Airport","NameCityCapital","NameCity","NameVillage","Hill","Mount"]

private ["_location", "_weight", "_position", "_locations", "_index", "_count_zones", "_count_groups", "_marker"];

_location = _this select 0;
_weight   = _this select 1;

_position = position _location;

if (wckindofserver == 3) then {
	wcambiantdistance = 2500;
};

// Create enemies around target
_locations = nearestLocations [_position, LOCATION_TYPES, wcambiantdistance];
{
	if (_position distance (position _x) < 600) then {
		_locations set [_forEachIndex, "<DELETE>"];
	};
} forEach _locations;

_locations = _locations - ["<DELETE>"];

if (wckindofserver != 3) then {
	wcambiantdistance = wcambiantdistance + 200;
};

if (count _locations > wclevelmaxoutofcity) then {
	while {count _locations > wclevelmaxoutofcity} do {
		_index = random (floor count _locations);
		_locations set [_index, "<DELETE>"];
		_locations = _locations - ["<DELETE>"];
	};
};

_count_zones = 0;
_count_groups = 0;

{
	_marker = [format ["ambiant%1", wcambiantindex], position _x, (wcdistance * 2), "ColorRed", "ELLIPSE", "FDIAGONAL", "EMPTY", 0, "", WC_MarkerAlpha] call WC_fnc_createmarkerlocal;
	wcambiantmarker set [count wcambiantmarker, _marker];
	wcambiantindex = wcambiantindex + 1;

	_count_zones = _count_zones + 1;

	if (wcwithcomposition == 1) then {
		[_x] spawn WC_fnc_createcomposition;
	};

	for "_i" from 0 to wcambiantgroups do {
		if (random 1 > 0.7) then {
			[_marker, true, _weight] spawn WC_fnc_creategroup;
		} else {
			[_marker, false] spawn WC_fnc_creategroup;
		};
		_count_groups = _count_groups + 1;
		sleep 0.5;
	};

	sleep 1;
} forEach _locations;

["INFO", format ["Created %1 ambiant zones with %2 patrol groups", _count_zones, _count_groups]] call WC_fnc_log;
