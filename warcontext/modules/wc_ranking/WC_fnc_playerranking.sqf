// -----------------------------------------------
// Author:     code34 nicolas_boiteux@yahoo.fr
// Edited by:  Neumatic
// Warcontext: Manage player ranking
// -----------------------------------------------

private ["_count", "_old_score", "_ranked", "_score", "_rank", "_old_rank", "_message"];

_count = 0;
_old_score = score player;

_ranked = [
	15, // CORPORAL
	30, // SERGEANT
	45, // LIEUTENANT
	60, // CAPTAIN
	75, // MAJOR
	90  // COLONEL
];

while {true} do {
	if (name player in wcinteam) then {
		_score = score player;
		_rank = rank player;
		_old_rank = _rank;

		if (wcdefaultscore == 1) then {
			_rank = "PRIVATE"; WC_reanimations = 6;
			if (_score > (_ranked select 0) && {_rank != "CORPORAL"}) then {  _rank = "CORPORAL";   WC_reanimations = 5};
			if (_score > (_ranked select 1) && {_rank != "SERGEANT"}) then {  _rank = "SERGEANT";   WC_reanimations = 4};
			if (_score > (_ranked select 2) && {_rank != "LIEUTENANT"}) then {_rank = "LIEUTENANT"; WC_reanimations = 3};
			if (_score > (_ranked select 3) && {_rank != "CAPTAIN"}) then {    _rank = "CAPTAIN";   WC_reanimations = 2};
			if (_score > (_ranked select 4) && {_rank != "MAJOR"}) then {      _rank = "MAJOR";     WC_reanimations = 1};
			if (_score > (_ranked select 5) && {_rank != "COLONEL"}) then {    _rank = "COLONEL";   WC_reanimations = 0};
		} else {
			_rank = "PRIVATE"; WC_reanimations = 20;
			if (_score > (_ranked select 0) && {_rank != "CORPORAL"}) then {  _rank = "CORPORAL";   WC_reanimations = 20};
			if (_score > (_ranked select 1) && {_rank != "SERGEANT"}) then {  _rank = "SERGEANT";   WC_reanimations = 20};
			if (_score > (_ranked select 2) && {_rank != "LIEUTENANT"}) then {_rank = "LIEUTENANT"; WC_reanimations = 20};
			if (_score > (_ranked select 3) && {_rank != "CAPTAIN"}) then {    _rank = "CAPTAIN";   WC_reanimations = 20};
			if (_score > (_ranked select 4) && {_rank != "MAJOR"}) then {      _rank = "MAJOR";     WC_reanimations = 20};
			if (_score > (_ranked select 5) && {_rank != "COLONEL"}) then {    _rank = "COLONEL";   WC_reanimations = 20};
		};

		if (_rank != _old_rank) then {
			_count = _count + 1;
			if (_count > 3) then {
				R3F_REV_CFG_nb_reanimations = WC_reanimations;
				R3F_REV_nb_reanimations = R3F_REV_CFG_nb_reanimations;
				player setRank _rank;
				if (_score > _old_score) then {
					wcpromote = [player, _rank];
					["wcpromote", "server"] call WC_fnc_publicvariable;
					_message = [localize "STR_WC_MESSAGEPROMOTED", format [localize "STR_WC_MESSAGETORANK", rank player]];
				} else {
					wcdegrade = [player, _rank];
					["wcdegrade", "server"] call WC_fnc_publicvariable;
					_message = [localize "STR_WC_MESSAGEDEGRADED", format [localize "STR_WC_MESSAGETORANK", rank player]];
				};
				_message spawn EXT_fnc_infotext;
				playSound "drum";
				wcrankchanged = true;
				_count = 0;
				_old_score = _score;
			};
		};
	};

	sleep 5;
};
