// -----------------------------------------------
// Author:     code34 nicolas_boiteux@yahoo.fr
// Edited by:  Neumatic
// Warcontext: Creates a US ammobox on local client side
// -----------------------------------------------

private ["_position", "_auto_load", "_crate", "_marker", "_magazines", "_amount_weapons", "_amount_ammo", "_refresh_time"];

_position  = _this select 0;
_auto_load = _this select 1;

_crate = "USVehicleBox" createVehicleLocal _position;
_crate setPos _position;

wcammocrates set [count wcammocrates, _crate];

clearWeaponCargo _crate;
clearMagazineCargo _crate;

wcammoboxindex = wcammoboxindex + 1;
_marker = [format ["wcammobox%1", wcammoboxindex], _position, 0.5, "ColorYellow", "ICON", "FDIAGONAL", "Select", 0, "Ammobox", 1] call WC_fnc_createmarkerlocal;

_crate addAction ["<t color='#668AFF'>Save Loadout</t>", "warcontext\modules\wc_loadout\WC_fnc_saveloadout.sqf", [], -99, false, true, "", ""];
_crate addAction ["<t color='#668AFF'>Restore Loadout</t>", "warcontext\modules\wc_loadout\WC_fnc_restoreloadout.sqf", [], -99, false, true, "", ""];

_magazines = [];

_amount_weapons = 10;
_amount_ammo = 20;

_refresh_time = 1800;
_crate allowDamage false;

while {!isNull _crate} do {
	clearWeaponCargo _crate;
	clearMagazineCargo _crate;

	switch (toLower _auto_load) do {
		case "addons": {
			{_crate addWeaponCargo [_x, _amount_weapons]} forEach wclistofaddonweapons;
			_magazines = [wclistofaddonweapons] call WC_fnc_enummagazines;
		};

		default {
			{_crate addWeaponCargo [_x, _amount_weapons]} forEach wclistofweapons;
			_magazines = [wclistofweapons + ["Throw", "Put"]] call WC_fnc_enummagazines;
		};
	};

	{_crate addMagazineCargo [_x, _amount_ammo]} forEach _magazines;

	sleep _refresh_time;
};

deleteMarkerLocal _marker;
