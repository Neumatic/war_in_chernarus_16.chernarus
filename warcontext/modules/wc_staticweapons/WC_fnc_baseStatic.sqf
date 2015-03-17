/*
	Author: Neumatic
	Description: Handles a base static weapon.

	Parameter(s):
		0: [Object] Static weapon

	Example(s):
		[_object] spawn WC_fnc_createstatic;

	Returns:
		nil
*/

#define LOOP_CYCLE 20

private ["_vehicle", "_group", "_marker_pos", "_marker_size", "_gunner", "_target", "_units_array"];

_vehicle = _this select 0;

// Get group of static add to handler.
_group = group _vehicle;
[_group, west] spawn WC_fnc_grouphandler;

// Get marker data.
_marker_pos = getMarkerPos "bluefor";
_marker_size = ["bluefor"] call WC_fnc_getMarkerSize;

// Add fired event handler.
_vehicle addEventHandler ["Fired", {
	(_this select 0) setVehicleAmmo 1;
}];

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

			// Reveal target to friendly units.
			_units_array = _marker_pos nearEntities ["CAManBase", _marker_size];
			{
				if (isPlayer _x || {side _x in wcside}) then {
					_x reveal _target;
				};
			} forEach _units_array;
		};
	};

	sleep LOOP_CYCLE;
};
