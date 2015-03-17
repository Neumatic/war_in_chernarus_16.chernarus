/*
	Author: Neumatic
	Description: Refreshes global persistent markers when new player joins.

	Parameter(s):
		nil

	Example(s):
		[] call WC_fnc_refreshemarkers;

	Returns:
		nil
*/

if (isNil "WC_MarkersArray") exitWith {
	["ERROR", "WC_fnc_refreshmarkers", "Failed to get persistent marker ARRAY"] call WC_fnc_log;
	nil
};

if (count WC_MarkersArray > 0) then {
	{
		_x setMarkerAlpha (markerAlpha _x);
		_x setMarkerColor (markerColor _x);
	} forEach WC_MarkersArray;
};

nil
