// -----------------------------------------------
// Author:     code34 nicolas_boiteux@yahoo.fr
// Edited by:  Neumatic
// Warcontext: Repair vehicle for engineer
// -----------------------------------------------

private ["_caller", "_object", "_name", "_damage", "_percentage"];

_caller = _this select 1;
_object = _this select 3;

_name = [_object] call WC_fnc_getDisplayName;

if (([_caller, _object] call WC_fnc_getDistance) > 5) exitWith {
	["Repair Vehicle", format ["%1", _name], "Get closer to the vehicle", 3] spawn WC_fnc_playerhint;
};

if (damage _object <= 0) exitWith {
	["Repair Vehicle", format ["%1", _name], "Vehicle is not damaged", 3] spawn WC_fnc_playerhint;
};

_damage = damage _object;
_caller playMove "AinvPknlMstpSlayWrflDnon_medic";

while {_damage > 0 && {alive _caller} && {alive _object}} do {
	sleep 1 + random 1;
	_percentage = 100 - (_damage * 100);
	_caller sideChat format ["Repairing (%1", floor _percentage] + "%)...";
	if ((_damage - 0.01) <= 0) then {
		_damage = 0;
	} else {
		if (animationState _caller != "AinvPknlMstpSlayWrflDnon_medic") then {
			_caller switchMove "AinvPknlMstpSlayWrflDnon_medic";
		};
		_object setDamage (_damage - 0.01);
		_damage = _damage - 0.01;
	};
};

if (!alive _caller || {!alive _object}) exitWith {};

_object setDamage 0;

wcresetgethit = _object;
["wcresetgethit", "server"] call WC_fnc_publicvariable;

_caller sideChat "Repaired (100%)";
["Repair Vehicle", format ["%1", _name], "Vehicle is repaired", 3] spawn WC_fnc_playerhint;
