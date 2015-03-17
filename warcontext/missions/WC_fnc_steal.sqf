// -----------------------------------------------
// Author:     code34 nicolas_boiteux@yahoo.fr
// Edited by:  Neumatic
// Warcontext: Steal an object
// -----------------------------------------------

private ["_unit", "_find", "_unit_pos", "_mission_number", "_near_units"];

_unit = _this select 0;

_find = false;
_unit allowDamage false;
_unit_pos = [_unit] call WC_fnc_getPos;

// Get the current mission number.
_mission_number = wccurrentmission select 0;

while {!wcmissionsuccess} do {
	if (wcalert > 99) then {
		wcmessageW = [localize "STR_WC_MESSAGEMISSIONFAILED", localize "STR_WC_MESSAGELEAVEZONE"];
		["wcmessageW", "client"] call WC_fnc_publicvariable;
		wcmissionsuccess = true;
	};

	_near_units = _unit_pos nearEntities ["CAManBase", 2];
	{
		if (isPlayer _x) exitWith {
			_find = true;
		};
	} forEach _near_units;

	if (_find) then {
		deleteVehicle _unit;

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
