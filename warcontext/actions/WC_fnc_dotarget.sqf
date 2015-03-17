// -----------------------------------------------
// Author:     code34 nicolas_boiteux@yahoo.fr
// Edited by:  Neumatic
// Warcontext: Do target
// -----------------------------------------------

private ["_unit", "_pos"];

_unit = cursorTarget;

if (!isNull _unit) then {
	["Target Fire", "Wait few seconds.", "You have call for a target fire", 10] spawn WC_fnc_playerhint;
	sleep 10;

	_pos = [_unit] call WC_fnc_getPos;
	createVehicle ["ARTY_R_227mm_HE", _pos, [], 0, "NONE"];
	createVehicle ["Bo_GBU12_LGB", _pos, [], 0, "NONE"];
} else {
	["Target Fire", "Point a real target.", "There is no target", 3] spawn WC_fnc_playerhint;
};
