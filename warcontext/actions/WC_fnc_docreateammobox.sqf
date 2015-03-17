// -----------------------------------------------
// Author:     code34 nicolas_boiteux@yahoo.fr
// Edited by:  Neumatic
// Warcontext: Create an ammobox near player position
// -----------------------------------------------

private ["_caller", "_crate", "_position"];

_caller = _this select 1;

_crate = ([_caller] call WC_fnc_getPos) nearObjects ["USVehicleBox", 150];
if (count _crate > 0) exitWith {
	["Build ammocrate", "Use the current ammocrate", "Ammocrate already in the area.", 3] spawn WC_fnc_playerhint;
};

if (count wcammocrates > 1) then {
	deleteVehicle (wcammocrates select 1);
	wcammocrates set [1, objNull];
	wcammocrates = wcammocrates - [objNull];
};

_position = [_caller, 0, 60, sizeOf "USVehicleBox", 0.2] call WC_fnc_getEmptyPosition;
if (count _position == 0) exitWith {
	["Build ammocrate", "Not enough room to build the ammocrate", "", 3] spawn WC_fnc_playerhint;
};

["Build ammocrate", "Wait while the building of ammocrate", "The ammocrate will appear near you in few seconds.", 3] spawn WC_fnc_playerhint;
sleep 3;

[_position, "base"] spawn WC_fnc_createammobox;
