// -----------------------------------------------
// Author:     code34 nicolas_boiteux@yahoo.fr
// Edited by:  Neumatic
// Warcontext: Create a persistent global marker
// -----------------------------------------------

private ["_name", "_size", "_pos", "_color", "_shape", "_brush", "_type", "_dir", "_text", "_alpha", "_marker"];

_name  = _this select 0;
_pos   = _this select 1;
_size  = _this select 2;
_color = _this select 3;
_shape = _this select 4;
_brush = _this select 5;
_type  = _this select 6;
_dir   = _this select 7;
_text  = _this select 8;
_alpha = _this select 9;

_name = toLower _name;
if (typeName _pos == "OBJECT") then {
	_pos = [_this select 1] call WC_fnc_getPos;
};

_marker = createMarker [_name, _pos];

if (!isNil "_size") then {
	_size = switch (typeName _size) do {
		case "ARRAY": {[_size select 0, _size select 1]};
		case "SCALAR": {[_size, _size]};
	};

	_marker setMarkerSize _size;
};

if (!isNil "_shape") then {_marker setMarkerShape _shape};
if (!isNil "_color") then {_marker setMarkerColor _color};
if (!isNil "_brush") then {_marker setMarkerBrush _brush};
if (!isNil "_text") then {_marker setMarkerText _text};
if (!isNil "_dir") then {_marker setMarkerDir _dir};
if (!isNil "_type") then {_marker setMarkerType _type};
if (!isNil "_alpha") then {_marker setMarkerAlpha _alpha};

[_marker] call WC_fnc_addMarker;

_marker
