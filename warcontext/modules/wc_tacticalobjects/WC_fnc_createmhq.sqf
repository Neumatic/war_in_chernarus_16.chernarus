// -----------------------------------------------
// Author:     code34 nicolas_boiteux@yahoo.fr
// Edited by:  Neumatic
// Warcontext: Create a Mobile HQ near zone
// -----------------------------------------------

#define LOCATION_TYPES ["FlatArea","FlatAreaCity","FlatAreaCitySmall","NameCityCapital","NameCity","NameVillage","NameLocal"]

private ["_position", "_location"];

_position = _this select 0;

if (!isNull wcteleport) then {deleteVehicle wcteleport};
if (getMarkerColor "teleporthq" != "") then {["teleporthq"] call WC_fnc_deletemarker};

_location = [_position, 600, 1200, true, LOCATION_TYPES] call WC_fnc_getLocation;
if (isNil "_location") exitWith {
	["ERROR", "WC_fnc_createmhq", "No location returned"] call WC_fnc_log;
};

_position = [position _location, 0, 150, sizeOf "LAV25_HQ_unfolded", 0.2] call WC_fnc_getEmptyPosition;

wcteleport = createVehicle ["LAV25_HQ_unfolded", _position, [], 0, "NONE"];
wcteleport setDir (random 360);
[wcteleport] call WC_fnc_alignToTerrain;
wcteleport allowDamage false;
wcteleport setFuel 0;

["teleporthq", _position, 0.5, "ColorGreen", "ICON", "FDIAGONAL", "Headquarters", 0, "", 1] call WC_fnc_createmarker;

["wcteleport", "client"] call WC_fnc_publicvariable;

wchintW = localize "STR_WC_MESSAGEMHQDEPLOYED";
["wchintW", "client"] call WC_fnc_publicvariable;
