// -----------------------------------------------
// Author:     code34 nicolas_boiteux@yahoo.fr
// Edited by:  Neumatic
// Warcontext: Enums compositions
// -----------------------------------------------

private ["_side", "_compositions", "_side_num", "_entry"];

_side = _this select 0;

_compositions = [];

_side_num = switch (_side) do {
	case east: {0};
	case west: {1};
	case resistance: {2};
	case civilian: {3};
};

_entry = configFile >> "CfgObjectCompositions";
for "_i" from 0 to (count _entry - 1) do {
	if (getNumber ((_entry select _i) >> "side") == _side_num) then {
		_compositions set [count _compositions, configName (_entry select _i)];
	};
};

_compositions
