// -----------------------------------------------
// Author:     code34 nicolas_boiteux@yahoo.fr
// Edited by:  Neumatic
// Warcontext: Create a grid of 9 positions NW,N,NE,W,C,E,SW,S,SE
// -----------------------------------------------

private [
	"_position", "_size", "_x", "_y", "_negative_x", "_positive_x", "_negative_y", "_positive_y", "_position_1",
	"_position_2", "_position_3", "_position_4", "_position_5", "_position_6", "_position_7", "_position_8",
	"_position_9"
];

_position = _this select 0;
_size     = _this select 1;

_x = _position select 0;
_y = _position select 1;

_negative_x = _x - _size;
_positive_x = _x + _size;
_negative_y = _y - _size;
_positive_y = _y + _size;

_position_1 = [_negative_x, _positive_y, 0];
_position_2 = [_x, _positive_y, 0];
_position_3 = [_positive_x, _positive_y, 0];

_position_4 = [_negative_x, _y, 0];
_position_5 = _position;
_position_6 = [_positive_x, _y, 0];

_position_7 = [_negative_x, _negative_y, 0];
_position_8 = [_x, _negative_y, 0];
_position_9 = [_positive_x, _negative_y, 0];

[_position_1, _position_2, _position_3, _position_4, _position_5, _position_6, _position_7, _position_8, _position_9]
