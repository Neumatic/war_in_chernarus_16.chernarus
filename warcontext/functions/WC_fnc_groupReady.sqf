/*
	Author: Neumatic
	Description: Checks if the group is ready by checking all units in group.
	If there are no units alive in the group true will be returned as default.

	Parameter(s):
		0: [Group] Group.

	Example(s):
		_ready = [group player] call WC_fnc_groupReady;
		-> _ready = false;

	Returns:
		Bool
*/

private ["_ready"];

_ready = true;

if ({alive _x && {!unitReady _x}} count (units (_this select 0)) > 0) then {
	_ready = false;
};

_ready
