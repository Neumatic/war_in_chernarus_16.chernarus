// -----------------------------------------------
// Author:     code34 nicolas_boiteux@yahoo.fr
// Edited by:  Neumatic
// Warcontext: Teleport to tent
// -----------------------------------------------

private ["_caller", "_position", "_vehicle"];

_caller = _this select 1;

_position = wcrespawnposition select 0;
_vehicle  = wcrespawnposition select 1;

if (format ["%1", _position] == "any") exitWith {hint "No respawn point avalaible"};
if (format ["%1", _vehicle] == "any") exitWith {hint "No respawn point avalaible"};

if (alive _vehicle && {([_vehicle, _position] call WC_fnc_getDistance) < 100}) then {
	if (leader group _caller == _caller) then {
		{
			if (!isPlayer _x && {([_x, _caller] call WC_fnc_getDistance) < 50}) then {
				_position = [_vehicle, 5, 10, 10, _caller] call WC_fnc_findEmptyPosition;
				_x setPosASL _position;
			};
		} forEach units group _caller;
	};

	_position = [_vehicle, 5, 10, 10, _caller] call WC_fnc_findEmptyPosition;
	_caller setPosASL _position;
} else {
	hint "No respawn point avalaible";
};
