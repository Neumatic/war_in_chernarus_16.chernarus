// -----------------------------------------------
// Author:     code34 nicolas_boiteux@yahoo.fr
// Edited by:  Neumatic
// Warcontext: Secure a zone
// -----------------------------------------------

private ["_unit", "_counter", "_position", "_mission_number", "_enemys", "_all_units", "_object", "_marker"];

_unit = _this select 0;

_counter = -36;
_position = [_unit] call WC_fnc_getPos;

// Get the current mission number.
_mission_number = wccurrentmission select 0;

while {!wcmissionsuccess} do {
	_enemys = [];

	// Add enemy units in the zone to array.
	_all_units = _position nearEntities [["CAManBase","LandVehicle"], wcdistance];
	{
		_object = _x;
		if (_object isKindOf "LandVehicle") then {
			{
				if (!isPlayer _x && {side _x in wcenemyside}) then {
					_enemys set [count _enemys, _x];
				};
			} forEach crew _object;
		} else {
			if (!isPlayer _object && {side _object in wcenemyside}) then {
				_enemys set [count _enemys, _object];
			};
		};
	} forEach _all_units;

	if (_counter > 36) then {
		_counter = 0;
		wcmessageW = [localize "STR_WC_MESSAGEMISSIONCOMMANDEMENT", format ["Still %1 enemies", count _enemys]];
		["wcmessageW", "client"] call WC_fnc_publicvariable;
	};

	// If no enemies left then mission success.
	if (count _enemys == 0) then {
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

		wcsecurezoneindex = wcsecurezoneindex + 1;
		_marker = [format ["wcsecurezone%1", wcsecurezoneindex], "rescuezone"] call WC_fnc_copymarker;
		_marker setMarkerColor "ColorBlue";
		_marker = [format ["wcsecuretext%1", wcsecurezoneindex], _marker] call WC_fnc_copymarker;
		_marker setMarkerText "Zone is safe";
		_marker setMarkerShape "ICON";
		_marker setMarkerSize [1,1];
		_marker setMarkerType "Warning";
		_marker setMarkerColor "ColorBlue";

		wcsecurezone set [count wcsecurezone, _position];
		objNull call WC_fnc_deletemissioninsafezone;
	};

	_counter = _counter + 1;
	sleep 5;
};
