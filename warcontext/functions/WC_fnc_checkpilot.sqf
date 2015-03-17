// -----------------------------------------------
// Author:     code34 nicolas_boiteux@yahoo.fr
// Edited by:  Neumatic
// Warcontext: Check if pilot is team member
// -----------------------------------------------

private ["_vehicle", "_fuel"];

// kindofserver 1 = team
if (wckindofserver != 1) exitWith {};

_vehicle = vehicle player;
_fuel = fuel _vehicle;

if (_vehicle isKindOf "Air" && {driver _vehicle == player} && {!(_vehicle isKindOf "ParachuteBase")}) then {
	if !(name player in wcinteam) then {
		_vehicle setFuel 0;
		_vehicle engineOn false;
		player action ["Eject", wcvehicle];

		["Pilot", "Ask admin to recruit you as team member", "You can not pilot air vehicle", 8] spawn WC_fnc_playerhint;
		sleep 1;

		_vehicle setFuel _fuel;
	};
};
