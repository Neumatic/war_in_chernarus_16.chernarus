/*
	Function: Creates Commanding Menu with groups, returns choosed group - waits for choosing (cannot be called where immediate response is needed)

	Input: array of groups
	Output: choosed group
*/

private ["_teams", "_label", "_group", "_data", "_labels", "_menu", "_return"];

_data = [];
_labels = [];
_teams = _this select 0;
_return = nil;

{
	_group = _x;

	if (!isNull _group) then
	{
		if !(isPlayer leader _x) then
		{
			_label = format ["(%1) %2 %3", localize "STRWFAI", localize format ["str_short_%1", rank leader _x], name leader _x];
			_data = _data + [_group];
			_labels = _labels + [_label];
		}
		else
		{
			if (player != leader _x) then
			{ // Player is excluded, other players on MP are in list
				_label = format ["%2 %3", localize "STRWFAI", localize format ["str_short_%1", rank leader _x], name leader _x];
				_data = _data + [_group];
				_labels = _labels + [_label];
			};
		};
	};
} forEach _teams;

BIS_SQLMENU_RETURN = nil;

_menu = [_data,_labels];
["Menu", "BIS_COMM_SQLMENU", _menu, "","BIS_SQLMENU_RETURN = '%2'"] call BIS_FNC_createmenu;

showCommandingMenu "#USER:BIS_COMM_SQLMENU_0";
waitUntil {!isNil {BIS_SQLMENU_RETURN}};
_return = _data select call compile BIS_SQLMENU_RETURN;
_return