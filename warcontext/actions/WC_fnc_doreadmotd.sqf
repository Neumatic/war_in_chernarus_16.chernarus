// -----------------------------------------------
// Author:     code34 nicolas_boiteux@yahoo.fr
// Edited by:  Neumatic
// Warcontext: Read the caution sign at base
// -----------------------------------------------

if (isNil "wcmotd") then {
	wcmotd = [];
};

if (count wcmotd == 0) then {
	"Informations of the day" hintC ["No informations"];
} else {
	"Informations of the day" hintC wcmotd;
};
