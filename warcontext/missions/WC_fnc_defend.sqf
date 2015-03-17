// -----------------------------------------------
// Author:     code34 nicolas_boiteux@yahoo.fr
// Edited by:  Neumatic
// Warcontext: Defend an area
// -----------------------------------------------

#define LOCATION_TYPES ["FlatArea","FlatAreaCity","FlatAreaCitySmall","Airport","NameCityCapital","NameCity","NameVillage","NameLocal"]

private [
	"_object", "_object_pos", "_marker_dest", "_timer", "_count", "_count_dead", "_delta", "_mission_number", "_location",
	"_marker_dest", "_position", "_units", "_group"
];

_object = _this select 0;

_object_pos = [_object] call WC_fnc_getPos;

_marker_dest = [format ["defendzone%1", wcdefendzoneindex], _object_pos, 300, "ColorRed", "ELLIPSE", "FDIAGONAL", "", 0, "", WC_MarkerAlpha] call WC_fnc_createmarkerlocal;
wcambiantmarker set [count wcambiantmarker, _marker_dest];
wcdefendzoneindex = wcdefendzoneindex + 1;

wcbegindefend = false;
waitUntil {sleep 1; wcmissionsuccess || wcbegindefend};

// Mission was canceled.
if (wcmissionsuccess) exitWith {};

_timer = 2400 + round (random 1200);
_count = 0;
_count_dead = 0;
_delta = wcnumberofkilledofmissionW;

// Get the current mission number.
_mission_number = wccurrentmission select 0;

// Amount of transports with infantry.
for "_i" from 1 to ([wclevelmaxincity * 0.75, wclevelmaxincity] call WC_fnc_randomMinMax) do {
	_location = [_object_pos, 800, 2000, true, LOCATION_TYPES] call WC_fnc_getLocation;
	[position _location, _object_pos, _marker_dest, "transport"] spawn WC_fnc_creategroupdefend;
	sleep 1;
};

if (wcwithenemyvehicle == 1) then {
	for "_i" from 1 to ([wclevelmaxincity * 0.25, wclevelmaxincity * 0.50] call WC_fnc_randomMinMax) do {
		if (random 1 > 0.5) then {
			// Amount of tanks.
			_location = [_object_pos, 800, 2000, true, LOCATION_TYPES] call WC_fnc_getLocation;
			[position _location, _object_pos, _marker_dest, "tank"] spawn WC_fnc_creategroupdefend;
		} else {
			// Amount of apcs with infantry.
			_location = [_object_pos, 800, 2000, true, LOCATION_TYPES] call WC_fnc_getLocation;
			[position _location, _object_pos, _marker_dest, "apc"] spawn WC_fnc_creategroupdefend;
		};
		sleep 1;
	};
};

if (wcairopposingforce > 0) then {
	for "_i" from 1 to ([wclevelmaxincity * 0.25, wclevelmaxincity * 0.50] call WC_fnc_randomMinMax) do {
		if (random 1 > 0.6) then {
			// Amount of helicopters with infantry.
			_location = [_object_pos, 3000, 4000, true, LOCATION_TYPES] call WC_fnc_getLocation;
			[position _location, _object_pos, _marker_dest, "helicopter"] spawn WC_fnc_defendParadrop;
		} else {
			// Amount of planes with infantry.
			_location = [_object_pos, 3000, 4000, true, LOCATION_TYPES] call WC_fnc_getLocation;
			[position _location, _object_pos, _marker_dest, "plane"] spawn WC_fnc_defendParadrop;
		};
		sleep 1;
	};
};

// Amount of infantry.
for "_i" from 1 to ([wclevelmaxincity * 0.75, wclevelmaxincity] call WC_fnc_randomMinMax) do {
	_position = [_object_pos, 600, 800] call WC_fnc_createpositionaround;
	[_position, _object_pos, _marker_dest, "infantry"] spawn WC_fnc_creategroupdefend;
	sleep 1;
};

while {!wcmissionsuccess} do {
	if (_timer == 0) then {
		wcmessageW = [localize "STR_WC_MESSAGEMISSIONCOMPLETED", localize "STR_WC_MESSAGELEAVEZONE"];
		["wcmessageW", "client"] call WC_fnc_publicvariable;

		// Add mission number to mission done array.
		wcmissiondone set [count wcmissiondone, _mission_number];
		wcmissionsuccess = true;
		wcleveltoadd = 1;

		wcfame = wcfame + wcbonusfame;
		wcnuclearprobability = wcnuclearprobability - wcbonusnuclear;
		wcenemyglobalfuel = wcenemyglobalfuel - wcbonusfuel;
		wcenemyglobalelectrical = wcenemyglobalelectrical - wcbonuselectrical;
	};

	if (!alive _object || {damage _object > 0.9}) then {
		wcmessageW = [localize "STR_WC_MESSAGEMISSIONFAILED", "Objective has been destroyed"];
		["wcmessageW", "client"] call WC_fnc_publicvariable;
		wcmissionsuccess = true;
	};

	_units = _object_pos nearEntities ["CAManBase", 1000];
	if ({isPlayer _x && {side _x in wcside}} count _units < ceil (count ([] call BIS_fnc_listPlayers) * 0.5)) then {
		_count = _count + 1;

		if (_count == 60) then {
			wcmessageW = ["Commandement", "All players must stay in area!"];
			["wcmessageW", "client"] call WC_fnc_publicvariable;
		} else {
			if (_count == 120) then {
				wcmessageW = ["Commandement", "All players must stay in area!"];
				["wcmessageW", "client"] call WC_fnc_publicvariable;
			} else {
				if (_count == 180) then {
					wcmessageW = [localize "STR_WC_MESSAGEMISSIONFAILED", "Too many players out of area"];
					["wcmessageW", "client"] call WC_fnc_publicvariable;
					wcmissionsuccess = true;
				};
			};
		};
	} else {
		_count = 0;
	};

	if (!wcmissionsuccess && {_count_dead > 60}) then {
		_count_dead = 0;

		wcmessageW = [format ["Still %1 minutes left", floor (_timer / 60)], format ["%1 have died", (wcnumberofkilledofmissionW - _delta)]];
		["wcmessageW", "client"] call WC_fnc_publicvariable;

		// Remove defend groups if all units of group are dead.
		{
			_group = _x;
			if ({alive _x} count units _group == 0) then {
				wcdefendgroup = wcdefendgroup - [_x];
			};
		} forEach wcdefendgroup;

		while {count wcdefendgroup < (wclevelmaxincity * 2)} do {
			if (diag_fps > wcminfpsonserver) then {
				if (random 1 > 0.4) then {
					if (random 1 > 0.7) then {
						_location = [_object_pos, 800, 2000, true, LOCATION_TYPES] call WC_fnc_getLocation;
						[position _location, _object_pos, _marker_dest, "transport"] spawn WC_fnc_creategroupdefend;
					} else {
						_position = [_object_pos, 600, 800] call WC_fnc_createpositionaround;
						[_position, _object_pos, _marker_dest, "infantry"] spawn WC_fnc_creategroupdefend;
					};
				} else {
					if (random 1 > 0.4) then {
						if (wcwithenemyvehicle == 1) then {
							if (random 1 > 0.5) then {
								_location = [_object_pos, 800, 2000, true, LOCATION_TYPES] call WC_fnc_getLocation;
								[position _location, _object_pos, _marker_dest, "tank"] spawn WC_fnc_creategroupdefend;
							} else {
								_location = [_object_pos, 800, 2000, true, LOCATION_TYPES] call WC_fnc_getLocation;
								[position _location, _object_pos, _marker_dest, "apc"] spawn WC_fnc_creategroupdefend;
							};
						};
					} else {
						if (wcairopposingforce > 0) then {
							if (random 1 > 0.6) then {
								_location = [_object_pos, 3000, 4000, true, LOCATION_TYPES] call WC_fnc_getLocation;
								[position _location, _object_pos, _marker_dest, "helicopter"] spawn WC_fnc_defendParadrop;
							} else {
								_location = [_object_pos, 3000, 4000, true, LOCATION_TYPES] call WC_fnc_getLocation;
								[position _location, _object_pos, _marker_dest, "plane"] spawn WC_fnc_defendParadrop;
							};
						};
					};
				};
			};

			sleep 5;
		};
	};

	sleep 1;

	_timer = _timer - 1;
	_count_dead = _count_dead + 1;
};
