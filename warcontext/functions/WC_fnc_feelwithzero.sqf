// -----------------------------------------------
// Author:     code34 nicolas_boiteux@yahoo.fr
// Edited by:  Neumatic
// Warcontext: Feel empty string with 0
// -----------------------------------------------

private ["_variable", "_count"];

_variable = _this select 0;
_count    = if (count _this > 1) then {_this select 1} else {2};

while {count (toArray _variable) < _count} do {
	_variable = format ["0%1", _variable];
};

_variable
