// -----------------------------------------------
// Author:     code34 nicolas_boiteux@yahoo.fr
// Edited by:  Neumatic
// Warcontext: Map markers for vehicles with a name
// -----------------------------------------------

/*
	DEPRECATED CODE
	All marker code moved into WC_fnc_playersmarkers.sqf
*/

#define REFRESH_COUNT 50

private ["_FNC_RefreshMarkers", "_FNC_DeleteMarkers", "_marker_array", "_refresh_count"];

_FNC_RefreshMarkers = {
	private ["_marker_array", "_array_push", "_name", "_var_name", "_all_vehicles", "_commander", "_color", "_alpha", "_type"];

	_marker_array = [];
	_array_push = false;

	_name = nil;
	_var_name = nil;

	_all_vehicles = vehicles;
	{
		if (count crew _x > 0) then {
			_commander = effectiveCommander _x;

			if (isPlayer _commander) then {
				_color = "ColorBlue"; _alpha = 1;
				_array_push = true;
			} else {
				if (_commander in units group player) then {
					_color = "ColorBlue"; _alpha = 1;
					_array_push = true;
				} else {
					if (side _commander in wcside) then {
						_color = "ColorBlue"; _alpha = 0.5;
						_array_push = true;
					};
				}
			};
		} else {
			_var_name = vehicleVarName _x;
			if (_var_name != "") then {
				_name = [_x] call WC_fnc_getDisplayName;

				if (alive _x) then {
					_color = "ColorGreen"; _alpha = 0.5;

					if (locked _x) then {
						_name = _name + ": Locked";
					} else {
						_name = _name + ": Unlocked";
					};
				} else {
					_color = "ColorRed"; _alpha = 0.5;
				};

				_array_push = true;
			};
		};

		if (_array_push) then {
			if (isNil "_var_name") then {
				_var_name = str (ceil (random 100000 + random 100000));
			};

			if (isNil "_name") then {
				_name = [_x] call WC_fnc_getDisplayName;
				_name = _name + format [": %1", name _commander];
			};

			if (!alive _x) then {
				_type = "DestroyedVehicle";
			} else {
				_type = "Vehicle";
			};

			_marker_array set [count _marker_array, [_x, _var_name, _name, _color, _type, _alpha]];
			_array_push = false;

			_name = nil;
			_var_name = nil;
		};
	} forEach _all_vehicles;

	_marker_array
};

_FNC_DeleteMarkers = {
	{
		deleteMarkerLocal (_x select 1);
	} forEach (_this select 0);
	nil
};

_marker_array = [];
_refresh_count = 999;

while {true} do {
	if (visibleMap) then {
		if (_refresh_count > REFRESH_COUNT) then {
			if (count _marker_array > 0) then {
				[_marker_array] call _FNC_DeleteMarkers;
				_marker_array = [];
			};

			_marker_array = objNull call _FNC_RefreshMarkers;

			{
				[_x select 1, _x select 0, 2, _x select 3, "ICON", "FDIAGONAL", _x select 4, 0, _x select 2, _x select 5] call WC_fnc_createmarkerlocal;
			} forEach _marker_array;

			_refresh_count = 0;
		} else {
			{
				(_x select 1) setMarkerPosLocal ([_x select 0] call WC_fnc_getPos);

				if (!alive (_x select 0)) then {
					(_x select 1) setMarkerColorLocal "ColorRed";
					(_x select 1) setMarkerTypeLocal "DestroyedVehicle";
				};
			} forEach _marker_array;

			_refresh_count = _refresh_count + 1;
		};

		sleep 0.1;
	} else {
		if (count _marker_array > 0) then {
			[_marker_array] call _FNC_DeleteMarkers;
			_marker_array = [];
		};

		_refresh_count = 999;
		sleep 1;
	};
};
