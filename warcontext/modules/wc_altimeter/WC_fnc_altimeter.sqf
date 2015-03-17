// -----------------------------------------------
// Author:     code34 nicolas_boiteux@yahoo.fr
// Edited by:  Neumatic
// Warcontext: Hint alti meter
// -----------------------------------------------

private ["_object"];

_object = _this select 0;

while {(([_object] call WC_fnc_getPos) select 2) > 10} do {
	hintSilent format ["Alt: %1 Meters", round (([_object] call WC_fnc_getPos) select 2)];
	sleep 0.1;
};

hintSilent "";
