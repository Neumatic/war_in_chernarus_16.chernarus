// -----------------------------------------------
// Author:     code34 nicolas_boiteux@yahoo.fr
// Edited by:  Neumatic
// Warcontext: ACE SYS WEAPONS reworks
// -----------------------------------------------

private ["_side", "_weapons", "_weapons_list", "_name"];

_side = _this select 0;

_weapons = [];

switch (_side) do {
	case west : {
		_side = ["USMC","BIS_GER","BIS_US","CIV"];
	};

	case east : {
		_side = ["RU"];
	};

	case resistance : {
		_side = ["GUE"];
	};

	case civilian : {
		_side = ["CIV"];
	};

	case "all" : {
		_side = ["USMC","BIS_GER","BIS_US","RU","GUE","CIV"];
	};

	default {
		_side = ["USMC","BIS_GER","BIS_US"];
	};
};

{
	_weapons_list = [_x, ["RIFLE","PISTOL","EQUIP","ITEM","RUCK","LAUNCHER","SNIPER","MG","AR"]] call ace_fnc_enumWeapons;
	{
		{
			_name = format ["%1", toLower (_x select 0)];
			if !(_name in _weapons) then {
				_weapons set [count _weapons, _name];
			};
		} forEach _x;
	} forEach (_weapons_list select 0);
} forEach _side;

_weapons
