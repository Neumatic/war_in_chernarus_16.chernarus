// -----------------------------------------------
// Author:     code34 nicolas_boiteux@yahoo.fr
// Edited by:  Neumatic
// Warcontext: Unflip vehicle for engineer
// -----------------------------------------------

private ["_caller", "_object", "_name"];

_caller = _this select 1;
_object = _this select 3;

_name = [_object] call WC_fnc_getDisplayName;

if (([_caller, _object] call WC_fnc_getDistance) > 5) exitWith {
	[localize "STR_WC_MENUUNFLIPVEHICLE", format ["%1", _name], "Get closer to the vehicle", 3] spawn WC_fnc_playerhint;
};

if (locked _object) exitWith {
	[localize "STR_WC_MENUUNFLIPVEHICLE", format ["%1", _name], "Unlock the vehicle before trying to unflip it", 3] spawn WC_fnc_playerhint;
};

if ({alive _x} count crew _object > 0) exitWith {
	[localize "STR_WC_MENUUNFLIPVEHICLE", format ["%1", _name], "Crew still in the vehicle. Dismount them before trying to unflip it", 3] spawn WC_fnc_playerhint;
};

_caller playMove "AinvPknlMstpSlayWrflDnon_medic";
sleep 10;

if (!alive _caller || {!alive _object}) exitWith {};

if (local _object) then {
	_object setVectorUp [0,0,1];
} else {
	wcsetvectorup = [_object, [0,0,1]];
	["wcsetvectorup", "server"] call WC_fnc_publicvariable;
};
