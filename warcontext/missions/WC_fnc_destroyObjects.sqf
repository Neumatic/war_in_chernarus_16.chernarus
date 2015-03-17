/*
	Author: Neumatic
	Description: Destroy multiple objects mission.

	Parameter(s):
		0: [String] Type of object
		1: [Array] Position
		2: [Number] How many objects
		3: [Number] Distance from each other

	Optional parameter(s):
		4: [Bool] Camo nets for objects
		5: [Bool] Crew members for objects

	Returns:
		nil
*/

#define OBJECT_TYPES ["Car","Tank","Motorcycle","Air"]

private [
	"_object", "_position", "_number", "_distance", "_camo", "_mission_number", "_crew", "_objects", "_object_type",
	"_vehicle", "_veh_pos", "_new_pos", "_camo_net", "_size", "_group", "_unit"
];

_object   = _this select 0;
_position = _this select 1;
_number   = _this select 2;
_distance = _this select 3;
_camo     = if (count _this > 4) then {_this select 4} else {false};
_crew     = if (count _this > 5) then {_this select 5} else {false};

// Get the current mission number.
_mission_number = wccurrentmission select 0;

// Array that contains all the objects.
_objects = [];

// Add the passed object to the array.
_objects set [count _objects, _object];
wcobjecttodelete set [count wcobjecttodelete, _object];

// Get the type of object.
_object_type = typeOf _object;

for "_i" from 1 to _number do {
	// Create object of the same type as the passed object.
	_vehicle = createVehicle [_object_type, _position, [], _distance, "NONE"];
	_vehicle setDir (random 360);

	// Get the vehicle position.
	_veh_pos = [_vehicle] call WC_fnc_getPos;

	// Set the vehicle at an empty position.
	_new_pos = [_veh_pos, 0, 60, sizeOf _object_type, 0.2] call WC_fnc_getEmptyPosition;
	_vehicle setPos _new_pos;
	[_vehicle] call WC_fnc_alignToTerrain;

	// Add object to handler.
	[_vehicle, east] spawn WC_fnc_vehiclehandler;

	// If object is a vehicle lock and remove fuel.
	if ({_object isKindOf _x} count OBJECT_TYPES > 0) then {
		_vehicle lock true;
		_vehicle setFuel 0;
	};

	// Add the created object to the array.
	_objects set [count _objects, _vehicle];
	wcobjecttodelete set [count wcobjecttodelete, _vehicle];

	// If true then add a camo net.
	if (_camo) then {
		_camo_net = createVehicle ["Land_CamoNetB_EAST", [0,0,0], [], 0, "NONE"];
		_camo_net setDir (getDir _vehicle + 180);
		[_camo_net] call WC_fnc_alignToTerrain;

		wcobjecttodelete set [count wcobjecttodelete, _camo_net];
	};

	// If true create crewman near the object.
	if (_crew) then {
		_size = [1, 3] call WC_fnc_randomMinMax;
		_new_pos = [_veh_pos, 0, 30, sizeOf "RU_Soldier", 0.2] call WC_fnc_getEmptyPosition;

		_group = createGroup east;
		for "_i" from 1 to _size do {
			_unit = _group createUnit [wccrewforces call WC_fnc_selectRandom, _new_pos, [], 10, "NONE"];
			sleep 0.1;
		};

		[_group, east] spawn WC_fnc_grouphandler;
		[_group, _veh_pos, 30, false] spawn WC_fnc_patrol;
	};

	sleep 1;
};

// Main check loop.
while {!wcmissionsuccess} do {
	// Check objects for crew then eject them.
	{
		_object = _x;
		if (count crew _object > 0) then {
			{
				_x action ["Eject", _object];
				unassignVehicle _x;
				(group _x) leaveVehicle _object;
			} forEach crew _object;
		};
	} forEach _objects;

	// If all object are dead then the mission ends.
	if ({alive _x} count _objects == 0) then {
		wcmessageW = [localize "STR_WC_MESSAGEMISSIONCOMPLETED", localize "STR_WC_MESSAGELEAVEZONE"];
		["wcmessageW", "client"] call WC_fnc_publicvariable;

		// Add mission number to mission done array.
		wcmissiondone set [count wcmissiondone, _mission_number];
		wcmissionsuccess = true;
		wcleveltoadd = 1;

		wcfame = wcfame + wcbonusfame;
		wcnuclearprobability = wcnuclearprobability - wcbonusnuclear;
		wcenemyglobalfuel = wcenemyglobalfuel - wcbonusfuel;
		wcenemyglobalelectrical = wcenemyglobalelectrical - wcbonuselectrical;
	};

	sleep 1;
};
