// -----------------------------------------------
// Author:     code34 nicolas_boiteux@yahoo.fr, Xeno - domination
// Edited by:  Neumatic
// Warcontext: Create a mission info dialog box
// -----------------------------------------------

private ["_count", "_name", "_index"];

disableSerialization;

if (isNil "WC_fnc_transfert") then {
	WC_fnc_transfert = {
		private ["_point", "_index", "_friend", "_me"];

		_point = ceil (sliderPosition 16005);
		if (_point > 0) then {
			_index = lbCurSel 16006;
			_friend = lbData [16006, _index];

			// Only a trick to retrieve the player object refering to _friend
			{
				//if (side _x == west && {name _x == _friend}) then {
				if (isPlayer _x && {name _x == _friend}) then {
					_me = name player;
					wcteamplayaddscore = [_friend, _me, _point];
					["wcteamplayaddscore", "client"] call WC_fnc_publicvariable;

					wcplayeraddscore = [_x, _point];
					["wcplayeraddscore", "server"] call WC_fnc_publicvariable;

					wcteamplayscore = wcteamplayscore - _point;
					if (wcteamplayscore < 0) then {
						wcteamplayscore = 0;
					};
				};
			} forEach allUnits;
		};
	};
};

//playSound "paper";

lbClear 16006;
_count = 0;
{
	_name = name _x;
	if (isPlayer _x && {_name != name player}) then {
		_index = lbAdd [16006, format ["[%1] %2", _count, _name]];
		lbSetData [16006, _index, _name];
		lbSetValue [16006, _index, (_count - 1)];
		_count = _count + 1;
	};
} forEach allUnits;

if (_count == 0) then {
	_name = name player;
	_index = lbAdd [16006, format ["[%1] %2", _count, _name]];
	lbSetData [16006, _index, _name];
	lbSetValue [16006, _index, (_count - 1)];
};

lbSetCurSel [16006, 0];

while {dialog && {alive player}} do {
	sliderSetRange [16005, 0, wcteamplayscore];
	ctrlSetText [16004, format [localize "STR_WC_POINTSTOTRANSFERT", ceil (sliderPosition 16005), wcteamplayscore]];
	sleep 0.05;
};
