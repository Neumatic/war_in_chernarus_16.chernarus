// -----------------------------------------------
// Author:     code34 nicolas_boiteux@yahoo.fr
// Edited by:  Neumatic
// Warcontext: Compute a village
// -----------------------------------------------

private ["_location", "_houses_type", "_vehicles", "_position", "_location", "_is_flat", "_vehicle", "_houses_type", "_text"];

_location    = _this select 0;
_houses_type = _this select 1;

if (typeName _location != "LOCATION") exitWith {
	hintC "computeavillage script: location parameter should be a location variable";
};

if (typeName _houses_type != "ARRAY") exitWith {
	hintC "computeavillage script: kindofhouse parameter should be an array variable";
};

if (count _houses_type == 0) exitWith {
	diag_log "WARCONTEXT: NO KIND OF HOUSES WERE SETTED";
};

_vehicles = [];

for "_i" from 0 to ceil (random 100) do {
	_position = (position _location) findEmptyPosition [5 + (random 10), 400];
	if (count _position > 0) then {
		if (count (_position nearRoads 15) == 0) then {
			_is_flat = _position isFlatEmpty [5, 0, 0, 20, 0, false];
			if (count _is_flat != 0) then {
				_vehicle = createVehicle [_houses_type call WC_fnc_selectRandom, _position, [], 0, "NONE"];
				_vehicle setDir (random 360);
				_vehicles set [count _vehicles, _vehicle];
			};
		};
	};
	sleep 0.005;
};

if (count _vehicles > 0) then {
	wcobjecttodelete = wcobjecttodelete + _vehicles;
	_text = [position _location] call WC_fnc_getLocationText;
	["INFO", format ["Created a village of %1 houses near %2", count _vehicles, _text]] call WC_fnc_log;
};
