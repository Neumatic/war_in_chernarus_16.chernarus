// -----------------------------------------------
// Author:     code34 nicolas_boiteux@yahoo.fr
// Edited by:  Neumatic
// Warcontext: Teleport to MHQ
// -----------------------------------------------

private ["_caller", "_position", "_vehicle"];

_caller = _this select 1;

_vehicle = wcteleport;

if (format ["%1", _vehicle] == "any") exitWith {hint "No respawn point avalaible"};

if (!isNull _vehicle && {alive _vehicle}) then {
	if (leader group _caller == _caller) then {
		{
			if (!isPlayer _x && {([_x, _caller] call WC_fnc_getDistance) < 50}) then {
				_position = [_vehicle, 10, 20, 10, _caller] call WC_fnc_findEmptyPosition;
				_x setPosASL _position;
			};
		} forEach units group _caller;
	};

	_position = [_vehicle, 10, 20, 10, _caller] call WC_fnc_findEmptyPosition;
	_caller setPosASL _position;
};
