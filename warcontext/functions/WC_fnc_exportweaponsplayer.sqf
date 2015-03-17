// -----------------------------------------------
// Author:     code34 nicolas_boiteux@yahoo.fr
// Edited by:  Neumatic
// Warcontext: Export players weapons & ammo into clipboard
// -----------------------------------------------

private ["_weapons", "_magazines", "_text", "_new_text"];

_weapons = weapons player;
_magazines = magazines player;

_text = format ["player name: %1;", name player];

{
	_new_text = format ["player addWeapon '%1';", _x];
	_text = _text + _new_text;
} forEach _weapons;

{
	_new_text = format ["player addMagazine '%1';", _x];
	_text = _text + _new_text;
} forEach _magazines;

_text = _text + format ["player selectweapon '%1';", primaryWeapon player];

copyToClipboard format ["%1", _text];
hintSilent "Weapons were exported in your clipboard";
