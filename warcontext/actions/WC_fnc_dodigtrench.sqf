// -----------------------------------------------
// Author:     code34 nicolas_boiteux@yahoo.fr
// Edited by:  Neumatic
// Warcontext: Create a trench behind player
// -----------------------------------------------

private ["_caller", "_dir", "_pos", "_position", "_trench"];

_caller = _this select 1;

if (([_caller, "respawn_west"] call WC_fnc_getDistance) < 300) exitWith {
	[localize "STR_WC_MESSAGEDIGATRENCH", localize "STR_WC_MESSAGETRYTOMOVEOUT", localize "STR_WC_MESSAGECANDIG", 10] spawn WC_fnc_playerhint;
};

_dir = getDir _caller;
_pos = [_caller] call WC_fnc_getPos;
_position = [(_pos select 0) + ((sin _dir) * 2), (_pos select 1) + ((cos _dir) * 2), _pos select 2];

_caller playMove "AinvPknlMstpSlayWrflDnon_medic";
sleep 10;

if (!alive _caller) exitWith {};

_trench = createVehicle ["Fort_envelopeBig", _position, [], 0, "NONE"];
[_trench] call WC_fnc_alignToTerrain;
_trench setDir _dir;
