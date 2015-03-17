// -----------------------------------------------
// Author:     code34 nicolas_boiteux@yahoo.fr
// Edited by:  Neumatic
// Warcontext: Respawn vehicle at their original position
// -----------------------------------------------

// Timer for empty vehicles.
#define EMPTY_VEHICLE_CYCLE 10
#define EMPTY_VEHICLE_COUNT 1080

private [
	"_vehicle", "_FNC_InitVehicle", "_fuel", "_ammo", "_empty", "_respawn", "_start_pos", "_start_dir", "_type_of",
	"_objets_charges", "_var_name"
];

_vehicle = _this select 0;

_FNC_InitVehicle = {
	private ["_vehicle"];

	_vehicle = _this select 0;

	if (wckindofgame == 2) then {
		_vehicle addEventHandler ["Killed", {
			wcaddtogarbage = _this select 0;
			["wcaddtogarbage", "server"] call WC_fnc_publicvariable;
		}];
	};

	_vehicle removeAllEventHandlers "HandleDamage";

	_vehicle setVariable ["EH_Selections", []];
	_vehicle setVariable ["EH_GetHit", []];

	_vehicle addEventHandler ["HandleDamage", {
		private ["_damage"];
		_damage = _this call WC_fnc_handleDamage;
		_damage
	}];

	_vehicle addEventHandler ["Fired", {
		if (!wcdetected) then {
			if (([_this select 0, wcselectedzone] call WC_fnc_getDistance) < wcalertzonesize) then {
				wcalerttoadd = ceil (random 5);
				["wcalerttoadd", "server"] call WC_fnc_publicvariable;
			};
		};
	}];

	// Broadcast vehicle variable.
	_vehicle setVariable ["WC_VehiclePlayer", true, true];
};

if (wcwithrandomfuel == 1) then {
	_fuel = 0.2 + random 0.8;
	_ammo = 0.5 + random 0.5;

	_vehicle setFuel _fuel;
	_vehicle setVehicleAmmo _ammo;
};

[_vehicle] spawn _FNC_InitVehicle;

// If simulation vehicles not respawn
if (wckindofgame == 2) exitWith {};

_empty = 0;
_respawn = false;

_start_pos = [_vehicle] call WC_fnc_getPos;
_start_dir = getDir _vehicle;
_type_of = typeOf _vehicle;

while {true} do {
	if (alive _vehicle) then {
		if (([_vehicle, _start_pos] call WC_fnc_getDistance) > 10) then {
			if ({alive _x} count crew _vehicle == 0) then {
				_empty = _empty + 1;

				if (_empty > EMPTY_VEHICLE_COUNT) then {
					_respawn = true;
				};
			} else {
				_empty = 0;
			};
		} else {
			_empty = 0;
		};
	} else {
		sleep wctimetorespawnvehicle;
		_respawn = true;
	};

	if (_respawn) then {
		_objets_charges = _vehicle getVariable ["R3F_LOG_objets_charges", []];
		[_vehicle] call WC_fnc_deleteObject;

		sleep 5;

		_vehicle = createVehicle [_type_of, _start_pos, [], 0, "NONE"];
		_vehicle setDir _start_dir;
		[_vehicle] call WC_fnc_alignToTerrain;
		_vehicle setVariable ["R3F_LOG_objets_charges", _objets_charges, true];

		if (wcwithrandomfuel == 1) then {
			_vehicle setFuel _fuel;
			_vehicle setVehicleAmmo _ammo;
		};

		[_vehicle] spawn _FNC_InitVehicle;

		_var_name = objNull call WC_fnc_createObjName;
		[_vehicle, _var_name] spawn WC_fnc_setVehicleVarName;

		["INFO", format ["Vehicle %1 : %2 : respawned at base : _empty=%3", _var_name, [_type_of] call WC_fnc_getDisplayName, _empty]] call WC_fnc_log;

		_empty = 0;
		_respawn = false;
	};

	sleep EMPTY_VEHICLE_CYCLE;
};
