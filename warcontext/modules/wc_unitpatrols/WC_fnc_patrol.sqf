/*
	Author: Neumatic
	Description: Handles an infantry patrol in a marker zone area. Can be set
	up to leave or stay inside the marker zone to chase enemies.

	Parameter(s):
		0: [Group] Patrol group
		1: [Array] Position from patrol
		2: [Number] Size of marker area

	Optional parameter(s):
		2: [Bool] Pursue spotted enemy

	Example(s):
		[_group, getPos (leader _group), true] spawn WC_fnc_patrol;

	Returns:
		nil
*/

// Uncomment for debug chat.
//#define DEBUG_CHAT

// Loop sleep time.
#define MAIN_LOOP_CYCLE 20

// Ready distances.
#define READY_DISTANCE_INF 5
#define READY_DISTANCE_VEH 10

#define GROUP_FORMATIONS ["STAG COLUMN","WEDGE","ECH LEFT","ECH RIGHT","VEE","LINE"]

#define MACHINE_GUNS [ \
	"PK","RPK_74","ACE_RPK","ACE_RPK74M","ACE_RPK74M_1P29","Pecheneg","PK","ACE_PKT_out","ACE_PKT_out","ACE_PKT_out_3", \
	"M60A4_EP1","ACE_M60","m8_SAW","M240","m240_scoped_EP1","ACE_M240B","ACE_M240L","ACE_M240L_M145","M249","ACE_M249_AIM", \
	"M249_EP1","M249_m145_EP1","M249_TWS_EP1","ACE_M249_PIP_ACOG","Mk_48","Mk_48_DES_EP1","BAF_L7A2_GPMG","ACE_BAF_L7A2_GPMG", \
	"MG36","ACE_MG36","ACE_MG36_D","MG36_camo","BWMod_MG3","BWMod_MG4","BWMod_MG4_Scope" \
]

private [
	"_group", "_position", "_area_size", "_pursue", "_alert", "_dead_bodies", "_formation", "_got_hit", "_loop", "_mission",
	"_wp_type", "_marker", "_marker_size", "_marker_pos", "_min_dist", "_index", "_radio", "_knows", "_fnc_got_hit",
	"_leader", "_near_objects", "_old_target", "_target", "_alert_time", "_behaviour", "_combat_mode", "_wp_form", "_wp_speed",
	"_unit_pos", "_count", "_run", "_target_pos", "_distance", "_temp_pos", "_got_hit_pos", "_wp", "_move", "_veh_name"
];

_group     = _this select 0;
_position  = _this select 1;
_area_size = _this select 2;
_pursue    = if (count _this > 3) then {_this select 3} else {true};

// Something went wrong so exit.
if ({alive _x} count units _group == 0) exitWith {};

// Set some variables.
_alert = false;
_dead_bodies = [];
_formation = GROUP_FORMATIONS call WC_fnc_selectRandom;
_got_hit = false;
_loop = true;
_mission = "PATROL";
_wp_type = "HOLD";

// Create the patrols marker.
_marker = [format ["patrolzone%1", wcpatrolindex], _position, _area_size, "ColorRed", "ELLIPSE", "Border", "", 0, "", WC_MarkerAlpha] call WC_fnc_createmarkerlocal;
wcpatrolgroups = wcpatrolgroups + [_group];
wcpatrolindex = wcpatrolindex + 1;

// Get some info from the marker.
_marker_size = [_marker] call WC_fnc_getMarkerSize;
_marker_pos = getMarkerPos _marker;
_min_dist = _marker_size * 0.5;

// If debug then get the index of the patrol.
#ifdef DEBUG_CHAT
	_index = (count wcpatrolgroups) + 1;
#endif

// Set some variables for the group.
_group setVariable ["WC_AlertTime", time];
_group setVariable ["WC_Waiting", time];

// If the group is east then check radio status.
switch (side _group) do {
	case east: {
		_radio = true;
	};

	case west: {
		_radio = false;
	};
};

// Current knows variable.
_knows = (WC_KnowsAbout + 2) - (wcskill * 2);

// Got hit function.
_fnc_got_hit = {
	private ["_got_hit"];

	_got_hit = false;

	// Check if anyone in the group was hit.
	{
		if (_x getVariable ["EH_GotHit", false]) exitWith {
			_got_hit = true;
		};
	} forEach units _this;

	_got_hit
};

// Main loop.
while {_loop} do {
	// If no more units left alive in the group then exit the loop.
	if ({alive _x} count units _group == 0) exitWith {_loop = false};

	_leader = leader _group;

	// Check if the leader of the group is too wounded to lead.
	if (!canStand _leader) then {
		{
			if (alive _x && {canStand _x}) exitWith {
				_group selectLeader _x;
			};
		} forEach units _group;
	};

	_leader = leader _group;

	// Make units pull back out their main weapon.
	if (_wp_type == "SENTRY") then {
		{
			if (vehicle _x == _x) then {
				_x selectWeapon (primaryWeapon _x);
			};
		} forEach units _group;
	};

	// If a unit in the group was hit then put group on alert and change mission to search.
	if (_got_hit) then {
		{
			_x setVariable ["EH_GotHit", false];
		} forEach units _group;

		_group setVariable ["WC_AlertTime", time + 300];

		_alert = true;
		_got_hit = false;
		_mission = "SEARCH";
	} else {
		_dead_bodies = [];

		// Check if any dead bodies are nearby that the leader knowsAbout.
		_near_objects = nearestObjects [getPos _leader, ["CAManBase"], 60];
		{
			if (!alive _x && {_leader knowsAbout _x > _knows}) then {
				_dead_bodies set [count _dead_bodies, _x];
			};
		} forEach _near_objects;

		// If there are dead bodies around then put the group on alert if not then the mission is patrol.
		if (count _dead_bodies > 0) then {
			_group setVariable ["WC_AlertTime", time + 300];

			_alert = true;
			_mission = "SEARCH";
		} else {
			_mission = "PATROL";
		};
	};

	/*
		Check for a target.
		If there is a target then change mission to attack.
	*/
	_target = _leader findNearestEnemy _leader;
	if (!isNull _target) then {
		_old_target = _target;
		_mission = "ATTACK";
	};

	switch (_mission) do {
		case "PATROL": {
			// If on alert then check if enough time has passed to take group off alert.
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

				_wp_type = ["MOVE","SENTRY"] call WC_fnc_selectRandom;
				_wp_form = _formation;
				_wp_speed = "NORMAL";

				_unit_pos = "AUTO";
			} else {
				// If side east, and radio is alive then change group behaviour based on alert level.
				if (_radio) then {
					if (wcradioalive) then {
						if (wcalert > 66) then {
							_behaviour = "AWARE";
							_combat_mode = "RED";

							_wp_type = ["MOVE","SENTRY"] call WC_fnc_selectRandom;
							_wp_form = _formation;
							_wp_speed = "NORMAL";

							_unit_pos = "AUTO";
						} else {
							if (wcalert > 33) then {
								_behaviour = "AWARE";
								_combat_mode = "YELLOW";

								_wp_type = "MOVE";
								_wp_form = "COLUMN";
								_wp_speed = "LIMITED";

								_unit_pos = "UP";
							} else {
								_behaviour = "SAFE";
								_combat_mode = "WHITE";

								_wp_type = "MOVE";
								_wp_form = "COLUMN";
								_wp_speed = "LIMITED";

								_unit_pos = "UP";
							};
						};
					} else {
						_behaviour = "SAFE";
						_combat_mode = "WHITE";

						_wp_type = "MOVE";
						_wp_form = "COLUMN";
						_wp_speed = "LIMITED";

						_unit_pos = "UP";
					};
				} else {
					_behaviour = "SAFE";
					_combat_mode = "WHITE";

					_wp_type = "MOVE";
					_wp_form = "COLUMN";
					_wp_speed = "LIMITED";

					_unit_pos = "UP";
				};
			};

			_count = 0;
			_run = true;

			// Get a position in the marker.
			while {_run} do {
				_position = [_marker, "onground"] call WC_fnc_createpositioninmarker;

				if (_leader distance _position > _min_dist) then {
					_run = false;
				} else {
					if (_count > 3) then {
						_run = false;
					} else {
						sleep 0.1
					};
				};
			};

			// Set waiting variable.
			_group setVariable ["WC_Waiting", time + round (random 180)];

			// Change unitPos, and reset doWatch.
			{
				if (vehicle _x == _x) then {
					_x setUnitPos _unit_pos;
				};

				_x doWatch objNull;
			} forEach units _group;
		};

		// Group has a target to attack.
		case "ATTACK": {
			_behaviour = "COMBAT";
			_combat_mode = "RED";

			_wp_form = _formation;

			/*
				Get the known position of the target.
				If no position was returned then just set a position on the target.
			*/
			_target_pos = _leader getHideFrom _target;
			if (count _target_pos == 0) then {
				_target_pos = getPos _target;
			};

			/*
				If true then pursue spotted enemy.
				If false then try to keep the group in marker.
			*/
			if (_pursue) then {
				_wp_type = "SAD";

				// Change unitPos, and waypoint speed based on distance from target.
				if (_leader distance _target_pos > 100) then {
					_wp_speed = "FULL";
					_unit_pos = "AUTO";
				} else {
					_wp_speed = "NORMAL";
					_unit_pos = "MIDDLE";
				};

				_position = _target_pos;
			} else {
				// If the target position is in the marker then we can still pursue the enemy.
				if (_marker_pos distance _target_pos < _marker_size) then {
					_wp_type = "SAD";

					// Change unitPos, and waypoint speed based on distance from target.
					if (_leader distance _target_pos > 100) then {
						_wp_speed = "FULL";
						_unit_pos = "AUTO";
					} else {
						_wp_speed = "NORMAL";
						_unit_pos = "MIDDLE";
					};

					_position = _target_pos;
				} else {
					_wp_type = "HOLD";

					_wp_speed = "NORMAL";
					_unit_pos = "MIDDLE";

					_distance = 100000;

					// Try to get a position near the direction of the target position.
					_temp_pos = [_marker_pos, _marker_size, 360, 0, 12] call WC_fnc_createcircleposition;
					{
						if (_x distance _target_pos < _distance) then {
							_distance = _x distance _target_pos;
							_position = _x;
						};
					} forEach _temp_pos;
				};
			};

			// Set waiting variable.
			_group setVariable ["WC_Waiting", time + 300];

			// Change unitPos, and doWatch the position.
			{
				if (vehicle _x == _x) then {
					_x setUnitPos _unit_pos;
				};

				_x doWatch _target_pos;
			} forEach units _group;
		};

		// No target but either gotHit or dead bodies around.
		case "SEARCH": {
			_behaviour = "COMBAT";
			_combat_mode = "RED";

			_wp_type = "SAD";
			_wp_form = _formation;
			_wp_speed = "LIMITED";

			/*
				If gotHit then set position on hit position.
				Else set position on random dead body.
			*/
			if (_got_hit) then {
				// Make sure hit position has an position.
				if (count _got_hit_pos == 0) then {
					_got_hit_pos = getPos (leader _group);
				};

				_position = _got_hit_pos;
			} else {
				if (count _dead_bodies > 0) then {
					_position = getPos (_dead_bodies call WC_fnc_selectRandom);
				} else {
					_position = getPos (leader _group);
				};
			};

			// Set waiting variable.
			_group setVariable ["WC_Waiting", time + 300];

			// Change unitPos, and doWatch the position.
			{
				if (vehicle _x == _x) then {
					_x setUnitPos "MIDDLE";
				};

				_x doWatch objNull;
			} forEach units _group;
		};
	};

	#ifdef DEBUG_CHAT
		player globalChat format ["PA %1: leader=%2 : mission=%3 : pos=%4 : behaviour=%5 : combatmode=%6 : wptype=%7 : wpformation=%8 : wpspeed=%9", _index, [_leader] call WC_fnc_getDisplayName, _mission, _position, _behaviour, _combat_mode, _wp_type, _wp_form, _wp_speed];
	#endif

	_wp = _group addWaypoint [_position, 0];
	_wp setWaypointPosition [_position, 0];
	_wp setWaypointStatements ["true", "(group this) setVariable ['WC_WP_Completed', true]"];
	_wp setWaypointCompletionRadius 2;
	_wp setWaypointType _wp_type;
	_wp setWaypointFormation _wp_form;
	_wp setWaypointSpeed _wp_speed;

	_group setBehaviour _behaviour;
	_group setCombatMode _combat_mode;

	_move = true;

	// Movement loop.
	while {_move} do {
		sleep MAIN_LOOP_CYCLE;

		_leader = leader _group;

		// If no leader then the group is likely dead then exit the loop.
		if (isNull _leader) then {
			_move = false;

			#ifdef DEBUG_CHAT
				player globalChat format ["PA %1: isnull=%2 : no leader", _index, isNull _leader];
			#endif
		} else {
			// Find nearest target.
			_target = _leader findNearestEnemy _leader;

			// Handle groups mission type.
			switch (_mission) do {
				case "PATROL": {
					// Check if any targets are around.
					if (!isNull _target) then {
						_move = false;

						#ifdef DEBUG_CHAT
							player globalChat format ["PA %1: leader=%2 : targets alert", _index, [_leader] call WC_fnc_getDisplayName];
						#endif
					} else {
						// If GotHit then exit the move loop.
						if (_group call _fnc_got_hit) then {
							_move = false;

							_got_hit_pos = getPos _leader;
							_got_hit = true;

							#ifdef DEBUG_CHAT
								player globalChat format ["PA %1: leader=%2 : gothit=%3 : gothitpos=%4", _index, [_leader] call WC_fnc_getDisplayName, _got_hit, _got_hit_pos];
							#endif
						} else {
							/*
								Check if the patrol has completed the waypoint.
								If at the waypoint then check if group is still waiting.
							*/
							if (_group getVariable ["WC_WP_Completed", false]) then {
								if (_group getVariable ["WC_Waiting", 0] < time) then {
									if (unitReady _leader) then {
										_move = false;

										#ifdef DEBUG_CHAT
											player globalChat format ["PA %1: leader=%2 : ready to move", _index, [_leader] call WC_fnc_getDisplayName];
										#endif
									};
								} else {
									if (unitReady _leader) then {
										{
											if (unitReady _x) then {
												switch (_wp_type) do {
													case "MOVE": {
														if (unitPos _x != "MIDDLE") then {
															_x setUnitPos "MIDDLE";
														};
													};

													case "SENTRY": {
														if (unitPos _x != "MIDDLE") then {
															_x setUnitPos "MIDDLE";
														};

														if (_x hasWeapon "Binocular") then {
															_x selectWeapon "Binocular";
														};
													};
												};
											};
										} forEach units _group;
									};
								};
							};
						};
					};
				};

				case "ATTACK": {
					/*
						If the current target is alive then check if the target has changed,
						If no target then check if the patrol is ready to move.
					*/
					if (!isNull _target && {alive _target}) then {
						if (_old_target != _target) exitWith {
							_move = false;

							#ifdef DEBUG_CHAT
								player globalChat format ["AP %1: vehicle=%2 : target=%3 : oldtarget=%4", _index, _veh_name, _target, _old_target];
							#endif
						} else {
							// If the target is a man then suppress the target.
							if (_target isKindOf "CAManBase") then {
								{
									if (vehicle _x == _x) then {
										if ((primaryWeapon _x) in MACHINE_GUNS && {random 1 < 0.3}) then {
											_x suppressFor 15;

											#ifdef DEBUG_CHAT
												player globalChat format ["PA %1: leader=%2 : unit=%3 : supressing", _index, [_leader] call WC_fnc_getDisplayName, [_x] call WC_fnc_getDisplayName];
											#endif
										};
									};
								} forEach units _group;
							};
						};
					} else {
						if (_group getVariable ["WC_WP_Completed", false]) then {
							if (_group getVariable ["WC_Waiting", 0] < time) then {
								_move = false;

								#ifdef DEBUG_CHAT
									player globalChat format ["PA %1: leader=%2 : ready to move", _index, [_leader] call WC_fnc_getDisplayName];
								#endif
							};
						};
					};
				};

				case "SEARCH": {
					// Check if any targets are around.
					if (!isNull _target) then {
						_move = false;

						#ifdef DEBUG_CHAT
							player globalChat format ["PA %1: leader=%2 : targets alert", _index, [_leader] call WC_fnc_getDisplayName];
						#endif
					} else {
						// If GotHit then exit the move loop.
						if (_group call _fnc_got_hit) then {
							_move = false;

							_got_hit_pos = getPos (vehicle _leader);
							_got_hit = true;


							#ifdef DEBUG_CHAT
								player globalChat format ["PA %1: leader=%2 : gothit=%3 : gothitpos=%4", _index, [_leader] call WC_fnc_getDisplayName, _got_hit, _got_hit_pos];
							#endif
						} else {
							/*
								Check if the patrol has completed the waypoint.
								If at the waypoint then check if group is still waiting.
							*/
							if (_group getVariable ["WC_WP_Completed", false]) then {
								if (_group getVariable ["WC_Waiting", 0] < time) then {
									if (unitReady _leader) then {
										_move = false;

										#ifdef DEBUG_CHAT
											player globalChat format ["PA %1: leader=%2 : ready to move", _index, [_leader] call WC_fnc_getDisplayName];
										#endif
									};
								};
							};
						};
					};
				};
			};
		};
	};

	deleteWaypoint _wp;
};

deleteMarkerLocal _marker;
wcpatrolgroups = wcpatrolgroups - [_group];
