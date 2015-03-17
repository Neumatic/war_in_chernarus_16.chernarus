/*
	Author: Neumatic
	Description: Spawns adds and removes road patrol convoys from the road patrol
	convoys array from games start to games end.

	Parameter(s):
		nil

	Example(s):
		[] spawn WC_fnc_initRoadPatrols;

	Returns:
		nil
*/

private [
	"_respawn_west", "_number", "_run", "_position", "_sleep", "_roads", "_vehicles", "_convoy_group", "_vehicle_array",
	"_vehicle", "_crew", "_group"
];

_respawn_west = getMarkerPos "respawn_west";

while {true} do {
	if (count WC_RoadConvoys < wcconvoylevel) then {
		_number = [1, 3] call WC_fnc_randomMinMax;

		_run = true;

		/*
			We get a random town locations position then check if that position
			is far enough away from the respawn point. If it is then we check if
			there are any players around that position. If no players are around
			then we get a road position to spawn the convoy at.
		*/
		while {_run} do {
			_position = position (wctownlocations call WC_fnc_selectRandom);
			_sleep = false;

			if (_position distance _respawn_west > 1000) then {
				if ({([_x, _position] call WC_fnc_getDistance) < 1000} count ([] call BIS_fnc_listPlayers) == 0) then {
					_roads = _position nearRoads 300;
					if (count _roads > 0) then {
						_position = [_roads call WC_fnc_selectRandom] call WC_fnc_getPos;
						_run = false;
					} else {_sleep = true};
				} else {_sleep = true};
			} else {_sleep = true};

			if (_sleep) then {sleep 0.1};
		};

		_vehicles = [];

		/*
			Creates a new road patrol convoy group. The first vehicle of the group
			will always be a turreted vehicle. The rest of the groups vehicles
			can either be a turreted vehicle or an unarmed convoy vehicle.
		*/
		_convoy_group = createGroup east;
		for "_i" from 1 to _number do {
			if (_number > 1 && {random 1 > 0.5} && {_i > 1}) then {
				_vehicle_array = [_position, random 360, wcconvoyvehicles call WC_fnc_selectRandom, east] call WC_fnc_spawnVehicle;
			} else {
				_vehicle_array = [_position, random 360, wcvehicleslistE call WC_fnc_selectRandom, east] call WC_fnc_spawnVehicle;
			};

			_vehicle = _vehicle_array select 0;
			_crew    = _vehicle_array select 1;
			_group   = _vehicle_array select 2;

			/*
				Set the vehicle and the vehicle group to protected so that when
				the mainloop cleans up they will not be deleted. Then we set the
				lock, fuel. Then the vehicle handler and the anti rollover scripts
				are spawned. The group joins the main convoy group and their old
				group is deleted.
			*/
			_vehicle setVariable ["wcprotected", true];
			{
				_x setVariable ["wcprotected", true];
			} forEach units _group;

			_vehicle lock true;
			_vehicle setFuel wcenemyglobalfuel;

			[_vehicle, east] spawn WC_fnc_vehiclehandler;
			[_vehicle] spawn EXT_fnc_atot;

			_vehicles set [count _vehicles, _vehicle];

			_crew joinSilent _convoy_group;
			deleteGroup _group;

			sleep 1;
		};

		/*
			The convoy group spawns the group handler and is sent to the road
			patrol script. The convoy group and the vehicles of the group are
			added the convoys array.
		*/
		[_convoy_group, east] spawn WC_fnc_grouphandler;
		[_convoy_group, _vehicles] spawn WC_fnc_roadpatrol;

		WC_RoadConvoys set [count WC_RoadConvoys, [_convoy_group, _vehicles]];
	} else {
		sleep 300 + random 300;
	};

	/*
		If no units in the group or no vehicles are left alive then we remove
		the convoy from the convoys array so we can start a new one.
	*/
	{
		_group    = _x select 0;
		_vehicles = _x select 1;
		if ({alive _x || {canMove _x}} count _vehicles == 0 || {{alive _x} count units _group == 0}) then {
			WC_RoadConvoys = WC_RoadConvoys - [_x];
		};
	} forEach WC_RoadConvoys;

	sleep 30;
};