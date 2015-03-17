/*
	Author: Neumatic
	Description: Find an empty position using parameters. If no position is
	found then it loops with a max distance increase till one is found. Keep
	the min distance under 50 meters or the loop will lock up.

	Parameter(s):
		0: [Array] Center position.
		1: [Number] Minimum distance.
		2: [Number] Maximum distance.

	Optional parameter(s):
		3: [Number] Maximum distance increase.
		4: [String/Object] String of vehicle class name.

	Example(s):
		_position = [getPos vehicle player, 10, 100, 10, typeOf vehicle player] call WC_fnc_findEmptyPosition;
		-> _position = [1000,2300,0];

	Returns:
		Array
*/

private ["_position", "_min_dist", "_max_dist", "_increase", "_params", "_type_of", "_new_pos"];

_position = _this select 0;
_min_dist = _this select 1;
_max_dist = _this select 2;
_increase = _this select 3;

// If not a position array then get a position.
if (typeName _position == typeName objNull) then {
	_position = [_position] call WC_fnc_getPos;
};

// Make sure min distance is under 50 meters.
if (_min_dist > 50) then {_min_dist = 50};

// Get the findEmptyPosition parameters.
_params = if (count _this > 4) then {
	_type_of = if (typeName (_this select 4) != "STRING") then {
		typeOf (_this select 4);
	} else {_this select 4};

	[_min_dist, _max_dist, _type_of];
} else {[_min_dist, _max_dist]};

_new_pos = [];
_new_pos = _position findEmptyPosition _params;

// If we have a position then no need to go any further.
if (count _new_pos > 0) exitWith {_new_pos};

sleep 1;

// Increase the max distance parameter.
_max_dist = _max_dist + _increase;
_params set [1, _max_dist];

/*
	Use while loop to findEmptyPosition.
	Loop increases the max distance till a position is found.
*/
while {true} do {
	_new_pos = _position findEmptyPosition _params;

	if (count _new_pos > 0) exitWith {};

	_max_dist = _max_dist + _increase;
	_params set [1, _max_dist];
	sleep 1;
};

_new_pos
