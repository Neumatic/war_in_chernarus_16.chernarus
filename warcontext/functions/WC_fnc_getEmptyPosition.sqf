/*
	Author Neumatic
	Description: Find a position using parameters. Based on findSafePos function
	by Joris-Jan van 't Land.

	Parameter(s):
		0: [Array/Object] Center position.
		1: [Scalar] Minimum distance.
		2: [Scalar] Maximum distance.
		3: [Scalar] Minimum distance from the nearest object.
		4: [Scalar] Maximum terrain gradient.

	Optional parameter(s):
		5: [Scalar] Water mode.
		6: [Boolean] Can be near water.

	Example(s):
		_pos = [player, 0, 100, sizeOf (typeOf player), 0, false] call WC_fnc_getEmptyPosition;

	Returns:
		Array
*/

private [
	"_position", "_min_dist", "_max_dist", "_obj_dist", "_max_grad", "_water_mode", "_near_water", "_pos_x", "_pos_y",
	"_tries", "_new_pos", "_new_x", "_new_y", "_test_pos"
];

_position   = _this select 0;
_min_dist   = _this select 1;
_max_dist   = _this select 2;
_obj_dist   = _this select 3;
_max_grad   = _this select 4;
_water_mode = if (count _this > 5) then {_this select 5} else {0};
_near_water = if (count _this > 6) then {_this select 6} else {false};

if (typeName _position == typeName objNull) then
{
	_position = [_position] call WC_fnc_getPos;
};

_pos_x = _position select 0;
_pos_y = _position select 1;

_tries = 0;
_new_pos = [];

scopeName "main";

if (count _new_pos == 0) then
{
	while {_tries < 1000} do
	{
		_new_x = _pos_x + (_max_dist - (random (_max_dist * 2)));
		_new_y = _pos_y + (_max_dist - (random (_max_dist * 2)));
		_test_pos = [_new_x, _new_y, 0];

		if (_position distance _test_pos >= _min_dist) then
		{
			if (count (_test_pos isFlatEmpty [_obj_dist, 0, _max_grad, _obj_dist max 5, _water_mode, _near_water, objNull]) > 0) then
			{
				_new_pos = _test_pos;
				breakTo "main";
			};
		};

		_tries = _tries + 1;
	};
};

_new_pos
