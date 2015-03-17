// -----------------------------------------------
// Author:     code34 nicolas_boiteux@yahoo.fr
// Edited by:  Neumatic
// Warcontext: Call halo jump
// -----------------------------------------------

private ["_caller", "_position", "_player_pos"];

_caller = _this select 1;

_position = [_caller] call WC_fnc_getPos;

[localize "STR_WC_MENUHALOJUMP", localize "STR_WC_MESSAGECLICKHALOJUMP", localize "STR_WC_MESSAGEHALOJUMPINFORMATION", 10] spawn WC_fnc_playerhint;

openMap [true, false];

wchalojumppos = [];

onMapSingleClick {
	titleText ["", "BLACK IN", 10];
	wchalojumppos = _pos;
	onMapSingleClick {};
	openMap [false, false];
};

while {alive _caller && {visibleMap}} do {
	sleep 0.5;
};

if (count wchalojumppos == 0) then {
	onMapSingleClick {};
	[localize "STR_WC_MENUHALOJUMP", localize "STR_WC_MESSAGEHALOJUMPNEWONE", localize "STR_WC_MESSAGECANCELHALOJUMPINFORMATION", 10] spawn WC_fnc_playerhint;
} else {
	_position = [wchalojumppos select 0, wchalojumppos select 1, 250];
	_player_pos = [_caller] call WC_fnc_getPos;
	[_caller, _position, _player_pos] spawn {
		private ["_caller", "_position", "_para", "_player_pos"];
		_caller     = _this select 0;
		_position   = _this select 1;
		_player_pos = _this select 2;
		{
			if (!isPlayer _x && {([_x, _player_pos] call WC_fnc_getDistance) < 50}) then {
				_para = createVehicle ["ParachuteC", _position, [], 0, "NONE"];
				_para setPos _position;
				_para setDir (getDir _caller);
				_para setVelocity [random 30, random 30, 10];
				_x moveInDriver _para;
				_para lock false;
				sleep 1;
			};
		} forEach units group _caller;
	};

	_caller setPos [wchalojumppos select 0, wchalojumppos select 1, 1000];
	_caller switchMove "HaloFreeFall_non";
	[_caller, 1000] spawn BIS_fnc_halo;
	[_caller] spawn WC_fnc_altimeter;
};
