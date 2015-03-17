/*
	Author: AgentRev
	Edited by: Neumatic
	Description: Get the side of an object.

	Parameter(s):
		0: [Object] Object to get side from.

	Example(s):
		_side = [_vehicle] call WC_fnc_getSide;

	Returns:
		Side
*/

private ["_object", "_config", "_side"];

_object = _this select 0;

if (typeName _object != "STRING") then {
	_object = typeOf _object;
};

_config = configFile >> "CfgVehicles" >> _object >> "side";

if (isNumber _config) then {
	_side = switch (getNumber _config) do {
		case 0: {east};
		case 1: {west};
		case 2: {resistance};
		case 3: {civilian};
		default {nil};
	};
};

if (isNil "_side") then {
	_side = side _object;
};

_side
