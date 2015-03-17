// -----------------------------------------------
// Author:     code34 nicolas_boiteux@yahoo.fr
// Edited by:  Neumatic
// Warcontext: Enums music
// -----------------------------------------------

private ["_tracks", "_entry"];

_tracks = [];

_entry = configFile >> "CfgMusic";
for "_i" from 1 to (count _entry - 1) do {
	_tracks set [count _tracks, configName (_entry select _i)];
};

_tracks
