// -----------------------------------------------
// Author:     code34 nicolas_boiteux@yahoo.fr
// Edited by:  Neumatic
// Warcontext: Remove a personal respawn tent
// -----------------------------------------------

private ["_object", "_caller", "_owner"];

_object = _this select 0;
_caller = _this select 1;

_caller playMove "AinvPknlMstpSlayWrflDnon_medic";
sleep 8;

if (!isNull _object && {!alive _caller}) exitWith {};

_owner = wctent getVariable "owner";

wcremoveaction = [_object, "Action_RemoveTent"];
["wcremoveaction", "client"] call WC_fnc_publicvariable;

wchintW = parseText format ["<t color='#33CC00'>%1's</t> tent was removed", _owner];
["wchintW", "client"] call WC_fnc_publicvariable;

deleteVehicle _object;
