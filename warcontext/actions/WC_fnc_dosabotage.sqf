// -----------------------------------------------
// Author:     code34 nicolas_boiteux@yahoo.fr
// Edited by:  Neumatic
// Warcontext: Do sabotage
// -----------------------------------------------

private ["_object", "_caller", "_param", "_light"];

_object = _this select 0;
_caller = _this select 1;
_param  = _this select 3;

_light = if (count _param == 0) then {false} else {true};

["Sabotage",  localize "STR_WC_MESSAGESABOTING", localize "STR_WC_MESSAGESABOTINGINFORMATION", 8] spawn WC_fnc_playerhint;
_caller playMove "AinvPknlMstpSlayWrflDnon_medic";
sleep 8;

if (!alive _caller) exitWith {};

["Sabotage", localize "STR_WC_MESSAGESABOTINGFINISHED", localize "STR_WC_MESSAGESABOTINGINFORMATION", 8] spawn WC_fnc_playerhint;

_object setVariable ["wcsabotage", true, true];

wcremoveaction = [_object, "Action_Sabotage"];
["wcremoveaction", "client"] call WC_fnc_publicvariable;

if (_light) then {
	wcswitchlightsall = [[_object] call WC_fnc_getPos, "OFF", 500];
	["wcswitchlightsall", "server"] call WC_fnc_publicvariable;
};
