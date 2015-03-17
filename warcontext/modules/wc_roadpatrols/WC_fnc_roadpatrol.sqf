/*
	Author: Neumatic
	Description: Handles the entire road patrol convoys movement and combat.

	Parameter(s):
		0: [Group] Patrol group
		1: [Array] Array of vehicles

	Example(s):
		[_group, [_vehicle_0, _vehicle_1]] spawn WC_fnc_roadpatrol;

	Returns:
		nil
*/

// Uncomment for debug chat.
//#define DEBUG_CHAT

#define MAIN_LOOP_CYCLE 20

private [
	"_group", "_vehicles", "_alert", "_convoy_vehs", "_exit", "_got_hit", "_loop", "_mission", "_respawn_west",
	"_stuck_check", "_stuck_count", "_turret_vehs", "_wp_form", "_vehicle", "_start_pos", "_index", "_leader",
	"_fnc_got_hit", "_unit", "_old_target", "_target", "_alert_time", "_behaviour", "_combat_mode", "_wp_type",
	"_wp_speed", "_town_pos", "_run", "_sleep", "_position", "_roads", "_object", "_got_hit_pos", "_wp", "_move",
	"_curr_pos", "_veh_name"
];

_group    = _this select 0;
_vehicles = _this select 1;

_alert = false;
_convoy_vehs = [];
_exit = false;
_got_hit = false;
_loop = true;
_mission = "PATROL";
_respawn_west = getMarkerPos "respawn_west";
_stuck_check = true;
_stuck_count = 0;
_turret_vehs = [];
_wp_form = "COLUMN";

// Get the first vehicle of the vehicles array.
_vehicle = _vehicles select 0;
_start_pos = getPos _vehicle;

// Set some variables for the vehicle.
_group setVariable ["WC_AlertTime", time];
_group setVariable ["WC_TownPos", getPos _vehicle];

// If debug then get the index of the patrol.
#ifdef DEBUG_CHAT
	_index = (count WC_RoadConvoys) + 1;
#endif

// Sort vehicles, and add to arrays.
{
	if (count (configFile >> "CfgVehicles" >> typeOf _x >> "Turrets") > 0) then {
		_turret_vehs set [count _turret_vehs, _x];
	} else {
		_convoy_vehs set [count _convoy_vehs, _x];
	};
} forEach _vehicles;

// Get the commander of the lead vehicle and set commander as group leader.
_leader = effectiveCommander _vehicle;
_group selectLeader _leader;

// Got hit function.
_fnc_got_hit = {
	private ["_got_hit", "_vehicle"];

	_got_hit = false;

	// Check if any vehicles or crew members were hit.
	{
		_vehicle = _x;

		if (_vehicle getVariable ["EH_GotHit", false]) then {
			_got_hit = true;
		};

		{
			if (_x getVariable ["EH_GotHit", false]) exitWith {
				_got_hit = true;
			};
		} forEach crew _vehicle;

		if (_got_hit) exitWith {};
	} forEach _this;

	_got_hit
};

// Main loop.
while {_loop} do {
	// If there are units outside of their vehicle then we assume their vehicle is dead.
	{
		_unit = _x;
		if (vehicle _unit == _unit) then {
			if ({_unit distance _x < 500} count ([] call BIS_fnc_listPlayers) == 0) then {
				[_unit] call WC_fnc_deleteObject;
			};
		};
	} forEach units _group;

	// Get the commander of the lead vehicle.
	_leader = effectiveCommander _vehicle;

	// If no commander in the lead vehicle then we assume the lead vehicle is dead.
	if (isNull _leader) then {
		_vehicle = objNull;

		// Get a new lead vehicle with a turret.
		{
			if (alive _x && {canMove _x} && {!isNull effectiveCommander _x} && {alive effectiveCommander _x}) exitWith {
				_vehicle = _x;
			};
		} forEach _turret_vehs;

		// If there is a new lead vehicle then set variables and get the commander of the lead vehicle.
		if (!isNull _vehicle) then {
			_group setVariable ["WC_TownPos", getPos _vehicle];
			_group setVariable ["WC_AlertTime", time];

			_leader = effectiveCommander _vehicle;
		} else {
			_exit = true;
		};
	};

	// If no lead vehicle then exit the loop.
	if (_exit) exitWith {_loop = false};

	// If any vehicle in the convoy were hit then put group on alert and change mission to search.
	if (_got_hit) then {
		{
			_x setVariable ["EH_GotHit", false];
		} forEach _vehicles;

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
	if (!isNull _target) then {
		_old_target = _target;
		_mission = "ATTACK";
	};

	switch (_mission) do {
		case "PATROL": {
			// If on alert then check if enough time has passed to take convoy off alert.
			if (_alert) then {
				_alert_time = _group getVariable ["WC_AlertTime", 0];
				if (time > _alert_time) then {
					_alert = false;
				};
			};

			// Change behaviour, and combatMode based on if on alert or not.
			if (_alert) then {
				_behaviour = "AWARE";
				_combat_mode = "RED";
			} else {
				_behaviour = "SAFE";
				_combat_mode = "GREEN";
			};

			_wp_type = "MOVE";
			_wp_speed = "NORMAL";

			/*
				Check if lead vehicle is near the destination position.
				If so then get a new town position to goto.
			*/
			_town_pos = _group getVariable ["WC_TownPos", getPos _vehicle];
			if (_vehicle distance _town_pos <= 20) then {
				_run = true;
				_sleep = false;

				// Get a road position in a random town location to goto.
				while {_run} do {
					_position = position (wctownlocations call WC_fnc_selectRandom);

					if (_vehicle distance _position > 1000 && {_position distance _respawn_west > 1000}) then {
						_roads = _position nearRoads 300;
						if (count _roads > 0) then {
							_position = getPos (_roads call WC_fnc_selectRandom);
							_run = false;
						} else {_sleep = true};
					} else {_sleep = true};

					if (_sleep) then {sleep 0.1};
				};

				_group setVariable ["WC_TownPos", _position];
			} else {
				_position = _town_pos;
			};

			// Reset doWatch.
			{
				_x doWatch objNull;
			} forEach units _group;

			// Get all turrets in convoy to align with their vehicle.
			{
				_object = _x;
				{
					if (!isNull _x && {alive _x}) then {
						_x setFormDir (getDir _object);
					};
				} forEach [commander _object, gunner _object];
				sleep 0.01;
			} forEach _turret_vehs;
		};

		// Convoy has a target to attack.
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
				_object = _x;
				{
					if (!isNull _x && {alive _x}) then {
						_x doWatch _position;
					};
				} forEach [commander _object, gunner _object];
				sleep 0.01;
			} forEach _turret_vehs;
		};

		// No target but vehicle in convoy was hit.
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

			// Reset doWatch.
			{
				_x doWatch objNull;
			} forEach units _group;
		};
	};

	#ifdef DEBUG_CHAT
		player globalChat format ["RP %1: vehicle=%2 : mission=%3 : pos=%4 : behaviour=%5 : combatmode=%6 : wptype=%7 : wpspeed=%8", _index, [_vehicle] call WC_fnc_getDisplayName, _mission, _position, _behaviour, _combat_mode, _wp_type, _wp_speed];
	#endif

	_wp = _group addWaypoint [_position, 0];
	_wp setWaypointPosition [_position, 0];
	_wp setWaypointStatements ["true", "(group this) setVariable ['WC_WP_Completed', true]"];
	_wp setWaypointCompletionRadius 5;
	_wp setWaypointFormation _wp_form;
	_wp setWaypointType _wp_type;
	_wp setWaypointSpeed _wp_speed;

	_group setBehaviour _behaviour;
	_group setCombatMode _combat_mode;

	_move = true;

	// Movement loop.
	while {_move} do {
		sleep MAIN_LOOP_CYCLE;

		// Get the current position of the lead vehicle.
		_curr_pos = getPos _vehicle;

		/*
			Get the commander of the lead vehicle.
			If no commander then exit the loop to find a new lead vehicle.
		*/
		_leader = effectiveCommander _vehicle;
		if (isNull _leader) then {
			_move = false;

			#ifdef DEBUG_CHAT
				player globalChat format ["RP %1: vehicle=%2 : leader=%3", _index, [_vehicle] call WC_fnc_getDisplayName, _leader];
			#endif
		} else {
			// Check if the lead vehicle is still alive, and has a commander.
			if (!alive _vehicle || {!canMove _vehicle} || {isNull effectiveCommander _vehicle} || {!alive effectiveCommander _vehicle}) then {
				_move = false;

				#ifdef DEBUG_CHAT
					player globalChat format ["RP %1: vehicle=%2 : loop=%3 : move=%4 : alive=%5 : canmove=%6 : fuel=%7", _index, [_vehicle] call WC_fnc_getDisplayName, _loop, _move, alive _vehicle, canMove _vehicle, fuel _vehicle];
				#endif
			} else {
				// Find nearest target.
				_target = _leader findNearestEnemy _leader;

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
						// Check if any targets are around.
						if (!isNull _target) then {
							_move = false;

							#ifdef DEBUG_CHAT
								player globalChat format ["AP %1: vehicle=%2 : targets alert", _index, _veh_name];
							#endif
						} else {
							// Was the patrol hit?
							if (_vehicles call _fnc_got_hit) then {
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
			};
		};

		// Check if the lead vehicle has moved from when it was spawned. If not then we exit the loop.
		if (_stuck_check) then {
			if (_vehicle distance _start_pos < 10) then {
				_stuck_count = _stuck_count + 1;

				if (_stuck_count >= 9) then {
					_move = false;
					_exit = true;
				};
			} else {
				_stuck_check = false;
			};
		};
	};

	if (_exit) exitWith {_loop = false};

	deleteWaypoint _wp;

	// Refuel vehicles of convoy if still alive, and has a commander.
	{
		if (alive _x && {canMove _x} && {!isNull effectiveCommander _x} && {alive effectiveCommander _x}) then {
			_x setFuel 1;
		};
	} forEach _vehicles;
};

#ifdef DEBUG_CHAT
	player globalChat format ["RP %1: exiting the loop", _index];
#endif

sleep wctimetorespawnvehicle;

// If there are vehicles in the group or units in the group still alive then check if players are around.
if ({alive _x} count _vehicles > 0 || {alive _x} count units _group > 0) then {
	if ({_x distance _curr_pos < 500} count ([] call BIS_fnc_listPlayers) > 0) then {
		_run = true;

		// If players around around then wait.
		while {_run} do {
			if ({alive _x} count _vehicles > 0 || {alive _x} count units _group > 0) then {
				if ({_x distance _curr_pos < 500} count ([] call BIS_fnc_listPlayers) == 0) then {
					_run = false;
				} else {sleep 60};
			} else {_run = false};
		};
	};
};

{
	[_x] call WC_fnc_deleteObject;
} forEach _vehicles;

{
	[_x] call WC_fnc_deleteObject;
} forEach units _group;
