// -----------------------------------------------
// Author:     code34 nicolas_boiteux@yahoo.fr
// Edited by:  Neumatic
// Warcontext: Call C130 bombing support
// -----------------------------------------------

private ["_caller"];

_caller = _this select 1;

wcbombingrequest = true;
["wcbombingrequest", "server"] call WC_fnc_publicvariable;

if (wcbombingsupport >= 0) then {
	_caller removeAction wcbombingsupport;
	wcbombingsupport = -1;
};
