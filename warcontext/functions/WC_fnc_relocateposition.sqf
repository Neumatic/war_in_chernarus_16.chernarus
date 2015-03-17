// -----------------------------------------------
// Author:     code34 nicolas_boiteux@yahoo.fr
// Edited by:  Neumatic
// Warcontext: Relocate a position on a town
// -----------------------------------------------

private ["_position", "_max", "_result", "_positions", "_houses"];

_position = _this select 0;

_max = 0;
_result = [0,0,0];

while {format ["%1", _position] != format ["%1", _result]} do {
	_result = _position;

	_positions = [_position, 100 + random 800] call WC_fnc_creategridofposition;
	{
		_houses = _x nearObjects ["House", 150];
		if (count _houses > _max) then {
			_max = count _houses;
			_position = _x;
		};
	} forEach _positions;
};

_position
