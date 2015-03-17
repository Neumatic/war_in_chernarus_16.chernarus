/*
	Author: Neumatic
	Description: Enemy units with a grenade launcher fire flares.

	Parameter(s):
		0: [Object] Unit
		1: [Array] Array of muzzle, magazine

	Example(s):
		[_unit, ["", true]] call WC_fnc_fireflare;

	Returns:
		nil
*/

private [
	"_unit", "_mags", "_flare_count", "_flare_type", "_knows", "_refill", "_ammo_count", "_flare_muzzle", "_shoot_flare",
	"_target", "_FNC_AddFlares", "_targets", "_targets_query", "_object", "_side", "_known_pos", "_new_target", "_distance",
	"_units"
];

_unit = _this select 0;
_mags = _this select 1;

// Total flare count, no more then 8.
_flare_count = 4;

// Select the flare color.
switch (faction _unit) do {
	case "RU": {
		_flare_type = ["FlareRed_GP25","FlareWhite_GP25"] call WC_fnc_selectRandom;
	};

	case "INS": {
		_flare_type = ["FlareGreen_GP25","FlareRed_GP25","FlareWhite_GP25","FlareYellow_GP25"] call WC_fnc_selectRandom;
	};

	case "GUE": {
		_flare_type = ["FlareGreen_GP25","FlareRed_GP25","FlareWhite_GP25","FlareYellow_GP25"] call WC_fnc_selectRandom;
	};
};

// Get the current knowsAbout.
_knows = (WC_KnowsAbout + 2) - (wcskill * 2);

// Refill his flares after he fires them all?
_refill = true;

// Units flare ammo count.
_ammo_count = _flare_count;

// Get the flare muzzle.
_flare_muzzle = _mags select 1;

_shoot_flare = false;
_target = objNull;

_FNC_AddFlares = {
	private ["_unit", "_flare_type", "_flare_count", "_mag_count", "_mag_total", "_magazines", "_count_mags", "_resize"];

	_unit        = _this select 0;
	_flare_type  = _this select 1;
	_flare_count = _this select 2;

	// Maximum number of magazines the unit can have for flares to fit.
	_mag_count = 12;
	_mag_total = 20;

	// Make sure the flare count is no more then 8.
	if (_flare_count > 8) then {_flare_count = 8};

	_magazines = [];

	// Get the current magazines from the unit.
	{
		_unit removeMagazine _x;
		_magazines set [count _magazines, _x];
	} forEach magazines _unit;

	_count_mags = count _magazines;

	// Make sure we have enough room to add the flares.
	if (_count_mags > _mag_count) then {
		_resize = _mag_total - _flare_count;

		if (_count_mags > _resize) then {
			_magazines resize _resize;
		};
	};

	// Add flares to magazines.
	for "_i" from 1 to _flare_count do {
		_magazines set [count _magazines, _flare_type];
	};

	// Add the magazines to unit.
	{
		_unit addMagazine _x;
	} forEach _magazines;

	nil
};

// Add the flares the to unit.
[_unit, _flare_type, _flare_count] call _FNC_AddFlares;

// Set the units flare variables.
_unit setVariable ["WC_FlareShot", false, false];
_unit setVariable ["WC_Flaring", false, false];

// When unit fires a flare it creates a light source.
_unit addEventHandler ["Fired", {
	if (count (getArray (configFile >> "CfgAmmo" >> typeOf (_this select 6) >> "LightColor")) > 1)then {
		_this spawn WC_fnc_flareLightSource;
	};
}];

// Main loop.
while {alive _unit} do {
	// Check if it is sun down.
	if (objNull call WC_fnc_sunAngle) then {
		// Check if unit is in a vehicle.
		if (vehicle _unit != _unit) then {
			while {alive _unit && {vehicle _unit != _unit}} do {sleep 5};
		};

		if (alive _unit) then {
			_targets = [];

			// Get targets from units targetsQuery.
			_targets_query = _unit targetsQuery ["","","","",""];
			{
				_object    = _x select 1;
				_side      = _x select 2;
				_known_pos = _x select 4;
				if (alive _object && {_unit knowsAbout _object > _knows} && {_side in wcside} && {([_unit, _object] call WC_fnc_getDistance) <= 300}) then {
					if (_object isKindOf "CAManBase"
					|| {(_object isKindOf "LandVehicle" && {(!isNull effectiveCommander _object && {alive effectiveCommander _object})})}
					) then {
						_targets set [count _targets, [_object, _known_pos]];
					};
				};
			} forEach _targets_query;

			_new_target = [objNull, [0,0]];

			if (count _targets > 0) then {
				_distance = 1000;

				// Get the closest target.
				{
					_object    = _x select 0;
					_known_pos = _x select 1;
					if (alive _object && {([_unit, _known_pos] call WC_fnc_getDistance) < _distance}) then {
						_distance = [_unit, _known_pos] call WC_fnc_getDistance;
						_new_target = [_object, _known_pos];
					};
				} forEach _targets;
			};

			_target    = _new_target select 0;
			_known_pos = _new_target select 1;

			if (!isNull _target && {alive _target}) then {
				_units = (([_unit] call WC_fnc_getPos) nearEntities ["CAManBase", 150]) - [_unit];

				// Check if any friendly units near the unit are currently firing flares.
				if ({side _x in wcenemyside && {_x getVariable ["WC_Flaring", false]}} count _units == 0) then {
					_shoot_flare = true;
				} else {
					_shoot_flare = false;
				};

				// If the unit still has flares then fire a flare.
				if (_shoot_flare && {_ammo_count > 0}) then {
					_unit setVariable ["WC_Flaring", true, false];
					_unit doWatch _known_pos;
					_unit doTarget _target;
					sleep 0.5;

					_unit selectWeapon _flare_muzzle;
					_unit fire [_flare_muzzle, _flare_muzzle, _flare_type];
					_ammo_count = _ammo_count - 1;

					_unit doWatch objNull;

					// Wait for the flare that was fired to be done.
					waitUntil {_unit getVariable ["WC_FlareShot", false]};

					_unit setVariable ["WC_FlareShot", false, false];
					_unit setVariable ["WC_Flaring", false, false];
				};
			};

			sleep 60 + random 60;

			// If the unit is out of flares and refill is true then give the unit more flares.
			if (_refill && {_ammo_count == 0}) then {
				[_unit, _flare_type, _flare_count] call _FNC_AddFlares;
				_ammo_count = _flare_count;

				sleep 180;
			};
		};
	} else {
		sleep 60;
	};
};

// Reset variables when the unit dies.
_unit setVariable ["WC_FlareShot", false, false];
_unit setVariable ["WC_Flaring", false, false];
