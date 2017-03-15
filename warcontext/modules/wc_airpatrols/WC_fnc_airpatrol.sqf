/*
	Author: Neumatic
	Description: Handles plane or helicopter air patrols in both marker area
	zone or map wide patrols.

	Parameter(s):
		0: [Object] Vehicle
		1: [Group] Vehicles group

	Optional parameter(s):
		2: [Bool] Patrol type

	Example(s):
		[_vehicle, _group, true] spawn WC_fnc_airpatrol;

	Returns:
		nil
*/

// Uncomment for debug chat.
//#define DEBUG_CHAT

#define MAIN_LOOP_CYCLE 10

private [
	"_vehicle", "_group", "_patrol", "_alert", "_got_hit", "_loop", "_marker", "_mission", "_old_target", "_return_pos",
	"_respawn_west", "_target", "_index", "_veh_name", "_pilot", "_alt", "_fnc_got_hit", "_fnc_alive", "_get_marker_pos",
	"_get_location_pos", "_alert_time", "_behaviour", "_combat_mode", "_wp_type", "_wp_speed", "_run", "_count",
	"_min_dist", "_position", "_sleep", "_roads", "_location", "_got_hit_pos", "_wp", "_move"
];

_vehicle = _this select 0;
_group   = _this select 1;
_patrol  = if (count _this > 2) then {_this select 2} else {true};

// Set some variables.
_alert = false;
_got_hit = false;
_loop = true;
_marker = "airzone";
_mission = "PATROL";
_old_target = objNull;
_return_pos = [wcmaptopright,wcmapbottomleft,wcmaptopleft] call WC_fnc_selectRandom;
_respawn_west = getMarkerPos "respawn_west";
_target = objNull;

// If debug then get the index of the patrol.
#ifdef DEBUG_CHAT
	_index = (count WC_AirPatrols) + 1; _veh_name = [_vehicle] call WC_fnc_getDisplayName;
#endif

// Set alert time variable.
_group setVariable ["WC_AlertTime", time];

// Get the driver of the vehicle.
_pilot = driver _vehicle;

// Set vehicle altitude depending on vehicle type.
if (_vehicle isKindOf "Plane") then {
	_alt = 300 + round (random 50);
} else {
	_alt = 100 + round (random 50);
};

_vehicle flyInHeight _alt;

// Got hit function.
_fnc_got_hit = {
	private ["_got_hit"];

	_got_hit = false;

	// Check if any units in crew were hit.
	{
		if (_x getVariable ["EH_GotHit", false]) then {
			_got_hit = true;
		};
	} forEach crew _this;

	// Check if the vehicle was hit.
	if (_this getVariable ["EH_GotHit", false]) then {
		_got_hit = true;
	};

	_got_hit
};

// Vehicle alive function.
_fnc_alive = {
	private ["_alive"];

	_alive = true;

	if (!alive driver _this) then {
		_alive = false;
	} else {
		if (!alive _this) then {
			_alive = false;
		} else {
			if (!canMove _this) then {
				_alive = false;
			} else {
				if (fuel _this <= 0.05) then {
					_alive = false;
				};
			};
		};
	};

	_alive
};

// Main loop.
while {_loop} do {
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
	_target = _pilot findNearestEnemy _pilot;
	if (!isNull _target) then {
		_old_target = _target;
		_mission = "ATTACK";
	};

	switch (_mission) do {
		case "PATROL": {
			_get_marker_pos = false;
			_get_location_pos = false;

			// If true then we patrol in the marker zone.
			if (_patrol) then {
				/*
					Check if the marker still exists.
					If not we send the vehicle to a random town location.
				*/
				if (getMarkerColor _marker != "") then {
					_get_marker_pos = true;
				} else {
					_get_location_pos = true;
				};
			} else {
				_get_location_pos = true;
			};

			// If on alert then check if enough time has passed to take off alert.
			if (_alert) then {
				_alert_time = _group getVariable ["WC_AlertTime", 0];
				if (time > _alert_time) then {
					_alert = false;
				};
			};

			// If on alert put group on into combat.
			if (_alert) then {
				_behaviour = "COMBAT";
				_combat_mode = "RED";

				_wp_type = ["MOVE","SAD"] call WC_fnc_selectRandom;
			} else {
				// If radio is alive then change group behaviour based on alert level.
				if (wcradioalive) then {
					if (wcalert > 66) then {
						_behaviour = "AWARE";
						_combat_mode = "RED";

						_wp_type = ["MOVE","SAD"] call WC_fnc_selectRandom;
					} else {
						if (wcalert > 33) then {
							_behaviour = "AWARE";
							_combat_mode = "YELLOW";

							_wp_type = "MOVE";
						} else {
							_behaviour = "SAFE";
							_combat_mode = "WHITE";

							_wp_type = "MOVE";
						};
					};
				} else {
					_behaviour = "SAFE";
					_combat_mode = "WHITE";

					_wp_type = "MOVE";
				};
			};

			// Change waypoint speed depending on waypoint type and vehicle type.
			switch (_wp_type) do {
				case "MOVE": {
					_wp_speed = "NORMAL";
				};

				case "SAD": {
					if (_vehicle isKindOf "Helicopter") then {
						if (_get_marker_pos) then {
							_wp_speed = "LIMITED";
						} else {
							_wp_speed = "NORMAL";
						};
					} else {
						_wp_speed = "NORMAL";
					};
				};
			};

			_run = true;

			// Get a position inside the patrol marker.
			if (_get_marker_pos) then {
				_count = 0;

				_min_dist = ([_marker] call WC_fnc_getMarkerSize) * 0.5;

				// Try to get a position on a road to goto.
				while {_run} do {
					_position = [_marker, "onground"] call WC_fnc_createpositioninmarker;
					_sleep = false;

					if (_vehicle distance _position > _min_dist) then {
						if (_count <= 3) then {
							_roads = _position nearRoads 100;
							if (count _roads > 0) then {
								_position = getPos (_roads call WC_fnc_selectRandom);
								_run = false;
							} else {_sleep = true};
						} else {_run = false};
					} else {_sleep = true};

					if (_sleep) then {_count = _count + 1; sleep 0.1};
				};
			};

			// Get a random town location position.
			if (_get_location_pos) then {
				while {_run} do {
					_location = position (wctownlocations call WC_fnc_selectRandom);
					_position = [(_location select 0) + ([0, 500] call WC_fnc_seed), (_location select 1) + ([0, 500] call WC_fnc_seed), 0];

					if (_vehicle distance _position > 1000 && {_position distance _respawn_west > 1000}) then {
						_run = false;
					} else {sleep 0.1};
				};
			};

			// Reset doWatch.
			{
				_x doWatch objNull;
			} forEach units _group;
		};

		// Pilot has a target to attack.
		case "ATTACK": {
			_behaviour = "COMBAT";
			_combat_mode = "RED";

			_wp_type = "SAD";

			// Change waypoint speed depending on target type, and vehicle type.
			if (_target isKindOf "Air") then {
				_wp_speed = "NORMAL";
			} else {
				if (_vehicle isKindOf "Helicopter") then {
					_wp_speed = "LIMITED";
				} else {
					_wp_speed = "NORMAL";
				};
			};

			/*
				Get the known position of the target.
				If no position was return then just set a position on the target.
			*/
			_position = _pilot getHideFrom _target;
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

			// Change waypoint speed depending on vehicle type.
			if (_vehicle isKindOf "Helicopter") then {
				_wp_speed = "LIMITED";
			} else {
				_wp_speed = "NORMAL";
			};

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
		player globalChat format ["AP %1: vehicle=%2 : mission=%3 : pos=%4 : behaviour=%5 : combatmode=%6 : wptype=%7 : wpspeed=%8", _index, _veh_name, _mission, _position, _behaviour, _combat_mode, _wp_type, _wp_speed];
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

		// Check if the vehicle is still alive and has enough fuel.
		if (_vehicle call _fnc_alive) then {
			// Find nearest target.
			_target = _pilot findNearestEnemy _pilot;

			// Handle patrol based on mission type.
			switch (_mission) do {
				case "ATTACK": {
					/*
						If the current target is alive then check if the target has changed.
						If no target then check if the patrol is ready to move.
					*/
					if (!isNull _target && {alive _target}) then {
						if (_old_target != _target) then {
							_move = false;

							#ifdef DEBUG_CHAT
								player globalChat format ["AP %1: vehicle=%2 : target=%3 : oldtarget=%4", _index, _veh_name, _target, _old_target];
							#endif
						};
					} else {
						if ([_vehicle] call WC_fnc_vehicleReady) then {
							_move = false;

							#ifdef DEBUG_CHAT
								player globalChat format ["AP %1: vehicle=%2 : ready", _index, _veh_name];
							#endif
						};
					};
				};

				default {
					// Check for a target.
					if (!isNull _target) then {
						_move = false;

						#ifdef DEBUG_CHAT
							player globalChat format ["AP %1: vehicle=%2 : new target %3", _index, _veh_name, [_target] call WC_fnc_getDisplayName];
						#endif
					} else {
						// Was the patrol hit?
						if (_vehicle call _fnc_got_hit) then {
							_move = false;

							_got_hit_pos = getPos _vehicle;
							_got_hit = true;

							#ifdef DEBUG_CHAT
								player globalChat format ["AP %1: vehicle=%2 : gothit=%3 : gothitpos=%4", _index, _veh_name, _got_hit, _got_hit_pos];
							#endif
						} else {
							// Patrol is ready to move.
							if ([_vehicle] call WC_fnc_vehicleReady) then {
								_move = false;

								#ifdef DEBUG_CHAT
									player globalChat format ["AP %1: vehicle=%2 : ready", _index, _veh_name];
								#endif
							};
						};
					};
				};
			};
		} else {
			_loop = false;
			_move = false;

			#ifdef DEBUG_CHAT
				player globalChat format ["AP %1: vehicle=%2 : loop=%3 : move=%4 : pilot=%5 : alive=%6 : canmove=%7 : fuel=%8", _index, _veh_name, _loop, _move, alive _pilot, alive _vehicle, canMove _vehicle, fuel _vehicle];
			#endif

		};
	};

	deleteWaypoint _wp;
};

#ifdef DEBUG_CHAT
	player globalChat format ["AP %1: vehicle=%2 : exiting loop", _index, _veh_name];
#endif

// Send the vehicle away to be deleted.
{
	_x doMove _return_pos;
} forEach units _group;

sleep wctimetorespawnvehicle;

{
	[_x] call WC_fnc_deleteObject;
} forEach units _group;

[_vehicle] call WC_fnc_deleteObject;
