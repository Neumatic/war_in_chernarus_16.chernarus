// -----------------------------------------------
// Author:     code34 nicolas_boiteux@yahoo.fr
// Edited by:  Neumatic
// Warcontext: Build an object
// -----------------------------------------------

private ["_unit", "_type_of", "_position", "_mission_number"];

_unit    = _this select 0;
_type_of = _this select 1;

_position = [_unit] call WC_fnc_getPos;

_unit allowDamage false;
_unit setVariable ["wcbuild", false, true];

wcaddactions = [_unit, "BUILD_OBJECT"];
["wcaddactions", "client"] call WC_fnc_publicvariable;

// Get the current mission number.
_mission_number = wccurrentmission select 0;

while {!wcmissionsuccess} do {
	if (_unit getVariable "wcbuild") then {
		deleteVehicle _unit;
		_unit = createVehicle [_type_of, _position, [], 0, "NONE"];
		[_unit] call WC_fnc_alignToTerrain;

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
