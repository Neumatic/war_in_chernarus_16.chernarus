// -----------------------------------------------
// Author:     code34 nicolas_boiteux@yahoo.fr
// Edited by:  Neumatic
// Warcontext: Create an energy generator
// -----------------------------------------------

private ["_position", "_pos_array", "_exit", "_new_pos", "_rand_pos", "_gen_type", "_protect", "_type", "_generator", "_text"];

_position = _this select 0;

_pos_array = [_position, "all", 500] call WC_fnc_gethousespositions;
if (count _pos_array == 0) exitWith {objNull};

_exit = false;
_new_pos = [];

while {true} do {
	_rand_pos = _pos_array call WC_fnc_selectRandom;
	_new_pos = [_rand_pos, 0, 20, sizeOf "PowerGenerator", 0.2] call WC_fnc_getEmptyPosition;
	if (count _new_pos > 0) exitWith {_exit = false};
	sleep 0.1;

	_pos_array = _pos_array - [_rand_pos];
	if (count _pos_array == 0) exitWith {_exit = true};
};

if (_exit) exitWith {objNull};

_gen_type = _this select 1;
_protect = wccurrentmission select 4;

_type = _gen_type call WC_fnc_selectRandom;
_generator = createVehicle [_type, _new_pos, [], 0, "NONE"];
_generator setDir (random 360);
[_generator] call WC_fnc_alignToTerrain;

wcaddactions = [_generator, "SABOTAGE_OBJECT"];
["wcaddactions", "client"] call WC_fnc_publicvariable;

_text = [_new_pos] call WC_fnc_getLocationText;
["INFO", format ["Created a generator %1 near %2", [_type] call WC_fnc_getDisplayName, _text]] call WC_fnc_log;

if (wcwithgeneratormarkers == 1) then {
	["generator", _generator, 0.5, "ColorRed", "ICON", "FDIAGONAL", "mil_triangle", 0, "Generator site", 1] call WC_fnc_createmarker;
};

if (_protect > 0) then {
	if (random 1 > 0.2) then {
		[_generator, 1, 30, 4] spawn WC_fnc_protectobject;
	};
};

_generator
