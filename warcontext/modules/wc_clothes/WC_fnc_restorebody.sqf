// -----------------------------------------------
// Author:     code34 nicolas_boiteux@yahoo.fr
// Edited by:  Neumatic
// Warcontext: Restore body with good clothes
// -----------------------------------------------

private ["_killer", "_dummy"];

_killer = _this select 0;

wcbackupbody setPos wcbackupposition;

waitUntil {alive player};
_dummy = player;
player setPos getMarkerPos "initpos";
selectPlayer wcbackupbody;
deleteVehicle _dummy;
