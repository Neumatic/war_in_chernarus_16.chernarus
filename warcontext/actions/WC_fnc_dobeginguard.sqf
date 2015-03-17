// -----------------------------------------------
// Author:     code34 nicolas_boiteux@yahoo.fr
// Edited by:  Neumatic
// Warcontext: Call a defend mission
// -----------------------------------------------

private ["_object", "_caller", "_units"];

_object = _this select 0;
_caller = _this select 1;

_units = ([_caller] call WC_fnc_getPos) nearEntities ["CAManBase", 1000];
if ({isPlayer _x && {side _x in wcside}} count _units < ceil (count ([] call BIS_fnc_listPlayers) * 0.5)) exitWith {
	hint "Not enough players in zone to start mission";
};

wcremoveaction = [_object, "Action_Guard"];
["wcremoveaction", "client"] call WC_fnc_publicvariable;

wcmessageW = ["Turn of duty", "starts now"];
["wcmessageW", "client"] call WC_fnc_publicvariable;

wcbegindefend = true;
["wcbegindefend", "server"] call WC_fnc_publicvariable;
