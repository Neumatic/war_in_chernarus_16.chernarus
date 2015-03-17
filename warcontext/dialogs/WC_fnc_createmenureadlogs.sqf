// -----------------------------------------------
// Author:     code34 nicolas_boiteux@yahoo.fr
// Warcontext: Create the read logs dialog
// -----------------------------------------------

if (dialog) then {closeDialog 0};

if (format ["%1", actionKeysNames "USER16"] == "") then {
	["Admin menu", "You should configure your user 16 personnal key to directly open this menu", "Choose your option", 10] spawn WC_fnc_playerhint;
} else {
	["Admin menu", "You can access directly to this menu by pressing the " + format ["%1", actionKeysNames "USER16"] + " key", "Choose your option", 10] spawn WC_fnc_playerhint;
};

createDialog "RscDisplayLogs";
