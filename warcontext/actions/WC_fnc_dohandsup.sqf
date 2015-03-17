// -----------------------------------------------
// Author:     code34 nicolas_boiteux@yahoo.fr
// Edited by:  Neumatic
// Warcontext: Unit hands up
// -----------------------------------------------

private [
	"_unit", "_caller", "_under_arrest", "_name", "_old_group", "_old_role", "_civil_gen_msg", "_civil_mad_msg", "_msg",
	"_east_gen_msg", "_east_mad_msg", "_east_surr_msg", "_east_agro_msg", "_group", "_knows_about", "_arrest_msg", "_count",
	"_check", "_position"
];

_unit   = _this select 0;
_caller = _this select 1;

player sideChat "Put your hands up!";
sleep ceil (random 5);

if (!alive _unit || {!alive _caller}) exitWith {};

_under_arrest = false;

_name = name _unit;
_unit doWatch _caller;

_old_group = group _unit;
_unit setVariable ["oldgroup", _old_group, true];

if (!isNil {_unit getVariable "civilrole"}) then {
	_old_role = _unit getVariable "civilrole";
	_unit setVariable ["oldcivilrole", _old_role, true];
};

switch (side _unit) do {
	case civilian: {
		_civil_gen_msg = [
			"I did nothing wrong.",
			"Please leave me in peace.",
			"We just want to get on with our lives.",
			"What do you want with me?",
			"I was just on a walk!",
			"My house is near by. Just let me go!",
			"I don't want any trouble"
		];

		_civil_mad_msg = [
			"Stop wasting my time.",
			"Are you a fool?",
			"Who do you think you are?",
			"I don't have to listen to you.",
			"If you don't leave me alone I will kick your ass!"
		];

		switch (side _caller) do {
			case civilian: {
				if (primaryWeapon _caller == "") then {
					_msg = _civil_mad_msg call WC_fnc_selectRandom;
					player sideChat format ["%1: %2", _name, _msg];
				} else {
					_msg = _civil_gen_msg call WC_fnc_selectRandom;
					player sideChat format ["%1: %2", _name, _msg];

					_under_arrest = true;
				};
			};

			case west: {
				_msg = _civil_gen_msg call WC_fnc_selectRandom;
				player sideChat format ["%1: %2", _name, _msg];

				_under_arrest = true;
			};
		};
	};

	case east: {
		_east_gen_msg = [
			"Stop wasting my time.",
			"Get out of my face!",
			"You are annoying me, go away!",
			"Leave now or I will arrest you!",
			"Stop provoking me.",
			"Do you think you are funny?",
			"Run along, you are in the way."
		];

		_east_mad_msg = [
			"Are you a fool?",
			"Provocation!",
			"Put your weapon down!",
			"I will shoot you!"
		];

		_east_surr_msg = [
			"Don't shoot! I surrender!",
			"I surrender! I'm just a conscript!",
			"I can't win this fight. I surrender!"
		];

		_east_agro_msg = [
			"I will never surrender!",
			"I will not surrender!",
			"I will fight to the death!",
			"You made a big mistake!"
		];

		switch (side _caller) do {
			case civilian: {
				if (primaryWeapon _caller == "") then {
					if (random 1 > 0.95) then {
						_msg = _east_mad_msg call WC_fnc_selectRandom;
						player sideChat format ["%1: %2", _name, _msg];

						_old_group setBehaviour "AWARE";
						_old_group setCombatMode "RED";

						_group = createGroup west;
						[_caller] joinSilent _group;
					} else {
						_msg = _east_gen_msg call WC_fnc_selectRandom;
						player sideChat format ["%1: %2", _name, _msg];
					};
				} else {
					_msg = _east_mad_msg call WC_fnc_selectRandom;
					player sideChat format ["%1: %2", _name, _msg];

					_old_group setBehaviour "AWARE";
					_old_group setCombatMode "RED";

					_group = createGroup west;
					[_caller] joinSilent _group;
				};
			};

			case west: {
				if (fleeing _unit || {count (units group _unit) < 2} || {damage _unit > 0.6}) then {
					_msg = _east_surr_msg call WC_fnc_selectRandom;
					player sideChat format ["%1: %2", _name, _msg];

					_under_arrest = true;
				} else {
					_msg = _east_agro_msg call WC_fnc_selectRandom;
					player sideChat format ["%1: %2", _name, _msg];

					_old_group setBehaviour "AWARE";
					_old_group setCombatMode "RED";

					sleep ceil (random 5);

					_unit doFire _caller;
				};
			};
		};
	};
};

_knows_about = _unit knowsAbout _caller;
_old_group reveal [_caller, _knows_about];

sleep ceil (random 5);

if (!alive _unit || {!alive _caller}) exitWith {};

if (_under_arrest) then {
	_unit setVariable ["civilrole", "arrest", true];

	wcstop = [_unit, true];
	["wcstop", "server"] call WC_fnc_publicvariable;

	wcplaymove = [_unit, "AmovPercMstpSnonWnonDnon_AmovPercMstpSsurWnonDnon"];
	["wcplaymove", "server"] call WC_fnc_publicvariable;

	wcremoveaction = [_unit, "Action_HandsUp"];
	["wcremoveaction", "client"] call WC_fnc_publicvariable;

	wcaddactions = [_unit, "SEARCH_UNIT"];
	["wcaddactions", "client"] call WC_fnc_publicvariable;

	_arrest_msg = [
		"Please let me go.",
		"Can you please let me go?",
		"I promise I will go home.",
		"I did nothing wrong."
	];

	_count = 0;
	_check = false;
	_position = [_unit] call WC_fnc_getPos;

	while {!_check && {alive _unit} && {alive _caller}} do {
		if (isNil {_unit getVariable "civilrole"}) then {
			_check = true;
		} else {
			if ({([_x, _position] call WC_fnc_getDistance) < 20} count ([] call BIS_fnc_listPlayers) == 0) then {
				_check = true;
			} else {
				if (group _unit != _unit getVariable "oldgroup") then {
					_check = true;
				} else {
					if (_count > 10) then {
						_msg = _arrest_msg call WC_fnc_selectRandom;
						player sideChat format ["%1: %2", _name, _msg];
						_count = 0;
					};

					sleep ceil (random 5);
					_count = _count + 1;
				};
			};
		};
	};

	sleep ceil (random 5);

	if (alive _unit && {group _unit == _unit getVariable "oldgroup"}) then {
		_unit setVariable ["civilrole", nil, true];

		if (!isNil {_unit getVariable "oldcivilrole"}) then {
			_old_role = _unit getVariable "oldcivilrole";
			_unit setVariable ["civilrole", _old_role, true];
		};

		if (!isNil {_unit getVariable "Action_Search"}) then {
			wcremoveaction = [_unit, "Action_Search"];
			["wcremoveaction", "client"] call WC_fnc_publicvariable;
		};

		if (!isNil {_unit getVariable "Action_FollowMe"}) then {
			wcremoveaction = [_unit, "Action_FollowMe"];
			["wcremoveaction", "client"] call WC_fnc_publicvariable;
		};

		wcaddactions = [_unit, "HANDS_UP"];
		["wcaddactions", "client"] call WC_fnc_publicvariable;

		wcsetunitpos = [_unit, "AUTO"];
		["wcsetunitpos", "server"] call WC_fnc_publicvariable;

		_unit switchMove "";

		wcstop = [_unit, false];
		["wcstop", "server"] call WC_fnc_publicvariable;
	};
};

_unit doWatch objNull;
