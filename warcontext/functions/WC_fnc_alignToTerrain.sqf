/*
	Author: BIS Wiki
	Edited by: Neumatic
	Description: Align object with the terrain underneath.

	Parameter(s):
		0: [Object] Object to align to terrain.

	Example(s):
		[_object] call WC_fnc_alignToTerrain;

	Returns:
		nil
*/

private ["_object", "_pos"];

_object = _this select 0;

_pos = [_object] call WC_fnc_getPos;
_object setVectorUp (surfaceNormal _pos);

nil
