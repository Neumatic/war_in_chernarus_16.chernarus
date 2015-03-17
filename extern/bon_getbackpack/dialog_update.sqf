// by Bon_Inf*

#include "dialog\definitions.sqf"

disableSerialization;

waitUntil {dialog};

private ["_dialog", "_ctrl", "_list", "_name", "_backpack", "_picture"];

_dialog = findDisplay BON_BACKPACK_DIALOG;
_ctrl = _dialog displayCtrl BON_BACKPACK_PICTURE;
_list = _dialog displayCtrl BON_BACKPACK_LIST;

#include "backpacks.sqf"
if (isNil "bon_getbackpack_index") then {bon_getbackpack_index = 0};

if (lbSize _list == 0) then {
	{
		_name = getText (configFile >> "cfgweapons" >> _x >> "displayname");
		_list lbAdd _name;
	} forEach bon_getbackpack_backpacks;
};

if (lbCurSel _list < 0) then {_list lbSetCurSel bon_getbackpack_index} else {bon_getbackpack_index = lbCurSel _list};

_backpack = bon_getbackpack_backpacks select (bon_getbackpack_index max 0);

_picture = getText (configFile >> "cfgweapons" >> _backpack >> "picture");
_ctrl ctrlSetStructuredText parseText format ["<img image='%1' />", _picture];