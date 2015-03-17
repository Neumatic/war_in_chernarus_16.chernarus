// -----------------------------------------------
// Author:     code34 nicolas_boiteux@yahoo.fr
// Edited by:  Neumatic
// Warcontext: Rob a vehicle
// -----------------------------------------------

private ["_vehicle", "_start_pos", "_mission_number", "_check", "_crew_units"];

_vehicle = _this select 0;

_check = false;
_start_pos = [_vehicle] call WC_fnc_getPos;

// Get the current mission number.

while {!wcmissionsuccess} do {
	if (!alive _vehicle) then {
		wcmessageW = [localize "STR_WC_MESSAGEMISSIONFAILED", localize "STR_WC_MESSAGELEAVEZONE"];
		["wcmessageW", "client"] call WC_fnc_publicvariable;
		wcmissionsuccess = true;
	};

	if (([_vehicle, _start_pos] call WC_fnc_getDistance) > wcleaveareasizeatendofmission) then {
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

		_check = true;
	};

	_crew_units = crew _vehicle;
	if (count _crew_units > 0) then {
		{
			if (!isPlayer _x || {!(side _x in wcside)}) then {
				_x action ["Eject", _vehicle];
				unassignVehicle _x;
				(group _x) leaveVehicle _vehicle;
			};
		} forEach _crew_units;
	};

	sleep 1;
};

if (_check) then {
	// Remove mission vehicle from vehicles arrays.
	[_vehicle] call WC_fnc_removeMissionVehicle;
} else {
	wcobjecttodelete set [count wcobjecttodelete, _vehicle];
};
