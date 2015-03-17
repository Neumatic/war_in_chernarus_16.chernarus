// Terrain following radar
// Simple version build 006 (1 scan point ahead)
if (!isServer) exitWith {};

private ["_vehicle", "_scanner", "_tfrlevel", "_mydir", "_myspeed", "_mylevel", "_lowlimit"];

_vehicle = _this select 0;

_lowlimit = 60;
_scanner = createVehicle ["HeliHEmpty", getPos _vehicle, [], 0, "NONE"];

_vehicle addEventHandler ["Gear", {
	if (_this select 1) then {
		(_this select 0) setVariable ["wclanding", true, false];
	} else {
		(_this select 0) setVariable ["wclanding", false, false];
	};
}];

while {canMove _vehicle && {damage _vehicle < 0.9}} do {
	if (isPlayer (driver _vehicle)) then {waitUntil {!isPlayer (driver _vehicle)};};
	if (_vehicle getVariable ["wclanding", false]) then {waitUntil {!(_vehicle getVariable ["wclanding", false])};};
	if (abs (speed _vehicle) > 30) then {
		_mylevel = (getPosATL _vehicle) select 2;
		_mydir = getDir _vehicle;
		_myspeed = speed _vehicle;
		_scanner setPos [(getPos _vehicle select 0) + ((sin _mydir) * _myspeed), (getPos _vehicle select 1) + ((cos _mydir) * _myspeed), _mylevel];
		_tfrlevel = (getPosATL _scanner) select 2;
		if (_tfrlevel < _lowlimit) then {_vehicle setVelocity [velocity _vehicle select 0, velocity _vehicle select 1, (velocity _vehicle select 2) + (_lowlimit - _tfrlevel)]};
	};
	sleep 0.5;
};

deleteVehicle _scanner;