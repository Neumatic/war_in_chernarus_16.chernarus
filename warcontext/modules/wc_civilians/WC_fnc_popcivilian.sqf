// -----------------------------------------------
// Author:     code34 nicolas_boiteux@yahoo.fr
// Edited by:  Neumatic
// Warcontext: Pop civilian (replace BIS MODULE)
// -----------------------------------------------

private [
	"_town_pos", "_count", "_town_pos", "_active", "_back", "_positions", "_count", "_number", "_spawn_pos", "_civil_class",
	"_civil_type", "_position", "_civil_role", "_group", "_civil"
];

_town_pos = _this select 0;

_count = count (_town_pos nearObjects ["House", 500]);
if (_count < wcwithcivilian) exitWith {
	["ERROR", "WC_fnc_popcivilian", format ["Not enough houses for civilians : count=%1 : wcwithcivilian=%2", _count, wcwithcivilian]] call WC_fnc_log;
};

if (WC_MarkerAlpha > 0) then {
	wcciviltownindex = wcciviltownindex + 1;
	[format ["civiltown%1", wcciviltownindex], _town_pos, 500, "ColorBlack", "ELLIPSE", "FDIAGONAL", "EMPTY", 0, "", WC_MarkerAlpha] call WC_fnc_createmarkerlocal;
};

_active = createTrigger ["EmptyDetector", _town_pos];
_active setTriggerArea [wccivildistancepop, wccivildistancepop, 0, false];
_active setTriggerActivation ["ANY", "PRESENT", true];
_active setTriggerStatements ["", "", ""];

_back = [];
_positions = [_town_pos, "all", 500] call WC_fnc_gethousespositions;

_count = count _positions;
_number = [wcwithcivilian * 0.50, wcwithcivilian] call WC_fnc_randomMinMax;
if (_number > _count) then {_number = _count};

_spawn_pos = +_positions;
_civil_class = +wccivilclass;

for "_i" from 1 to _number do {
	_civil_type = _civil_class call WC_fnc_selectRandom;
	_civil_class = _civil_class - [_civil_type];

	_position = _spawn_pos call WC_fnc_selectRandom;
	_spawn_pos = _spawn_pos - [_position];

	if (_civil_type in wccivilwithoutweapons) then {
		_civil_role = "civil";
	} else {
		if (random 1 < wcterroristprobability) then {
			_civil_role = ["bomberman","propagander","altercation","saboter","healer","builder"] call WC_fnc_selectRandom;
		} else {
			if (random 1 < wcciviliandriverprobability) then {
				_civil_role = "driver";
			} else {
				_civil_role = "civil";
			};
		};
	};

	_back set [count _back, [_civil_type, _position, _civil_role]];
};

while {true} do {
	waitUntil {sleep 1; {isPlayer _x} count list _active > 0};

	_group = createGroup civilian;
	{
		_civil = _group createUnit [_x select 0, _x select 1, [], 0, "NONE"];
		wcaddactions = [_civil, "HANDS_UP"];
		["wcaddactions", "client"] call WC_fnc_publicvariable;
		_civil setVariable ["civilrole", _x select 2, true];
		_civil setVariable ["destination", _positions call WC_fnc_selectRandom, false];
		_civil setVariable ["wcprotected", true, false];
		[_civil] call WC_fnc_civilianinit;
	} forEach _back;

	[_group, civilian] spawn WC_fnc_grouphandler;
	[_group, _town_pos] spawn WC_fnc_walkercivilian;

	_back = [];

	waitUntil {sleep 1; {isPlayer _x} count list _active == 0};

	{
		if (alive _x) then {
			_back set [count _back, [typeOf _x, [_x] call WC_fnc_getPos, _x getVariable ["civilrole", "civil"]]];
			[_x] call WC_fnc_deleteObject;
		};
	} forEach units _group;

	deleteGroup _group;
};
