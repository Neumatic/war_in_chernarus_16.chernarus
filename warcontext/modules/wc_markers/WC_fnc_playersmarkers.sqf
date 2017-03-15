// -----------------------------------------------
// Author:     code34 nicolas_boiteux@yahoo.fr
// Edited by:  Neumatic
// Warcontext: Players markers
// -----------------------------------------------

#define REFRESH_COUNT 50
#define OBJECT_TYPES ["CAManBase","LandVehicle","Air"]

private [
	"_fnc_markerColor", "_fnc_markerType", "_fnc_markerAlpha", "_fnc_markerSize", "_fnc_markerText", "_fnc_cleanArray",
	"_fnc_isInArray", "_fnc_markerCheck", "_refresh_count", "_unit", "_marker"
];

// Get marker color.
_fnc_markerColor = {
	if (!alive _this) exitWith {"ColorRed"};
	if (_this isKindOf "CAManBase") exitWith {
		if (_this getVariable ["deadmarker", false]) exitWith {"ColorRed"};
		if (typeOf _this in wcmedicclass) exitWith {"ColorGreen"};
		if (typeOf _this in wcengineerclass) exitWith {"ColorBlack"};
		"ColorBlue"
	};
	if ({alive _x} count crew _this > 0) exitWith {"ColorBlue"};
	"ColorGreen"
};

// Get marker type.
_fnc_markerType = {
	if (_this isKindOf "CAManBase") exitWith {
		if (_this getVariable ["deadmarker", false]) exitWith {"mil_triangle"};
		if (typeOf _this in wcmedicclass) exitWith {"Defend"};
		if (typeOf _this in wcengineerclass) exitWith {"Defend"};
		"Attack"
	};
	if (alive _this) exitWith {"Vehicle"};
	"DestroyedVehicle"
};

// Get marker alpha.
_fnc_markerAlpha = {
	if (_this isKindOf "CAManBase") exitWith {
		if (vehicle _this != _this) exitWith {0};
		if (isPlayer _this || {_this in units group player}) exitWith {1};
		0.5
	};
	if (isPlayer (effectiveCommander _this) || {(effectiveCommander _this) in units group player}) exitWith {1};
	0.5
};

// Get marker size.
_fnc_markerSize = {
	if (_this isKindOf "CAManBase") exitWith {[0.4,0.4]};
	[2,2]
};

// Get marker text.
_fnc_markerText = {
	if (_this isKindOf "CAManBase") exitWith {name _this};
	if ({alive _x} count crew _this > 0) exitWith {format ["%1: %2", (getText (configFile >> "CfgVehicles" >> typeOf _this >> "DisplayName")), name (effectiveCommander _this)]};
	if (locked _this) exitWith {format ["%1: Locked", (getText (configFile >> "CfgVehicles" >> typeOf _this >> "DisplayName"))]};
	format ["%1: Unlocked", (getText (configFile >> "CfgVehicles" >> typeOf _this >> "DisplayName"))];
};

// Removes markers.
_fnc_cleanArray = {
	{
		if (isNull (_x select 0)) then {
			deleteMarkerLocal (_x select 1);
			WC_PlayerMarkers set [_forEachIndex, "<DELETE>"];
		};
	} forEach WC_PlayerMarkers;
	WC_PlayerMarkers = WC_PlayerMarkers - ["<DELETE>"];
};

// Checks if marker already exists.
_fnc_isInArray = {
	{_this in _x} count WC_PlayerMarkers > 0;
};

// Check if the marker can be added.
_fnc_markerCheck = {
	if (isNull _this) exitWith {false};
	if (_this getVariable ["WC_MarkerIgnore", false]) exitWith {false};
	if (_this isKindOf "CAManBase") exitWith {
		if (isPlayer _this) exitWith {true};
		side _this in wcside;
	};
	if (_this getVariable ["WC_VehiclePlayer", false]) exitWith {true};
	if (isNull (effectiveCommander _this)) exitWith {false};
	if (isPlayer (effectiveCommander _this)) exitWith {true};
	side (effectiveCommander _this) in wcside;
};

_refresh_count = 99;

while {true} do {
	if (visibleMap) then {
		if (_refresh_count > REFRESH_COUNT) then {
			{
				if (_x call _fnc_markerCheck) then {
					_marker = str (vehicle _x);
					if !(_marker call _fnc_isInArray) then {
						_marker = createMarkerLocal [_marker, [0,0]];
						WC_PlayerMarkers set [count WC_PlayerMarkers, [_x, _marker]];
					};
				};
			} count (wcmapcenter nearObjects ["AllVehicles", 20000]);

			_refresh_count = 0;
		};

		{
			if ((_x select 0) call _fnc_markerCheck) then {
				(_x select 1) setMarkerTypeLocal ((_x select 0) call _fnc_markerType);
				(_x select 1) setMarkerSizeLocal ((_x select 0) call _fnc_markerSize);
				(_x select 1) setMarkerTextLocal ((_x select 0) call _fnc_markerText);
				(_x select 1) setMarkerColorLocal ((_x select 0) call _fnc_markerColor);
				(_x select 1) setMarkerAlphaLocal ((_x select 0) call _fnc_markerAlpha);
				(_x select 1) setMarkerPosLocal (getPosASL (_x select 0));
			} else {
				WC_PlayerMarkers set [_forEachIndex, [objNull, (_x select 1)]];
			};
		} forEach WC_PlayerMarkers;

		_refresh_count = _refresh_count + 1;
		sleep 0.1;
	} else {
		_refresh_count = 99;
		sleep 1;
	};

	objNull call _fnc_cleanArray;
};
