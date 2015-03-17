// -----------------------------------------------
// Author:     code34 nicolas_boiteux@yahoo.fr
// Edited by:  Neumatic
// Warcontext: Nasty thing happen to vehicle after sabotage
// -----------------------------------------------

private ["_unit", "_sabotage"];

_unit = _this select 0;

_sabotage = ["fuel","explosion","weapon","sabotage","speed","ied"] call WC_fnc_selectRandom;

switch (_sabotage) do {
	case "fuel": {
		_unit setVariable ["typeofsabotage", "fuel", false];
		_unit setDamage 0.05;
		while {damage _unit > 0} do {
			if (speed _unit > 1) then {
				if ({alive _x} count crew _unit > 0) then {
					_unit setFuel (fuel _unit - 0.05);
				};
			};
			sleep 1;
		};
		_unit vehicleChat "VEHICLE WAS SABOTAGED!";
		_unit setDamage 1;
	};

	case "explosion": {
		_unit setVariable ["typeofsabotage", "explosion", false];
		while {alive _unit} do {
			if ({alive _x} count crew _unit > 2) then {
				if (speed _unit > (30 + random 30)) then {
					{
						_x setDamage (0.9 + random 0.5);
					} forEach crew _unit;
					_unit vehicleChat "VEHICLE WAS SABOTAGED!";
					_unit setDamage 1;
				};
			};
			sleep 1;
		};
	};

	case "weapon": {
		_unit setVariable ["typeofsabotage", "ammo", false];
		_unit setVehicleAmmo 0;
	};

	case "sabotage": {
		_unit setVariable ["typeofsabotage", "sabotage", false];
		_unit setDamage 0.95;
	};

	case "ied": {
		_unit setVariable ["typeofsabotage", "ied", false];
		[_unit] spawn WC_fnc_createied;
	};
};
