// -----------------------------------------------
// Author:     code34 nicolas_boiteux@yahoo.fr
// Edited by:  Neumatic
// Warcontext: Create a positions circle of x points around position
// -----------------------------------------------

private ["_position", "_radius", "_degree", "_dir", "_num_of_pos", "_positions", "_a", "_b"];

_position   = _this select 0;
_radius     = _this select 1;
_degree     = _this select 2;
_dir        = _this select 3;
_num_of_pos = _this select 4;

_positions = [];
_dir = _dir - 90;
_degree = _degree / _num_of_pos;

for "_i" from 1 to _num_of_pos do {
	_a = (_position select 0) + ((sin _dir) * _radius);
	_b = (_position select 1) + ((cos _dir) * _radius);
	_positions set [count _positions, [_a, _b, _position select 2]];
	_dir = _dir + _degree;
};

_positions
