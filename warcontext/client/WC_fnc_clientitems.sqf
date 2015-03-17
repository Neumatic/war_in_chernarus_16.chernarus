// -----------------------------------------------
// Author:     code34 nicolas_boiteux@yahoo.fr
// Edited by:  Neumatic
// Warcontext: Add/remove player items here
// -----------------------------------------------

private ["_items", "_ace_items"];

removeBackpack player;

// Add items here
_items = [
	"ITEMGPS",
	"Binocular",
	"ItemRadio"
];

{
	if !(player hasWeapon _x) then {
		player addWeapon _x;
	};
} forEach _items;

// Add ACE items here
if (wcwithACE == 1) then {
	_ace_items = [
		"ACE_Earplugs"
	];

	{
		if !(player hasWeapon _x) then {
			player addWeapon _x;
		};
	} forEach _ace_items;
};
