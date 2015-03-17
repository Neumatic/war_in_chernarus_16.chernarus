// -----------------------------------------------
// Author:     code34 nicolas_boiteux@yahoo.fr
// Edited by:  Neumatic
// Warcontext: Players markers
// -----------------------------------------------

#define REFRESH_COUNT 50
#define OBJECT_TYPES ["CAManBase","LandVehicle","Air"]

private [
	"_FNC_MarkerColor", "_FNC_MarkerType", "_FNC_MarkerAlpha", "_FNC_MarkerSize", "_FNC_MarkerText", "_FNC_CleanArray",
	"_FNC_IsInArray", "_FNC_MarkerCheck", "_refresh_count", "_all_units", "_unit", "_marker"
];

// Get marker color.
_FNC_MarkerColor = {
	private ["_color"];
	if (alive _this) then {
		if (_this isKindOf "CAManBase") then {
			if (_this getVariable ["deadmarker", false]) then {
				_color = "ColorRed";
			} else {
				if (typeOf _this in wcmedicclass) then {
					_color = "ColorGreen";
				} else {
					if (typeOf _this in wcengineerclass) then {
						_color = "ColorBlack";
					} else {
						_color = "ColorBlue";
					};
				};
			};
		} else {
			if ({alive _x} count crew _this > 0) then {
				_color = "ColorBlue";
			} else {
				_color = "ColorGreen";
			};
		};
	} else {
		_color = "ColorRed";
	};
	_color
};

// Get marker type.
_FNC_MarkerType = {
	private ["_type"];
	if (_this isKindOf "CAManBase") then {
		if (_this getVariable ["deadmarker", false]) then {
			_type = "mil_triangle";
		} else {
			if (typeOf _this in wcmedicclass) then {
				_type = "Defend";
			} else {
				if (typeOf _this in wcengineerclass) then {
					_type = "Defend";
				} else {
					_type = "Attack";
				};
			};
		};
	} else {
		if (alive _this) then {
			_type = "Vehicle";
		} else {
			_type = "DestroyedVehicle";
		};
	};
	_type
};

// Get marker alpha.
_FNC_MarkerAlpha = {
	private ["_alpha"];
	if (_this isKindOf "CAManBase") then {
		if (vehicle _this == _this) then {
			if (isPlayer _this) then {
				_alpha = 1;
			} else {
				if (_this in units group player) then {
					_alpha = 1;
				} else {
					_alpha = 0.5;
				};
			};
		} else {
			_alpha = 0;
		};
	} else {
		if ({alive _x} count crew _this > 0) then {
			if (isPlayer (effectiveCommander _this)) then {
				_alpha = 1;
			} else {
				if ((effectiveCommander _this) in units group player) then {
					_alpha = 1;
				} else {
					_alpha =  0.5;
				};
			};
		} else {
			_alpha = 0.5;
		};
	};
	_alpha
};

// Get marker size.
_FNC_MarkerSize = {
	private ["_size"];
	if (_this isKindOf "CAManBase") then {
		_size = [0.4,0.4];
	} else {
		_size = [2,2];
	};
	_size
};

// Get marker text.
_FNC_MarkerText = {
	private ["_text"];
	if (_this isKindOf "CAManBase") then {
		_text = name _this;
	} else {
		_text = getText (configFile >> "CfgVehicles" >> typeOf _this >> "DisplayName");
		if ({alive _x} count crew _this > 0) then {
			_text = _text + format [": %1", name (effectiveCommander _this)];
		} else {
			if (locked _this) then {
				_text = _text + ": Locked";
			} else {
				_text = _text + ": Unlocked";
			};
		};
	};
	_text
};

// Removes markers.
_FNC_CleanArray = {
	{
		if (isNull (_x select 0)) then {
			deleteMarkerLocal (_x select 1);
			WC_PlayerMarkers set [_forEachIndex, "<DELETE>"];
		};
	} forEach WC_PlayerMarkers;
	WC_PlayerMarkers = WC_PlayerMarkers - ["<DELETE>"];
};

// Checks if marker already exists.
_FNC_IsInArray = {
	private ["_return"];
	_return = false;
	{
		if (_this in _x) then {
			_return = true;
		};
	} count WC_PlayerMarkers;
	_return
};

// Check if the marker can be added.
_FNC_MarkerCheck = {
	private ["_return"];
	_return = false;
	if !(_this getVariable ["WC_MarkerIgnore", false]) then {
		if (_this isKindOf "CAManBase") then {
			if (isPlayer _this) then {
				_return = true;
			} else {
				if (side _this in wcside) then {
					_return = true;
				};
			};
		} else {
			if ({alive _x} count crew _this > 0) then {
				if (isPlayer (effectiveCommander _this)) then {
					_return = true;
				} else {
					if (side (effectiveCommander _this) in wcside) then {
						_return = true;
					};
				};
			} else {
				if (_this getVariable ["WC_VehiclePlayer", false]) then {
					_return = true;
				};
			};
		};
	};
	_return
};

_refresh_count = 99;

while {true} do {
	if (visibleMap) then {
		if (_refresh_count > REFRESH_COUNT) then {
			_all_units = nearestObjects [wcmapcenter, OBJECT_TYPES, 20000];
			{
				_unit = _x;
				if (_unit call _FNC_MarkerCheck) then {
					_marker = str (vehicle _unit);
					if !(_marker call _FNC_IsInArray) then {
						_marker = createMarkerLocal [_marker, [0,0]];
						WC_PlayerMarkers set [count WC_PlayerMarkers, [_unit, _marker]];
					};
				};
			} count _all_units;

			_refresh_count = 0;
		};

		{
			_unit   = _x select 0;
			_marker = _x select 1;
			if (_unit call _FNC_MarkerCheck) then {
				_marker setMarkerTypeLocal (_unit call _FNC_MarkerType);
				_marker setMarkerSizeLocal (_unit call _FNC_MarkerSize);
				_marker setMarkerTextLocal (_unit call _FNC_MarkerText);
				_marker setMarkerColorLocal (_unit call _FNC_MarkerColor);
				_marker setMarkerAlphaLocal (_unit call _FNC_MarkerAlpha);
				_marker setMarkerPosLocal (getPosASL _unit);
			} else {
				WC_PlayerMarkers set [_forEachIndex, [objNull, _marker]];
			};
		} forEach WC_PlayerMarkers;

		_refresh_count = _refresh_count + 1;
		sleep 0.1;
	} else {
		_refresh_count = 99;
		sleep 1;
	};

	objNull call _FNC_CleanArray;
};
