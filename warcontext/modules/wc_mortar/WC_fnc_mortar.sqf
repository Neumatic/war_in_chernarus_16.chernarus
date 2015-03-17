// -----------------------------------------------
// Author:     code34 nicolas_boiteux@yahoo.fr
// Edited by:  Neumatic
// Warcontext: Create mortar in marker
// -----------------------------------------------

private [
	"_marker", "_count", "_exit", "_mortar_pos", "_wall_pos", "_wall", "_vehicle_array", "_vehicle", "_group", "_gunner",
	"_dir", "_check", "_cool_down", "_cool_down_max", "_position", "_list", "_do_fire"
];

_marker = _this select 0;

_count = 0;
_exit = false;
_mortar_pos = [1,1,0];

// Give up to 5 seconds to find a position.
while {!_exit && {format ["%1", _mortar_pos] == "[1,1,0]"}} do {
	_mortar_pos = [_marker, "onground", "onflat"] call WC_fnc_createpositioninmarker;

	if (_count >= 10) then {
		_exit = true;
	} else {sleep 0.5};
};

if (_exit) exitWith {};

_wall_pos = [_mortar_pos select 0, (_mortar_pos select 1) + 1.5];
_wall = createVehicle ["Land_fort_bagfence_round", _wall_pos, [], 0, "NONE"];
[_wall] call WC_fnc_alignToTerrain;
wcobjecttodelete set [count wcobjecttodelete, _wall];

_vehicle_array = [_mortar_pos, 0, "2b14_82mm", east] call WC_fnc_spawnVehicle;
_vehicle = _vehicle_array select 0;
_group   = _vehicle_array select 2;

["INFO", format ["Created a mortar in %1", _marker]] call WC_fnc_log;

[_vehicle, east] spawn WC_fnc_vehiclehandler;
[_group, east] spawn WC_fnc_grouphandler;

_gunner = gunner _vehicle;

_dir = getDir _vehicle;
_wall setDir _dir;

_check = true;
_cool_down = 0;
_cool_down_max = round (random 6);

while {_check} do {
	if (!alive _vehicle) exitWith {
		_check = false;
	};

	if (count crew _vehicle == 0) exitWith {
		_vehicle setDamage 1;
		_check = false;
	};

	if (_cool_down > _cool_down_max) then {
		if (count wcmortarposition > 0) then {
			_position = wcmortarposition select 0;
			wcmortarposition set [0, objNull];
			wcmortarposition = wcmortarposition - [objNull];
			_gunner doWatch _position;

			// Make sure there are enemy units and no friendly units on the position.
			_list = _position nearEntities ["CAManBase", 60];
			if ({side _x in wcside} count _list > 0 && {{side _x in wcenemyside} count _list == 0}) then {
				_do_fire = true;
			} else {
				_do_fire = false;
			};

			if (_do_fire) then {
				if (([_gunner, _position] call WC_fnc_getDistance) <= 800) then {
					_position = [(_position select 0) + ([30, 60] call WC_fnc_seed), (_position select 1) + ([30, 60] call WC_fnc_seed), (_position select 2)];

					if (random 1 > 0.1) then {
						if (wcwithACE == 1) then {
							createVehicle ["ACE_ARTY_Sh_82_HE", _position, [], 0, "NONE"];
						} else {
							createVehicle ["ARTY_Sh_82_HE", _position, [], 0, "NONE"];
						};
					} else {
						if (wcwithACE == 1) then {
							createVehicle ["ACE_ARTY_SmokeShellWhite", _position, [], 0, "NONE"];
						} else {
							createVehicle ["ARTY_SmokeShellWhite", _position, [], 0, "NONE"];
						};
					};
				};
			};
		};

		_cool_down = 0;
		_cool_down_max = round (random 6);
	};

	sleep 5;
	_cool_down = _cool_down + 1;
};

if (alive _gunner) then {
	[_group, [leader _group] call WC_fnc_getPos, 150] spawn WC_fnc_patrol;
};
