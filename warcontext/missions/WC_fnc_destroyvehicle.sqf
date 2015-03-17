// -----------------------------------------------
// Author:     code34 nicolas_boiteux@yahoo.fr
// Edited by:  Neumatic
// Warcontext: Create a destroy vehicle mission
// -----------------------------------------------

private ["_vehicle", "_mission_number"];

_vehicle  = _this select 0;

// Get the current mission number.
_mission_number = wccurrentmission select 0;

wcobjecttodelete set [count wcobjecttodelete, _vehicle];

while {!wcmissionsuccess} do {
	if (count crew _vehicle > 0) then {
		{
			_x action ["Eject", _vehicle];
			unassignVehicle _x;
			(group _x) leaveVehicle _vehicle;
		} forEach crew _vehicle;
	};

	if (!alive _vehicle) then {
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

		// Remove mission vehicle from vehicles arrays.
		[_vehicle] call WC_fnc_removeMissionVehicle;
	};

	sleep 1;
};
