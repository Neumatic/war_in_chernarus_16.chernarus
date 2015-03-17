﻿/*******************************************************************************************
 Copyright (C) 2010 Team ~R3F~

 This program is free software under the terms of the GNU General Public License version 3.
 You should have received a copy of the GNU General Public License
 along with this program.  If not, see <http://www.gnu.org/licenses/>.

@authors team-r3f.org
@version 0.03
@date 20100514

@function void FNCT_R3F_DEBUG_SetShowIA
@params1 (boolean) CONST_R3F_DEBUG_SHOW_IA = voir les IA sur la map, CONST_R3F_DEBUG_HIDE_IA ne pas voir les IA sur la map
@return rien
********************************************************************************************/

#include "constants_R3F_DEBUG.sqf";

FNCT_R3F_DEBUG_GetMarkerColor = {
	private ["_color"];
	_color = switch (side (_this select 0)) do {
		case (playerSide): {"ColorGreen"};
		case (civilian): {"ColorBlue"};
		default {"ColorRed"};
	};
	_color
};

FNCT_R3F_DEBUG_GetMarkerSize = {
	private ["_vehicle", "_size"];
	_vehicle = vehicle (_this select 0);
	if (_vehicle isKindOf "Man") then {
		_size = [0.2,0.2];
	} else {
		if (_vehicle isKindOf "Land") then {
			_size = [0.3,0.4];
		} else {
			if (_vehicle isKindOf "Air") then {
				_size = [0.3,0.4];
			} else {
				if (_vehicle isKindOf "Ship") then {
					_size = [0.3,0.3];
				};
			};
		};
	};
	_size
};

FNCT_R3F_DEBUG_GetMarkerType = {
	private ["_vehicle", "_type"];
	_vehicle = vehicle (_this select 0);
	if (_vehicle isKindOf "Man") then {
		_type = "hd_arrow";
	} else {
		if (_vehicle isKindOf "Land") then {
			_type = "mil_arrow2";
		} else {
			if (_vehicle isKindOf "Air") then {
				_type = "mil_arrow2";
			} else {
				if (_vehicle isKindOf "Ship") then {
					_type = "mil_arrow2";
				};
			};
		};
	};
	_type
};

FNCT_R3F_DEBUG_GetMarkerText = {
	private ["_unit", "_text", "_driver", "_array_cargo", "_nbr_cargo", "_role", "_name"];
	_unit = _this select 0;
	_text = "";
	if (_unit == leader _unit) then {
		_driver = assignedDriver (vehicle _unit);
		_array_cargo = assignedCargo (vehicle _unit);
		_nbr_cargo = count _array_cargo;
		if ((((units _unit) select (count units _unit) - 1) in _array_cargo) && {(_driver in (units _unit))}) then {
			_nbr_cargo = 0;
		};
		if ((vehicle _unit) == _unit) then {
			_role = _unit getVariable "civilrole";
			if (!isNil "_role") then {
				_text = format ["%1 %2", (_nbr_cargo + count (units vehicle _unit)), _role];
			} else {
				_text = format ["%1", (_nbr_cargo + count (units vehicle _unit))];
			};
		} else {
			_name = getText (configFile >> "CfgVehicles" >> typeOf (vehicle _unit) >> "DisplayName");
			_text = format ["%1: %2 %3", (_nbr_cargo + count (units vehicle _unit)), _name, damage (vehicle _unit)] + "%";
		};
	} else {
		_role = _unit getVariable "civilrole";
		if (!isNil "_role") then {
			_text = format ["%1", _role];
		};
	};
	_text
};

FNCT_R3F_DEBUG_CleanAllMarker = {
	{
		deleteMarkerLocal (_x select 1);
	} forEach (_this select 0);
	nil
};

FNCT_R3F_DEBUG_CleanArray = {
	private ["_array_temp"];
	_array_temp = [];
	{
		if ((isNull (_x select 0)) || {(!alive (_x select 0))}) then {
			deleteMarkerLocal (_x select 1);
		} else {
			_array_temp set [count _array_temp, _x];
		};
	} forEach (_this select 0);
	_array_temp
};

FNCT_R3F_DEBUG_IsInArray = {
	private ["_ret"];
	_ret = false;
	if (count (_this select 0) > 0) then {
		{
			if ((_this select 1) in _x) exitWith {
				_ret = true;
			};
		} forEach (_this select 0);
	};
	_ret
};
/*
FNCT_R3F_DEBUG_SetShowIA = {
	private ["_array_mark", "_all_units", "_unit", "_vehicle", "_mark", "_assigned_vehicle"];
	if (count _this > 0) then {
		VAR_R3F_DEBUG_ShowIA = _this select 0;
	} else {
		VAR_R3F_DEBUG_ShowIA = true;
	};
	_array_mark = [];
	while {VAR_R3F_DEBUG_ShowIA} do {
		if (visibleMap) then {
			_all_units = allUnits;
			{
				_unit = _x;
				if (alive _unit) then {
					_vehicle = vehicle _unit;
					_mark = str _vehicle;
					if !([_array_mark, _mark] call FNCT_R3F_DEBUG_IsInArray) then {
						_mark = createMarkerLocal [_mark, [0,0]];
						_mark setMarkerTypeLocal ([_unit] call FNCT_R3F_DEBUG_GetMarkerType);
						_mark setMarkerColorLocal ([_unit] call FNCT_R3F_DEBUG_GetMarkerColor);
						_mark setMarkerSizeLocal ([_unit] call FNCT_R3F_DEBUG_GetMarkerSize);
						_array_mark set [count _array_mark, [_unit, _mark]];
						_assigned_vehicle = assignedVehicle _unit;
					};
					if (assignedVehicle _unit != _assigned_vehicle) then {
						_mark setMarkerTypeLocal ([_unit] call FNCT_R3F_DEBUG_GetMarkerType);
						_mark setMarkerSizeLocal ([_unit] call FNCT_R3F_DEBUG_GetMarkerSize);
					};
					//if (_unit == leader _unit) then {
						_mark setMarkerTextLocal ([_unit] call FNCT_R3F_DEBUG_GetMarkerText);
					//};
					_mark setMarkerPosLocal (getPos _vehicle);
					_mark setMarkerDirLocal (getDir _vehicle);
				};
			} forEach _all_units;
			sleep 0.1;
		} else {
			sleep 1;
		};
		_array_mark = [_array_mark] call FNCT_R3F_DEBUG_CleanArray;
	};
	[_array_mark] call FNCT_R3F_DEBUG_CleanAllMarker;
};
*/
FNCT_R3F_DEBUG_SetShowIA = {
	private ["_array_mark", "_all_units", "_unit", "_vehicle", "_mark", "_assigned_vehicle"];
	if (count _this > 0) then {
		VAR_R3F_DEBUG_ShowIA = _this select 0;
	} else {
		VAR_R3F_DEBUG_ShowIA = true;
	};
	_array_mark = [];
	while {VAR_R3F_DEBUG_ShowIA} do {
		if (visibleMap) then {
			_all_units = allUnits;
			{
				_unit = _x;
				if (alive _unit) then {
					_vehicle = vehicle _unit;
					_mark = str _vehicle;
					if !([_array_mark, _mark] call FNCT_R3F_DEBUG_IsInArray) then {
						_mark = createMarkerLocal [_mark, [0,0]];
						_mark setMarkerTypeLocal ([_unit] call FNCT_R3F_DEBUG_GetMarkerType);
						_mark setMarkerColorLocal ([_unit] call FNCT_R3F_DEBUG_GetMarkerColor);
						_mark setMarkerSizeLocal ([_unit] call FNCT_R3F_DEBUG_GetMarkerSize);
						_array_mark set [count _array_mark, [_unit, _mark]];
					};
					_mark setMarkerTypeLocal ([_unit] call FNCT_R3F_DEBUG_GetMarkerType);
					_mark setMarkerSizeLocal ([_unit] call FNCT_R3F_DEBUG_GetMarkerSize);
					if (_unit == leader _unit) then {
						_mark setMarkerTextLocal ([_unit] call FNCT_R3F_DEBUG_GetMarkerText);
					};
					_mark setMarkerPosLocal (getPos _vehicle);
					_mark setMarkerDirLocal (getDir _vehicle);
				};
			} forEach _all_units;
			sleep 0.1;
		} else {
			sleep 1;
		};
		_array_mark = [_array_mark] call FNCT_R3F_DEBUG_CleanArray;
	};
	[_array_mark] call FNCT_R3F_DEBUG_CleanAllMarker;
};
