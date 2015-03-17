/*
	Author: Neumatic
	Description: Player markers function.
*/

#include <oop_macros.h>

CLASS("NEU_OO_FNC_PlayersMarkers")
	PRIVATE VARIABLE("array", "markers");
	PRIVATE VARIABLE("scalar", "refresh");

	PUBLIC FUNCTION("array", "constructor") {
		private ["_array"];
		_array = [];
		MEMBER("markers", _array);
		MEMBER("refresh", 0);
	};

	PRIVATE FUNCTION("", "getMarkers") FUNC_GETVAR("markers");
	PRIVATE FUNCTION("", "getRefresh") FUNC_GETVAR("refresh");

	// Get marker color.
	PRIVATE FUNCTION("object", "getColor") {
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
	PRIVATE FUNCTION("object", "getType") {
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
	PRIVATE FUNCTION("object", "getAlpha") {
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
	PRIVATE FUNCTION("object", "getSize") {
		private ["_size"];
		if (_this isKindOf "CAManBase") then {
			_size = [0.4,0.4];
		} else {
			_size = [2,2];
		};
		_size
	};

	// Get marker text.
	PRIVATE FUNCTION("object", "getText") {
		private ["_text"];
		if (_this isKindOf "CAManBase") then {
			_text = name _unit;
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

	// Check if object can be added.
	PRIVATE FUNCTION("object", "checkObj") {
		private ["_return"];
		_return = false;
		if !(_this getVariable ["WC_MarkerIgnore", false]) then {
			if (_this isKindOf "CAManBase") then {
				if (isPlayer _this || {side _this in wcside}) then {
					_return = true;
				};
			} else {
				if ({alive _x} count crew _this > 0) then {
					if (isPlayer (effectiveCommander _this)) then {
						_return = true;
					} else {
						if (side (effectiveCommander _this) in wcside}) then {
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

	// Clean marker array of null objects.
	PRIVATE FUNCTION("", "cleanArray") {
		private ["_markers"];
		if (count MEMBER("getMarkers", nil) > 0) then {
			_markers = MEMBER("getMarkers", nil);
			{
				if (isNull (_x select 0)) then {
					deleteMarkerLocal (_x select 1);
					_markers set [_forEachIndex, "<DELETE>"];
				};
			} forEach _markers;
			_markers = _markers - ["<DELETE>"];
			MEMBER("markers", _markers);
		};
	};

	// Check if marker is in the array.
	PRIVATE FUNCTION("string", "inArray") {
		private ["_return", "_markers"];
		_return = false;
		_markers = MEMBER("getMarkers", nil);
		if (count _markers > 0) then {
			{
				if (_this in _x) then {
					_return = true;
				};
			} count _markers;
		};
		_return
	};

	// Marker loop.
	PUBLIC FUNCTION("", "markerLoop") {
		private ["_all_units", "_unit", "_marker", "_array", "_marker_array", "_refresh"];
		_refresh = 0;
		while {true} do {
			if (visibleMap) then {
				_marker_array = MEMBER("getMarkers", nil);

				if (_refresh > 50) then {
					_all_units = nearestObjects [wcmapcenter, ["CAManBase", "LandVehicle", "Air"], 20000];
					{
						_unit = _x;
						if (MEMBER("checkObj", _unit)) then {
							_marker = str (vehicle _unit);
							if !(MEMBER("inArray", _marker)) then {
								_marker = createMarkerLocal [_marker, [0,0]];
								_marker_array set [count _marker_array, [_unit, _marker]];
							};
						};
					} count _all_units;

					_refresh = 0;
				};

				{
					_unit   = _x select 0;
					_marker = _x select 1;
					if (MEMBER("checkObj", _unit)) then {
						_marker setMarkerTypeLocal MEMBER("getType", _unit);
						_marker setMarkerSizeLocal MEMBER("getSize", _unit);
						_marker setMarkerTextLocal MEMBER("getText", _unit);
						_marker setMarkerColorLocal MEMBER("getColor", _unit);
						_marker setMarkerAlphaLocal MEMBER("getAlpha", _unit);
						_marker setMarkerPosLocal (getPos _unit);
					} else {
						_marker_array set [_forEachIndex, [objNull, _marker]];
					};
				} forEach _marker_array;

				MEMBER("markers", _marker_array);
				_refresh = _refresh + 1;

				sleep 0.1;
			} else {
				_refresh = 99;
				sleep 1;
			};

			MEMBER("cleanArray", nil);
		};
	};

	PUBLIC FUNCTION("", "deconstructor") {
		DELETE_VARIABLE("markers");
		DELETE_VARIABLE("refresh");
	};
ENDCLASS;