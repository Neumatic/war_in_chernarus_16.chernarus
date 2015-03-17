private [
	"_count",
	"_destinationreached",
	"_emptyposition",
	"_enemys",
	"_enemyposition",
	"_group",
	"_groupv",
	"_helo",
	"_leader",
	"_leadertarget",
	"_pilot",
	"_spawn",
	"_target",
	"_targetmarker",
	"_targettingdistance",
	"_unit",
	"_vehicle"
];
	
_spawn = _this select 0; 																							// parameters passed by calling script
_targetmarker = _this select 1;
_target = getMarkerPos _targetmarker;

_destinationreached = false;
_count = 0;
//_spawn = getMarkerPos "spawnmarker"; //use for offline testing
//_target = getMarkerPos "targetmarker"; //use for offline testing
_vehicle = ["ACE_Mi17_RU"] call BIS_fnc_selectRandom; //"UH1H_TK_EP1", "Mi17_Ins"


_group = createGroup east;																							// infantry group
_groupv = createGroup east;																							// vehicle crew group. Could possibly be merged since we unassign the vehicle anyways.
//_emptyposition = _spawn findEmptyPosition [4000,5000, _vehicle];														// find an emptyposition to spawn the helo, the helo will be flund into the air regardless, but-
																													// this could be used to have the vehicle spawn in a random arc around the target

//_helo = _vehicle createVehicle [(_emptyposition select 0) + 30, _emptyposition select 1, _emptyposition select 2]; // old methood, here the helo spawns on the ground-
//_groupv addVehicle _helo;																							 // and the passengers plus crew must be moved into it
//_vehcrew = [_helo,_groupv] call BIS_fnc_spawnCrew;

sleep random 120;
_vehiclearray = [[_spawn select 0, _spawn select 1, 300], 0, "ACE_Mi17_RU", _groupv] call BIS_fnc_spawnvehicle;		// spawn the vehicle
_helo = _vehiclearray select 0;																						// put the helo's "object in an easy to identify array;
_emptypositions = (_helo emptypositions "cargo");																	// count the cargo positions to detemrine how many passengers to spawn

// ADD HELO TO WC_fnc_vehiclehandler
wcgarbage = [_helo] spawn WC_fnc_vehiclehandler;

for "_x" from 1 to _emptypositions do {																				// here we spawn passengers based on available cargo spots
	_soldier = _group createUnit [(wcspecialforces call BIS_fnc_selectRandom), _spawn, [], 0, "FORM"];
};

// ADD INFANTRY IN HELO TO WC_fnc_grouphandler
wcgarbage = [_group] spawn WC_fnc_grouphandler;

_leader = leader _group;																							// find leader of group
_helo flyinheight 300;																								// set helo flying height

{
	_x assignAsCargo _helo;
	_x moveInCargo _helo;
}forEach units _group;																								// loop to assign and move each passenger into the plane

_units = count (units _group);
hint str _units;

while {((_helo distance _target) > 150) && (alive _helo) && (alive driver _helo) && (canMove _helo) && ((fuel _helo) > 0) && (!_destinationreached) && ((damage _helo) < 4)} do {
	_pilot = driver _helo;
	_helo flyinheight 300;
	_pilot doMove [_target select 0, _target select 1, 300];
	_groupv setBehaviour "AWARE";
	_groupv setCombatMode "YELLOW";
	_groupv setSpeedMode "FULL";
	
	if ((_helo distance [_target select 0, _target select 1, (getPos _helo select 2)]) < 350) then {
		_destinationreached = true;
		{	
			if ((speed _helo) < 120) then {
				_helovelocity = velocity _helo;
				_helodirection = direction _helo;
				_speedmultiplier = 3;
				_helo setVelocity [(_helovelocity select 0)+(sin _helodirection * _speedmultiplier),(_helovelocity select 1)+(cos _helodirection * _speedmultiplier),(_helovelocity select 2)];
				player globalchat format["speed%1", (speed _helo)];
			};
			_helo flyinheight 300;
			if (vehicle _x == _helo) then {
				_x action ["eject", vehicle _x];
				unassignVehicle _x;
				sleep 0.4;
			};
		}forEach assignedCargo _helo;
		
		_groupv setBehaviour "COMBAT";
		_groupv setCombatMode "RED";
		_groupv setSpeedMode "FULL";
	};

player globalchat format["distance%1", (_helo distance _target)];
sleep 6;
};
player globalchat "move loop end";

if !(_destinationreached) then {
player globalchat "dumping";
	{
		_x action ["eject", vehicle _x];
		unassignVehicle _x;
		sleep 0.4;
	}forEach assignedCargo _helo;
};
// cargo unloaded, delete helo and units for nopw

deleteVehicle _helo;
{
	deleteVehicle _x;
}forEach units _groupv;

// give the paratroopers orders

while {(count (units _group) > 0) && ((_leader distance _target) > wcdistance)} do {
	hint "final loops";
	_group setBehaviour "COMBAT";
	_group setCombatMode "RED";
	_group setSpeedMode "FULL";
	if !(isNull _leader) then {
		_enemys = nearestObjects [_leader, ["Man", "LandVehicle"], 400];
	};
	_targettingdistance = 400;
	{
		if(vehicle _x == _x) then {
		player globalchat "1";
			if (side _x == west) then {
			player globalchat "2";
				_leader reveal _x;
				if(_leader distance _x < _targettingdistance) then { _targettingdistance = _leader distance _x; _leadertarget = _x;};
				_count = _count + 1;
			};
		}else {
			if(count(crew _x) > 0) then {
			player globalchat "3";
				if (side (driver(_x)) == west) then {
				player globalchat "4";
					_leader reveal _x;
					if( _leader distance _x < _targettingdistance) then { _targettingdistance = _leader distance _x; _leadertarget = _x;};
					_count = _count + 1;
				};
			};
		};
		sleep 1;
		player globalchat format["enemies=%1", _count];
	}forEach _enemys;
	
	{
		_unit = _x;	
		if(_count == 0) then {
			_unit doMove _target;
		}else {
			_unit doWatch _leadertarget;
			_unit doTarget _leadertarget;
			_unit doFire _leadertarget;
			_unit reveal _leadertarget;
			_enemyposition = ([position _leadertarget, 10, 360, getDir _leadertarget, 5] call WC_fnc_createcircleposition) call BIS_fnc_selectRandom;
			_unit doMove _enemyposition;
		};
		sleep 0.05;
	}forEach units _group;
	sleep 30;
};

if(count (units _group) == 0) exitWith {};
wcgarbage = [(leader _group), _targetmarker, 'noslow', 'showmarker'] execVM 'extern\upsmon.sqf';