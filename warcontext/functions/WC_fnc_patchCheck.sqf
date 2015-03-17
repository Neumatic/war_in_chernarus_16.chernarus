/*
	Author: Code34
	Edited by: Neumatic
	Description: Checks clients patches.

	Parameter(s):
		nil

	Example(s):
		[] spawn WC_fnc_patchCheck;

	Returns:
		nil
*/

wccfglocalpatches = wccfgpatches;

{
	if !(isClass (configFile >> "CfgPatches" >> _x)) then {
		player sideChat format [localize "STR_WC_MESSAGEMISSINGADDONS", _x];
		sleep 1;
	} else {
		wccfglocalpatches = wccfglocalpatches - [_x];
	};
} forEach wccfglocalpatches;

if (count wccfglocalpatches > 0) then {
	while {true} do {
		[localize "STR_WC_MESSAGEWARNING", localize "STR_WC_MESSAGERESTARTGAME", localize "STR_WC_MESSAGENOTSYNC", 60] spawn WC_fnc_playerhint;
		sleep 60;
	};
};
