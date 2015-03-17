// -----------------------------------------------
// Author:     code34 nicolas_boiteux@yahoo.fr
// Edited by:  Neumatic
// Warcontext: Create a destroy group mission
// -----------------------------------------------

private ["_vehicle", "_veh_pos", "_size", "_position", "_unit", "_units", "_group", "_type", "_counter", "_mission_number"];

_vehicle = _this select 0;

wcobjecttodelete set [count wcobjecttodelete, _vehicle];

_veh_pos = [_vehicle] call WC_fnc_getPos;
_position = [_veh_pos, 0, 30, sizeOf "RU_Soldier", 0.2] call WC_fnc_getEmptyPosition;

_units = +wcspecialforces;
_size = 7;

// Create special forces group.
_group = createGroup east;
for "_i" from 1 to _size do {
	_type = _units call WC_fnc_selectRandom;
	_units = _units - [_type];

	_unit = _group createUnit [_type, _position, [], 10, "NONE"];
	sleep 0.5;
};

[_group, east] spawn WC_fnc_grouphandler;
[_group, _veh_pos, 150, false] spawn WC_fnc_patrol;

_counter = -180;

// Get the current mission number.
_mission_number = wccurrentmission select 0;

while {!wcmissionsuccess} do {
	if (count crew _vehicle > 0) then {
		{
			_x action ["Eject", _vehicle];
			unassignVehicle _x;
			(group _x) leaveVehicle _vehicle;
		} forEach crew _vehicle;
	};

	if ({alive _x} count units _group == 0 && {!alive _vehicle}) then {
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

	if (_counter > 180) then {
		wcmessageW = [localize "STR_WC_MESSAGEMISSIONCOMMANDEMENT", format ["Still %1 enemies", {alive _x} count units _group]];
		["wcmessageW", "client"] call WC_fnc_publicvariable;
		_counter = 0;
	};

	_counter = _counter + 1;
	sleep 1;
};
