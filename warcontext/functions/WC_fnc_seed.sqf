// -----------------------------------------------
// Author:     code34 nicolas_boiteux@yahoo.fr
// Warcontext: Create seed
// -----------------------------------------------

private ["_min", "_max", "_seed", "_rand"];

_min = _this select 0;
_max = _this select 1;

_rand = _max - _min;
_seed = random _rand;
_seed = _seed + _min;

if (random 1 > random 1) then {_seed = _seed * -1};

_seed
