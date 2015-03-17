/*
	Author: code34
	Edited by: Neumatic
	Description: Eliminate a unit mission.

	Parameter(s):
		0: [Object] Unit

	Example(s):
		[_unit] spawn WC_fnc_eliminate;

	Returns:
		nil
*/

private ["_unit", "_mission_number"];

_unit = _this select 0;

// Get the current mission number.
_mission_number = wccurrentmission select 0;

wcunits set [count wcunits, _unit];

while {!wcmissionsuccess} do {
	if (!alive _unit) then {
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
