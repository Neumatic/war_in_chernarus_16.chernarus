// -----------------------------------------------
// Author:     code34 nicolas_boiteux@yahoo.fr
// Edited by:  Neumatic
// Warcontext: Arrest a prisoner
// -----------------------------------------------

private ["_unit", "_positions", "_position", "_size", "_group", "_new_unit", "_jail_pos", "_mission_number"];

_unit = _this select 0;

wcaddactions = [_unit, "FOLLOW_ME"];
["wcaddactions", "client"] call WC_fnc_publicvariable;

_unit setVariable ["wcprotected", true];
_unit setUnitPos "Up";
doStop _unit;

//[_unit, wcskill] spawn WC_fnc_setskill;

_positions = [[_unit] call WC_fnc_getPos, "all"] call WC_fnc_gethousespositions;
_position = _positions call WC_fnc_selectRandom;

_unit setPosATL _position;
_unit setDamage 0;

_size = [2, 4] call WC_fnc_randomMinMax;
_position = [_unit, 0, 30, sizeOf "RU_Soldier", 0.2] call WC_fnc_getEmptyPosition;

_group = group _unit;
for "_i" from 1 to _size do {
	_new_unit = _group createUnit [wcspecialforces call WC_fnc_selectRandom, _position, [], 10, "NONE"];
	sleep 0.1;
};

[_group, [_unit] call WC_fnc_getPos, 150, false] spawn WC_fnc_patrol;
[_group, east] spawn WC_fnc_grouphandler;

_jail_pos = getMarkerPos "jail";

// Get the current mission number.
_mission_number = wccurrentmission select 0;

while {!wcmissionsuccess} do {
	if (([_unit, _unit findNearestEnemy _unit] call WC_fnc_getDistance) < 8) then {
		_unit setCaptive true;
		removeAllWeapons _unit;
		_unit allowFleeing 0;
		_unit playMoveNow "AmovPercMstpSnonWnonDnon_AmovPercMstpSsurWnonDnon";
	};

	if (([_unit, _jail_pos] call WC_fnc_getDistance) < 20) then {
		wcmessageW = [localize "STR_WC_MESSAGEMISSIONCOMPLETED", localize "STR_WC_MESSAGELEAVEZONE"];
		["wcmessageW", "client"] call WC_fnc_publicvariable;

		// Add mission number to mission done array.
		wcmissiondone set [count wcmissiondone, _mission_number];
		wcmissionsuccess = true;
		wcleveltoadd = 1;

		wcfame = wcfame + wcbonusfame;
		wcnuclearprobability = wcnuclearprobability - wcbonusnuclear;
		wcenemyglobalfuel = wcenemyglobalfuel - wcbonusfuel;
		wcenemyglobalelectrical = wcenemyglobalelectrical - wcbonuselectrical;

		if (alive _unit) then {
			_unit setPos _jail_pos;
			[_unit] joinSilent (group prisoner);
			_unit allowDammage false;
			_unit setUnitPos "Up";
			doStop _unit;
			_unit playMoveNow "AmovPercMstpSnonWnonDnon_AmovPercMstpSsurWnonDnon";
			_unit disableAI "MOVE";
			_unit disableAI "ANIM";
		};
	};

	if (!alive _unit) then {
		wcmessageW = [localize "STR_WC_MESSAGEMISSIONFAILED", localize "STR_WC_MESSAGELEAVEZONE"];
		["wcmessageW", "client"] call WC_fnc_publicvariable;
		wcmissionsuccess = true;

		_unit setVariable ["wcprotected", nil];
		wcunits set [count wcunits, _unit];
	};

	if (damage _unit > 0.1) then {
		removeAllWeapons _unit;
	};

	sleep 1;
};
