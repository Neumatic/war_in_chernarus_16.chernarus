/*
	Author: Eightbit
	Edited by: Neumatic
	Description: Starts loop for attach/detach addAction when player is driver
	of a vehicle.

	Parameter(s):
		nil

	Example(s):
		[] spawn "addActionLoop.sqf";

	Returns:
		nil
*/

#define VEHICLE_TYPES ["Air","Car","Tank"]

objNull spawn
{
	private ["_id1", "_id2", "_veh"];

	waitUntil {!isNull player && player == player};

	while {true} do
	{
		waitUntil {sleep 0.5; (vehicle player == player) || {((driver (vehicle player)) != player)}};

		if (!isNil "_veh") then
		{
			_veh removeAction _id1;
			_veh removeAction _id2;
		};

		waitUntil {sleep 0.5; ((driver (vehicle player)) == player) && {{(vehicle player) isKindOf _x} count VEHICLE_TYPES > 0}};

		_veh = vehicle player;
		_id1 = _veh addAction ["<t color='#ffcb00'>Attach</t>", "extern\eightbits_scripts\vehicle_attach\attach.sqf", "Attach", 6, false, false];
		_id2 = _veh addAction ["<t color='#ffcb00'>Detach</t>", "extern\eightbits_scripts\vehicle_attach\attach.sqf", "Detach", 6, false, false];
	};
};
