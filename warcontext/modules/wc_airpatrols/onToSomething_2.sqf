private ["_MAIN_LOOP_CYCLE","_debug","_vehicle","_x","_flyInHeight","_marker","_targetPos","_mode","_target","_hitTime","_gotHit",
"_gotHitPos","_move","_pilot","_group","_knows","_targets","_targetsQuery","_unit","_knowsAbout","_distance","_behaviour","_combatMode",
"_speedMode","_count","_run","_sleep","_position","_roads"];

_MAIN_LOOP_CYCLE = 10;

_debug = false;
_respawn_west = getMarkerPos "respawn_west";

while {true} do {
	{
		_vehicle = _x;

		if (alive _vehicle) then {
			_flyInHeight = _vehicle getVariable "APflyInHeight";
			_marker = _vehicle getVariable "APmarker";
			_targetPos = _vehicle getVariable "APtargetPos";
			_mode = _vehicle getVariable "APmode";
			_target = _vehicle getVariable "APtarget";
			_hitTime = _vehicle getVariable "APhitTime";
			_gotHit = _vehicle getVariable "APgotHit";
			_gotHitPos = _vehicle getVariable "APgotHitPos";
			_patrolType = _vehicle getVariable "APpatrolType";
			_returnPos = _vehicle getVariable "APreturnPos";

			_move = false;

			_pilot = driver _vehicle;
			_group = group _pilot;

			_knows = (WC_KnowsAbout + 2) - (wcskill * 2);

			_targets = [];

			_targetsQuery = _pilot targetsQuery ["","","","",""];
			{
				_unit = _x select 1;
				if (alive _unit && {_pilot knowsAbout _unit > _knows} && {side _unit in wcside}) then {
					if (_unit isKindOf "CAManBase"
						|| {(_unit isKindOf "LandVehicle" && {(!isNull effectiveCommander _unit && {alive effectiveCommander _unit})})}
						|| {(_unit isKindOf "Air" && {(!isNull effectiveCommander _unit && {alive effectiveCommander _unit})})}
					) then {
						_targets set [count _targets, _unit];

						player sideChat format ["adding=%1", (_unit) call WC_fnc_getDisplayName];
					};
				};
			} forEach _targetsQuery;

			if (count _targets > 0) then {
				_knowsAbout = 0;
				_distance = 100000;
				_target = objNull;

				{
					if (_pilot distance _x < _distance) then {
						_distance = _pilot distance _x;
						_knowsAbout = _pilot knowsAbout _x;
						_group reveal [_x, _knowsAbout];
						_target = _x;
					};
				} forEach _targets;

				player sideChat format ["target=%1", (_target) call WC_fnc_getDisplayName];
				_vehicle setVariable ["APhitTime", time, true];
				_vehicle setVariable ["APgotHit", false, true];
				_vehicle setVariable ["APgotHitPos", getPos _vehicle, true];

				_mode = "attack";
			} else {
				if (_gotHit) then {
					if (time < _hitTime) then {
						_gotHitPos = _vehicle getVariable "APgotHitPos";

						_mode = "search";
					} else {
						_vehicle setVariable ["APhitTime", time, true];
						_vehicle setVariable ["APgotHit", false, true];
						_vehicle setVariable ["APgotHitPos", getPos _vehicle, true];

						_mode = "patrol";
					};
				} else {
					{
						if (_x getVariable "EH_GotHit") exitWith {
							_gotHitPos = getPos _vehicle;
							_gotHit = true;
							player sideChat "hit";
						};
					} forEach units _group;

					if (_gotHit) then {
						{
							_x setVariable ["EH_GotHit", false];
						} forEach units _group;

						_vehicle setVariable ["APhitTime", time + 180, true];
						_vehicle setVariable ["APgotHit", _gotHit, true];
						_vehicle setVariable ["APgotHitPos", _gotHitPos, true];

						_mode = "search";
					} else {
						_mode = "patrol";
					};
				};
			};

			switch _mode do {
				case "patrol": {
					if ((_vehicle) call WC_fnc_vehicleReady) then {
						_run = true;

						if (_patrolType) then {
							if (getMarkerColor _marker != "") then {
								if (wcalert > 50) then {
									_behaviour = "AWARE";
									_combatMode = "RED";
								} else {
									_behaviour = "SAFE";
									_combatMode = "GREEN";
								};

								_markerSize = (_marker) call WC_fnc_getMarkerSize;
								_distance = _markerSize * 0.5;

								_count = 0;
								_sleep = false;

								while {_run} do {
									_position = [_marker] call WC_fnc_createpositioninmarker;

									if (_vehicle distance _position > 1000) then {
										if (_count <= 3) then {
											_roads = _position nearRoads 150;
											if (count _roads > 0) then {
												_position = getPos (_roads call WC_fnc_selectRandom);
											} else {_sleep = true};
										} else {_run = false};
									} else {_sleep = true};

									if (_sleep) then {_count = _count + 1; sleep 0.1};
								};
							} else {
								_patrolType = false;
							};
						};

						if (!_patrolType) then {
							_behaviour = "SAFE";
							_combatMode = "GREEN";

							while {_run} do {
								_location = position (wctownlocations call WC_fnc_selectRandom);
								_position = [(_location select 0) + ([0, 500] call WC_fnc_seed), (_location select 1) + ([0, 500] call WC_fnc_seed), 0];

								if (_vehicle distance _position > 1000 && {_vehicle distance _respawn_west > 1000}) then {
									_run = false;
								} else {sleep 0.5};
							};
						};

						_speedMode = "NORMAL";

						_move = true;

						player sideChat format ["ready=%1", _position];

						{
							_x doWatch objNull;
						} forEach units _group;
					};
				};

				case "attack": {
					_behaviour = "COMBAT";
					_combatMode = "RED";

					if (_target isKindOf "Air") then {
						_speedMode = "FULL";
					} else {
						if (_vehicle isKindOf "Helicopter") then {
							_speedMode = "LIMITED";
						} else {
							_speedMode = "NORMAL";
						};
					};

					_position = _pilot getHideFrom _target;

					{
						_x doWatch _position;
					} forEach units _group;

					_move = true;
				};

				case "search": {
					if ((_vehicle) call WC_fnc_vehicleReady) then {
						_behaviour = "COMBAT";
						_combatMode = "RED";

						if (_vehicle isKindOf "Helicopter") then {
							_speedMode = "LIMITED";
						} else {
							_speedMode = "NORMAL";
						};

						_position = ([_gotHitPos, 300, 360, 0, 8] call WC_fnc_createcircleposition) call WC_fnc_selectRandom;

						{
							_x doWatch _position;
						} forEach units _group;

						_move = true;
					};
				};

				case "fuel": {

				};
			};

			if (_move) then {
				_pilot doMove _position;

				_vehicle setVariable ["APtargetPos", _position, true];

				_group setBehaviour _behaviour;
				_group setCombatMode _combatMode;
				_group setSpeedMode _speedMode;

				player sideChat "move";
			};

			sleep 0.5;
		} else {
			WC_AirPatrolVehicles = WC_AirPatrolVehicles - [_x];
		};
	} forEach WC_AirPatrolVehicles;

	sleep _MAIN_LOOP_CYCLE;
};