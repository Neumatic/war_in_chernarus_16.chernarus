// -----------------------------------------------
// Author:     code34 nicolas_boiteux@yahoo.fr
// Edited by:  Neumatic
// Warcontext: Create bunkers near roads
// -----------------------------------------------

#define COMP_TOTAL 4
#define STATIC_TYPES ["KORD_high","DSHKM_Ins"]

private [
	"_location", "_roads", "_diff", "_temp", "_count", "_compositions_object", "_compositions", "_object", "_pos", "_dir",
	"_composition", "_marker", "_marker_size", "_positions", "_static", "_unit", "_text"
];

_location = _this select 0;

_roads = (position _location) nearRoads 500;
{
	if !((count (roadsConnectedTo _x) > 1) && {(count (nearestObjects [_x, ["House"], 30]) == 0)}) then {
		_roads = _roads - [_x];
	};
} forEach _roads;

if (count _roads == 0) exitWith {};

// Remove roads
if (count _roads > COMP_TOTAL) then {
	_diff = count _roads - (ceil (random COMP_TOTAL));
	for "_i" from 0 to (_diff - 1) do {
		_temp = random (count _roads - 1);
		_roads set [_temp, objNull];
		_roads = _roads - [objNull];
	};
};

_count = 0;
_compositions_object = [];
_compositions = +wccompositions;
_roads = _roads call WC_fnc_arrayShuffle;

{
	_object = _x;
	_pos = [getPos _object, (getDir _object + 90), 20] call WC_fnc_PDB;
	_dir = getDir _object;

	if (count (_pos isFlatEmpty [20, 0, 0.2, 20, 0, false]) > 0) then {
		_composition = _compositions call WC_fnc_selectRandom;
		_compositions = _compositions - [_composition];

		_compositions_object = [];
		_compositions_object = ([_pos, (_dir + 180), _composition] call (compile (preprocessFileLineNumbers "ca\modules\dyno\data\scripts\objectMapper.sqf")));

		if (count _compositions_object > 0) then {
			{
				wcobjecttodelete set [count wcobjecttodelete, _x];
			} forEach _compositions_object;

			if (WC_MarkerAlpha > 0) then {
				_marker = [format ["wccompositions%1", wccompositionindex], _pos, 0.5, "ColorGreen", "ICON", "FDIAGONAL", "dot", 0, "", WC_MarkerAlpha] call WC_fnc_createmarkerlocal;
				wcambiantmarker set [count wcambiantmarker, _marker];
				wccompositionindex = wccompositionindex + 1;
			};

			_count = _count + 1;

			if (random 1 > 0.5) then {
				_marker_size = 20 + round (random 20);
				_marker = [format ["wccompositionups%1", wccompositionindex], _pos, _marker_size, "ColorRed", "ELLIPSE", "Border", "", 0, "", WC_MarkerAlpha] call WC_fnc_createmarkerlocal;
				wcambiantmarker set [count wcambiantmarker, _marker];
				wccompositionindex = wccompositionindex + 1;

				[_marker, false] spawn WC_fnc_creategroup;

				_positions = [_pos, "all", 20] call WC_fnc_gethousespositions;
				if (count _positions > 0) then {
					{
						if (random 1 < wcstaticinbunkerprobability) then {
							_static = STATIC_TYPES call WC_fnc_selectRandom;
							_unit = createVehicle [_static, _x, [], 0, "NONE"];
							_unit setPosATL _x;
						};
					} forEach _positions;
				};
			};
		};
	};

	sleep 1;
} forEach _roads;

if (_count > 0) then {
	_text = [position _location] call WC_fnc_getLocationText;
	["INFO", format ["Created %1 compositions near %2", _count, _text]] call WC_fnc_log;
};
