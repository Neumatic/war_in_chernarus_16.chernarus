// -----------------------------------------------
// Author:     code34 nicolas_boiteux@yahoo.fr
// Edited by:  Neumatic
// Warcontext: Generate a random position
// -----------------------------------------------

private [
	"_top_right", "_bottom_left", "_params", "_on_mountain", "_on_flat", "_on_road", "_in_village", "_in_city",
	"_in_city_capital", "_on_hill", "_on_mount", "_on_ground", "_on_sea", "_empty", "_near_road", "_position",
	"_respawn_west", "_x_max", "_y_max", "_x_min", "_y_min", "_x_random", "_y_random", "_x", "_y", "_new_x", "_new_y",
	"_location"
];

_top_right   = _this select 0;
_bottom_left = _this select 1;

_params = [];

// Convert the strings to lower case
_params = [_this, "tolower"] call WC_fnc_convertStrings;

if ("onmountain" in _params) then {   _on_mountain = true    } else {_on_mountain = false};
if ("onflat" in _params) then {       _on_flat = true        } else {_on_flat = false};
if ("onroad" in _params) then {       _on_road = true        } else {_on_road = false};
if ("invillage" in _params) then {    _in_village = true     } else {_in_village = false};
if ("incity" in _params) then {       _in_city = true        } else {_in_city = false};
if ("incitycapital" in _params) then {_in_city_capital = true} else {_in_city_capital = false};
if ("onhill" in _params) then {       _on_hill = true        } else {_on_hill = false};
if ("onmount" in _params) then {      _on_mount = true       } else {_on_mount = false};
if ("onground" in _params) then {     _on_ground = true      } else {_on_ground = false};
if ("onsea" in _params) then {        _on_sea = true         } else {_on_sea = false};
if ("empty" in _params) then {        _empty = true          } else {_empty = false};
if ("nearroad" in _params) then {     _near_road = true      } else {_near_road = false};

_position = [0,0,0];
_respawn_west = getMarkerPos "respawn_west";

// Top right
_x_max = _top_right select 0;
_y_max = _top_right select 1;

// Bottom left
_x_min = _bottom_left select 0;
_y_min = _bottom_left select 1;

// Random
_x_random = _x_max - _x_min;
_y_random = _y_max - _y_min;

while {format ["%1", _position] == "[0,0,0]"} do {
	_x = random _x_random;
	_y = random _y_random;

	_new_x = _x + _x_min;
	_new_y = _y + _y_min;

	_position = [_new_x,_new_y,0];

	if (_in_city_capital) then {
		_location = nearestLocation [_position, "NameCityCapital"];
		_position = position _location;
	};

	if (_in_village) then {
		_location = nearestLocation [_position, "NameVillage"];
		_position = position _location;
	};

	if (_in_city) then {
		_location = nearestLocation [_position, "NameCity"];
		_position = position _location;
	};

	if (_on_hill) then {
		_location = nearestLocation [_position, "Hill"];
		_position = position _location;
	};

	if (_on_mount) then {
		_location = nearestLocation [_position, "Mount"];
		_position = position _location;
	};

	if (_on_mountain) then {
		_position = [_position] call WC_fnc_getterraformvariance;
	};

	if (true) then {
		scopeName "main";

		if (_on_ground) then {
			if ({surfaceIsWater _x} count ([_position, 100] call WC_fnc_creategridofposition) > 0) then {
				_position = [0,0,0]; breakOut "main";
			};
		};

		if (_on_flat) then {
			if (count (_position isFlatEmpty [20, 0, 0.1, 20, 0, false, objNull]) == 0) then {
				_position = [0,0,0]; breakOut "main";
			};
		};

		if (_on_road) then {
			if (!isOnRoad _position) then {
				_position = [0,0,0]; breakOut "main";
			};
		};

		if (_near_road) then {
			if (count (_position nearRoads 15) == 0) then {
				_position = [0,0,0]; breakOut "main";
			};
		};

		if (_empty) then {
			if (count (nearestObjects [_position, ["All"], 20]) > 0) then {
				_position = [0,0,0]; breakOut "main";
			};
		};

		if (_on_sea) then {
			if (!surfaceIsWater _position) then {
				_position = [0,0,0]; breakOut "main";
			};
		};

		if (_position distance _respawn_west < 1000) then {
			_position = [0,0,0];
		};
	};

	sleep 0.05;
};

_position
