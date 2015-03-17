// -----------------------------------------------
// Author:     code34 nicolas_boiteux@yahoo.fr
// Edited by:  Neumatic
// Warcontext: Create support enemy base
// -----------------------------------------------

#define MIN_DISTANCE 1200
#define MARKER_SIZE 300
#define MAX_TRIES 3
#define LOCATION_TYPES ["FlatArea","FlatAreaCity","FlatAreaCitySmall","Airport","NameCity","NameVillage"]

private [
	"_location", "_marker_dest", "_counter", "_position_dest", "_position", "_run", "_count", "_max_dist", "_marker_source",
	"_marker_barrack", "_marker_factory", "_text", "_support", "_group", "_enemy"
];

_location    = _this select 0;
_marker_dest = _this select 1;

_counter = 0;
_position_dest = getMarkerPos _marker_dest;
_position = position _location;

_run = 1;
_count = 0;
_location = nil;
_max_dist = 3000;

while {_run > 0} do {
	switch (_run) do {
		case 1: {
			_location = [_position, MIN_DISTANCE, _max_dist, true, LOCATION_TYPES] call WC_fnc_getLocation;
			if (!isNil "_location") then {
				_marker_source = ["markersupport", position _location, MARKER_SIZE, "ColorBlack", "ELLIPSE", "FDIAGONAL", "EMPTY", 0, "", WC_MarkerAlpha] call WC_fnc_createmarkerlocal;

				_position = [];
				_run = 2;
			} else {
				_max_dist = _max_dist + 500;
			};
		};

		case 2: {
			if (_count > MAX_TRIES) then {
				_position = [_marker_source, "onground", "onflat"] call WC_fnc_createpositioninmarker;
			} else {
				_position = [getMarkerPos _marker_source, 0, MARKER_SIZE, sizeOf "RU_WarfareBBarracks", 0.2] call WC_fnc_getEmptyPosition;
			};

			if (count _position > 0) then {
				wcbarrack = createVehicle ["RU_WarfareBBarracks", _position, [], 0, "NONE"];
				wcbarrack setDir (random 360);
				[wcbarrack] call WC_fnc_alignToTerrain;

				if (WC_MarkerAlpha > 0) then {
					_marker_barrack = ["markerbarrack", wcbarrack, 0.5, "ColorBlack", "ICON", "FDIAGONAL", "Camp", 0, "Barrack", WC_MarkerAlpha] call WC_fnc_createmarkerlocal;
					wcambiantmarker set [count wcambiantmarker, _marker_barrack];
				};

				wcbarrack removeAllEventHandlers "HandleDamage";
				wcbarrack addEventHandler ["HandleDamage", {
					private ["_damage", "_shooter"];
					_damage  = _this select 2;
					_shooter = _this select 3;
					if (isPlayer _shooter || {side _shooter in wcside}) then {
						_damage
					};
				}];

				wcbarrack addEventHandler ["Killed", {
					wcmessageW = ["Barrack", "has been destroyed"];
					["wcmessageW", "client"] call WC_fnc_publicvariable;
					["INFO", "Reinforcements barrack was destroyed"] call WC_fnc_log;
				}];

				_position = [];
				_count = 0;
				_run = 3;
			} else {
				_count = _count + 1;
			};
		};

		case 3: {
			if (_count > MAX_TRIES) then {
				_position = [_marker_source, "onground", "onflat"] call WC_fnc_createpositioninmarker;
			} else {
				_position = [getMarkerPos _marker_source, 0, MARKER_SIZE, sizeOf "RU_WarfareBHeavyFactory", 0.2] call WC_fnc_getEmptyPosition;
			};

			if (count _position > 0) then {
				wcheavyfactory = createVehicle ["RU_WarfareBHeavyFactory", _position, [], 0, "NONE"];
				wcheavyfactory setDir (random 360);
				[wcheavyfactory] call WC_fnc_alignToTerrain;

				if (WC_MarkerAlpha > 0) then {
					_marker_factory = ["markerfactory", wcheavyfactory, 0.5, "ColorBlack", "ICON", "FDIAGONAL", "Camp", 0, "Heavyfactory", WC_MarkerAlpha] call WC_fnc_createmarkerlocal;
					wcambiantmarker set [count wcambiantmarker, _marker_factory];
				};

				wcheavyfactory removeAllEventHandlers "HandleDamage";
				wcheavyfactory addEventHandler ["HandleDamage", {
					private ["_damage", "_shooter"];
					_damage  = _this select 2;
					_shooter = _this select 3;
					if (isPlayer _shooter || {side _shooter in wcside}) then {
						_damage
					};
				}];

				wcheavyfactory addEventHandler ["Killed", {
					wcmessageW = ["Heavy Factory", "has been destroyed"];
					["wcmessageW", "client"] call WC_fnc_publicvariable;
					["INFO", "Reinforcements heavy factory was destroyed"] call WC_fnc_log;
				}];

				_run = 0;
			} else {
				_count = _count + 1;
			};
		};
	};

	sleep 0.5;
};

_text = [position _location] call WC_fnc_getLocationText;
["INFO", format ["Created reinforcements support base near %1", _text]] call WC_fnc_log;

_marker_dest = ["markersupportdest", _position_dest, (wcdistance * 2), "ColorBlack", "ELLIPSE", "FDIAGONAL", "EMPTY", 0, "", WC_MarkerAlpha] call WC_fnc_createmarkerlocal;

if (random 1 > 0.2) then {
	[_marker_source, false] spawn WC_fnc_creategroup;
};

while {{!isNull _x && {alive _x}} count [wcheavyfactory, wcbarrack] > 0} do {
	if (wcalert > 99) then {
		_support = false;

		{
			_group = _x;
			if ({alive _x} count units _group == 0) then {
				wcsupportgroup = wcsupportgroup - [_group];
			};
		} forEach wcsupportgroup;

		while {count wcsupportgroup < wcreinforcmentlevel} do {
			if (diag_fps > wcminfpsonserver) then {
				if (random 1 > 0.3) then {
					if (alive wcbarrack) then {
						_enemy = (getPos wcbarrack) nearEntities [["CAManBase","LandVehicle","Air"], 150];
						if ({side _x in wcside} count _enemy == 0) then {
							[_marker_dest, "transport"] spawn WC_fnc_creategroupsupport;
							_support = true;
						};
					};
				} else {
					if (wcwithenemyvehicle == 1) then {
						if (alive wcheavyfactory) then {
							_enemy = (getPos wcheavyfactory) nearEntities [["CAManBase","LandVehicle","Air"], 150];
							if ({side _x in wcside} count _enemy == 0) then {
								if (random 1 > 0.1) then {
									if (random 1 > 0.6) then {
										[_marker_dest, "tank"] spawn WC_fnc_creategroupsupport;
										_support = true;
									} else {
										[_marker_dest, "apc"] spawn WC_fnc_creategroupsupport;
										_support = true;
									};
								} else {
									if (wcairopposingforce > 0) then {
										//if (random 1 > 0.7) then {
										//	[_marker_dest, "plane"] spawn WC_fnc_supportAir;
										//	_support = true;
										//} else {
											[_marker_dest, "helicopter"] spawn WC_fnc_supportAir;
											_support = true;
										//};
									};
								};
							};
						};
					};
				};
			};

			sleep 5 + random 25;
		};

		if (_support) then {_counter = _counter + 1};
		if (_counter > 3) then {
			wcbombingavalaible = 1;
			["wcbombingavalaible", "client"] call WC_fnc_publicvariable;
			["INFO", "Bombing is available"] call WC_fnc_log;
			_counter = 0;
		};
		if (_support) then {
			wcmessageW = [localize "STR_WC_MESSAGEMISSIONCOMMANDEMENT", localize "STR_WC_CALLREINFORCEMENT"];
			["wcmessageW", "client"] call WC_fnc_publicvariable;
			sleep 600 - (wclevel * 20);
		};
	};

	sleep 1;

	if (!wcradioalive) exitWith {};
};
