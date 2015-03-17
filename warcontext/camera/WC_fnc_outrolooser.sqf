// -----------------------------------------------
// Author:     code34 nicolas_boiteux@yahoo.fr
// Edited by:  Neumatic
// Warcontext: Camera focus on object
// -----------------------------------------------

private ["_grave", "_cam", "_position"];

waitUntil {isNull wccam};
waitUntil {!(player getVariable "deadmarker")};

player allowDamage true;

_cam = "camera" camCreate [0,0,1000];
_cam cameraEffect ["internal", "back"];
showCinemaBorder true;

playMusic "outro";

_position = [getMarkerPos "respawn_west", 0, 150, sizeOf "RU_Soldier", 0.2] call WC_fnc_getEmptyPosition;
if (count _position == 0) then {
	player setPos wcmapcenter;
} else {
	player setPos _position;
};

while {true} do {
	_grave = nearestObjects [getMarkerPos "mortuary", [["gravecross2","GraveCrossHelmet"] call WC_fnc_selectRandom], 300];
	_cam camSetTarget ([_grave call WC_fnc_selectRandom] call WC_fnc_getPos);
	_cam camSetRelPos [0, -4, 1];
	_cam camCommit 8;
	sleep 8;

	titleRsc ["LooseMission", "Plain", 2];
	_cam camSetRelPos [0, -4, 1];
	_cam camCommit 0;
	sleep 4;
};

wccam = objNull;
