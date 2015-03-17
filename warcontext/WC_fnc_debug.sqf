// -----------------------------------------------
// Author:     code34 nicolas_boiteux@yahoo.fr
// Edited by:  Neumatic
// Warcontext: Debugger - works only on local
// -----------------------------------------------

// Uncomment for debugging.
//#define DEBUG_MARKERS

#ifdef DEBUG_MARKERS
	WC_MarkerAlpha = 1;

	if (WC_isClient && {WC_isServer}) then {
		["extern\R3F_DEBUG\scripts\functions_R3F_Debug.sqf"] call WC_fnc_compile;
	};
#else
	WC_MarkerAlpha = 0;
#endif

nil
