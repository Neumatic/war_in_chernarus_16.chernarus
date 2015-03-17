// -----------------------------------------------
// Author:     code34 nicolas_boiteux@yahoo.fr
// Edited by:  Neumatic
// Warcontext: Add score to a player depend of his ranking
// -----------------------------------------------

private ["_score", "_ratio"];

_score = _this select 0;

// Player should be in team
if (name player in wcinteam) then {
	_ratio = switch (rank player) do {
		case "PRIVATE": {   ceil (_score * 0.4)};
		case "CORPORAL": {  ceil (_score * 0.5)};
		case "SERGEANT": {  ceil (_score * 0.6)};
		case "LIEUTENANT": {ceil (_score * 0.7)};
		case "CAPTAIN": {   ceil (_score * 0.8)};
		case "MAJOR": {     ceil (_score * 0.9)};
		case "COLONEL": {   ceil (_score)};
	};

	wcteamplayscore = wcteamplayscore + _ratio;
};
