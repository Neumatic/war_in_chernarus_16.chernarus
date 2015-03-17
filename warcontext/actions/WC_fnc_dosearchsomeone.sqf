// -----------------------------------------------
// Author:     code34 nicolas_boiteux@yahoo.fr
// Edited by:  Neumatic
// Warcontext: Search some one
// -----------------------------------------------

private ["_unit", "_caller", "_role_type"];

_unit   = _this select 0;
_caller = _this select 1;

player sideChat "Searching...";
sleep ceil (random 10);

if (!alive _unit || {!alive _caller}) exitWith {};

if (primaryWeapon _unit != "") then {
	player sideChat "Remove your weapons!";

	sleep ceil (random 5);

	wcplaymove = [_unit, "AinvPknlMstpSlayWrflDnon_medic"];
	["wcplaymove", "server"] call WC_fnc_publicvariable;
	sleep 6;

	wcremoveallweapons = _unit;
	["wcremoveallweapons", "server"] call WC_fnc_publicvariable;

	wcplaymove = [_unit, "AmovPercMstpSnonWnonDnon_AmovPercMstpSsurWnonDnon"];
	["wcplaymove", "server"] call WC_fnc_publicvariable;
};

if (!alive _unit || {!alive _caller}) exitWith {};

sleep ceil (random 10);

switch (side _unit) do {
	case civilian: {
		_role_type = ["bomberman","propagander","altercation","saboter"];

		if (format ["%1", _unit getVariable "oldcivilrole"] in _role_type) then {
			[format ["Search %1", name _unit], "You found a person of intrest", "You should arrest him and bring him back to base", 10] spawn WC_fnc_playerhint;

			if (!isNil {_unit getVariable "Action_Search"}) then {
				wcremoveaction = [_unit, "Action_Search"];
				["wcremoveaction", "client"] call WC_fnc_publicvariable;
			};

			wcaddactions = [_unit, "FOLLOW_ME"];
			["wcaddactions", "client"] call WC_fnc_publicvariable;

			wchintW = parseText format ["<t color='#33CC00'>%1</t> has found a person of intrest", name _caller];
			["wchintW", "client"] call WC_fnc_publicvariable;
		} else {
			[format ["Search %1", name _unit], "Nothing seems to be suspect", "Search others civil if you have some doubt", 10] spawn WC_fnc_playerhint;
			_unit setVariable ["civilrole", nil, true];

			if (!isNil {_unit getVariable "Action_Search"}) then {
				wcremoveaction = [_unit, "Action_Search"];
				["wcremoveaction", "client"] call WC_fnc_publicvariable;
			};
		};
	};

	case east: {
		[format ["Search %1", name _unit], "You have taken a POW", "You should bring him back to base", 10] spawn WC_fnc_playerhint;

		if (!isNil {_unit getVariable "Action_Search"}) then {
			wcremoveaction = [_unit, "Action_Search"];
			["wcremoveaction", "client"] call WC_fnc_publicvariable;
		};

		wcaddactions = [_unit, "FOLLOW_ME"];
		["wcaddactions", "client"] call WC_fnc_publicvariable;
	};
};
