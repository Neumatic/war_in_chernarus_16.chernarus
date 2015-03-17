// -----------------------------------------------
// Author:     code34 nicolas_boiteux@yahoo.fr
// Edited by:  Neumatic
// Warcontext: Add an addaction menu depending on target
// -----------------------------------------------

private ["_target", "_menu_service", "_menu_repair", "_menu_unlock", "_menu_unflip", "_vehicle", "_name"];

while {true} do {
	_target = cursorTarget;

	if (([player, _target] call WC_fnc_getDistance) < 10 && {alive _target && {_target == cursorTarget}}) then {
		_menu_service = nil;
		_menu_repair = nil;
		_menu_unlock = nil;
		_menu_unflip = nil;

		_vehicle = vehicle player;

		if (_vehicle != player) then {
			if ((typeOf _target) in wcrepairpointtype) then {
				_name = [_target] call WC_fnc_getDisplayName;
				_menu_service = _vehicle addAction [format ["<t color='#ffcb00'>%1</t>", _name], "warcontext\modules\wc_repairzone\WC_fnc_servicing.sqf", _vehicle, 6, false, true];
			};
		} else {
			if ((typeOf player) in wcengineerclass) then {
				if (_target isKindOf "LandVehicle" || {_target isKindOf "Air"}) then {
					_menu_repair = player addAction ["<t color='#ffcb00'>" + localize "STR_WC_MENUREPAIRVEHICLE" + "</t>", "warcontext\actions\WC_fnc_dorepairvehicle.sqf", _target, 6, false];

					if !(_target isKindOf "StaticWeapon") then {
						_menu_unlock = player addAction ["<t color='#ffcb00'>" + localize "STR_WC_MENUUNLOCKVEHICLE" + "</t>", "warcontext\actions\WC_fnc_dounlockvehicle.sqf", _target, 6, false];
						_menu_unflip = player addAction ["<t color='#ffcb00'>Unflip Vehicle</t>", "warcontext\actions\WC_fnc_dounflipvehicle.sqf", _target, 6, false];
					};
				};
			};
		};

		waitUntil {sleep 0.5; ([player, _target] call WC_fnc_getDistance) > 10 || {!alive _target || {_target != cursorTarget}}};

		if (!isNil "_menu_service") then {_vehicle removeAction _menu_service};
		if (!isNil "_menu_repair") then {player removeAction _menu_repair};
		if (!isNil "_menu_unlock") then {player removeAction _menu_unlock};
		if (!isNil "_menu_unflip") then {player removeAction _menu_unflip};
	};

	sleep 0.5;
};
