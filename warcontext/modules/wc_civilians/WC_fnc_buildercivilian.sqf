// -----------------------------------------------
// Author:     code34 nicolas_boiteux@yahoo.fr
// Edited by:  Neumatic
// Warcontext: Civilian build thing
// -----------------------------------------------

private ["_unit", "_position", "_spawn_pos", "_repair_msg", "_vehicle", "_vehicles", "_msg"];

_unit = _this select 0;

["INFO", format ["Created a civlian repairer : fame=%1", wcfame]] call WC_fnc_log;

_position = [_unit, 0, 150, sizeOf "RU_Soldier", 0.2] call WC_fnc_getEmptyPosition;
_unit setPos _position;

_spawn_pos = [_unit] call WC_fnc_getPos;

_repair_msg = [
	"Let me help you with this.",
	"I used to own a repair shop nearby.",
	"Remember this the next time you come here.",
	"Let me fix this for you."
];

_vehicle = objNull;

while {alive _unit} do {
	_vehicles = [];

	{
		if (alive _x && {damage _x > 0.1}) then {
			_vehicles set [count _vehicles, _x];
		};
	} forEach nearestObjects [[_unit] call WC_fnc_getPos, ["Car","Motorcycle"], 300];

	if (count _vehicles > 0) then {
		_vehicle = _vehicles select 0;

		if (isNull _vehicle && {alive _vehicle}) then {
			while {alive _unit && {alive _vehicle} && {([_unit, _vehicle] call WC_fnc_getDistance) < 300} && {([_unit, _vehicle] call WC_fnc_getDistance) > 8}} do {
				_position = [_vehicle] call WC_fnc_getPos;
				_unit setVariable ["destination", _position, false];
				_unit doMove _position;
				sleep 5;
			};

			if (alive _unit && {alive _vehicle} && {([_unit, _vehicle] call WC_fnc_getDistance) < 8}) then {
				_msg = _repair_msg call WC_fnc_selectRandom;
				_vehicle vehicleChat _msg;

				_unit doWatch _vehicle;
				sleep 3;

				_unit playMove "AinvPknlMstpSlayWrflDnon_medic";
				sleep 8;

				if (alive _unit && {alive _vehicle} && {([_unit, _vehicle] call WC_fnc_getDistance) < 8}) then {
					_vehicle setDamage 0;
					_unit doWatch objNull;
				};
			};
		};
	} else {
		if (([_unit, _unit getVariable "destination"] call WC_fnc_getDistance) < 5) then {
			_position = ([_spawn_pos, "all", 300] call WC_fnc_gethousespositions) call WC_fnc_selectRandom;
			_unit setVariable ["destination", _position, false];
			_unit doWatch objNull;
		};

		_unit doMove _position;

		sleep 30;
	};
};
