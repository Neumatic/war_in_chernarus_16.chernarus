// -----------------------------------------------
// Author:     code34 nicolas_boiteux@yahoo.fr
// Edited by:  Neumatic
// Warcontext: Rescue some civils
// -----------------------------------------------

private [
	"_unit", "_number", "_position", "_group", "_type", "_civil", "_counter", "_civils", "_respawn_west",
	"_mission_number", "_count"
];

_unit   = _this select 0;
_number = _this select 1;

_position = [_unit, 0, 30, sizeOf "RU_Soldier", 0.2] call WC_fnc_getEmptyPosition;

_group = createGroup civilian;
for "_i" from 1 to _number do {
	_type = wcrescuecivils call WC_fnc_selectRandom;
	_civil = _group createUnit [_type, _position, [], 10, "FORM"];
	wcunits set [count wcunits, _civil];
	wcaddactions = [_civil, "FOLLOW_ME"];
	["wcaddactions", "client"] call WC_fnc_publicvariable;
	_civil stop true;
	sleep 0.1;
};

[_group, civilian] spawn WC_fnc_grouphandler;

_counter = 0;
_civils = units _group;
_group allowFleeing 0;

_respawn_west = getMarkerPos "respawn_west";

// Get the current mission number.
_mission_number = wccurrentmission select 0;

while {!wcmissionsuccess} do {
	_count = 0;
	{
		if (([_x, _respawn_west] call WC_fnc_getDistance) < 100) then {
			_x doMove _respawn_west;
			_count = _count + 1;
		};
		if (!alive _x) then {
			_civils = _civils - [_x];
		};
	} forEach _civils;

	if (_count == count _civils) then {
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

	if (count _civils < floor (0.80 * _number)) then {
		wcmessageW = [localize "STR_WC_MESSAGEMISSIONFAILED", localize "STR_WC_MESSAGELEAVEZONE"];
		["wcmessageW", "client"] call WC_fnc_publicvariable;
		wcmissionsuccess = true;
	};

	if (_counter > 24) then {
		_position = ([leader _group] call WC_fnc_getPos) findEmptyPosition [1, 20];
		createVehicle ["SmokeShellRed", _position, [], 0, "NONE"];
		wcmessageW = [format ["Still %1 civils", (count _civils - _count)], "to rescue"];
		["wcmessageW", "client"] call WC_fnc_publicvariable;
		_counter = 0;
	};

	_counter = _counter + 1;
	sleep 5;
};
