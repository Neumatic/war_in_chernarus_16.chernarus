// -----------------------------------------------
// Author:     code34 nicolas_boiteux@yahoo.fr
// Edited by:  Neumatic
// Warcontext: Copy a persistent global marker
// -----------------------------------------------

private ["_name", "_marker", "_size", "_position", "_color", "_shape", "_brush", "_type", "_dir", "_alpha", "_text"];

_name   = _this select 0;
_marker = _this select 1;

_size = getMarkerSize _marker;
_position = markerPos _marker;
_color = markerColor _marker;
_shape = markerShape _marker;
_brush = markerBrush _marker;
_type = markerType _marker;
_dir = markerDir _marker;
_alpha = markerAlpha _marker;
_text = _name;

_marker = [_name, _position, _size, _color, _shape, _brush, _type, _dir, _text, _alpha] call WC_fnc_createmarker;

_marker
