/*
	Author: Neumatic
	Description: Handles the seapatrol movement and combat.

	Parameter(s):
		0: [Object] Vehicle
		1: [Group] Vehicles group

	Example(s):
		[_object, _group] spawn WC_fnc_seapatrol;

	Returns:
		nil
*/

// Uncomment for debug chat.
//#define DEBUG_CHAT

#define MAIN_LOOP_CYCLE 20

private [
	"_vehicle", "_group", "_alert", "_got_hit", "_loop", "_mission", "_index", "_veh_name", "_fnc_got_hit", "_leader",
	"_old_target", "_target", "_alert_time", "_behaviour", "_combat_mode", "_wp_type", "_wp_speed", "_position",
	"_got_hit_pos", "_wp", "_move"
];

_vehicle = _this select 0;
_group   = _this select 1;

_alert = false;
_got_hit = false;
_loop = true;
_mission = "PATROL";

// If debug then get the index of the patrol.
#ifdef DEBUG_CHAT
	_index = (count WC_SeaPatrols) + 1; _veh_name = [_vehicle] call WC_fnc_getDisplayName;
#endif

// Set alert time variable.
_group setVariable ["WC_AlertTime", time];

// Got hit function.
_fnc_got_hit = {
	private ["_got_hit"];

	_got_hit = false;

	// Check if any crew of vehicle were hit.
	{
		if (_x getVariable ["EH_GotHit", false]) exitWith {
			_got_hit = true;
		};
	} forEach crew _this;

	// Check if the vehicle was hit.
	if (_this getVariable ["EH_GotHit", false]) then {
		_got_hit = true;
	};

	_got_hit
};

while {_loop} do {
	// Get the commander of the vehicle.
	_leader = effectiveCommander _vehicle;

	// If no commander in the vehicle then we assume the vehicle is dead, and exit the loop.
	if (isNull _leader) exitWith {_loop = false};

	// If the vehicle was hit then put on alert and change mission to search.
	if (_got_hit) then {
		_vehicle setVariable ["EH_GotHit", false];

		{
			_x setVariable ["EH_GotHit", false];
		} forEach units _group;

		_group setVariable ["WC_AlertTime", time + 300];

		_alert = true;
		_got_hit = false;
		_mission = "SEARCH";
	} else {
		_mission = "PATROL";
	};

	/*
		Check for a target.
		If there is a target then change mission to attack.
	*/
	_target = _leader findNearestEnemy _leader;
	if (!isNull _leader) then {
		_old_target = _target;
		_mission = "ATTACK";
	};

	switch (_mission) do {
		case "PATROL": {
			// If on alert then check if enough time has passed to take off alert.
			if (_alert) then {
				_alert_time = _group getVariable ["WC_AlertTime", 0];
				if (time > _alert_time) then {
					_alert = false;
				};
			};

			// Change behaviour, combatMode, and waypoint type if on alert or not.
			if (_alert) then {
				_behaviour = "AWARE";
				_combat_mode = "RED";

				_wp_type = ["MOVE","SAD"] call WC_fnc_selectRandom;
			} else {
				_behaviour = "SAFE";
				_combat_mode = "GREEN";

				_wp_type = "MOVE";
			};

			_wp_speed = "FULL";

			// Get a position on the sea to goto.
			_position = [wcmapbottomleft, wcmaptopright, "onsea"] call WC_fnc_createposition;

			// Reset doWatch.
			{
				_x doWatch objNull;
			} forEach units _group;
		};

		// Vehicle has a target to attack.
		case "ATTACK": {
			_behaviour = "COMBAT";
			_combat_mode = "RED";

			_wp_type = "SAD";
			_wp_speed = "NORMAL";

			/*
				Get the known position of the target.
				If no position was return then just set a position on the target.
			*/
			_position = _leader getHideFrom _target;
			if (count _position == 0) then {
				_position = getPos _target;
			};

			{
				_x doWatch _position;
			} forEach units _group;
		};

		// No target but vehicle was hit.
		case "SEARCH": {
			_behaviour = "COMBAT";
			_combat_mode = "RED";

			_wp_type = "SAD";
			_wp_speed = "NORMAL";

			// Make sure hit position has an position.
			if (count _got_hit_pos == 0) then {
				_got_hit_pos = getPos _vehicle;
			};

			_position = _got_hit_pos;

			{
				_x doWatch objNull;
			} forEach units _group;
		};
	};

	#ifdef DEBUG_CHAT
		player globalChat format ["SP %1: vehicle=%2 : mission=%3 : pos=%4 : behaviour=%5 : combatmode=%6 : wptype=%7 : wpspeed=%8", _index, _veh_name, _mission, _position, _behaviour, _combat_mode, _wp_type, _wp_speed];
	#endif

	_wp = _group addWaypoint [_position, 0];
	_wp setWaypointPosition [_position, 0];
	_wp setWaypointType _wp_type;
	_wp setWaypointSpeed _wp_speed;

	_group setBehaviour _behaviour;
	_group setCombatMode _combat_mode;

	_move = true;

	// Movement loop.
	while {_move} do {
		sleep MAIN_LOOP_CYCLE;

		/*
			Get the commander of the vehicle.
			If no commander then exit the loop.
		*/
		_leader = effectiveCommander _vehicle;
		if (isNull _leader) then {
			_move = false;

			#ifdef DEBUG_CHAT
				player globalChat format ["SP %1: vehicle=%2 : leader=%3", _index, [_vehicle] call WC_fnc_getDisplayName, _leader];
			#endif
		} else {
			// Check if the vehicle is still alive and has enough fuel.
			if (!alive _vehicle || {!canMove _vehicle} || {fuel _vehicle <= 0.05}) then {
				_move = false;

				#ifdef DEBUG_CHAT
					player globalChat format ["SP %1: vehicle=%2 : loop=%3 : move=%4 : alive=%5 : canmove=%6 : fuel=%7", _index, _veh_name, _loop, _move, alive _vehicle, canMove _vehicle, fuel _vehicle];
				#endif
			} else {
				// Find nearest enemy.
				_target = _leader findNearestEnemy _leader;

				// Handle patrol based on mission type.
				switch (_mission) do {
					case "ATTACK": {
						/*
							If the current target is alive then check if the target has changed,
							If no target then check if the patrol is ready to move.
						*/
						if (!isNull _target && {alive _target}) then {
							if (_old_target != _target) then {
								_move = false;

								#ifdef DEBUG_CHAT
									player globalChat format ["SP %1: vehicle=%2 : target=%3 : oldtarget=%4", _index, _veh_name, _target, _old_target];
								#endif
							};
						} else {
							if ([_vehicle] call WC_fnc_vehicleReady) then {
								_move = false;

								#ifdef DEBUG_CHAT
									player globalChat format ["SP %1: vehicle=%2 : ready", _index, _veh_name];
								#endif
							};
						};
					};

					default {
						// Check if any targets are around.
						if (!isNull _target) then {
							_move = false;

							#ifdef DEBUG_CHAT
								player globalChat format ["SP %1: vehicle=%2 : targets alert", _index, _veh_name];
							#endif
						} else {
							// Check if vehicle or crew was hit.
							if (_vehicle call _fnc_got_hit) then {
								_move = false;

								_got_hit_pos = getPos _vehicle;
								_got_hit = true;

								#ifdef DEBUG_CHAT
									player globalChat format ["SP %1: vehicle=%2 : gothit=%3 : gothitpos=%4", _index, _veh_name, _got_hit, _got_hit_pos];
								#endif
							} else {
								// If the vehicle is ready then we assume it is done with it's last task.
								if ([_vehicle] call WC_fnc_vehicleReady) then {
									_move = false;

									#ifdef DEBUG_CHAT
										player globalChat format ["SP %1: vehicle=%2 : ready", _index, _veh_name];
									#endif
								};
							};
						};
					};
				};
			};
		};
	};

	deleteWaypoint _wp;

	// If the vehicle is stil alive, and still crewed then refuel it.
	if (alive _vehicle && {canMove _vehicle} && {{alive _x} count crew _vehicle > 0}) then {
		_vehicle setFuel 1;
	} else {_loop = false};
};

sleep wctimetorespawnvehicle;

{
	[_x] call WC_fnc_deleteObject;
} forEach units _group;

[_vehicle] call WC_fnc_deleteObject;
