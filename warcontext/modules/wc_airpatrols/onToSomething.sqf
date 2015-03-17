private ["__MAIN_LOOP_CYCLE","_debug","_respawn_west","_vehicle","_exit","_pilot","_marker","_markerSize","_minMarkerDist","_patrol","_group",
"_gotHit","_gotHitPos","_targets","_knows","_targetsQuery","_unit","_knowsAbout","_distance","_target","_wpType","_wpSpeed","_position",
"_count","_check","_location","_wp","_index","_wpPos"];

__MAIN_LOOP_CYCLE = 10;
_debug = true;
_respawn_west = getMarkerPos "respawn_west";

while {true} do {
	{
		_vehicle = _x;

		if (!isNull _vehicle) then {
			_exit = false;

			_pilot = driver _vehicle;

			if (isNull _pilot || {!alive _pilot} || !alive _vehicle || {!canMove _vehicle}) then {
				WC_AirPatrolVehicles = WC_AirPatrolVehicles - [_vehicle];
				_exit = true;
			};

			if (!_exit) then {
				_marker = _vehicle getVariable "WC_AirPatrolMarker";
				_markerSize = (_marker) call WC_fnc_getMarkerSize;
				_minMarkerDist = _markerSize * 0.5;

				_patrol = _vehicle getVariable "WC_AirPatrolType";

				_group = group _pilot;

				_gotHit = false;
				_gotHitPos = [0,0,0];

				{
					if (_x getVariable "EH_GotHit") exitWith {
						_gotHitPos = getPos _vehicle;
						_gotHit = true;

						if (_debug) then {Server globalChat format ["air patrol %1: %2 was hit", (_vehicle) call WC_fnc_getDisplayName, _x]};
					};
				} forEach units _group;

				if (_gotHit) then {
					{
						_x setVariable ["EH_GotHit", false];
					} forEach units _group;
				};

				_knows = (WC_KnowsAbout + 2) - (wcskill * 2);
				_target = _vehicle getVariable "WC_AirPatrolTarget";

				if (isNull _target || {!alive _target} || {_pilot knowsAbout _target < _knows}) then {
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

								if (_debug) then {Server globalChat format ["air patrol %1: adding %2 to targets", (_vehicle) call WC_fnc_getDisplayName, (_x) call WC_fnc_getDisplayName]};
							};
						};
					} forEach _targetsQuery;

					_knowsAbout = 0;
					_distance = 1000;
					_target = objNull;

					{
						if (alive _x && {_pilot distance _x < _distance}) then {
							_distance = _pilot distance _x;
							_knowsAbout = _pilot knowsAbout _x;
							_group reveal [_x, _knowsAbout];
							_target = _x;
						};
					} forEach _targets;

					_vehicle setVariable ["WC_AirPatrolTarget", _target, false];
				};

				if (isNull _target || {!alive _target}) then {
					if (_gotHit) then {
						_group setBehaviour "AWARE";
						_group setCombatMode "RED";
						_wpType = ["SAD"] call WC_fnc_selectRandom;
						_wpSpeed = "NORMAL";

						_position = _gotHitPos;
					} else {
						if (wcalert > 50) then {
							_group setBehaviour "AWARE";
							_group setCombatMode "RED";
							_wpType = ["MOVE","SAD"] call WC_fnc_selectRandom;
							_wpSpeed = "NORMAL";
						} else {
							_group setBehaviour "SAFE";
							_group setCombatMode "GREEN";
							_wpType = ["MOVE"] call WC_fnc_selectRandom;
							_wpSpeed = "NORMAL";
						};

						if (_patrol) then {
							if (getMarkerColor _marker != "") then {
								_count = 0;
								_check = false;

								while {!_check} do {
									_position = [_marker] call WC_fnc_createpositioninmarker;

									if (_count >= 2) then {
										_check = true;
									} else {
										if (_pilot distance _position > _distance) then {
											_check = true;
										} else {
											if (_pilot distance _position < _distance) then {
												_count = _count + 1; sleep 0.5
											};
										}
									};
								};
							} else {
								_check = false;

								while {!_check} do {
									_location = position (wctownlocations call WC_fnc_selectRandom);
									_position = [(_location select 0) + ([0, 500] call WC_fnc_seed), (_location select 1) + ([0, 500] call WC_fnc_seed), 0];

									if (_vehicle distance _position > 1000 && {_vehicle distance _respawn_west > 1000}) then {
										_check = true;
									} else {sleep 0.5};
								};

								if (_debug) then {Server globalChat format ["air patrol %1: new location", (_vehicle) call WC_fnc_getDisplayName]};
							};
						} else {
							_check = false;

							while {!_check} do {
								_location = position (wctownlocations call WC_fnc_selectRandom);
								_position = [(_location select 0) + ([0, 500] call WC_fnc_seed), (_location select 1) + ([0, 500] call WC_fnc_seed), 0];

								if (_vehicle distance _position > 1000 && {_vehicle distance _respawn_west > 1000}) then {
									_check = true;
								} else {sleep 0.5};
							};

							if (_debug) then {Server globalChat format ["air patrol %1: new location", (_vehicle) call WC_fnc_getDisplayName]};
						};
					};

					{
						_x doWatch objNull;
					} forEach units _group;
				} else {
					_group setBehaviour "COMBAT";
					_group setCombatMode "RED";
					_wpType = "SAD";
					_wpSpeed = "LIMITED";

					for "_i" from (count waypoints _group - 1) to 1 step -1 do {
						deleteWaypoint ((waypoints _group) select _i);
					};

					_position = _pilot getHideFrom _target;

					if (_debug) then {Server globalChat format ["air patrol %1: has a target %2 target pos %3 actual pos is %4", (_vehicle) call WC_fnc_getDisplayName, (_target) call WC_fnc_getDisplayName, _position, getPos _target]};

					{
						_x doWatch _position;
					} forEach units _group;
				};

				_index = currentWaypoint _group;

				if (_index == 1 || {_index > count waypoints _group}) then {
					_wp = _group addWaypoint [_position, 0];
					_wp setWaypointPosition [_position, 0];
					_wp setWaypointType _wpType;
					_wp setWaypointSpeed _wpSpeed;
					_index = _wp select 1;
					if (_debug) then {Server globalChat format ["air patrol %1: adding waypoint : _wp=%2 : _index=%3", (_vehicle) call WC_fnc_getDisplayName, _wp, _index]};
				} else {
					_wp = [_group, _index];
					if (_debug) then {Server globalChat format ["air patrol %1: selecting waypoint : _wp=%2 : _index=%3", (_vehicle) call WC_fnc_getDisplayName, _wp, _index]};
				};

				sleep 0.5;
			};
		};
	} forEach WC_AirPatrolVehicles;

	sleep __MAIN_LOOP_CYCLE;
};