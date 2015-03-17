// -----------------------------------------------
// Author:     code34 nicolas_boiteux@yahoo.fr
// Edited by:  Neumatic
// Warcontext: Enum faction
// -----------------------------------------------

private [
	"_side","_side_num","_class_list","_factions","_count","_i","_actual","_class","_vehicle_class","_scope","_side",
	"_faction"
];

_side = _this select 0;

_side_num = switch (_side) do {
	case east: {0};
	case west: {1};
	case resistance: {2};
	case civilian: {3};
};

_class_list = [];
_factions = [];

_count = count (configFile >> "CfgVehicles");
for [{_i = 0}, {_i < _count}, {_i = _i + 1}] do {
	_actual = (configFile >> "CfgVehicles") select _i;
	if (isClass _actual) then {
		_class = configName _actual;
		if (_class isKindOf "Man") then {
			_vehicle_class = getText (configFile >> "CfgVehicles" >> _class >> "vehicleClass");
			if !(_vehicle_class in ["Sounds","Mines"]) then {
				_scope = getNumber (_actual >> "scope");
				_side = getNumber (_actual >> "side");
				if ((_scope == 2) && {(_side == _side_num)}) then {
					_faction = getText (configFile >> "CfgVehicles" >> _class >> "faction");
					if !(_faction in _factions) then {_factions set [count _factions, _faction]};
					_class_list set [count _class_list, [_faction, _class]];
				};
			};
		};
	};
};

[_factions, _class_list]
