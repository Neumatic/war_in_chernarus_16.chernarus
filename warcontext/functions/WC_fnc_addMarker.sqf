/*
	Author: Neumatic
	Description: Adds a marker to the persistent marker array.

	Parameter(s):
		0: [String] Marker name.

	Example(s):
		["MarkerName"] call WC_fnc_addMarker;

	Returns:
		nil
*/

private ["_marker"];

_marker = _this select 0;
_marker = toLower _marker;

WC_MarkersArray set [count WC_MarkersArray, _marker];
publicVariable "WC_MarkersArray";

nil
