// -----------------------------------------------
// Author:     code34 nicolas_boiteux@yahoo.fr
// Edited by:  Neumatic
// Warcontext: IED in town
// -----------------------------------------------

private ["_position", "_houses", "_count", "_ied_objects", "_max", "_new_pos", "_ied_type", "_object", "_marker", "_text"];

_position = _this select 0;

_houses = _position nearObjects ["House", 500];
if (count _houses == 0) exitWith {};

_count = 0;
_ied_objects = +wciedobjects;
_max = [1, wcwithied] call WC_fnc_randomMinMax;

for "_x" from 1 to _max do {
	_new_pos = [_houses call WC_fnc_selectRandom] call WC_fnc_getPos;
	_new_pos = _new_pos findEmptyPosition [0, 50];

	if (count _new_pos > 0) then {
		_ied_type = _ied_objects call WC_fnc_selectRandom;
		_ied_objects = _ied_objects - [_ied_type];

		_object = createVehicle [_ied_type, _new_pos, [], 0, "NONE"];
		_object setDir (random 360);
		[_object] call WC_fnc_alignToTerrain;

		wcobjecttodelete set [count wcobjecttodelete, _object];
		_count = _count + 1;

		if (WC_MarkerAlpha > 0) then {
			_marker = [format ["mrkied%1", wciedindex], _new_pos, 0.5, "ColorRed", "ICON", "FDIAGONAL", "dot", 0, ("IED: " + typeOf _object), WC_MarkerAlpha] call WC_fnc_createmarkerlocal;
			wcambiantmarker set [count wcambiantmarker, _marker];
			wciedindex = wciedindex + 1;
		};

		[_object] spawn WC_fnc_createied;
	};
};

if (_count > 0) then {
	_text = [_new_pos] call WC_fnc_getLocationText;
	["INFO", format ["Created %1 IEDs near %2", _count, _text]] call WC_fnc_log;
};
