/*
	Author: Muzzleflash and DenVdmj
	Edited by: Neumatic
	Description: Checks if two variables are equal to each other. String
	comparisons are case sensitive.

	Parameter(s):
		0: [Anything] Anything.
		1: [Anything] Anything.

	Example(s):
		_bool = [_var_0, _var_1] call WC_fnc_isEqual;

	Returns:
		Bool
*/

private ["_var_0", "_var_1", "_return"];

_var_0 = _this select 0;
_var_1 = _this select 1;

if (isNil "_var_0") exitWith {isNil "_var_1"};
if (typeName _var_0 != typeName _var_1) exitWith {false};
if (typeName _var_0 in ["BOOL","CODE","DIARY_RECORD","SCRIPT","TASK"]) exitWith {_var_0 in [_var_1]};
if (typeName _var_0 in ["SCALAR","STRING","OBJECT","SIDE","GROUP","TEXT","CONFIG","DISPLAY","CONTROL","TEAM_MEMBER"]) exitWith {_var_0 == _var_1};
if (count _var_0 != count _var_1) exitWith {false};

_return = true;

for "_i" from 0 to (count _var_0 - 1) do {
	if !([_var_0 select _i, _var_1 select _i] call WC_fnc_isEqual) exitWith {
		_return = false;
	};
};

_return
