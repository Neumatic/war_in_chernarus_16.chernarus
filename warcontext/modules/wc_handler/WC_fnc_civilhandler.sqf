// -----------------------------------------------
// Author:     code34 nicolas_boiteux@yahoo.fr
// Edited by:  Neumatic
// Warcontext: Handler for all civil
// -----------------------------------------------

private ["_group"];

_group = _this select 0;

{
	//[_x, wccivilianskill] spawn WC_fnc_setskill;

	_x removeAllEventHandlers "HandleDamage";

	_x setVariable ["EH_Selections", []];
	_x setVariable ["EH_GetHit", []];

	_x addEventHandler ["HandleDamage", {
		private ["_shooter", "_damage"];
		_shooter = _this select 3;
		if (isPlayer _shooter || {side _shooter != side (_this select 0)}) then {
			_damage = _this call WC_fnc_handleDamage;
			_damage
		};
	}];

	_x addEventHandler ["Killed", {
		wcaddtogarbage = _this select 0;
		["wcaddtogarbage", "server"] call WC_fnc_publicvariable;
		if (name (_this select 1) in wcinteam) then {
			wcnumberofkilledofmissionC = wcnumberofkilledofmissionC + 1;
			wccivilkilled = wccivilkilled + 1;
			["wccivilkilled", "client"] call WC_fnc_publicvariable;
			wcfame = wcfame - (random 0.1);
		};
	}];

	_x addEventHandler ["FiredNear", {
		(_this select 0) playMove "AmovPercMstpSnonWnonDnon_AmovPercMstpSsurWnonDnon";
		(_this select 0) stop true;
	}];

	// Unlimited ammo for civilians
	if !(typeOf _x in wccivilwithoutweapons) then {
		_x addEventHandler ["Fired", {(_this select 0) setVehicleAmmo 1}];
	};
} forEach units _group;
