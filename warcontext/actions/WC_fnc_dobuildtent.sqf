// -----------------------------------------------
// Author:     code34 nicolas_boiteux@yahoo.fr
// Edited by:  Neumatic
// Warcontext: Create a tent respawn point
// -----------------------------------------------

private ["_caller", "_exit", "_dir", "_pos", "_position"];

_caller = _this select 1;

if (([_caller, "respawn_west"] call WC_fnc_getDistance) < 300) exitWith {
	[localize "STR_WC_MESSAGEDEPLOYATENT", localize "STR_WC_MESSAGETRYTOMOVEOUT", localize "STR_WC_MESSAGECANCREATETENT", 10] spawn WC_fnc_playerhint;
};

_exit = false;

if (wcwithACE == 0) then {
	if (isNull unitBackpack _caller) then {
		[localize "STR_WC_MESSAGEDEPLOYATENT", localize "STR_WC_MESSAGETAKEABACKPACK", localize "STR_WC_MESSAGECANCREATETENT", 10] spawn WC_fnc_playerhint;
		_exit = true;
	};
} else {
	if !(_caller call ace_sys_ruck_fnc_hasRuck) exitWith {
		[localize "STR_WC_MESSAGEDEPLOYATENT", localize "STR_WC_MESSAGETAKEABACKPACK", localize "STR_WC_MESSAGECANCREATETENT", 10] spawn WC_fnc_playerhint;
		_exit = true;
	};
};

if (_exit) exitWith {};

_dir = getDir _caller;
_pos = [_caller] call WC_fnc_getPos;
_position = [(_pos select 0) + ((sin _dir) * 2), (_pos select 1) + ((cos _dir) * 2), _pos select 2];

if (isNil "wctent") then {
	[localize "STR_WC_MESSAGEDEPLOYATENT", localize "STR_WC_MESSAGEBUILDING", localize "STR_WC_MESSAGEBUILDINGINFORMATION", 8] spawn WC_fnc_playerhint;
	_caller playMove "AinvPknlMstpSlayWrflDnon_medic";
	sleep 8;

	if (!alive _caller) exitWith {};

	wctent = createVehicle ["ACamp", _position, [], 0, "NONE"];
	[wctent] call WC_fnc_alignToTerrain;
	wctent setVariable ["owner", name _caller, true];

	wcaddaction = [wctent, format ["<t color='#ffcb00'>Remove tent of %1</t>", name _caller], "warcontext\actions\WC_fnc_doremovetent.sqf", [], 6, false, true, "", "true", "Action_RemoveTent"];
	["wcaddaction", "client"] call WC_fnc_publicvariable;

	wcrespawnposition = [[_caller] call WC_fnc_getPos, wctent];
	wcrespawnmarker setMarkerAlphaLocal 1;
	wcrespawnmarker setMarkerPosLocal _position;
	wcrespawnmarker setMarkerTextLocal format ["%1 Camp", name _caller];

	[localize "STR_WC_MESSAGEDEPLOYATENT", localize "STR_WC_MESSAGEBUILDINGFINISHED", localize "STR_WC_MESSAGEBUILDINGINFORMATION", 3] spawn WC_fnc_playerhint;
} else {
	if (!alive wctent) then {
		deleteVehicle wctent;

		[localize "STR_WC_MESSAGEDEPLOYATENT", localize "STR_WC_MESSAGEBUILDING", localize "STR_WC_MESSAGEBUILDINGINFORMATION", 8] spawn WC_fnc_playerhint;
		_caller playMove "AinvPknlMstpSlayWrflDnon_medic";
		sleep 8;

		if (!alive _caller) exitWith {};

		wctent = nil;
		wctent = createVehicle ["ACamp", _position, [], 0, "NONE"];
		[wctent] call WC_fnc_alignToTerrain;
		wctent setVariable ["owner", name _caller, true];

		wcaddaction = [wctent, format ["<t color='#ffcb00'>Remove tent of %1</t>", name _caller], "warcontext\actions\WC_fnc_doremovetent.sqf", [], 6, false, true, "", "true", "Action_RemoveTent"];
		["wcaddaction", "client"] call WC_fnc_publicvariable;

		wcrespawnposition = [[_caller] call WC_fnc_getPos, wctent];
		wcrespawnmarker setMarkerAlphaLocal 1;
		wcrespawnmarker setMarkerPosLocal _position;
		wcrespawnmarker setMarkerTextLocal format ["%1 Camp", name _caller];

		[localize "STR_WC_MESSAGEDEPLOYATENT", localize "STR_WC_MESSAGEBUILDINGFINISHED", localize "STR_WC_MESSAGEBUILDINGINFORMATION", 3] spawn WC_fnc_playerhint;
	} else {
		[localize "STR_WC_MESSAGEDEPLOYATENT", localize "STR_WC_MESSAGEREMOVETENT", localize "STR_WC_MESSAGECANBUILDTENT", 10] spawn WC_fnc_playerhint;
	};
};

while {!isNull wctent && {alive wctent}} do {
	sleep 30;
};

wcrespawnmarker setMarkerPosLocal [0,0,0];
wcrespawnmarker setMarkerAlphaLocal 0;
