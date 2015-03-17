// by Bon_Inf*

if (!local player || isNil "_this") exitWith {};

private ["_unit", "_preset", "_loadoutclass", "_weapons", "_magazines", "_ruckweapons", "_ruckmags", "_weapononback", "_classremaining", "_process", "_currentmag", "_hadRuck"];

_unit = _this select 0;
_preset = _this select 1;
_loadoutclass = _preset select 1;
_weapons = _preset select 2;
_magazines = _preset select 3;
_ruckweapons = _preset select 4;
_ruckmags = _preset select 5;
_weapononback = _preset select 6;

_classremaining = Server getVariable format ["%1", _loadoutclass];

if (_loadoutclass != "" && _classremaining == 0) exitWith {hint "Team limits already reached for this equipment class"};

closeDialog 0;
_process = "";
for "_i" from 0 to 4 do {
	hintSilent format ["Equipping (%1) %2",_loadoutclass,_process];
	sleep 0.5 + random 1;
	_process = _process + ".";
};
hint "";

Server setVariable [_loadoutclass, _classremaining - 1, true];

removeAllWeapons _unit;
removeAllItems _unit;
{
	_currentmag = _x;
	for "_i" from 1 to (_currentmag select 1) do {_unit addMagazine (_currentmag select 0)};
} forEach _magazines;
{_unit addWeapon _x} forEach _weapons;


Rucksacks = ["ACE_Rucksack_MOLLE_Green","ACE_Rucksack_MOLLE_Brown","ACE_Rucksack_MOLLE_Wood","ACE_Rucksack_MOLLE_ACU","ACE_Rucksack_MOLLE_WMARPAT","ACE_Rucksack_MOLLE_DMARPAT","ACE_Rucksack_MOLLE_Green_Medic","ACE_Rucksack_MOLLE_Brown_Medic","ACE_Rucksack_MOLLE_ACU_Medic","ACE_Rucksack_MOLLE_WMARPAT_Medic","ACE_Rucksack_MOLLE_DMARPAT_Medic"];

_hadRuck = (count _weapons) - (count (_weapons - Rucksacks)) < (count _weapons);
if (_hadRuck) then{
	if (count _ruckweapons > 0) then{
		_unit setVariable ["ACE_RuckWepContents", _ruckweapons, false];
		//{[_unit, _x select 0, _x select 1] call ace_sys_ruck_fnc_API_PackWeapon} forEach _ruckweapons;
	};
	if (count _ruckmags > 0) then{
		_unit setVariable ["ACE_RuckMagContents", _ruckmags, false];
		//{[_unit, _x select 0, _x select 1] call ace_sys_ruck_fnc_API_PackMagazine} forEach _ruckmags;
	};
};

if (!isNil "_weapononback") then {_unit setVariable ["ACE_weapononback", _weapononback, false]};