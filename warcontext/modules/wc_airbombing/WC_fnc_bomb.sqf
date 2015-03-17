// -----------------------------------------------
// Author:     code34 nicolas_boiteux@yahoo.fr
// Edited by:  Neumatic
// Warcontext: Bombing the mission zone with the C130
// -----------------------------------------------

private [
	"_run", "_position", "_return_to_base", "_dir", "_bomb", "_bombs", "_bombed", "_mission_complete", "_vehicle_array",
	"_vehicle", "_crew", "_start_position"
];

_run = true;

while {_run} do {
	_position = position (wctownlocations call WC_fnc_selectRandom);

	if ({([_x, _position] call WC_fnc_getDistance) < 1000} count ([] call BIS_fnc_listPlayers) == 0) then {
		_run = false;
	} else {sleep 0.1};
};

_dir = [_position, getMarkerPos "rescuezone"] call WC_fnc_dirTo;

_vehicle_array = [[_position select 0, _position select 1, 300], _dir, "C130J", west] call WC_fnc_spawnVehicle;
_vehicle = _vehicle_array select 0;
_crew    = _vehicle_array select 1;

_bombs = 70;
_mission_complete = false;
_vehicle setCaptive true;
_vehicle setDir 0;
_return_to_base = false;

wcmessageW = ["Bombing begins", "Take cover!"];
["wcmessageW", "client"] call WC_fnc_publicvariable;

wcbomb = true;
["wcbomb", "client"] call WC_fnc_publicvariable;
playSound "bomb";

_start_position = getMarkerPos "rescuezone";

while {alive _vehicle && {damage _vehicle < 0.9} && {!_return_to_base} && {_bombs > 1}} do {
	_vehicle flyInHeight 200;
	_position = getMarkerPos "bombzone";
	if (_start_position distance _position > 1500) then {
		_return_to_base = true;
	} else {
		{
			if (side driver _x in wcenemyside) then {
				_position = position _x;
			};
		} forEach (_position nearEntities [["CAManBase","LandVehicle"], 300]);

		if (([_vehicle, _position] call WC_fnc_getDistance) > 1500) then {
			{
				_x doMove _position;
				(group _x) setSpeedMode "FULL";
			} forEach _crew;
			sleep 30;
		};

		if (_bombs > 0) then {
			_bombed = 0;
			while {([_vehicle, _position] call WC_fnc_getDistance) < 300 && {_bombed < 30}} do {
				(group driver _vehicle) setSpeedMode "LIMITED";
				_dir = getDir _vehicle;
				_bomb = "Bo_Mk82" createVehicle [([_vehicle] call WC_fnc_getPos) select 0, ([_vehicle] call WC_fnc_getPos) select 1, (([_vehicle] call WC_fnc_getPos) select 2) - 10];
				_bomb setDir _dir;
				_bomb setVelocity [0,0,-150];
				sleep (random 0.1);
				_bomb = "Bo_FAB_250" createVehicle [([_vehicle] call WC_fnc_getPos) select 0, ([_vehicle] call WC_fnc_getPos) select 1, (([_vehicle] call WC_fnc_getPos) select 2) - 10];
				_bomb setDir _dir;
				_bomb setVelocity [0,0,-150];
				sleep (random 0.1);
				_bombs = _bombs - 2;
				_bombed = _bombed + 2;
			};
			sleep 5;
		} else {
			_position = [0,0];

			{
				_x doMove _position;
			} forEach _crew;

			if (([_vehicle, _position] call WC_fnc_getDistance) < 300) then {
				_vehicle setDamage 1;
				deleteVehicle _vehicle;

				{
					_x setDamage 1;
					deleteVehicle _x;
				} forEach _crew;

				_mission_complete = true;
			};

			sleep 30;
		};
	};
};

wcmessageW = ["Bombing finished", "Go to Battle!"];
["wcmessageW", "client"] call WC_fnc_publicvariable;
diag_log "WARCONTEXT: BOMBING SUPPORT IS FINISHED";

wcbomb = true;
["wcbomb", "client"] call WC_fnc_publicvariable;
playSound "bomb";

_vehicle doMove [0,0,0];
sleep 180;

_vehicle setDamage 1;
deleteVehicle _vehicle;
