// -----------------------------------------------
// Author:     code34 nicolas_boiteux@yahoo.fr
// Edited by:  Neumatic
// Warcontext: Delete units when they are killed
// -----------------------------------------------

#define MAX_DISTANCE 20
#define MAIN_LOOP_CYCLE 60

private ["_object"];

while {true} do {
	if (count WC_GarbageArray > 0) then {
		{
			_object = _x select 0;
			if (!isNull _object) then {
				if (_x select 1 <= time) then {
					if ({([_x, _object] call WC_fnc_getDistance) <= MAX_DISTANCE} count ([] call BIS_fnc_listPlayers) == 0) then {
						WC_GarbageArray set [_forEachIndex, "<DELETE>"];
						deleteVehicle _object;
					};
				};
			} else {
				WC_GarbageArray set [_forEachIndex, "<DELETE>"];
			};
		} forEach WC_GarbageArray;

		WC_GarbageArray = WC_GarbageArray - ["<DELETE>"];
	};

	sleep MAIN_LOOP_CYCLE;
};
