// -----------------------------------------------
// Author:     code34 nicolas_boiteux@yahoo.fr
// Edited by:  Neumatic
// Warcontext: Client netcode
// -----------------------------------------------

WC_fnc_netcode_wcweather = {
	60 setRain (_this select 0);
	60 setFog (_this select 1);
	60 setOverCast (_this select 2);
};

WC_fnc_netcode_wcdate = {
	_this spawn WC_fnc_fasttime;
};

WC_fnc_netcode_wcnewnuclearzone = {
	_this spawn WC_fnc_nuclearnuke;
};

WC_fnc_netcode_wcbomb = {
	playSound "bomb";
};

WC_fnc_netcode_wciedsound = {
	if ((_this select 0) == name player) then {
		if (vehicle player == player) then {
			playSound "bombdetector";
		};
	};
};

WC_fnc_netcode_wcallahsound = {
	if ((_this select 0) == name player) then {
		playSound "allah";
	};
};

WC_fnc_netcode_wcdogbark = {
	playSound "dog_bark";
};

WC_fnc_netcode_wcdoggrognement = {
	playSound "dog_grognement";
};

WC_fnc_netcode_wcaddkilled = {
	private ["_killed", "_message"];
	_killed = _this select 0;
	if (name _killed in wcinteam) then {
		_message = format [localize "STR_WC_MESSAGEWASKILLED", name _killed];
		wcclientlogs set [count wcclientlogs, _message];
	};
};

WC_fnc_netcode_wctk = {
	hintSilent format [localize "STR_WC_MESSAGEGOTABLAME", _this select 0];
};

WC_fnc_netcode_wcrespawntobase = {
	private ["_respawn", "_message"];
	_respawn = _this select 0;
	_message = format [localize "STR_WC_MESSAGERESPAWNTOBASE", _respawn];
	wcclientlogs set [count wcclientlogs, _message];
	hintSilent _message;
};

WC_fnc_netcode_wcrespawntotent = {
	private ["_respawn", "_message"];
	_respawn = _this select 0;
	_message = format [localize "STR_WC_MESSAGERESPAWNTOTENT", _respawn];
	wcclientlogs set [count wcclientlogs, _message];
	hintSilent _message;
};

WC_fnc_netcode_wcrespawntohq = {
	private ["_respawn", "_message"];
	_respawn = _this select 0;
	_message = format [localize "STR_WC_MESSAGERESPAWNTOHQ", _respawn];
	wcclientlogs set [count wcclientlogs, _message];
	hintSilent _message;
};

WC_fnc_netcode_wcpromote = {
	private ["_promote", "_name", "_rank"];
	_promote = _this;
	_name = name (_promote select 0);
	_rank = _promote select 1;
	(_promote select 0) setRank _rank;
	hintSilent format [localize "STR_WC_MESSAGEPLAYERPROMOTED", _name, _rank];
	wcrankchanged = true;
	wcclientlogs set [count wcclientlogs, "A soldier got promoted: + 1 point"];
};

WC_fnc_netcode_wcdegrade = {
	private ["_degrade", "_name", "_rank"];
	_degrade = _this;
	_name = name (_degrade select 0);
	_rank = _degrade select 1;
	(_degrade select 0) setRank _rank;
	hintSilent format [localize "STR_WC_MESSAGEPLAYERDEGRADED", _name, _rank];
	wcrankchanged = true;
	wcclientlogs set [count wcclientlogs, format ["%1 got degraded: - 1 point", _name]];
};

WC_fnc_netcode_wcranksync = {
	{
		(_x select 0) setRank (_x select 1);
	} forEach _this;
};

WC_fnc_netcode_wcobjective = {
	wcobjective = _this;
	if (!isNull (wcobjective select 1)) then {
		["New Goal", "Open your mission info menu", "You just receive a new goal", 10] spawn WC_fnc_playerhint;
	};
};

WC_fnc_netcode_wcteamplayaddscore = {
	private ["_add_score", "_message", "_text", "_text_2"];
	_add_score = _this;
	if (wckindofserver != 3) then {
		if ((_add_score select 0) == name player) then {
			_text = format ["%1", (_add_score select 1)];
			_text_2 = format ["Transfer: %1 points", (_add_score select 2)];
			[_text, _text_2] spawn EXT_fnc_infotext;
			_message = format ["%1 gave you : %2 points", (_add_score select 1), (_add_score select 2)];
			wcclientlogs set [count wcclientlogs, _message];
		};
	};
};

WC_fnc_netcode_wcinteamintegration = {
	private ["_integrate"];
	_integrate = _this select 0;
	if (_integrate == name player) then {
		[localize "STR_WC_MENURECRUITMENT", localize "STR_WC_MENUFOLLOWTHELEADER", localize "STR_WC_MENURECRUITASTEAMMENBER", 10] spawn WC_fnc_playerhint;
		wcclientlogs set [count wcclientlogs, "You have been recruited as team member"];
	};
};

WC_fnc_netcode_wcinteamfired = {
	private ["_fired"];
	_fired = _this select 0;
	if (_fired == name player) then {
		[localize "STR_WC_MENURECRUITMENT", localize "STR_WC_MENUFOLLOWTHELEADERTOBERECRUIT", localize "STR_WC_MENUFIREDASTEAMMENBER", 10] spawn WC_fnc_playerhint;
		wcclientlogs set [count wcclientlogs, "You have been fired of team members"];
	};
};

// Recieve points to share
// More ranked player is, less points he has to distribute
WC_fnc_netcode_wcteamplayscoretoadd = {
	_this spawn WC_fnc_addplayerscore;
	if (wckindofgame == 1) then {
		wcclientlogs set [count wcclientlogs, "Mission finished: +5 points teamscore"];
	} else {
		wcclientlogs set [count wcclientlogs, "Mission finished: +3 points teamscore"];
	};
};

// Add combat operation plan action
WC_fnc_netcode_wcchoosemission = {
	wcchoosemission = _this select 0;
	if (wcchoosemission) then {
		private ["_message"];
		_message = [localize "STR_WC_MESSAGEMISSIONCOMMANDEMENT", localize "STR_WC_MENUOPERATIONPLAN"];
		_message spawn EXT_fnc_infotext;
		if (wcchoosemissionmenu < 0) then {
			wcchoosemissionmenu = player addAction ["<t color='#dddd00'>" + localize "STR_WC_MENUCHOOSEMISSION" + "</t>", "warcontext\dialogs\WC_fnc_createmenuchoosemission.sqf", [], 6, false];
		};
	} else {
		if (wcchoosemissionmenu >= 0) then {
			player removeAction wcchoosemissionmenu;
			wcchoosemissionmenu = -1;
		};
	};
};

WC_fnc_netcode_wchintW = {
	hintSilent (_this select 0);
};

WC_fnc_netcode_wcmessageW = {
	_this spawn EXT_fnc_infotext;
};

WC_fnc_netcode_wcbombingavalaible = {
	wcbombingavalaible = _this select 0;
};

WC_fnc_netcode_wccivilkilled = {
	wccivilkilled = _this select 0;
};

WC_fnc_netcode_wcenemykilled = {
	wcenemykilled = _this select 0;
};

WC_fnc_netcode_wcteamscore = {
	wcteamscore = _this select 0;
};

WC_fnc_netcode_wcalert = {
	wcalert = _this select 0;
};

WC_fnc_netcode_wccfgpatches = {
	wccfgpatches = _this;
	objNull spawn WC_fnc_patchCheck;
};

WC_fnc_netcode_wcinteam = {
	wcinteam = _this;
};

WC_fnc_netcode_wclistofmissions = {
	wclistofmissions = _this;
};

WC_fnc_netcode_wclistofweapons = {
	wclistofweapons = _this;
};

WC_fnc_netcode_wcnuclearzone = {
	wcnuclearzone = _this;
};

WC_fnc_netcode_wcteleport = {
	wcteleport = _this select 0;
	if (!isNil "wcteleport") then {
		[wcteleport, "TELEPORT_BASE"] call WC_fnc_addActions;
		[wcteleport, "DROP_AMMOBOX"] call WC_fnc_addActions;
		[wcteleport, "BUILD_VEHICLE"] call WC_fnc_addActions;
	};
};

WC_fnc_netcode_wchostage = {
	wchostage = _this select 0;
};

WC_fnc_netcode_wcday = {
	wcday = _this select 0;
};

WC_fnc_netcode_wckindofserver = {
	wckindofserver = _this select 0;
};

WC_fnc_netcode_wcselectedzone = {
	wcselectedzone = _this;
};

WC_fnc_netcode_wcradioalive = {
	wcradioalive = _this select 0;
};

WC_fnc_netcode_wcskill = {
	wcskill = _this select 0;
};

WC_fnc_netcode_wclevel = {
	wclevel = _this select 0;
};

WC_fnc_netcode_wcmissioncount = {
	wcmissioncount = _this select 0;
};

WC_fnc_netcode_wclight = {
	wclight = _this select 0;
};

WC_fnc_netcode_wcwithlight = {
	wcwithlight = _this select 0;
};

WC_fnc_netcode_wclevelmax = {
	wclevelmax = _this select 0;
};

WC_fnc_netcode_wcengineerclass = {
	wcengineerclass = _this;
};

WC_fnc_netcode_wcmedicclass = {
	wcmedicclass = _this;
};

WC_fnc_netcode_wcscorelimitmin = {
	wcscorelimitmin = _this select 0;
};

WC_fnc_netcode_wcscorelimitmax = {
	wcscorelimitmax = _this select 0;
};

WC_fnc_netcode_wckindofgame = {
	wckindofgame = _this select 0;
};

WC_fnc_netcode_wcviewdistance = {
	wcviewdistance = _this select 0;
};

WC_fnc_netcode_wcwestside = {
	wcwestside = _this select 0;
};

WC_fnc_netcode_wcautoloadweapons = {
	wcautoloadweapons = _this select 0;
};

WC_fnc_netcode_wcmotd = {
	wcmotd = _this;
};

WC_fnc_netcode_wcversion = {
	wcversion = _this select 0;
};

WC_fnc_netcode_wcrecruitberanked = {
	wcrecruitberanked = _this select 0;
};

WC_fnc_netcode_wcwithcam = {
	wcwithcam = _this select 0;
};

WC_fnc_netcode_wcwithonelife = {
	wcwithonelife = _this select 0;
};

WC_fnc_netcode_wcwithmarkers = {
	wcwithmarkers = _this select 0;
};

WC_fnc_netcode_wceverybodymedic = {
	wceverybodymedic = _this select 0;
};

WC_fnc_netcode_wcwithvehicles = {
	wcwithvehicles = _this select 0;
};

WC_fnc_netcode_wconelife = {
	wconelife = _this select 0;
};

WC_fnc_netcode_wcaddaction = {
	_this call WC_fnc_addAction;
};

WC_fnc_netcode_wcaddactions = {
	private ["_target", "_type"];
	_target = _this select 0;
	_type   = _this select 1;
	[_target, _type] call WC_fnc_addActions;
};

WC_fnc_netcode_wcremoveaction = {
	_this call WC_fnc_removeAction;
};

WC_fnc_netcode_wclock = {
	private ["_object", "_bool"];
	_object = _this select 0;
	_bool   = _this select 1;
	if (local _object) then {
		_object lock _bool;
	} else {
		wclock = [_object, _bool];
		["wclock", "server"] call WC_fnc_publicvariable;
	};
};

WC_fnc_netcode_wcsetvectorup = {
	private ["_object", "_array"];
	_object = _this select 0;
	_array  = _this select 1;
	if (local _object) then {
		_object setVectorUp _array;
	} else {
		wcsetvectorup = [_object, _array];
		["wcsetvectorup", "server"] call WC_fnc_publicvariable;
	};
};

WC_fnc_netcode_wcmainflag = {
	private ["_flag"];
	_flag = _this select 0;
	if (!isNil "_flag") then {
		if (wcwithhalojump == 1) then {
			[_flag, "HALO_JUMP"] call WC_fnc_addActions;
		};
		if (wcwithteleporttent == 1) then {
			[_flag, "TELEPORT_TENT"] call WC_fnc_addActions;
		};
		if (wcwithmhq == 1) then {
			[_flag, "TELEPORT_MHQ"] call WC_fnc_addActions;
		};
	};
};

WC_fnc_netcode_wcflag = {
	private ["_flag"];
	_flag = _this select 0;
	if (!isNil "_flag") then {
		[_flag, "TELEPORT_BASE"] call WC_fnc_addActions;
	};
};

WC_fnc_netcode_wcstop = {
	private ["_object", "_bool"];
	_object = _this select 0;
	_bool   = _this select 1;
	if (local _object) then {
		_object stop _bool;
	} else {
		wcstop = [_object, _bool];
		["wcstop", "server"] call WC_fnc_publicvariable;
	};
};

WC_fnc_netcode_wcplaymove = {
	private ["_object", "_string"];
	_object = _this select 0;
	_string = _this select 1;
	if (local _object) then {
		_object playMove _string;
	} else {
		wcplaymove = [_object, _string];
		["wcplaymove", "server"] call WC_fnc_publicvariable;
	};
};

WC_fnc_netcode_wcsetunitpos = {
	private ["_object", "_string"];
	_object = _this select 0;
	_string = _this select 1;
	if (local _object) then {
		_object setUnitPos _string;
	} else {
		wcsetunitpos = [_object, _string];
		["wcsetunitpos", "server"] call WC_fnc_publicvariable;
	};
};

WC_fnc_netcode_wcremoveallweapons = {
	private ["_object"];
	_object = _this select 0;
	if (local _object) then {
		removeAllWeapons _object;
	} else {
		wcremoveallweapons = _object;
		["wcremoveallweapons", "server"] call WC_fnc_publicvariable;
	};
};

WC_fnc_netcode_wcresetgethit = {
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
		["wcresetgethit", "server"] call WC_fnc_publicvariable;
	};
};

nil
