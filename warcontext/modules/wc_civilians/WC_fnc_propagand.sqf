// -----------------------------------------------
// Author:     code34 nicolas_boiteux@yahoo.fr
// Edited by:  Neumatic
// Warcontext: Create propagander in towns
// -----------------------------------------------

private [
	"_unit", "_need_propagander", "_men", "_position", "_conversion", "_mission_complete", "_jail_pos", "_positions",
	"_group", "_civil_role"
];

_unit = _this select 0;

_need_propagander = true;
{
	if (([_x, _unit] call WC_fnc_getDistance) < 500) then {
		_need_propagander = false;
	};
	if (isNull _x || {!alive _x}) then {
		wcpropagander = wcpropagander - [_x];
	};
} forEach wcpropagander;

if (!_need_propagander) exitWith {_unit setVariable ["civilrole", "civil", true]};
wcpropagander set [count wcpropagander, _unit];

_men = (([_unit] call WC_fnc_getPos) nearEntities ["CAManBase", 300]) - [_unit];
if (count _men <= 0) exitWith {};

["INFO", format ["Created a civilian propagander : fame=%1", wcfame]] call WC_fnc_log;

_position = [_unit, 0, 150, sizeOf "RU_Soldier", 0.2] call WC_fnc_getEmptyPosition;
_unit setPos _position;

_unit setVariable ["wcprotected", true];
_unit stop true;
_unit disableAI "MOVE";

_conversion = 0;
_mission_complete = false;
_jail_pos = getMarkerPos "jail";

while {alive _unit && {_conversion < 500} && {!_mission_complete}} do {
	_men = (([_unit] call WC_fnc_getPos) nearEntities ["CAManBase", 300]) - [_unit];
	if (count _men > 0) then {
		_positions = [[_unit] call WC_fnc_getPos, 5, 360, getDir _unit, 8] call WC_fnc_createcircleposition;
		_unit stop true;
		{
			if (!isPlayer _x && {side _x == civilian} && {(_x getVariable "civilrole" == "civil" || {_x getVariable "civilrole" == "converting"} || {_x getVariable "civilrole" == "converted"})}) then {
				if (([_x, _unit] call WC_fnc_getDistance) > 7) then {
					_position = _positions call WC_fnc_selectRandom;
					_x stop false;
					_x doMove _position;
					_x setVariable ["destination", _position, false];
					_x setVariable ["civilrole", "converting", true];
				} else {
					_x doWatch _unit;
					_x setUnitPos "Up";
					_x setVariable ["civilrole", "converted", true];
					_x stop true;
					_conversion = _conversion + 1;
				};
				_unit setVariable ["convertingrate", _conversion, false];
			};
		} forEach _men;
	};

	if (([_unit, _jail_pos] call WC_fnc_getDistance) < 50) then {
		wcmessageW = ["Propagand", "A prisoner is in jail"];
		["wcmessageW", "client"] call WC_fnc_publicvariable;
		wcfame = wcfame + 0.1;
		_mission_complete = true;
		_conversion = 0;
	};

	sleep 1;
};

// If converted success
// Create a resistance group with weapons
if (!_mission_complete && {alive _unit}) then {
	_unit stop false;
	_unit setVariable ["civilrole", "converted", true];

	_group = createGroup east;
	_men = ([_unit] call WC_fnc_getPos) nearEntities ["CAManBase", 30];
	{
		if (!isPlayer _x && {_x getVariable "civilrole" == "converted"}) then {
			if !((typeOf _x) in wccivilwithoutweapons) then {
				_x stop false;
				removeAllWeapons _x;
				_x removeAllEventHandlers "Killed";
				_x removeAllEventHandlers "HandleDamage";
				_x removeAllEventHandlers "FiredNear";
				_x addWeapon "AKS_74";
				_x addMagazine "30Rnd_545x39_AK";
				_x setVariable ["wcprotected", true];
			} else {
				_civil_role = ["bomberman","propagander","altercation","saboter","builder","healer"] call WC_fnc_selectRandom;
				_x setVariable ["civilrole", _civil_role, true];
				_men = _men - [_x];
			};
		} else {
			_men = _men - [_x];
		};
	} forEach _men;

	{
		[_x] joinSilent _group;
	} forEach _men;

	[_group, east] spawn WC_fnc_grouphandler;
	[_group, [leader _group] call WC_fnc_getPos, 300] spawn WC_fnc_patrol;
};
