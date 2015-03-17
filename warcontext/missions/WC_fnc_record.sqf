// -----------------------------------------------
// Author:     code34 nicolas_boiteux@yahoo.fr
// Edited by:  Neumatic
// Warcontext: Record a discussion
// -----------------------------------------------

private [
	"_group", "_leader", "_units", "_position", "_recording_time", "_mission_number", "_leader_pos", "_find",
	"_near_units", "_message"
];

_group = _this select 0;

_leader = leader _group;
_units = units _group;

(_units select 0) setDir 0;
_position = [_units select 0] call WC_fnc_getPos;
(_units select 1) setPos [_position select 0, (_position select 1) + 2];
(_units select 1) setDir 180;

(_units select 0) disableAI "ANIM";
(_units select 1) disableAI "ANIM";

(_units select 0) switchMove "AidlPercSnonWnonDnon_talk1";
sleep (5 + random 10);
(_units select 1) switchMove "AidlPercSnonWnonDnon_talk1";

{
	wcunits set [count wcunits, _x];
} forEach units _group;

_recording_time = 0;

// Get the current mission number.
_mission_number = wccurrentmission select 0;

while {!wcmissionsuccess} do {
	_leader_pos = [_leader] call WC_fnc_getPos;

	if ({alive _x} count _units == 0) then {
		wcmessageW = [localize "STR_WC_MESSAGEMISSIONFAILED", localize "STR_WC_MESSAGELEAVEZONE"];
		["wcmessageW", "client"] call WC_fnc_publicvariable;
		wcmissionsuccess = true;
	};

	if (wcalert > 99) then {
		if ({alive _x} count _units > 0) then {
			(_units select 0) enableAI "ANIM";
			(_units select 1) enableAI "ANIM";

			[_group, _leader_pos, 300, false] spawn WC_fnc_patrol;
		};

		wcmessageW = [localize "STR_WC_MESSAGEMISSIONFAILED", localize "STR_WC_MESSAGELEAVEZONE"];
		["wcmessageW", "client"] call WC_fnc_publicvariable;
		wcmissionsuccess = true;
	};

	_find = false;
	_near_units = _leader_pos nearEntities ["CAManBase", 10];
	{
		if (isPlayer _x && {!_find}) then {
			_recording_time = _recording_time + 1;
			_find = true;
		};
		if (isPlayer _x && {side _x in wcside} && {_leader knowsAbout _x > 1}) then {
			wcalert = 100;
		};
	} forEach _near_units;

	if (_recording_time > 100) then {
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
	} else {
		if (_find) then {
			if ((_recording_time mod 10) == 0) then {
				_message = format ["Progression: %1", _recording_time] + "%";
				wcmessageW = ["Recording", _message];
				["wcmessageW", "client"] call WC_fnc_publicvariable;
			};
		};
	};

	sleep 1;
};
