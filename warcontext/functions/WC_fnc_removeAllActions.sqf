/*
	Author: Neumatic
	Description: Removes all object action menus.

	Parameter(s):
		0: [Object] Target to remove action menus from.
		0: [Scalar] Number of actions to remove.

	Example(s):
		[player, 5] call WC_fnc_removeAllActions;

	Returns:
		nil
*/

private ["_target", "_number"];

_target = _this select 0;
_number = if (count _this > 0) then {_this select 0} else {20};

for "_i" from 0 to _number do {
	_target removeAction _i;
};

nil
