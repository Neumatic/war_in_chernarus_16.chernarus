// -----------------------------------------------
// Author:     code34 nicolas_boiteux@yahoo.fr
// Edited by:  Neumatic
// Warcontext: Create a mine field at road position
// -----------------------------------------------

#define MINE_FIELDS [1,3]
#define MINES_TOTAL [2,4]

private ["_position", "_roads", "_max", "_road", "_dir", "_pos", "_marker", "_number", "_mine", "_text"];

_position = _this select 0;

_roads = _position nearRoads 500;
{
	if !((count (roadsConnectedTo _x) > 1) && {(count (nearestObjects [_x, ["House"], 20]) > 0)}) then {
		_roads = _roads - [_x];
	};
} forEach _roads;

if (count _roads == 0) exitWith {};

_max = MINE_FIELDS call WC_fnc_randomMinMax;
if (_max > count _roads) then {_max = count _roads};

for "_i" from 1 to _max do {
	_road = _roads call WC_fnc_selectRandom;
	_dir = getDir _road;
	_pos = [[_road] call WC_fnc_getPos, (_dir + 90), 0] call WC_fnc_PDB;

	if (WC_MarkerAlpha > 0) then {
		_marker = [format ["mrkminefield%1", wcminefieldindex], _pos, 0.5, "ColorRed", "ICON", "FDIAGONAL", "hd_warning", 0, "", WC_MarkerAlpha] call WC_fnc_createmarkerlocal;
		wcambiantmarker set [count wcambiantmarker, _marker];
		wcminefieldindex = wcminefieldindex + 1;
	};

	_number = MINES_TOTAL call WC_fnc_randomMinMax;

	for "_x" from 1 to _number do {
		_mine = createMine ["MineMine", _pos, [], 5];
		wcobjecttodelete set [count wcobjecttodelete, _mine];
	};

	sleep 0.5;
};

_text = [_pos] call WC_fnc_getLocationText;
["INFO", format ["Created %1 minefields near %2", _max, _text]] call WC_fnc_log;
