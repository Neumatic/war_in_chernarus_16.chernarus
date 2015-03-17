// -----------------------------------------------
// Author:     code34 nicolas_boiteux@yahoo.fr
// Edited by:  Neumatic
// Warcontext: Nuclear weapon with ACE
// -----------------------------------------------

private ["_unit", "_nuclear_ammo", "_nuclear_count", "_respawn_west", "_position", "_run", "_near_units"];

_unit         = _this select 0;
_nuclear_ammo = if (count _this > 1) then {_this select 1} else {1};

_nuclear_count = _nuclear_ammo;
_respawn_west = getMarkerPos "respawn_west";

while {alive _unit && {_nuclear_ammo > 0}} do {
	_run = true;

	while {_run} do {
		_position = position (wctownlocations call WC_fnc_selectRandom);
		_position = [_position] call WC_fnc_relocateposition;

		_run = false;

		if (_position distance _respawn_west < 2000) then {
			_run = true;
		} else {
			{
				if (_position distance _x < 1000) exitWith {
					_run = true;
				};
			} forEach wcnuclearzone;
		};

		sleep 0.1;
	};

	wcbomb = true;
	["wcbomb", "client"] call WC_fnc_publicvariable;

	wcmessageW = [format [localize "STR_WC_MESSAGEMISSIONCOMMANDEMENT", wclevel], "NUCLEAR BOMBING TAKE COVER"];
	["wcmessageW", "client"] call WC_fnc_publicvariable;

	// Create nuclear marker
	[format ["nuclear%1", wcnuclearindex], _position, 500, "ColorOrange", "ELLIPSE", "FDIAGONAL", "", 0, "", 1] call WC_fnc_createmarker;
	wcnuclearindex = wcnuclearindex + 1;

	sleep random 240;

	_near_units = _position nearEntities ["All", 500];
	{
		_x setDamage (0.5 + random 0.5);
	} forEach _near_units;

	wcnewnuclearzone = _position;
	["wcnewnuclearzone", "client"] call WC_fnc_publicvariable;

	wcnuclearzone set [count wcnuclearzone, _position];
	["wcnuclearzone", "client"] call WC_fnc_publicvariable;

	_nuclear_ammo = _nuclear_ammo - 1;

	sleep 240 + random 240;
};

["INFO", format ["%1 nuclear zones were created", _nuclear_count]] call WC_fnc_log;
