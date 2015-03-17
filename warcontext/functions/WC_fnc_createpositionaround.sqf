// -----------------------------------------------
// Author:     code34 nicolas_boiteux@yahoo.fr
// Edited by:  Neumatic
// Warcontext: Create a position around another position
// -----------------------------------------------

private ["_old_pos", "_min_dist", "_radius", "_size", "_position", "_x", "_y", "_x_temp", "_y_temp", "_new_x", "_new_y"];

_old_pos  = _this select 0;
_min_dist = _this select 1;
_radius   = _this select 2;

_size = _radius - _min_dist;

_position = [0,0,0];

while {format ["%1", _position] == "[0,0,0]"} do {
	_x = _old_pos select 0;
	_y = _old_pos select 1;

	if (random 1 > 0.5) then {_x_temp = ((random _size) + _min_dist)} else {_x_temp = ((random _size) + _min_dist) * -1};
	if (random 1 > 0.5) then {_y_temp = ((random _size) + _min_dist)} else {_y_temp = ((random _size) + _min_dist) * -1};

	_new_x = ceil (_x_temp + _x);
	_new_y = ceil (_y_temp + _y);

	_position = [_new_x,_new_y,0];

	if (surfaceIsWater _position) then {
		_position = [0,0,0];
	};

	sleep 0.01;
};

_position
