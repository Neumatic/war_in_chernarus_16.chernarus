// -----------------------------------------------
// Author:     code34 nicolas_boiteux@yahoo.fr
// Edited by:  Neumatic
// Warcontext: Sabotage
// -----------------------------------------------

#define VEHICLE_TYPES ["Car","Tank","Motorcycle","Air"]

private ["_vehicle", "_mission_number"];

_vehicle = _this select 0;

_vehicle setVariable ["wcsabotage", false, true];
wcaddactions = [_vehicle, "SABOTAGE_OBJECT"];
["wcaddactions", "client"] call WC_fnc_publicvariable;

if ({_vehicle isKindOf _x} count VEHICLE_TYPES > 0) then {
	_vehicle lock true;
	_vehicle setFuel 0;
};

wcobjecttodelete set [count wcobjecttodelete, _vehicle];

// Get the current mission number.
_mission_number = wccurrentmission select 0;

while {!wcmissionsuccess} do {
	if ({_vehicle isKindOf _x} count VEHICLE_TYPES > 0) then {
		if (count crew _vehicle > 0) then {
			{
				_x action ["Eject", _vehicle];
				unassignVehicle _x;
				(group _x) leaveVehicle _vehicle;
			} forEach crew _vehicle;
		};
	};

	if (wcalert > 99) then {
		wcmessageW = [localize "STR_WC_MESSAGEMISSIONFAILED", localize "STR_WC_MESSAGELEAVEZONE"];
		["wcmessageW", "client"] call WC_fnc_publicvariable;
		wcmissionsuccess = true;
	};

	if (!alive _vehicle) then {
		wcmessageW = [localize "STR_WC_MESSAGEMISSIONFAILED", localize "STR_WC_MESSAGELEAVEZONE"];
		["wcmessageW", "client"] call WC_fnc_publicvariable;
		wcmissionsuccess = true;
	};

	if (_vehicle getVariable "wcsabotage") then {
		wcmessageW = [localize "STR_WC_MESSAGEMISSIONCOMPLETED", localize "STR_WC_MESSAGELEAVEZONE"];
		["wcmessageW", "client"] call WC_fnc_publicvariable;

		// Add mission number to mission done array.
		wcmissiondone set [count wcmissiondone, _mission_number];
		wcmissionsuccess = true;
		wcleveltoadd = 1;

		wcsabotagelist set [count wcsabotagelist, typeOf _vehicle];

		wcfame = wcfame + wcbonusfame;
		wcnuclearprobability = wcnuclearprobability - wcbonusnuclear;
		wcenemyglobalfuel = wcenemyglobalfuel - wcbonusfuel;
		wcenemyglobalelectrical = wcenemyglobalelectrical - wcbonuselectrical;
	};

	sleep 1;
};
