/*
	Author: Neumatic
	Description: Deletes a global marker from the persistent marker array.
	This is the only way to delete a persistent global marker.

	Parameter(s):
		0: [String] Marker name.

	Example(s):
		_removed = ["MarkerName"] call WC_fnc_deletemarker;
		-> _removed = true;

	Returns:
		Bool
*/

private ["_marker", "_removed"];

_marker = _this select 0;

_removed = false;

if (getMarkerColor _marker == "") exitWith {
	["ERROR", "WC_fnc_deletemarker", format ["Marker does not exist : _marker=%1 : getMarkerColor=%2", _marker, getMarkerColor _marker]] call WC_fnc_log;
	_removed
};

deleteMarker _marker;

if (_marker in WC_MarkersArray) then {
	_removed = [WC_MarkersArray, _marker] call WC_fnc_arrayRemove;
	publicVariable "WC_MarkersArray";
};

_removed
