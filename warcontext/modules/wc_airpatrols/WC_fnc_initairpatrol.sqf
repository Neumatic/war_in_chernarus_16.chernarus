// -----------------------------------------------
// Author:     code34 nicolas_boiteux@yahoo.fr
// Edited by:  Neumatic
// Warcontext: Generate until end of game air patrol
// -----------------------------------------------

private [
	"_size", "_respawn_west", "_run", "_location", "_position", "_dir", "_type", "_vehicle_array", "_patrol", "_vehicle",
	"_group"
];

_size = _this select 0;

_respawn_west = getMarkerPos "respawn_west";

while {true} do {
	if (format ["%1", wcairpatrolzone] != "[0,0,0]") then {
		if (count WC_AirPatrols < _size) then {
			_run = true;

			// Get a town location position to spawn at with no players around.
			while {_run} do {
				_location = position (wctownlocations call WC_fnc_selectRandom);
				_position = [(_location select 0) + ([0, 500] call WC_fnc_seed), (_location select 1) + ([0, 500] call WC_fnc_seed), 0];

				if (_position distance _respawn_west > 1000 && {{([_x, _position] call WC_fnc_getDistance) < 1000} count ([] call BIS_fnc_listPlayers) == 0}) then {
					_run = false;
				} else {sleep 0.1};
			};

			// Get dir to air patrol marker.
			_dir = [_position, wcairpatrolzone] call WC_fnc_dirTo;

			// First vehicle will always patrol marker zone. Afterwards it's random whether map wide patrol or marker patrol.
			if (count WC_AirPatrols > 0) then {
				_type = wcairpatroltype call WC_fnc_selectRandom;
				_vehicle_array = [[_position select 0, _position select 1, 300], _dir, _type, east, "RU_Soldier_Pilot"] call WC_fnc_spawnVehicle;
				_patrol = if (random 1 > 0.6) then {true} else {false};
			} else {
				waitUntil {_type = wcairpatroltype call WC_fnc_selectRandom; _type isKindOf "Helicopter"};
				_vehicle_array = [[_position select 0, _position select 1, 100], _dir, _type, east, "RU_Soldier_Pilot"] call WC_fnc_spawnVehicle;
				_patrol = true;
			};

			_vehicle = _vehicle_array select 0;
			_group   = _vehicle_array select 2;

			_vehicle lock true;
			_vehicle setFuel wcenemyglobalfuel;

			// Set the vehicle, and units of group to protected so they will not be deleted on clean up.
			_vehicle setVariable ["wcprotected", true];
			{
				_x setVariable ["wcprotected", true];
			} forEach units _group;

			WC_AirPatrols set [count WC_AirPatrols, _vehicle];

			[_vehicle, east] spawn WC_fnc_vehiclehandler;
			[_group, east] spawn WC_fnc_grouphandler;

			// Send vehicle to air patrol script.
			[_vehicle, _group, _patrol] spawn WC_fnc_airpatrol;
		} else {
			sleep 1800 + random 1800;
		};
	};

	// Remove dead vehicles from air patrols array.
	{
		_vehicle = _x;
		if (isNull _vehicle || {!alive _vehicle} || {!canMove _vehicle} || {{alive _x} count crew _vehicle == 0}) then {
			WC_AirPatrols = WC_AirPatrols - [_vehicle];
		};
	} forEach WC_AirPatrols;

	sleep 60;
};
