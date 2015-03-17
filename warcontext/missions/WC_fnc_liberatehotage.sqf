// -----------------------------------------------
// Author:     code34 nicolas_boiteux@yahoo.fr
// Edited by:  Neumatic
// Warcontext: Liberate hotage
// -----------------------------------------------

private ["_unit", "_positions", "_position", "_size", "_group", "_new_unit", "_marker_pos", "_mission_number"];

_unit = _this select 0;

wcaddactions = [_unit, "FOLLOW_ME"];
["wcaddactions", "client"] call WC_fnc_publicvariable;

_unit setVariable ["wcprotected", true];
_unit setCaptive true;
_unit allowFleeing 0;
_unit setUnitPos "Up";
removeAllWeapons _unit;

_positions = [[_unit] call WC_fnc_getPos, "all"] call WC_fnc_gethousespositions;
if (count _positions > 0) then {
	_position = _positions call WC_fnc_selectRandom;
} else {
	_position = [_position, 0, 150, sizeOf "RU_Soldier", 0.2] call WC_fnc_getEmptyPosition;
};

_unit setPosATL _position;
_unit setDamage 0;
_unit playMoveNow "AmovPercMstpSnonWnonDnon_AmovPercMstpSsurWnonDnon";
_unit setVariable ["wchostage", true, true];
_unit setVariable ["WC_MarkerIgnore", true, true];
_unit stop true;

wcunits set [count wcunits, _unit];

_size = [2, 4] call WC_fnc_randomMinMax;
_position = [_unit, 0, 30, sizeOf "RU_Soldier", 0.2] call WC_fnc_getEmptyPosition;

// Create guards near the hostage
_group = createGroup east;
for "_i" from 1 to _size do {
	_new_unit = _group createUnit [wcspecialforces call WC_fnc_selectRandom, _position, [], 10, "NONE"];
	sleep 0.1;
};

[_group, east] spawn WC_fnc_grouphandler;
[_group, [_unit] call WC_fnc_getPos, 30, false] spawn WC_fnc_patrol;

wchostage = _unit;
["wchostage", "client"] call WC_fnc_publicvariable;

_marker_pos = getMarkerPos "respawn_west";

// Get the current mission number.
_mission_number = wccurrentmission select 0;

while {!wcmissionsuccess} do {
	if (!alive _unit) then {
		wcmessageW = [localize "STR_WC_MESSAGEMISSIONFAILED", localize "STR_WC_MESSAGELEAVEZONE"];
		["wcmessageW", "client"] call WC_fnc_publicvariable;
		wcmissionsuccess = true;
	};

	if (([_unit, _marker_pos] call WC_fnc_getDistance) < 20) then {
		_unit setVariable ["wchostage", false, true];
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
	};

	sleep 1;
};

_unit setVariable ["wcprotected", nil];
