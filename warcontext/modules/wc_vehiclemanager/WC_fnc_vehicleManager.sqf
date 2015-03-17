/*
	Author: AgentRev
	Edited by: Neumatic
	Description: Inspired by AgentRevs vehicle manager.

	Parameter(s):
		nil

	Example(s):
		[] spawn WC_fnc_vehicleManager;

	Returns:
		nil
*/

#define MOVEMENT_RESCAN_CYCLE 5
#define MOVEMENT_DISTANCE_RESCAN 100
#define DISABLE_DISTANCE_MOBILE 2000
#define DISABLE_DISTANCE_IMMOBILE 1000

private ["_FNC_EventCode", "_FNC_VehicleManager", "_last_pos", "_R3F_attach_point", "_cam_pos"];

_FNC_EventCode = {
	private ["_vehicle"];
	_vehicle = _this select 0;
	if (!simulationEnabled _vehicle) then {_vehicle enableSimulation true};
	_vehicle setVariable ["fpsFix_simulationCooloff", diag_tickTime + 20];
};

_FNC_VehicleManager = {
	private ["_all_objects", "_vehicle", "_enable", "_vehicle_pos", "_distance", "_velocity"];

	_all_objects = nearestObjects [wcmapcenter, ["LandVehicle","Air"], 20000];
	{
		if (_x != _R3F_attach_point) then {
			_vehicle = _x;
			_enable = true;

			_vehicle_pos = [_vehicle] call WC_fnc_getPos;

			if (!local _vehicle && {count crew _vehicle == 0
			&& {_vehicle getVariable ["fpsFix_simulationCooloff", 0] < diag_tickTime}
			&& {_vehicle_pos select 2 < 1}}
			) then {
				_distance = _vehicle_pos distance (positionCameraToWorld [0,0,0]);
				_velocity = (velocity _vehicle) distance [0,0,0];

				if (_distance > DISABLE_DISTANCE_MOBILE
				|| {_velocity < 0.1 && {_distance > DISABLE_DISTANCE_IMMOBILE}}
				) then {
					_vehicle enableSimulation false;
					_enable = false;
				};
			};

			if (_enable && {!simulationEnabled _vehicle}) then {
				_vehicle enableSimulation true;
			};

			if !(_vehicle getVariable ["fpsFix_eventHandlers", false]) then {
				_vehicle addEventHandler ["GetIn", _FNC_EventCode];
				_vehicle addEventHandler ["HandleDamage", _FNC_EventCode];
				_vehicle addEventHandler ["Killed", _FNC_EventCode];

				_vehicle setVariable ["fpsFix_eventHandlers", true];
			};
		};
		sleep 0.01;
	} forEach _all_objects;

	nil
};

_last_pos = [0,0,0];
_R3F_attach_point = objNull;

while {true} do {
	_cam_pos = positionCameraToWorld [0,0,0];

	if (_last_pos distance _cam_pos > MOVEMENT_DISTANCE_RESCAN) then {
		if (isNull _R3F_attach_point && {!isNil "R3F_LOG_PUBVAR_point_attache"}) then {
			_R3F_attach_point = R3F_LOG_PUBVAR_point_attache;
		};

		objNull call _FNC_VehicleManager;
		_last_pos = _cam_pos;
	};

	sleep MOVEMENT_RESCAN_CYCLE;
};
