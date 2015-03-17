// -----------------------------------------------
// Author:     code34 nicolas_boiteux@yahoo.fr
// Edited by:  Neumatic
// Warcontext: On killed player event
// -----------------------------------------------

wcaddtogarbage = _this select 0;
["wcaddtogarbage", "server"] call WC_fnc_publicvariable;

// Removed save loadout on death
//objNull call WC_fnc_saveloadout;

waitUntil {alive player};

wcrespawntobase = name player;
["wcrespawntobase", "server"] call WC_fnc_publicvariable;

// Change the scoring based on param
if (wcdefaultscore == 1) then {
	wcplayeraddscore = switch (rank player) do {
		case "PRIVATE": {   [player, -1]};
		case "CORPORAL": {  [player, -2]};
		case "SERGEANT": {  [player, -3]};
		case "LIEUTENANT": {[player, -4]};
		case "CAPTAIN": {   [player, -5]};
		case "MAJOR": {     [player, -7]};
		case "COLONEL": {   [player, -10]};
	};
} else {
	wcplayeraddscore = switch (rank player) do {
		case "PRIVATE": {   [player, -1]};
		case "CORPORAL": {  [player, -1]};
		case "SERGEANT": {  [player, -1]};
		case "LIEUTENANT": {[player, -1]};
		case "CAPTAIN": {   [player, -1]};
		case "MAJOR": {     [player, -1]};
		case "COLONEL": {   [player, -1]};
	};
};

["wcplayeraddscore", "server"] call WC_fnc_publicvariable;

objNull call WC_fnc_clienteventhandler;
objNull call WC_fnc_restoreactionmenu;
objNull call WC_fnc_restoreloadout;
