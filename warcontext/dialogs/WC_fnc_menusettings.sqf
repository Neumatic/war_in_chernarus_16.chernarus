// -----------------------------------------------
// Author:     code34 nicolas_boiteux@yahoo.fr, Xeno - domination
// Edited by:  Neumatic
// Warcontext: Create a settings dialog box
// -----------------------------------------------

private ["_terrain_grid", "_view_dist", "_view_dist_max", "_text"];

//playSound "paper";

_terrain_grid = wcterraingrid;
_view_dist = wcviewdist;
_view_dist_max = wcviewdistance;

ctrlSetText [13001, format [localize "STR_ACGUI_VM_TXT_VD", _view_dist]];
ctrlSetText [13003, format [localize "STR_ACGUI_VM_TXT_TG", (50 - _terrain_grid)]];

sliderSetRange [13002, 100, _view_dist_max];
sliderSetRange [13004, 0, 50];

SliderSetPosition [13002, _view_dist];
SliderSetPosition [13004, (50 - _terrain_grid)];

_text = "Game settings";
lbAdd [13007, _text];

for "_i" from 0 to (count paramsArray - 1) do {
	_text = format ["%1 = %2", configName ((missionConfigFile >> "Params") select _i), paramsArray select _i];
	lbAdd [13007, _text];
};

_text = "";
lbAdd [13007, _text];

_text = "Missing Addons";
lbAdd [13007, _text];

if (count wccfglocalpatches > 0) then {
	{
		_text = format ["%1", _x];
		lbAdd [13007, _text];
	} forEach wccfglocalpatches;
} else {
	_text = "None";
	lbAdd [13007, _text];
};

menuaction = -1;

while {dialog && {alive player}} do {
	sleep 0.1;

	_view_dist = floor (sliderPosition 13002);
	_terrain_grid = (50 - floor (sliderPosition 13004));

	ctrlSetText [13001, format [localize "STR_ACGUI_VM_TXT_VD", _view_dist]];
	ctrlSetText [13003, format [localize "STR_ACGUI_VM_TXT_TG", (50 - _terrain_grid)]];

	if (menuaction == 2) then {
		menuaction = -1;
		closeDialog 0;

		setViewDistance _view_dist;
		setTerrainGrid _terrain_grid;

		wcterraingrid = _terrain_grid;
		wcviewdist = _view_dist;
	};
};

menuaction = -1;
