/*
	Author: Neumatic
	Description: Creates and handles a static weapon.

	Parameter(s):
		0: [Array] Position

	Example(s):
		[_position] spawn WC_fnc_createstatic;

	Returns:
		nil
*/

#define LOOP_CYCLE 20

private ["_position", "_static", "_vehicle_array", "_vehicle", "_group", "_gunner", "_target"];

_position = _this select 0;

_static = ["AGS_RU","AGS_INS","DSHkM_Mini_TriPod","DSHKM_Ins","KORD","KORD_high"] call WC_fnc_selectRandom;

// Get a position.
_position = [_position, 50, 300] call WC_fnc_createpositionaround;
_position = [_position, 0, 20, 20, _static] call WC_fnc_findEmptyPosition;

// Spawn static weapon.
_vehicle_array = [_position, random 360, _static, east] call WC_fnc_spawnVehicle;
_vehicle = _vehicle_array select 0;
_group   = _vehicle_array select 2;

// Add to handlers.
[_vehicle, east] spawn WC_fnc_vehiclehandler;
[_group, east] spawn WC_fnc_grouphandler;

// Main loop.
while {!isNull _vehicle && {alive _vehicle}} do {
	if ({alive _x} count crew _vehicle > 0) then {
		// Get the gunner and set combat mode.
		_gunner = gunner _vehicle;

		// Check for a target.
		_target = _gunner findNearestEnemy _gunner;

		// Is there a target? If so target him.
		if (isNull _target || {!alive _target}) then {
			_gunner setBehaviour "AWARE";
			_gunner setCombatMode "WHITE";

			_gunner doWatch objNull;
		} else {
			_gunner setBehaviour "COMBAT";
			_gunner setCombatMode "RED";

			_gunner doWatch _target;
			_gunner doTarget _target;
			_gunner doFire _target;

			// Reveal target to the gunner group.
			{
				_x reveal _target;
			} forEach units group _gunner;
		};
	};

	sleep LOOP_CYCLE;
};
