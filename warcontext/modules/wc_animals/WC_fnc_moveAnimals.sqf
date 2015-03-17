/*
	Author: Neumatic
	Description: Loop handles movement of animals.

	Parameters:
		0: [Group] Animals group

	Example:
		[_group] spawn WC_fnc_moveAnimals;

	Returns:
		nil
*/

private ["_group", "_behaviour", "_speed_mode", "_units", "_unit", "_init_pos", "_position"];

_group = _this select 0;

_behaviour = "CARELESS";
_speed_mode = "LIMITED";

_group setBehaviour _behaviour;
_group setSpeedMode _speed_mode;

{
	_x disableAI "AUTOTARGET";
	_x disableAI "TARGET";
	_x forceWalk true;
	_x allowFleeing (random 0.8);
	_x setVariable ["WC_initPos", [_x] call WC_fnc_getPos, false];
	_x setVariable ["WC_destPos", [_x] call WC_fnc_getPos, false];
} forEach units _group;

_units = [];

// Main loop
while {{alive _x} count units _group > 0} do {
	// Get the units of the group; Add them to array.
	if (count _units == 0) then {
		{
			if (alive _x) then {
				_units set [count _units, _x];
			};
		} forEach units _group;
	};

	_unit = _units select 0;
	_units = _units - [_unit];

	// Give each unit individual move orders.
	if (([_unit, _unit getVariable "WC_destPos"] call WC_fnc_getDistance) <= 2) then {
		_init_pos = _unit getVariable "WC_initPos";
		_position = [(_init_pos select 0) + ([0, 20] call WC_fnc_seed), (_init_pos select 1) + ([0, 20] call WC_fnc_seed), _init_pos select 2];
		_unit setVariable ["WC_destPos", _position, false];
		_unit doMove _position;
		_unit setBehaviour _behaviour;
		_unit setSpeedMode _speed_mode;
	} else {
		_unit doMove (_unit getVariable "WC_destPos");
		_unit setBehaviour _behaviour;
		_unit setSpeedMode _speed_mode;
	};

	sleep 5;
};
