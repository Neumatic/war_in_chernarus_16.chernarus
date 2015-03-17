/*
	Author: Carl Gustaffa
	Edited by: Demonized and Neumatic
	Description: Creates light source when unit fires flare.

	Parameter(s):
		_this

	Example(s):
		_this spawn WC_fnc_flareLightSource;

	Returns:
		nil
*/

private ["_unit", "_projectile", "_color", "_r", "_g", "_b", "_a", "_li"];

_unit       = _this select 0;
_projectile = _this select 6;

if (!alive _projectile) exitWith {};
if !(count (getArray (configFile >> "CfgAmmo" >> typeOf _projectile >> "LightColor")) > 1) exitWith {};

_color = getArray (configFile >> "CfgAmmo" >> typeOf _projectile >> "LightColor");
_r = _color select 0;
_g = _color select 1;
_b = _color select 2;
_a = _color select 3;
_li = "#lightpoint" createVehicleLocal [0,0,0];
_li setLightBrightness 0.24;
_li setLightAmbient [(_r * 0.8), (_g * 0.8), (_b * 0.8)];
_li setLightColor [_r, _g, _b];
_li lightAttachObject [_projectile, [0,0,0]];

[_projectile] spawn {
	private ["_projectile", "_pos"];

	_projectile = _this select 0;

	while {alive _projectile} do {
		_pos = [_projectile] call WC_fnc_getPos;
		_projectile setPosASL [(_pos select 0) + 0.05 * (wind select 0), (_pos select 1) + 0.05 * (wind select 1), (_pos select 2) + 0.1];
		sleep 0.075;
	};
};

waitUntil {!alive _projectile};
deleteVehicle _li;

_unit setVariable ["WC_FlareShot", true, false];
