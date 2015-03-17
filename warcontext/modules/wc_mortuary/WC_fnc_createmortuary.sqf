// -----------------------------------------------
// Author:     code34 nicolas_boiteux@yahoo.fr
// Edited by:  Neumatic
// Warcontext: Deployed a mortuary
// -----------------------------------------------

private ["_position", "_y_todo", "_x_start", "_y_start", "_position_2", "_count", "_type_of", "_vehicle", "_position_3"];

_position = _this select 0;

_y_todo = wcnumberofkilled / 10;
_x_start = (_position select 0) - (5 * 5);
_y_start = (_position select 1) - ((_y_todo / 2) * 5);
_position = [_x_start, _y_start];

while {true} do {
	_position = [(_position select 0) + 5, _position select 1];
	_position_2 = _position;

	_count = 0;

	while {_count < 20} do {
		if (wcgrave > 0) then {
			wcgrave = wcgrave - 1;

			_position_2 = [_position_2 select 0, (_position_2 select 1) + 5];

			_type_of = wcgravetype call WC_fnc_selectRandom;
			_vehicle = createVehicle [_type_of, _position_2, [], 0, "NONE"];
			[_vehicle] call WC_fnc_alignToTerrain;

			_position_3 = [_position_2 select 0, (_position_2 select 1) - 1];
			_vehicle = createVehicle ["Grave", _position_3, [], 0, "NONE"];
			[_vehicle] call WC_fnc_alignToTerrain;

			_count = _count + 1;
			sleep 0.5;
		} else {sleep 60};
	};
};
