// -----------------------------------------------
// Author:     code34 nicolas_boiteux@yahoo.fr
// Edited by:  Neumatic
// Warcontext: Init civilian with a queue for less lag
// -----------------------------------------------

private ["_unit"];

_unit = _this select 0;

switch (_unit getVariable ["civilrole", ""]) do {
	case "bomberman": {
		_unit addBackpack "TK_ALICE_Pack_Explosives_EP1";
		[_unit] spawn WC_fnc_createied;
	};

	case "propagander": {
		[_unit] spawn WC_fnc_propagand;
	};

	case "altercation": {
		[_unit] spawn WC_fnc_altercation;
	};

	case "saboter": {
		_unit addBackpack "TK_ALICE_Pack_Explosives_EP1";
		[_unit] spawn WC_fnc_sabotercivilian;
	};

	case "builder": {
		[_unit] spawn WC_fnc_buildercivilian;
	};

	case "healer": {
		[_unit] spawn WC_fnc_healercivilian;
	};

	case "driver": {
		[_unit] spawn WC_fnc_drivercivilian;
	};

	default {};
};

nil
