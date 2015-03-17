// -----------------------------------------------
// Author:     code34 nicolas_boiteux@yahoo.fr
// Edited by:  Neumatic
// Warcontext: Do a construction for mission
// -----------------------------------------------

private ["_object", "_caller"];

_object = _this select 0;
_caller = _this select 1;

["Build construction site", localize "STR_WC_MESSAGEBUILDING", localize "STR_WC_MESSAGEBUILDINGINFORMATION", 8] spawn WC_fnc_playerhint;
_caller playMove "AinvPknlMstpSlayWrflDnon_medic";
sleep 8;

if (!alive _caller) exitWith {};

_object setVariable ["wcbuild", true, true];

wcremoveaction = [_object, "Action_Build"];
["wcremoveaction", "client"] call WC_fnc_publicvariable;
