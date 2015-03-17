/*
	Author: Neumatic
	Description: Removes action menu of target object.

	Parameter(s):
		0: [Object] Target to remove action menu from.
		1: [Scalar/String] Action menu index.

	Example(s):
		[player, 0] call WC_fnc_removeAction;

	Returns:
		Boolean
*/

private ["_target", "_act_id", "_removed"];

_target = _this select 0;
_act_id = _this select 1;

_removed = false;

if (typeName _act_id == "STRING") then {
	_act_id = _target getVariable _act_id;
};

if (!isNil "_act_id") then {
	_target removeAction _act_id;
	_removed = true;
};

_removed
