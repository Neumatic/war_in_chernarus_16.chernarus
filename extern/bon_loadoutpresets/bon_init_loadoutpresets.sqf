presetDialogUpdate = compile (preprocessFileLineNumbers "extern\bon_loadoutpresets\bon_func_presetdlgUpdate.sqf"); sleep 0.1;

if (!isServer) exitWith {};

private ["_classnames"];

_classnames = [		// Each element presents one class, ["<classname>", <limitation>]
	["Neumatic", -1],
	["Eightbit", -1],
	["Xyber", -1]
];

{
	Server setVariable [_x select 0, _x select 1, true];
} forEach _classnames;