// -----------------------------------------------
// Author:     code34 nicolas_boiteux@yahoo.fr
// Edited by:  Neumatic
// Warcontext: Civilian sabotage friendly vehicles
// -----------------------------------------------

private ["_unit", "_position", "_target", "_mission_complete", "_jail_pos"];

_unit = _this select 0;

["INFO", format ["Created a saboter : fame=%1", wcfame]] call WC_fnc_log;

_position = [_unit, 0, 150, sizeOf "RU_Soldier", 0.2] call WC_fnc_getEmptyPosition;
_unit setPos _position;

WC_fnc_findtargetvehicle = {
	private ["_unit", "_target"];

	_unit = _this select 0;

	_target = objNull;
	{
		if (vehicleVarName _x != "") then {
			if (format ["%1", _x getVariable "wcsabotage"] == "<null>") then {
				_target = _x;
			};
		};
	} forEach (([_unit] call WC_fnc_getPos) nearObjects ["LandVehicle", 300]);

	_target
};

_mission_complete = false;
_jail_pos = getMarkerPos "jail";
_target = [_unit] call WC_fnc_findtargetvehicle;

while {alive _unit && {!_mission_complete}} do {
	if (!isNull _target) then {
		if (west countSide (([_unit] call WC_fnc_getPos) nearEntities ["CAManBase", 30]) > 0) then {
			_unit setVariable ["civilrole", "civil", true];
		} else {
			_unit setVariable ["civilrole", "saboter", true];
		};

		_unit setVariable ["target", _target, false];

		if (([_target, _unit] call WC_fnc_getDistance) < 300) then {
			if (([_unit, _target] call WC_fnc_getDistance) > 7) then {
				_unit stop false;
				_position = [_target] call WC_fnc_getPos;
				_unit doMove _position;
				_unit setVariable ["destination", _position, false];
			} else {
				for "_i" from 0 to 4 do {
					if (alive _unit) then {
						_unit doWatch _target;
						sleep 3;
						_unit playMove "AinvPknlMstpSnonWnonDnon_medic_2";
						sleep 5;
					};
					_unit playMove "";
				};

				if (alive _unit && {([_unit, _target] call WC_fnc_getDistance) < 10}) then {
					[_target] spawn WC_fnc_nastyvehicleevent;
					_target setVariable ["wcsabotage", "saboted", false];
					_unit stop false;
					_target = [_unit] call WC_fnc_findtargetvehicle;
				};
			};
		};
	} else {
		_target = [_unit] call WC_fnc_findtargetvehicle;

		if (isNull _target) then {
			_unit setVariable ["civilrole", "civil", true];
		} else {
			_unit setVariable ["civilrole", "saboter", true];
		};
	};

	if (([_unit, _jail_pos] call WC_fnc_getDistance) < 50) then {
		wcmessageW = ["Saboter", "A prisoner is in jail"];
		["wcmessageW", "client"] call WC_fnc_publicvariable;
		_mission_complete = true;
	};

	sleep 5;
};
