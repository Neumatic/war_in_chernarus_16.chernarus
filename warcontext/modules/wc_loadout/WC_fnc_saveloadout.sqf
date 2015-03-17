// -----------------------------------------------
// Author:     code34 nicolas_boiteux@yahoo.fr
// Edited by   Neumatic
// Warcontext: Save loadout
// -----------------------------------------------

wcmagazines = magazines player;
wcweapons = weapons player;

wchasruck = false;
wchasruckace = false;

wcruckmags = [];
wcruckweapons = [];
wcweapononback = [];

if (!isNull unitBackpack player) then {
	wchasruck = true;
	wcbackpack = unitBackpack player;
	wcrucktype = typeOf wcbackpack;
	wcruckmags = getMagazineCargo wcbackpack;
	wcruckweapons = getWeaponCargo wcbackpack;
};

if (wcwithACE == 1) then {
	wcweapononback = player getVariable "ACE_weapononback";
	if (player call ace_sys_ruck_fnc_hasRuck) then {
		wcrucktype = player call ACE_Sys_Ruck_fnc_FindRuck;
		wcruckmags = player getVariable "ACE_RuckMagContents";
		wcruckweapons = player getVariable "ACE_RuckWepContents";
		wchasruckace = true;
	};
};
