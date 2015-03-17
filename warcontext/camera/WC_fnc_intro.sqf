// -----------------------------------------------
// Author:     code34 nicolas_boiteux@yahoo.fr
// Edited by:  Neumatic
// Warcontext: Main intro over the base
// -----------------------------------------------

private ["_vehicle"];

_vehicle = (wcmapcenter nearObjects ["Land_A_TVTower_Base", 20000]) call WC_fnc_selectRandom;
if (isNull _vehicle) then {_vehicle = player};

sleep 6;
/*
switch (toLower worldName) do {
	case "isoladicapraia": {
		playMusic "CAPRI1";
	};

	default {
		playMusic "intro";
	};
};
*/
//wccam = "camera" camCreate [0,0,1000];
wccam = "camera" camCreate ([player] call WC_fnc_getPos);
wccam cameraEffect ["internal", "back"];
showCinemaBorder true;

wccam camSetTarget player;
wccam camSetRelPos [300,300,80];
wccam camCommit 0;

titleRsc ["Titrecredits", "Plain", 2];

wccam camSetRelPos [150,150,45];
wccam camCommit 10;
sleep 10;

titleRsc ["TitreMission", "Plain", 2];

wccam camSetTarget anim;
wccam camSetRelPos [3,1,1.65];
wccam camCommit 0;
wccam camSetRelPos [-2,2,1.65];
wccam camCommit 16;
sleep 6;

wccam camSetTarget _vehicle;
wccam camSetRelPos [100,100,40];
wccam camCommit 0;

wccam camSetRelPos [50,50,10];
wccam camCommit 16;
sleep 6;

wccam cameraEffect ["internal", "back"];
wccam camSetTarget imam;
wccam camSetRelPos [0.4,0.6,1.65];
wccam camCommit 0;
imam setMimic "Agresive";

wccam camSetRelPos [2,1,1.65];
wccam camCommit 10;
sleep 6;

wccam cameraEffect ["terminate", "back"];
camDestroy wccam;

wccam = objNull;
