// -----------------------------------------------
// Author:     code34 nicolas_boiteux@yahoo.fr
// Edited by:  Neumatic
// Warcontext: AI follow players
// -----------------------------------------------

private ["_unit", "_caller", "_name", "_hostage_msg", "_msg", "_unit_msg", "_old_group", "_leader", "_group"];

_unit   = _this select 0;
_caller = _this select 1;

player sideChat "Follow me!";
sleep ceil (random 5);

if (!alive _unit || {!alive _caller}) exitWith {};

_name = name _unit;

if (!isNil {_unit getVariable "wchostage"}) then {
	_hostage_msg = [
		"Thank you for rescuing me!",
		"Get me out of here!",
		"Happy to see you guys!",
		"Thought I wouldn't make it out of here!"
	];

	_msg = _hostage_msg call WC_fnc_selectRandom;
	player sideChat format ["%1: %2", _name, _msg];

	_unit setVariable ["wchostage", false, true];
	_unit setVariable ["WC_MarkerIgnore", false, true];
} else {
	_unit_msg = [
		"I'll do what you say.",
		"Get me out of here!"
	];

	_msg = _unit_msg call WC_fnc_selectRandom;
	player sideChat format ["%1: %2", _name, _msg];
};

sleep ceil (random 5);

if (!alive _unit || {!alive _caller}) exitWith {};

if !(side _caller in wcside) then {
	_old_group = group _caller;

	_leader = leader _old_group;
	if (!isPlayer _leader) then {
		_leader = _caller;
	};

	_group = createGroup west;

	if (count units _old_group > 1) then {
		{
			if (_forEachIndex == 0) then {
				[_leader] joinSilent _group;
			} else {
				[_x] joinSilent _group;
			};
		} forEach units _old_group;
	} else {
		[_leader] joinSilent _group;
	};

	_group selectLeader _leader;
	deleteGroup _old_group;
} else {
	_group = group _caller;
};

[_unit] joinSilent _group;

_unit setUnitPos "AUTO";
_unit enableAI "Move";
_unit switchMove "";
_unit stop false;

_unit doWatch (leader _group);
_unit doFollow (leader _group);

if (format ["%1", _unit getVariable "civilrole"] == "arrest") then {
	[_unit] spawn {
		private ["_unit", "_jail_pos"];

		_unit = _this select 0;

		_jail_pos = getMarkerPos "jail";
		_unit setVariable ["wcprotected", true, true];

		while {alive _unit && {([_unit, _jail_pos] call WC_fnc_getDistance) > 50}} do {sleep 10};

		if (alive _unit) then {
			_unit setPos _jail_pos;
			[_unit] joinSilent (group prisoner);
			_unit allowDammage false;
			_unit setUnitPos "Up";
			doStop _unit;
			_unit playMoveNow "AmovPercMstpSnonWnonDnon_AmovPercMstpSsurWnonDnon";
			_unit disableAI "MOVE";
			_unit disableAI "ANIM";

			_unit setVariable ["civilrole", "arrested", true];

			if (!isNil {_unit getVariable "Action_FollowMe"}) then {
				wcremoveaction = [_unit, "Action_FollowMe"];
				["wcremoveaction", "client"] call WC_fnc_publicvariable;
			};
		};
	};
};