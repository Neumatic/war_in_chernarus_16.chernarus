// -----------------------------------------------
// Author:     code34 nicolas_boiteux@yahoo.fr
// Warcontext: Check if weapon can use flare, with wich mag, muzzles
// -----------------------------------------------

private ["_weapon", "_canFlare", "_muzzle", "_magazine"];

_weapon = _this select 0;

if (count (getArray (configFile >> "CfgWeapons" >> _weapon >> "muzzles")) > 1) then {
	_canFlare = true;
	_muzzle = (getArray (configFile >> "CfgWeapons" >> _weapon >> "muzzles") select 1);
	_magazine = (getArray (configFile >> "CfgWeapons" >> _weapon >> _muzzle >> "magazines") select 1);
} else {
	_canFlare = false;
	_muzzle = [];
	_magazine = [];
};

[_canFlare, _muzzle, _magazine]
