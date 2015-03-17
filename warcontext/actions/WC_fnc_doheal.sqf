// -----------------------------------------------
// Author:     code34 nicolas_boiteux@yahoo.fr
// Edited by:  Neumatic
// Warcontext: Heal other player when not medic
// -----------------------------------------------

private ["_caller", "_unit"];

_caller = _this select 1;
_unit   = _this select 3;

_caller playMove "AinvPknlMstpSlayWrflDnon_medic";
sleep 4;

wcresetgethit = _unit;
["wcresetgethit", "server"] call WC_fnc_publicvariable;

_unit setDamage 0;
