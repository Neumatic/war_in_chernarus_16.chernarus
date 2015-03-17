// -----------------------------------------------
// Author:     code34 nicolas_boiteux@yahoo.fr
// Edited by:  Neumatic
// Warcontext: Generate a random position in a marker
// -----------------------------------------------

private [
	"_marker", "_params", "_on_flat", "_on_flat_for_base", "_on_road", "_on_ground", "_empty", "_near_road", "_empty_area",
	"_count", "_count_sleep", "_position", "_size", "_x", "_y", "_x_temp", "_y_temp", "_new_x", "_new_y"
];

_marker = _this select 0;

_params = [];

// Convert the strings to lower case
_params = [_this, "tolower"] call WC_fnc_convertStrings;

if ("onflat" in _params) then {       _on_flat = true         } else {_on_flat = false};
if ("onflatforbase" in _params) then {_on_flat_for_base = true} else {_on_flat_for_base = false};
if ("onroad" in _params) then {       _on_road = true         } else {_on_road = false};
if ("onground" in _params) then {     _on_ground = true       } else {_on_ground = false};
if ("empty" in _params) then {        _empty = true           } else {_empty = false};
if ("nearroad" in _params) then {     _near_road = true       } else {_near_road = false};
if ("emptyarea" in _params) then {    _empty_area = true      } else {_empty_area = false};

_count = 0;
_count_sleep = 0;
_position = [0,0,0];

_size = (getMarkerSize _marker) select 0;

_x = abs ((getMarkerPos _marker) select 0);
_y = abs ((getMarkerPos _marker) select 1);

while {format ["%1", _position] == "[0,0,0]"} do {
	if (random 1 > 0.5) then {_x_temp = random _size} else {_x_temp = (random _size) * -1};
	if (random 1 > 0.5) then {_y_temp = random _size} else {_y_temp = (random _size) * -1};

	_new_x = ceil (_x_temp + _x);
	_new_y = ceil (_y_temp + _y);

	_position = [_new_x,_new_y,0];

	if (true) then {
		scopeName "main";

		if (_on_ground) then {
			if ({surfaceIsWater _x} count ([_position, 50] call WC_fnc_creategridofposition) > 0) then {
				_position = [0,0,0]; breakOut "main";
			};
		};

		if (_on_flat) then {
			if (count (_position isFlatEmpty [2, 0, 0.2, 2, 0, false, objNull]) == 0) then {
				_position = [0,0,0]; breakOut "main";
			};
		};

		if (_on_flat_for_base) then {
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
		} else {
			if (!_on_road) then {
				if (count (_position nearRoads 15) > 0) then {
					_position = [0,0,0]; breakOut "main";
				};
			};
		};

		if (_empty) then {
			_position = _position findEmptyPosition [0, _size];
			if (count _position == 0) then {
				_position = [0,0,0]; breakOut "main";
			};
		};

		if (_empty_area) then {
			if (count (_position nearObjects ["All", 20]) > 0) then {
				_position = [0,0,0];
			};
		};
	};

	_count = _count + 1;
	_count_sleep = _count_sleep + 1;

	if (_count_sleep > 50) then {_count_sleep = 0; sleep 0.5};
	if (_count > 500) then {_on_flat = false; _on_flat_for_base = false; _empty_area = false};
	if (_count > 1000) then {_position = [1,1,0]; ["ERROR", "WC_fnc_createpositioninmarker", "Position loop over 100 exiting"] call WC_fnc_log};

	sleep 0.05;
};

_position
