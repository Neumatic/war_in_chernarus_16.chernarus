// -----------------------------------------------
// Author:     code34 nicolas_boiteux@yahoo.fr
// Edited by:  Neumatic
// Warcontext: Server netcode
// -----------------------------------------------

// Recieve mission choosen by player
WC_fnc_netcode_server_wcaskformission = {
	if (count wccurrentmission == 0) then {
		private ["_count", "_mission_number", "_player", "_score"];
		_player         = _this select 0;
		_mission_number = _this select 1;
		_score = score _player;
		_count = 0;
		{
			if (isPlayer _x && {score _x > _score}) then {
				_count = _count + 1;
			};
		} forEach allUnits;
		if (_count < 4) then {
			{
				if ((_x select 0) == _mission_number) exitWith {
					wccurrentmission = _x;
				};
			} forEach wclistofmissions;
		};
	};
};

// Promote a player
WC_fnc_netcode_server_wcpromote = {
	private ["_name", "_rank", "_promote"];
	_promote = _this;
	(_promote select 0) setRank (_promote select 1);
	if (wckindofserver != 3) then {
		wcteamscore = wcteamscore + 1;
	};
	_name = name (_promote select 0);
	_rank = _promote select 1;
	["INFO", format ["%1 has been promoted to rank %2", _name, _rank]] call WC_fnc_log;
	wcpromote = _promote;
	["wcpromote", "client"] call WC_fnc_publicvariable;
};

// Degrade a player
WC_fnc_netcode_server_wcdegrade = {
	private ["_name", "_rank", "_degrade"];
	_degrade = _this;
	(_degrade select 0) setRank (_degrade select 1);
	if (wckindofserver != 3) then {
		wcteamscore = wcteamscore - 1;
	};
	_name = name (_degrade select 0);
	_rank = _degrade select 1;
	["INFO", format ["%1 has been degraded to rank %2", _name, _rank]] call WC_fnc_log;
	wcdegrade = _degrade;
	["wcdegrade", "client"] call WC_fnc_publicvariable;
};

// Player respawn to tent
WC_fnc_netcode_server_wcrespawntotent = {
	private ["_respawn"];
	_respawn = _this select 0;
	if (wckindofserver != 3) then {
		if (_respawn in wcinteam) then {
			wcteamscore = wcteamscore - 1;
		};
	};
	wcrespawntotent = _respawn;
	["wcrespawntotent", "client"] call WC_fnc_publicvariable;
};

// Player respawn to hq
WC_fnc_netcode_server_wcrespawntohq = {
	private ["_respawn"];
	_respawn = _this select 0;
	if (wckindofserver != 3) then {
		if (_respawn in wcinteam) then {
			wcteamscore = wcteamscore - 1;
		};
	};
	wcrespawntohq = _respawn;
	["wcrespawntohq", "client"] call WC_fnc_publicvariable;
};

// Player respawn to base
WC_fnc_netcode_server_wcrespawntobase = {
	private ["_respawn"];
	_respawn = _this select 0;
	if (wckindofserver != 3) then {
		if (_respawn in wcinteam) then {
			wcteamscore = wcteamscore - 1;
		};
	};
	wcrespawntobase = _respawn;
	["wcrespawntobase", "client"] call WC_fnc_publicvariable;
};

// Add player in ready state
WC_fnc_netcode_server_wcplayerreadyadd = {
	wcplayerready set [count wcplayerready, _this select 0];
};

// Add x points to teamscore
WC_fnc_netcode_server_wcaddscore = {
	wcteamscore = wcteamscore + (_this select 0);
};

// Add x points to team bonus score
WC_fnc_netcode_server_wcteambonusaddscore = {
	wcteambonus = wcteambonus + (_this select 0);
};

// Add x points to player
WC_fnc_netcode_server_wcplayeraddscore = {
	private ["_find", "_player", "_point", "_score", "_player_name"];
	_player = _this select 0;
	_point  = _this select 1;
	_player_name = name _player;
	_find = false;
	{
		if ((_x select 0) == _player_name) then {
			_score = (_x select 2) + _point;
			if (_score < 0) then {_score = 0};
			wcscoreboard set [_forEachIndex, [_player_name, _player, _score]];
			_find = true;
		};
	} forEach wcscoreboard;
	if (!_find) then {
		if (_point < 0) then {
			wcscoreboard set [count wcscoreboard, [_player_name, _player, 0]];
		} else {
			wcscoreboard set [count wcscoreboard, [_player_name, _player, _point]];
		};
	};
};

// Increase the detection level of x prct
WC_fnc_netcode_server_wcalerttoadd = {
	wcalert = wcalert + (_this select 0);
};

// Log blame
WC_fnc_netcode_server_wctk = {
	["INFO", format ["%1 is a team killer!", _this select 0]] call WC_fnc_log;
};

// Unflip a vehicle
WC_fnc_netcode_server_wcflip = {
	private [
		"_vehicle", "_type_of", "_dir", "_position", "_damage", "_fuel", "_var_name", "_objets_charges", "_selections",
		"_get_hit"
	];
	_vehicle = _this select 0;
	if (!locked _vehicle && {alive _vehicle} && {{alive _x} count crew _vehicle == 0}) then {
		if (!local _vehicle) then {
			_vehicle setOwner (owner (missionNamespace getVariable ["bis_functions_mainscope", objNull]));
		};
		_type_of = typeOf _vehicle;
		_dir = getDir _vehicle;
		_position = [_vehicle] call WC_fnc_getPos;
		_damage = damage _vehicle;
		_fuel = fuel _vehicle;
		_var_name = vehicleVarName _vehicle;
		_vehicle setVehicleVarName "";
		_objets_charges = _vehicle getVariable ["R3F_LOG_objets_charges", []];
		_selections = _vehicle getVariable ["EH_Selections", []];
		_get_hit = _vehicle getVariable ["EH_GetHit", []];
		sleep 0.1;
		[_vehicle] call WC_fnc_deleteObject;
		_vehicle = createVehicle [_type_of, [0,0,0], [], 0, "NONE"];
		[_vehicle, west] call WC_fnc_vehiclehandler;
		_vehicle setDir _dir;
		_vehicle setPos _position;
		[_vehicle] call WC_fnc_alignToTerrain;
		[_vehicle, _var_name] spawn WC_fnc_setVehicleVarName;
		_vehicle setVariable ["R3F_LOG_objets_charges", _objets_charges, true];
		_vehicle setVariable ["EH_Selections", _selections];
		_vehicle setVariable ["EH_GetHit", _get_hit];
		_vehicle setDamage _damage;
		_vehicle setFuel _fuel;
	};
};

// Admin command - lock/unlock all vehicles
WC_fnc_netcode_server_wclockall = {
	private ["_bool"];
	_bool = _this select 0;
	{
		if (local _x) then {
			_x lock _bool;
		} else {
			wclock = [_x, _bool];
			["wclock", "client", owner _x] call WC_fnc_publicvariable;
		};
	} forEach vehicles;
};

// Bomb via c130 request by admin on a zone
WC_fnc_netcode_server_wcbombingrequest = {
	if (wcbombingavalaible == 1) then {
		// Disabled.
		//["INFO", "Called c130 bombing support"] call WC_fnc_log;
		//objNull spawn WC_fnc_bomb;
		//wcbombingavalaible = 0;
		//["wcbombingavalaible", "client"] call WC_fnc_publicvariable;
	};
};

// Count how many W soldier died during a mission, and complete campaign
WC_fnc_netcode_server_wcaddkilled = {
	private ["_killed"];
	_killed = _this select 0;
	wcnumberofkilled = wcnumberofkilled + 1;
	wcnumberofkilledofmissionW = wcnumberofkilledofmissionW + 1;
	wcgrave = wcgrave + 1;
	if (name _killed in wcinteam) then {
		if (wckindofserver != 3) then {
			wcteamscore = wcteamscore - 1;
		};
	};
	wcaddkilled = _killed;
	["wcaddkilled", "client"] call WC_fnc_publicvariable;
};

// Recompute the list of missions when admin asks
WC_fnc_netcode_server_wcrecomputemission = {
	wcday = wcday + 1;
	wclistofmissions = [];
	objNull call WC_fnc_createlistofmissions;
	["INFO", "Admin requested new missions"] call WC_fnc_log;
};

// Insert player name died during a one life mission
WC_fnc_netcode_server_wctoonelife = {
	if !((_this select 0) in wconelife) then {
		wconelife set [count wconelife, _this select 0];
	};
};

// Start a defend mission
WC_fnc_netcode_server_wcbegindefend = {
	wcbegindefend = _this select 0;
};

// Cancel a mission by admin
WC_fnc_netcode_server_wcmissionsuccess = {
	wcmissionsuccess = _this select 0;
};

// Retrieve team members
WC_fnc_netcode_server_wcinteam = {
	wcinteam = _this;
	["wcinteam", "client"] call WC_fnc_publicvariable;
};

WC_fnc_netcode_server_wclock = {
	private ["_object", "_bool"];
	_object = _this select 0;
	_bool   = _this select 1;
	if (local _object) then {
		_object lock _bool;
	} else {
		wclock = [_object, _bool];
		["wclock", "client", owner _object] call WC_fnc_publicvariable;
	};
};

WC_fnc_netcode_server_wcswitchlight = {
	(_this select 0) switchLight (_this select 1);
};

WC_fnc_netcode_server_wcswitchlightsall = {
	private ["_position", "_string", "_distance", "_near_object"];
	_position = _this select 0;
	_string   = _this select 1;
	_distance = _this select 2;
	_near_object = _position nearObjects ["Streetlamp", _distance];
	{
		_x switchLight _string;
	} forEach _near_object;
};

WC_fnc_netcode_server_wcchangeowner = {
	(_this select 0) setOwner (owner (_this select 1));
};

WC_fnc_netcode_server_wcsetvectorup = {
	private ["_object", "_array"];
	_object = _this select 0;
	_array  = _this select 1;
	if (local _object) then {
		_object setVectorUp _array;
	} else {
		wcsetvectorup = [_object, _array];
		["wcsetvectorup", "client", owner _object] call WC_fnc_publicvariable;
	};
};

WC_fnc_netcode_server_wcclientforward = {
	private ["_event", "_target", "_uid", "_params"];
	_event  = _this select 0;
	_target = _this select 1;
	_uid    = _this select 2;
	_params = _this select 3;
	missionNamespace setVariable [_event, _params];
	[_event, _target, _uid] call WC_fnc_publicvariable;
};

WC_fnc_netcode_server_wcclientbroadcast = {
	private ["_event", "_target", "_params"];
	_event  = _this select 0;
	_target = _this select 1;
	_params = _this select 2;
	missionNamespace setVariable [_event, _params];
	[_event, _target] call WC_fnc_publicvariable;
};

WC_fnc_netcode_server_wcstop = {
	private ["_object", "_bool"];
	_object = _this select 0;
	_bool   = _this select 1;
	if (local _object) then {
		_object stop _bool;
	} else {
		wcstop = [_object, _bool];
		["wcstop", "client", owner _object] call WC_fnc_publicvariable;
	};
};

WC_fnc_netcode_server_wcplaymove = {
	private ["_object", "_string"];
	_object = _this select 0;
	_string = _this select 1;
	if (local _object) then {
		_object playMove _string;
	} else {
		wcplaymove = [_object, _string];
		["wcplaymove", "client", owner _object] call WC_fnc_publicvariable;
	};
};

WC_fnc_netcode_server_wcsetunitpos = {
	private ["_object", "_string"];
	_object = _this select 0;
	_string = _this select 1;
	if (local _object) then {
		_object setUnitPos _string;
	} else {
		wcsetunitpos = [_object, _string];
		["wcsetunitpos", "client", owner _object] call WC_fnc_publicvariable;
	};
};

WC_fnc_netcode_server_wcremoveallweapons = {
	private ["_object"];
	_object = _this select 0;
	if (local _object) then {
		removeAllWeapons _object;
	} else {
		wcremoveallweapons = _object;
		["wcremoveallweapons", "client", owner _object] call WC_fnc_publicvariable;
	};
};

WC_fnc_netcode_server_wcaddtogarbage = {
	private ["_object", "_time"];
	_object = _this select 0;
	if (!isNull _object) then {
		if (_object isKindOf "Man") then {
			_time = time + wctimetogarbagedeadbody;
		} else {
			_time = time + wctimetorespawnvehicle;
		};
		WC_GarbageArray set [count WC_GarbageArray, [_object, _time]];
	};
};

WC_fnc_netcode_server_wcresetgethit = {
	private ["_object", "_get_hit"];
	_object = _this select 0;
	if (local _object) then {
		_get_hit = _object getVariable ["EH_GetHit", []];
		if (count _get_hit > 0) then {
			{
				_get_hit set [_forEachIndex, 0];
			} forEach _get_hit;
		};
	} else {
		wcresetgethit = _object;
		["wcresetgethit", "client", owner _object] call WC_fnc_publicvariable;
	};
};

WC_fnc_netcode_server_wcaddplayerobj = {
	private ["_uid", "_object", "_objects"];
	_uid    = _this select 0;
	_object = _this select 1;
	_objects = missionNamespace getVariable [format ["WC_%1_Objects", _uid], []];
	if (!isNull _object) then {
		switch (typeName _object) do {
			case (typeName objNull): {
				_objects set [count _objects, _object];
			};
			case (typeName []): {
				_objects = [_objects, _object] call WC_fnc_arrayPushStack;
			};
		};
	};
	missionNamespace setVariable [format ["WC_%1_Objects", _uid], _objects];
};

nil
