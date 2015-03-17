// -----------------------------------------------
// Author:     code34 nicolas_boiteux@yahoo.fr
// Warcontext: Create a logs dialog box
// -----------------------------------------------

if (!wcadmin) then {
	ctrlEnable [15005, false];
	ctrlEnable [15006, false];
	ctrlEnable [15007, false];
	ctrlEnable [15008, false];
	ctrlEnable [15009, false];
	ctrlEnable [15010, false];
};

if (wcbombingavalaible != 1) then {
	ctrlEnable [15009, false];
};

{
	lbAdd [15003, _x];
} forEach wcclientlogs;
