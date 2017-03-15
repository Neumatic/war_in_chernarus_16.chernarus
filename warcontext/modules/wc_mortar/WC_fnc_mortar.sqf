// -----------------------------------------------
// Author:     code34 nicolas_boiteux@yahoo.fr
// Edited by:  Neumatic
// Warcontext: Create mortar in marker
// -----------------------------------------------

#define MIN_RADIUS 30
#define MAX_RADIUS 60

#define MAX_DISTANCE 1000

private [
	"_marker", "_tries", "_exit", "_mortar_pos", "_wall_pos", "_wall", "_vehicle_array", "_vehicle", "_group", "_gunner",
	"_dir", "_ammo_he", "_ammo_smoke", "_check", "_cool_down", "_cool_down_max", "_marker_pos", "_position", "_objects",
	"_fire"
];

_marker = _this select 0;

_tries = 0;
_exit = false;
_mortar_pos = [1,1,0];

// Give up to 10 tries to find a position.
while {!_exit && {format ["%1", _mortar_pos] == "[1,1,0]"}} do {
	_mortar_pos = [_marker, "onground", "onflat"] call WC_fnc_createpositioninmarker;
	if (_tries > 10) then {_exit = true} else {sleep 0.5};
};

if (_exit) exitWith {};

_wall_pos = [_mortar_pos select 0, (_mortar_pos select 1) + 1.5, _mortar_pos select 2];
_wall = "Land_fort_bagfence_round" createVehicle _wall_pos;
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

if (wcwithACE == 1) then {
	_ammo_he = "ACE_ARTY_Sh_82_HE";
	_ammo_smoke = "ACE_ARTY_SmokeShellWhite";
} else {
	_ammo_he = "ARTY_Sh_82_HE";
	_ammo_smoke = "ARTY_SmokeShellWhite";
};

_check = true;
_cool_down = 0;
_cool_down_max = round (random 6);
_marker_pos = getMarkerPos _marker;

while {_check} do {
	if (alive _vehicle && {count crew _vehicle > 0}) then {
		if (_cool_down > _cool_down_max) then {
			if (count wcmortarposition > 0) then {
				_position = wcmortarposition select 0;

				if (round (_marker_pos distance _position) <= MAX_DISTANCE) then {
					// Make sure there are no friendly units on the position.
					_objects = _position nearEntities ["CAManBase", MAX_RADIUS];
					if ({side _x in wcenemyside} count _objects == 0) then {
						wcmortarposition = wcmortarposition - [_position];
						_gunner doWatch _position;
						_fire = true;
					} else {
						_fire = false;
					};

					if (_fire) then {
						_position = [
							(_position select 0) + ([MIN_RADIUS, MAX_RADIUS] call WC_fnc_seed),
							(_position select 1) + ([MIN_RADIUS, MAX_RADIUS] call WC_fnc_seed),
							(_position select 2) + 20
						];

						if (random 1 > 0.05) then {
							_ammo_he createVehicle _position;
						} else {
							_ammo_smoke createVehicle _position;
						};
					};
				};
			};

			_cool_down = 0;
			_cool_down_max = round (random 6);
		};

		sleep 5;
		_cool_down = _cool_down + 1;
	} else {
		_vehicle setDamage 1;
		_check = false;
	};
};

if (alive _gunner) then {
	[_group, getPos (leader _group), 150] spawn WC_fnc_patrol;
};
