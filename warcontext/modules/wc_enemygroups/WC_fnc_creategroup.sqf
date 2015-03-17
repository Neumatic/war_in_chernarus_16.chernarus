// -----------------------------------------------
// Author:     code34 nicolas_boiteux@yahoo.fr
// Edited by:  Neumatic
// Warcontext: Creates group in marker
// -----------------------------------------------

private [
	"_marker", "_motorized", "_weight", "_position", "_group_type", "_vehicle_array", "_vehicle", "_group", "_group_size",
	"_script", "_alert", "_local_alert"
];

_marker    = _this select 0;
_motorized = _this select 1;
_weight    = if (count _this > 2) then {_this select 2};

if (_motorized) then {
	_position = [getMarkerPos _marker, 0, (wcdistance * 2), sizeOf "T90", 0.2] call WC_fnc_getEmptyPosition;

	_group_type = wcvehicleslistE call WC_fnc_selectRandom;

	if (wcautoloadvehicles == 1) then {
		_vehicle_array = [_position, random 360, _group_type, east] call WC_fnc_spawnVehicle;
	} else {
		if (_weight > 0) then {
			_vehicle_array = [_position, random 360, _weight, east] call WC_fnc_spawnIntVehicle;
		} else {
			_vehicle_array = [_position, random 360, _group_type, east] call WC_fnc_spawnVehicle;
		};
	};

	_vehicle = _vehicle_array select 0;
	_group   = _vehicle_array select 2;

	_vehicle lock true;
	_vehicle setFuel wcenemyglobalfuel;

	[_vehicle, east] spawn WC_fnc_vehiclehandler;
	[_vehicle] spawn EXT_fnc_atot;

	["INFO", format ["Created vehicle %1 in marker %2", [_vehicle] call WC_fnc_getDisplayName, _marker]] call WC_fnc_log;
} else {
	_position = [getMarkerPos _marker, 0, (wcdistance * 2), sizeOf "RU_Soldier", 0.2] call WC_fnc_getEmptyPosition;

	_group_size = [4,7] select (random 1);
	_group_type = wcfactions call WC_fnc_selectRandom;
	_group = [_group_type, east, _position, _group_size] call WC_fnc_popgroup;

	["INFO", format ["Created group %1 of %2 units in marker %3", _group_type, _group_size, _marker]] call WC_fnc_log;
};

_group allowFleeing 0;
[_group, east] spawn WC_fnc_grouphandler;

if (_motorized) then {
	if (random 1 > 0.05) then {
		(units _group) orderGetIn false;
		_script = [_group, getPos (leader _group), 30, false] spawn WC_fnc_patrol;

		_alert = false;
		_local_alert = 20 + round (random 70);

		while {!_alert} do {
			if (wcalert > _local_alert) then {
				_alert = true;
			};
			if (behaviour leader _group == "COMBAT") then {
				_alert = true;
			} else {
				sleep 1 + random 4;
			};
		};

		terminate _script;
		(units _group) orderGetIn true;

		if (!isNull _vehicle && {alive _vehicle} && {{alive _x} count units _group > 0}) then {
			while {!isNull _vehicle && {alive _vehicle} && {count (crew _vehicle) != count (units _group)}} do {
				sleep 1;
			};
		};
	};

	if (!isNull _vehicle && {alive _vehicle}) then {
		if (typeOf _vehicle in wcsabotagelist) then {
			_vehicle setDamage 1;

			wcmessageW = [localize "STR_WC_MESSAGEMISSIONCOMMANDEMENT", format ["%1 has exploded it was sabotaged", typeOf _vehicle]];
			["wcmessageW", "client"] call WC_fnc_publicvariable;
		};
	};

	if (!isNull _vehicle && {alive _vehicle}) then {
		[_vehicle, _marker, "showmarker"] spawn EXT_fnc_ups;
	} else {
		if ({alive _x} count units _group > 0) then {
			[leader _group, _marker, "showmarker", "nofollow"] spawn EXT_fnc_upsmon;
		};
	};
} else {
	if (random 1 > 0.4) then {
		if (count (_position nearObjects ["House", 70]) > 10) then {
			[leader _group, _marker, "showmarker", "fortify"] spawn EXT_fnc_upsmon;
		} else {
			if (random 1 > 0.2) then {
				[leader _group, _marker, "showmarker"] spawn EXT_fnc_upsmon;
			} else {
				[leader _group, _marker, "showmarker", "nofollow"] spawn EXT_fnc_upsmon;
			};
		};
	} else {
		if (random 1 > 0.2) then {
			[leader _group, _marker, "showmarker"] spawn EXT_fnc_upsmon;
		} else {
			[leader _group, _marker, "showmarker", "nofollow"] spawn EXT_fnc_upsmon;
		};
	};
};
