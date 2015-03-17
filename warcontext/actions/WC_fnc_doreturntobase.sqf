// -----------------------------------------------
// Author:     code34 nicolas_boiteux@yahoo.fr
// Edited by:  Neumatic
// Warcontext: Teleport to base
// -----------------------------------------------

private ["_caller", "_respawn_west", "_position"];

_caller = _this select 1;

_respawn_west = getMarkerPos "respawn_west";

if (leader group _caller == _caller) then {
	{
		_position = [_respawn_west, 0, 10, 10, _caller] call WC_fnc_findEmptyPosition;
		if (!isPlayer _x && {([_x, _caller] call WC_fnc_getDistance) < 50}) then {
			_x setPosASL _position;
		};
	} forEach units group _caller;
};

_position = [_respawn_west, 0, 10, 10, _caller] call WC_fnc_findEmptyPosition;
_caller setPosASL _position;
