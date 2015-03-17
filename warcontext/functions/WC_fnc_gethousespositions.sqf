// -----------------------------------------------
// Author:     code34 nicolas_boiteux@yahoo.fr
// Edited by:  Neumatic
// Warcontext: Get all houses position in a zone
// Parameters: Can be top, bot, all
// -----------------------------------------------

#define HOUSE_TOP "top"
#define HOUSE_BOT "bot"
#define HOUSE_ALL "all"

private ["_position", "_type", "_distance", "_positions", "_houses", "_index"];

_position = _this select 0;
_type     = if (count _this > 1) then {toLower (_this select 1)} else {HOUSE_ALL};
_distance = if (count _this > 2) then {_this select 2} else {300};

if (count _position < 3) then {_position = [(_this select 0) select 0, (_this select 0) select 1, 0]};

_positions = [];
_houses = _position nearObjects ["House", _distance];
{
	if (damage _x <= 0) then {
		_index = 0;
		while {format ["%1", _x buildingPos _index] != "[0,0,0]"} do {
			_position = _x buildingPos _index;
			switch (_type) do {
				case HOUSE_TOP: {
					if (_position select 2 > 1) then {
						_positions set [count _positions, _position];
					};
				};
				case HOUSE_BOT: {
					if (_position select 2 < 1) then {
						_positions set [count _positions, _position];
					};
				};
				case HOUSE_ALL: {
					_positions set [count _positions, _position];
				};
			};
			_index = _index + 1;
		};
	};
} forEach _houses;

_positions
