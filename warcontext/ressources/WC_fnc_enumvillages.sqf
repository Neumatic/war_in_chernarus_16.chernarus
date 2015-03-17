// -----------------------------------------------
// Author:     code34 nicolas_boiteux@yahoo.fr
// Edited by:  Neumatic
// Warcontext: Parse villages on map
// -----------------------------------------------

#define OBJECT_BLACKLIST ["Land_runway_edgelight"]

private [
	"_last_pos", "_zone_size", "_zone_size_2", "_zone_size_3", "_respawn_west", "_locations", "_temp", "_water", "_array",
	"_check"
];

_last_pos = [0,0,0];
_zone_size = 300;
_zone_size_2 = _zone_size * 2;
_zone_size_3 = _zone_size / 2;
_respawn_west = getMarkerPos "respawn_west";

_locations = [];

for "_y" from (wcmapbottomleft select 1) to (wcmaptopright select 1) step _zone_size do {
	for "_x" from (wcmapbottomleft select 0) to (wcmaptopright select 0) step _zone_size do {
		_temp = [_x,_y,0];

		if ((_temp distance _respawn_west > 1000) && {(_temp distance _last_pos > _zone_size_2)}) then {
			_water = false;

			_array = [_temp, _zone_size_3] call WC_fnc_creategridofposition;
			if ({surfaceIsWater _x} count _array > 0) then {
				_water = true;
			};

			if (!_water) then {
				_check = true;

				_array = _temp nearObjects ["House", _zone_size];
				if ({typeOf _x in OBJECT_BLACKLIST} count _array > 0) then {
					_check = false;
				};

				if (_check) then {
					if (count _array > wcminimunbuildings) then {
						_locations set [count _locations, _temp];
						_last_pos = _temp;
					};
				};
			};
		};

		sleep 0.01;
	};

	sleep 0.01;
};

// Max towns
if (count _locations > wccomputedzones) then {
	while {count _locations > wccomputedzones} do {
		_temp = random (count _locations - 1);
		_locations set [_temp, "<DELETE>"];
		_locations = _locations - ["<DELETE>"];
	};
};

{
	wctownlocations set [count wctownlocations, createLocation ["NameVillage", _x, _zone_size_3, _zone_size_3]];
	sleep 0.01;
} forEach _locations;

["INFO", format ["Created %1 town locations", count wctownlocations]] call WC_fnc_log;

nil
