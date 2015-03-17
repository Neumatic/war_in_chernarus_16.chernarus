// -----------------------------------------------
// Author:     code34 nicolas_boiteux@yahoo.fr
// Warcontext: Set skill of ai
// -----------------------------------------------

private ["_unit", "_level", "_skill"];

_unit  = _this select 0;
_level = _this select 1;

_skill = [
	"aimingAccuracy",
	"aimingShake",
	"aimingSpeed",
	"endurance",
	"spotDistance",
	"spotTime",
	"courage",
	"reloadSpeed",
	"commanding",
	"general"
];

_unit setSkill _level;

{
	_unit setSkill [_x, _level];
	sleep 0.05;
} forEach _skill;
