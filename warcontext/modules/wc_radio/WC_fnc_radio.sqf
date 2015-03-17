/*
	Author: Neumatic
	Description: Gets targets from units in the group.

	Parameter(s):
		nil

	Example(s):
		[] spawn WC_fnc_radio;

	Returns:
		nil
*/

// Loop cycles sleep.
#define MAIN_LOOP_CYCLE 5

// Share targets with other groups.
#define RADIO_TARGETS

// Distance that group is to another to share targets.
#define RADIO_RANGE 600

private [
	"_FNC_HasRadio", "_FNC_EstimateTarget", "_knows", "_group", "_leader", "_enemy_side", "_targets", "_unit",
	"_targets_query", "_entry", "_target", "_side", "_sorted", "_estimate", "_nearest", "_temp_est", "_temp_group"
];

// CHeck if the group has a radio.
_FNC_HasRadio = {
	private ["_group", "_has_radio", "_leader"];

	_group = _this select 0;

	_has_radio = false;
	_leader = leader _group;

	if (vehicle _leader == _leader) then {
		{
			if (_x hasWeapon "ItemRadio") exitWith {
				_has_radio = true;
			};
		} forEach units _group;
	} else {
		_has_radio = true;
	};

	_has_radio
};

// Estimate how well the leader sees the target.
_FNC_EstimateTarget = {
	private ["_leader", "_target", "_position", "_known_pos", "_distance"];

	_leader = _this select 0;
	_target = _this select 1;

	_position = [_target] call WC_fnc_getPos;
	_known_pos = _leader getHideFrom _target;
	_distance = _known_pos distance _position;

	_distance
};

while {true} do {
	if (count WC_PatrolGroups > 0) then {
		_knows = (WC_KnowsAbout + 2) - (wcskill * 2);

		{
			_group = _x;

			// Check if there is still a group.
			if (!isNull _group) then {
				_leader = leader _group;

				// If there is no leader then we assume the group is dead.
				if (!isNull _leader) then {
					// Get the enemy side.
					switch (side _group) do {
						case west: {
							_enemy_side = wcenemyside;
						};

						case east: {
							_enemy_side = wcside;
						};
					};

					// Get the groups current targets.
					_targets = _group getVariable ["WC_KnownTargets", []];

					{
						_unit = _x;

						// Get targets from the units targetsQuery and add them to targets array.
						_targets_query = _unit targetsQuery ["","","","",""];
						if (count _targets_query > 0) then {
							while {count _targets_query > 0} do {
								_entry = _targets_query select 0;

								_target = _entry select 1;
								_side   = _entry select 2;

								if (alive _target && {_unit knowsAbout _target > _knows} && {_side in _enemy_side}) then {
									if (_target isKindOf "CAManBase"
									|| {(_target isKindOf "LandVehicle" && {(!isNull effectiveCommander _target && {alive effectiveCommander _target})})}
									|| {(_target isKindOf "Air" && {(!isNull effectiveCommander _target && {alive effectiveCommander _target})})}
									) then {
										if !(_target in _targets) then {
											_targets = _targets + [_target];
										};
									};
								};

								_targets_query = _targets_query - [_entry];
							};
						};

						sleep 0.05;
					} forEach units _group;

					// If there are targets then sort and share them.
					if (count _targets > 0) then {
						// Remove targets that are dead or the leader has lost track of.
						{
							if (isNull _x || {!alive _x} || {_leader knowsAbout _x < _knows}) then {
								_targets = _targets - [_x];
							};
						} forEach _targets;

						// If there are no more targets then exit the scope.
						if (count _targets == 0) exitWith {};

						_sorted = [];

						// Sort targets by estimation.
						while {count _targets > 0} do {
							_estimate = 100000;
							_nearest = objNull;

							{
								_entry = _x;
								_temp_est = [_leader, _entry] call _FNC_EstimateTarget;

								if (_temp_est < _estimate) then {
									_estimate = _temp_est;
									_nearest = _entry;
								};
							} forEach _targets;

							if (!isNull _nearest) then {
								_sorted = _sorted + [_nearest];
								_targets = _targets - [_nearest];
							};
						};

						// Set the groups targets.
						_group setVariable ["WC_KnownTargets", _sorted];

						// If share targets then share with near groups.
						#ifdef RADIO_TARGETS
							if ([_group] call _FNC_HasRadio) then {
								{
									_temp_group = _x;

									if (!isNull _temp_group && {side _temp_group == side _group}) then {
										if (([leader _group, leader _temp_group] call WC_fnc_getDistance) < RADIO_RANGE) then {
											// Check if the other group also has a radio.
											if ([_temp_group] call _FNC_HasRadio) then {
												_targets = _temp_group getVariable ["WC_KnownTargets", []];
												if (count _targets > 0) then {
													{
														// If target is not in the targets array then add.
														if !(_x in _targets) then {
															_targets = _targets + [_x];
														};
													} forEach _sorted;

													// Set the groups targets.
													_temp_group setVariable ["WC_KnownTargets", _targets];
												};
											};
										};
									};

									sleep 0.05;
								} forEach WC_PatrolGroups;
							};
						#endif
					};
				};
			} else {
				// Remove group from patrol groups array.
				WC_PatrolGroups = WC_PatrolGroups - [_group];
			};

			sleep 0.05;
		} forEach WC_PatrolGroups;
	};

	sleep MAIN_LOOP_CYCLE;
};