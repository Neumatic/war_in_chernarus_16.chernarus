/*
	Author: Neumatic
	Description: Selects a random number then selects the intel message.

	Parameter(s):
		nil

	Optional parameter(s):
		0: [Bool] Defend mode.

	Example(s):
		_intel = [true] call WC_fnc_getVehicleIntel;

	Returns:
		Array
*/

private ["_num", "_intel"];

_num = switch (typeName (_this select 0)) do {
	case "OBJECT": {[0, 3] call WC_fnc_randomMinMax};
	case "BOOL": {0};
};

_intel = switch (_num) Do {
	case 0: {localize "STR_INTEL0"};
	case 1: {localize "STR_INTEL1"};
	case 2: {localize "STR_INTEL2"};
	case 3: {localize "STR_INTEL3"};
};

[_num, _intel]
