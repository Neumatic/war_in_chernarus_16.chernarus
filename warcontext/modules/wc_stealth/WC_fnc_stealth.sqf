// -----------------------------------------------
// Author:     code34 nicolas_boiteux@yahoo.fr
// Edited by:  Neumatic
// Warcontext: Player disguised until discovered
// -----------------------------------------------

private ["_unit", "_detected", "_knows", "_near_units", "_group"];

_unit = _this select 0;

// If unit == west no stealth
if (side _unit in wcside) exitWith {};

_detected = false;
_knows = (WC_KnowsAbout + 2) - (wcskill * 2);

while {!_detected && {alive _unit}} do {

	_near_units = ([_unit] call WC_fnc_getPos) nearEntities ["CAManBase", 10];
	{
		if (side _x in wcenemyside && {_x knowsAbout _unit > _knows}) exitWith {
			if (objNull call WC_fnc_sunAngle) then {
				if (primaryWeapon _unit == "") then {
					if (random 10 > ([_x, _unit] call WC_fnc_getDistance)) then {
						_x doWatch _unit;
						wcalerttoadd = round ((10 - ([_x, _unit] call WC_fnc_getDistance)) * 3);
						["wcalerttoadd", "server"] call WC_fnc_publicvariable;
						[localize "STR_WC_MESSAGESTEALTH", localize "STR_WC_MESSAGEABEENLOOKED", localize "STR_WC_MESSAGESTEALTHRUN", 5] spawn WC_fnc_playerhint;
					};
				} else {
					_detected = true;
				};
			} else {
				if (primaryWeapon _unit == "") then {
					if (random 5 > ([_x, _unit] call WC_fnc_getDistance)) then {
						_x doWatch _unit;
						wcalerttoadd = round ((10 - ([_x, _unit] call WC_fnc_getDistance)) * 3);
						["wcalerttoadd", "server"] call WC_fnc_publicvariable;
						[localize "STR_WC_MESSAGESTEALTH", localize "STR_WC_MESSAGEABEENLOOKED", localize "STR_WC_MESSAGESTEALTHRUN", 5] spawn WC_fnc_playerhint;
					};
				} else {
					_detected = true;
				};
			};
		};
	} forEach _near_units;

	if (wcalert > 99) then {
		_detected = true;
	};

	sleep 5;
};

if (_detected && {alive _unit}) then {
	_group = createGroup west;
	[_unit] joinSilent _group;

	_near_units = ([_unit] call WC_fnc_getPos) nearEntities ["CAManBase", 40];
	{
		if (side _x in wcenemyside) then {
			_x doTarget _unit;
			_x doFire _unit;
			(group _x) reveal _unit;
		};
	} forEach _near_units;

	sleep 2;

	[localize "STR_WC_MESSAGESTEALTH", localize "STR_WC_MESSAGEABEENDETECTED", localize "STR_WC_MESSAGESTEALTHRUN", 10] spawn WC_fnc_playerhint;
};
