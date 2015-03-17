// -----------------------------------------------
// Author:     code34 nicolas_boiteux@yahoo.fr
// Edited by:  Neumatic
// Warcontext: Pop enemy group of faction at pos
// -----------------------------------------------

private ["_faction", "_side", "_position", "_size", "_types", "_rand", "_group", "_unit"];

_faction  = _this select 0;
_side     = _this select 1;
_position = _this select 2;
_size     = if (count _this > 3) then {_this select 3} else {[4,7] select (random 1)};

_types = [];

switch (true) do {
	// Retrieve all units of east faction
	case (_side in wcenemyside): {
		{
			if ((_x select 0) == _faction) then {
				if !((_x select 1) in wcblacklistenemyclass) then {
					_types set [count _types, _x select 1];
				};
			};
		} forEach wcclasslist;
	};

	// Retrieve all units of west faction
	case (_side in wcside): {
		{
			if ((_x select 0) == _faction) then {
				if !((_x select 1) in wcwestblacklist) then {
					_types set [count _types, _x select 1];
				};
			};
		} forEach (wcwestside select 1);
	};
};

if (count _types > _size) then {
	while {count _types > _size} do {
		_rand = random (count _types - 1);
		_types set [_rand, "<DELETE>"];
		_types = _types - ["<DELETE>"];
	};
};

_group = createGroup _side;

while {count _types > 0} do {
	_rand = random (count _types - 1);
	_unit = _types select _rand;
	_group createUnit [_unit, _position, [], 10, "FORM"];
	_types set [_rand, "<DELETE>"];
	_types = _types - ["<DELETE>"];
	sleep 0.05;
};

_group
