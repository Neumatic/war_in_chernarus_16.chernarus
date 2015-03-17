// -----------------------------------------------
// Author:     code34 nicolas_boiteux@yahoo.fr
// Edited by:  Neumatic
// Warcontext: Repurposed for event handlers
// -----------------------------------------------

player addEventHandler ["Fired", {
	if (count (getArray (configFile >> "CfgAmmo" >> typeOf (_this select 6) >> "LightColor")) > 1) then {
		_this spawn WC_fnc_flareLightSource;
	};

	if (!wcdetected) then {
		if ((_this select 0) distance wcselectedzone < wcalertzonesize) then {
			if (getText (configFile >> "CfgMagazines" >> (_this select 5) >> "DisplayNameShort") != "SD") then {
				wcalerttoadd = ceil (random 3);
				["wcalerttoadd", "server"] call WC_fnc_publicvariable;
			};
		};
	};

	wcammoused = wcammoused + 1;
}];

player removeAllEventHandlers "HandleDamage";

switch (wckindofgame) do {
	// Arcade mode
	case 1: {
		player addEventHandler ["HandleDamage", {
			if (vehicle (_this select 0) == (_this select 0)) then {
				(_this select 0) setDamage ((damage (_this select 0)) + ((_this select 2) / 10));
			} else {
				(_this select 0) setDamage ((damage (_this select 0)) + ((_this select 2) / 2));
			};
		}];
	};

	// Simulation mode
	case 2: {
		player setVariable ["EH_Selections", []];
		player setVariable ["EH_GetHit", []];

		player addEventHandler ["HandleDamage", {
			private ["_damage"];
			(_this select 0) setMimic "Hurt";
			_damage = _this call WC_fnc_handleDamage;
			_damage
		}];
	};

	// Practice mode
	case 3: {
		player addEventHandler ["Fired", {(_this select 0) setVehicleAmmo 1}];

		player addEventHandler ["HandleDamage", {
			if (vehicle (_this select 0) == (_this select 0)) then {
				(_this select 0) setDamage ((damage (_this select 0)) + ((_this select 2) / 100));
			} else {
				(_this select 0) setDamage ((damage (_this select 0)) + ((_this select 2) / 20));
			};
		}];
	};
};

nil
