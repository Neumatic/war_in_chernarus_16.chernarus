// -----------------------------------------------
// Author:     code34 nicolas_boiteux@yahoo.fr
// Edited by:  Neumatic
// Warcontext: Main game loop
// -----------------------------------------------

private [
	"_respawn_west", "_count", "_mission_number", "_name", "_objective", "_city", "_num_of_groups", "_num_of_vehicles",
	"_position", "_time", "_weight", "_intel", "_location", "_location_pos", "_marker", "_town_pos", "_flag_pos",
	"_flag_mkr", "_run", "_num_of_players", "_fame", "_unit", "_group", "_temp_array"
];

if (WC_isDedicated) then {
	["INFO", format ["Dedicated server %1", wcversion]] call WC_fnc_log;
} else {
	["INFO", format ["Client hosted server %1", wcversion]] call WC_fnc_log;
};

_respawn_west = getMarkerPos "respawn_west";

while {wclevel < wclevelmax && {wcteamscore < wcscorelimitmax}} do {
	// Compute missions list.
	objNull call WC_fnc_createlistofmissions;

	wccurrentmission = [];
	wcmissionsuccess = false;
	wcnumberofkilledofmissionW = 0;
	wcnumberofkilledofmissionE = 0;
	wcnumberofkilledofmissionC = 0;
	wcnumberofkilledofmissionV = 0;
	wcteambonus = 0;

	_count = 0;

	while {count wccurrentmission == 0} do {
		_count = _count + 1;

		if (_count > 36) then {
			wcchoosemission = true;
			["wcchoosemission", "client"] call WC_fnc_publicvariable;
			["wclistofmissions", "client"] call WC_fnc_publicvariable;
			_count = 0;
		};

		sleep 5;
	};

	// Reset missions list.
	wclistofmissions = [];

	// Turn off player menu.
	wcchoosemission = false;
	["wcchoosemission", "client"] call WC_fnc_publicvariable;

	// Retrieve mission information.
	_mission_number  = wccurrentmission select 0;
	_name            = wccurrentmission select 1;
	_objective       = wccurrentmission select 2;
	_city            = wccurrentmission select 3;
	_num_of_groups   = wccurrentmission select 4;
	_num_of_vehicles = wccurrentmission select 5;
	_position        = wccurrentmission select 6;
	_time            = wccurrentmission select 7;
	_weight          = wccurrentmission select 8;
	_intel           = wccurrentmission select 9;

	_location = createLocation ["Strategic", _position, 50, 50];
	wcmissionlocations set [count wcmissionlocations, _location];

	// Location position.
	_location_pos = position _location;

	if ((_time select 3) < (date select 3)) then {wcday = wcday + 1; wcfame = wcfame - 0.15};
	if ((_time select 3) == (date select 3)) then {if ((_time select 4) < (date select 4)) then {wcday = wcday + 1; wcfame = wcfame - 0.15};};

	// Delete zones for next mission near this zone.
	wclastmissionposition = _position;
	wcmissionposition = _position;

	if (wcskiptime > 0) then {
		wcdate = _time;
		if (WC_isDedicated) then {setDate wcdate};
		["wcdate", "client"] call WC_fnc_publicvariable;
		["wcday", "client"] call WC_fnc_publicvariable;
	};

	["INFO", format ["Created mission location near %1", _city]] call WC_fnc_log;

	// Creat rescue zone marker.
	_marker = ["rescuezone", _position, wcdistance, "ColorRed", "ELLIPSE", "FDIAGONAL", "", 0, "", 1] call WC_fnc_createmarker;

	if (wcairopposingforce > 0) then {
		["airzone", _position, 2000, "ColorGreen", "ELLIPSE", "FDIAGONAL", "", 0, "", WC_MarkerAlpha] call WC_fnc_createmarkerlocal;
		wcairpatrolzone = _position;
	};

	wcselectedzone = _position;
	["wcselectedzone", "client"] call WC_fnc_publicvariable;

	// Create mission.
	[_marker, _mission_number, _name] spawn WC_fnc_createsidemission;
	sleep 1;

	if (_num_of_groups > 0) then {
		// Create mortar.
		if (random 1 < wcmortarprobability) then {
			[_marker] spawn WC_fnc_mortar;
			sleep 1;
		};

		// Create static weapons.
		if (wcwithstaticweapons > 0) then {
			for "_i" from 1 to ([1, wcwithstaticweapons] call WC_fnc_randomMinMax) do {
				[_position] spawn WC_fnc_createstatic;
				sleep 1;
			};
		};

		for "_i" from 1 to _num_of_groups do {
			[_marker, false] spawn WC_fnc_creategroup;
			sleep 1;
		};

		// Create reinforcements.
		if (wcreinforcmentlevel > 0) then {
			[_location, _marker] spawn WC_fnc_support;
			sleep 1;
		};
	};

	// Create enemy vehicles on target.
	if (_num_of_vehicles > 0) then {
		for "_i" from 1 to _num_of_vehicles do {
			[_marker, true, _weight] spawn WC_fnc_creategroup;
			sleep 1;
		};
	};

	// Create enemy ambiant zones around target.
	if (wclevelmaxoutofcity > 0) then {
		[_location, _weight] spawn WC_fnc_ambiantlife;
		sleep 1;
	};

	// Create anti air.
	if (wcaalevel > 0) then {
		for "_i" from 1 to ([1, wcaalevel] call WC_fnc_randomMinMax) do {
			objNull spawn WC_fnc_antiair;
			sleep 1;
		};
	};

	// Create mobile HQ near target.
	if (wcwithmhq == 1) then {
		[_position] spawn WC_fnc_createmhq;
		sleep 1;
	};

	// Create composition bunkers.
	if (wcwithcomposition == 1) then {
		[_location] spawn WC_fnc_createcomposition;
		sleep 1;
	};

	// Create civil cars, ieds, and minefields.
	{
		_town_pos = position _x;
		if (wcwithcivilcar > 0) then {
			[_town_pos] spawn WC_fnc_createcivilcar;
		};
		if (wcwithied > 0) then {
			if (random 1 > 0.5 && {_town_pos distance _respawn_west > 600}) then {
				[_town_pos] spawn WC_fnc_createiedintown;
			};
		};
		if (wcwithminefield > 0) then {
			if (random 1 > 0.5 && {_town_pos distance _respawn_west > 600}) then {
				[_town_pos] spawn WC_fnc_createminefield;
			};
		};
		sleep 0.5;
	} forEach wctownlocations;

	// Send mission text to player.
	wcmessageW = [format ["Mission %1", wcmissioncount], format [localize "STR_WC_MESSAGENEAR", _city], localize "STR_WC_MESSAGETAKISTANLOCALISED"];
	["wcmessageW", "client"] call WC_fnc_publicvariable;

	// Wait until the end of mission.
	while {!wcmissionsuccess} do {sleep 60};
	wcmissionsuccess = false;

	// Increase objective.
	wcobjectiveindex = wcobjectiveindex + 1;

	"operationtext" setMarkerText "Mission is finished. Leave the zone.";

	if (wcwithteleportflagatend == 1) then {
		_flag_pos = [_location_pos, 0, 300, sizeOf "RU_Soldier", 0.2] call WC_fnc_getEmptyPosition;

		if (!isNull wcflag) then {
			[_flag_mkr] call WC_fnc_deletemarker;
			deleteVehicle wcflag;
		};

		wcflag = createVehicle ["FlagCarrierUSA_EP1", _flag_pos, [], 0, "NONE"];
		wcflag allowDamage false;
		wcflag setFlagTexture "pics\teamtag.paa";

		_flag_mkr = [format ["teleportflag%1", wcteleportindex], wcflag, 0.5, "ColorGreen", "ICON", "FDIAGONAL", "City", 0, "", 1] call WC_fnc_createmarker;
		wcteleportindex = wcteleportindex + 1;

		["wcflag", "client"] call WC_fnc_publicvariable;
	};

	_count = 0;
	_run = true;

	while {_run} do {
		_num_of_players = {_x distance _location_pos < wcleaveareasizeatendofmission} count ([] call BIS_fnc_listPlayers);

		if (_num_of_players >= ceil (count ([] call BIS_fnc_listPlayers) * wcleaversatendofmission)) then {
			_count = _count + 1;

			if (_count >= 3) then {
				_count = 0;

				wcmessageW = [format [localize "STR_WC_MESSAGEMISSIONCOMMANDEMENT", wclevel], localize "STR_WC_MESSAGELEAVEZONE"];
				["wcmessageW", "client"] call WC_fnc_publicvariable;
			};
		} else {_run = false};

		sleep 60;
	};

	// The mission is finished. All players are out of zone.

	if (!isNull wcradio) then {[wcradio] call WC_fnc_deleteObject};
	if (!isNull wcgenerator) then {[wcgenerator] call WC_fnc_deleteObject};
	if (!isNull wcheavyfactory) then {[wcheavyfactory] call WC_fnc_deleteObject};
	if (!isNull wcbarrack) then {[wcbarrack] call WC_fnc_deleteObject};

	wcmessageW = [format [localize "STR_WC_MESSAGEMISSIONFINISHED", wcmissioncount], localize "STR_WC_MESSAGNEXTSTEP"];
	["wcmessageW", "client"] call WC_fnc_publicvariable;

	sleep 1;

	// Print stats before map cleanup.
	wcmessageW = ["Casualty", format ["%1 East soldiers killed", wcnumberofkilledofmissionE]];
	["wcmessageW", "client"] call WC_fnc_publicvariable;

	sleep 1;

	wcmessageW = ["Casualty", format ["%1 West soldiers killed", wcnumberofkilledofmissionW]];
	["wcmessageW", "client"] call WC_fnc_publicvariable;

	sleep 1;

	wcmessageW = ["Casualty", format ["%1 Civils killed", wcnumberofkilledofmissionC]];
	["wcmessageW", "client"] call WC_fnc_publicvariable;

	sleep 1;

	wcmessageW = ["Casualty", format ["%1 Vehicles destroyed", wcnumberofkilledofmissionV]];
	["wcmessageW", "client"] call WC_fnc_publicvariable;

	sleep 1;

	if (ceil (wcfame * 100) > 75) then {
		_fame = "Very Good";
	} else {
		if (ceil (wcfame * 100) > 50) then {
			_fame = "Good";
		} else {
			if (ceil (wcfame * 100) > 25) then {
				_fame = "Bad";
			} else {
				_fame = "Ugly";
			};
		};
	};

	wcmessageW = ["Military intervention", format ["%1 fame", _fame]];
	["wcmessageW", "client"] call WC_fnc_publicvariable;

	sleep 1;

	if (wckindofgame == 1) then {
		wcteamplayscoretoadd = ceil ((wcnumberofkilledofmissionE - wcnumberofkilledofmissionW + wclevel + wcteambonus + (wcnumberofkilledofmissionV * 3)) / (playersNumber west));
	} else {
		wcteamplayscoretoadd = ceil ((wcnumberofkilledofmissionE - wcnumberofkilledofmissionW - wcnumberofkilledofmissionC + wclevel + wcteambonus + (wcnumberofkilledofmissionV * 3)) / (playersNumber west));
	};

	if (wcteamplayscoretoadd < 0) then {wcteamplayscoretoadd = 0};

	// Send points to share.
	if (wcleveltoadd > 0) then {
		if (wckindofgame == 1) then {
			wcteamscore = wcteamscore + 5;
		} else {
			wcteamscore = wcteamscore + 3;
		};
		["wcteamplayscoretoadd", "client"] call WC_fnc_publicvariable;
	};

	// Map clean up.
	["INFO", "Mission is finished. Starting map cleanup..."] call WC_fnc_log;

	{
		if (!isNull _x) then {
			if !(_x getVariable ["wcprotected", false]) then {
				[_x] call WC_fnc_deleteObject;
			};
		};
		sleep 0.05;
	} forEach wcunits;

	wcunits = wcunits - [objNull];

	{
		_unit = _x;
		if (!isNull _unit) then {
			if !(_unit getVariable ["wcprotected", false]) then {
				if ({isPlayer _x || side _x in wcside} count crew _unit == 0) then {
					[_unit] call WC_fnc_deleteObject;
				};
			};
		};
		sleep 0.05;
	} forEach wcblinde;

	wcblinde = wcblinde - [objNull];

	{
		_unit = _x;
		if (!isNull _unit) then {
			if !(_unit getVariable ["wcprotected", false]) then {
				if ({isPlayer _x || side _x in wcside} count crew _unit == 0) then {
					[_unit] call WC_fnc_deleteObject;
				};
			};
		};
		sleep 0.05;
	} forEach wcvehicles;

	wcvehicles = wcvehicles - [objNull];

	{
		deleteMarkerLocal _x;
		wcambiantmarker set [_forEachIndex, "<DELETE>"];
		sleep 0.05;
	} forEach wcambiantmarker;

	wcambiantmarker = wcambiantmarker - ["<DELETE>"];

	{
		deleteVehicle _x;
		sleep 0.05;
	} forEach wcammobox;

	wcammobox = wcammobox - [objNull];

	{
		_unit = _x;
		if (!isNull _unit) then {
			if !(_unit getVariable ["wcprotected", false]) then {
				if (_unit isKindOf "LandVehicle") then {
					if ({isPlayer _x || side _x in wcside} count crew _unit == 0) then {
						[_unit] call WC_fnc_deleteObject;
					};
				} else {
					[_unit] call WC_fnc_deleteObject;
				};
			};
		};
		sleep 0.05;
	} forEach wcobjecttodelete;

	wcobjecttodelete = wcobjecttodelete - [objNull];

	{
		_group = _x;
		if ({alive _x} count units _group == 0) then {
			wcpatrolgroups = wcpatrolgroups - [_x];
		};
		sleep 0.05;
	} forEach wcpatrolgroups;

	_temp_array = allGroups;
	{
		_group = _x;
		if ({alive _x} count units _group == 0) then {
			deleteGroup _group;
		};
		sleep 0.05;
	} forEach _temp_array;

	if (wcwithACE == 1) then {
		_temp_array = nearestObjects [wcmapcenter, ["ACE_UsedTubes","ACE_Rucksack_crate","ACE_T72WreckTurret","ACE_K36"], 20000];
		{
			deleteVehicle _x;
			sleep 0.05;
		} forEach _temp_array;
	};

	// Moved from top of cleanup.
	["rescuezone"] call WC_fnc_deletemarker;
	["operationtext"] call WC_fnc_deletemarker;
	["radiotower"] call WC_fnc_deletemarker;
	["generator"] call WC_fnc_deletemarker;

	deleteMarkerLocal "airzone";

	// Moved from support script.
	if (getMarkerColor "markersupport" != "") then {deleteMarkerLocal "markersupport"};
	if (getMarkerColor "markersupportdest" != "") then {deleteMarkerLocal "markersupportdest"};

	wccompositionindex = 0;
	wcambiantindex = 0;
	wcaaindex = 0;
	wciedindex = 0;

	// Reset airpatrol zone.
	wcairpatrolzone = [0,0,0];

	// Reset selected zone.
	wcselectedzone = [0,0,0];
	["wcselectedzone", "client"] call WC_fnc_publicvariable;

	wclevel = wclevel + wcleveltoadd;
	wcmissioncount = wcmissioncount + 1;
	wcleveltoadd = 0;
	wcskill = wcskill + 0.02;
	["wcskill", "client"] call WC_fnc_publicvariable;
	["wclevel", "client"] call WC_fnc_publicvariable;
	["wcmissioncount", "client"] call WC_fnc_publicvariable;
	["wcenemykilled", "client"] call WC_fnc_publicvariable;
	wcdistance = wcdistance + wcdistancegrowth;
	/*
	wcblinde = [];
	wcunits = [];
	wcvehicles = [];
	wcobjecttodelete = [];
	*/
	wcallaaposition = [];
	wcsupportgroup = [];
	wcdefendgroup = [];

	wcalert = 0;
	["wcalert", "client"] call WC_fnc_publicvariable;

	["INFO", "Map cleanup complete"] call WC_fnc_log;

	sleep 60 + random 120;
};
