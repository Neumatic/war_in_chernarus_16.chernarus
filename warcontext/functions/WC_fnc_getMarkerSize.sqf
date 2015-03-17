/*
	Author: Neumatic
	Description: Get the size of the marker using the largest size of the marker.

	Parameter(s):
		0: [String] Marker name.

	Example(s):
		_size = ["MarkerName"] call WC_fnc_getMarkerSize;
		-> _size = 100;

	Returns:
		Number
*/

private ["_marker", "_x", "_y", "_size"];

_marker = _this select 0;

_x = (getMarkerSize _marker) select 0;
_y = (getMarkerSize _marker) select 1;

if (_x > _y) then {_size = _x} else {_size = _y};

_size
