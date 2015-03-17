// -----------------------------------------------
// Author:     code34 nicolas_boiteux@yahoo.fr
// Edited by:  Neumatic
// warcontext: Restore loadout
// -----------------------------------------------

// Retrait de l'équipement
removeAllWeapons player;
removeAllItems player;
if (!wchasruck) then {removeBackpack player};

// Restauration des armes d'avant le décès
{player addMagazine _x} forEach wcmagazines;
{player addWeapon _x} forEach wcweapons;

if (wcwithACE == 1) then {
	if (wchasruckace) then {
		[player, "ALL"] call ACE_fnc_RemoveGear;
		if (!isNil "wcruckmags") then {
			player setVariable ["ACE_RuckMagContents", wcruckmags];
		};
		if (!isNil "wcruckweapons") then {
			player setVariable ["ACE_RuckWepContents", wcruckweapons];
		};
	};
	if (!isNil "wcweapononback") then {
		[player, "WOB"] call ACE_fnc_RemoveGear;
		player setVariable ["ACE_weapononback", wcweapononback];
	};
	if !(player hasWeapon "ACE_Earplugs") then {
		player addWeapon "ACE_Earplugs";
	};
};
if (wchasruck) then {
	[player, [wcrucktype, wcruckweapons, wcruckmags]] call R3F_REV_FNCT_assigner_sacados;
};

player selectWeapon (primaryWeapon player);
