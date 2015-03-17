// -----------------------------------------------
// Author:     code34 nicolas_boiteux@yahoo.fr
// Edited by:  Neumatic
// Warcontext: Write the motd
// -----------------------------------------------

private ["_caller"];

_caller = _this select 1;

if (isNil "wcmotd") then {
	wcmotd = [];
};

if (name _caller in wcinteam) then {
	createDialog "RscDisplaypaperboard";
} else {
	["Informations of the day", "Only members of team can write informations of the day", "Wait to be recruit as team member",  10] spawn WC_fnc_playerhint;
};
