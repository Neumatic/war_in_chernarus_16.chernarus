// -----------------------------------------------
// Author:     code34 nicolas_boiteux@yahoo.fr
// Edited by:  Neumatic
// Warcontext: Heal a civilian
// -----------------------------------------------

private ["_unit", "_positions", "_position", "_mission_number"];

_unit = _this select 0;

_unit setVariable ["wcprotected", true];
_unit setCaptive true;
_unit allowFleeing 0;
_unit setUnitPos "Up";
doStop _unit;
removeAllWeapons _unit;

_positions = [[_unit] call WC_fnc_getPos, "all"] call WC_fnc_gethousespositions;
_position = _positions call WC_fnc_selectRandom;

_unit setPosATL _position;
_unit setDamage 0.9;
_unit playMoveNow "AmovPercMstpSnonWnonDnon_AmovPercMstpSsurWnonDnon";
_unit setVariable ["wchostage", true, true];

wcunits set [count wcunits, _unit];

wchostage = _unit;
["wchostage", "client"] call WC_fnc_publicvariable;

// Get the current mission number.
_mission_number = wccurrentmission select 0;

while {!wcmissionsuccess} do {
	if (!alive _unit) then {
		wcmessageW = [localize "STR_WC_MESSAGEMISSIONFAILED", localize "STR_WC_MESSAGELEAVEZONE"];
		["wcmessageW", "client"] call WC_fnc_publicvariable;
		wcmissionsuccess = true;
	};

	if (damage _unit < 0.1) then {
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
