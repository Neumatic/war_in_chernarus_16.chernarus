// -----------------------------------------------
// Author:     code34 nicolas_boiteux@yahoo.fr
// Edited by:  Neumatic
// Warcontext: HANDLE KEYBOARD EVENTS
// -----------------------------------------------

#include <dik_codes.h>

// TAB
["KeyDown", DIK_TAB, [false, true, false], {
	private ["_handled"];
	_handled = false;
	if (format ["%1", wcanim] != "") then {
		terminate wcanim;
		wccam cameraEffect ["terminate", "back"];
		camDestroy wccam;
		wccam = objNull;
		wcanim = "";
		playMusic "";
		titleText ["", "PLAIN"];
		ppEffectDestroy wccameffect;
		"FilmGrain" ppEffectEnable false;
		camUseNVG false;
		false setCamUseTi 1;
		_handled = true;
	} else {
		if (wcrankactivate) then {
			wcrankactivate = false;
			playMusic "";
			player cameraEffect ["terminate", "back"];
			_handled = true;
		} else {
			wcrankactivate = true;
			playMusic "";
			_handled = true;
		};
	};
	if (count wcadvancetodate > 0) then {
		setDate wcadvancetodate;
		wcadvancetodate = [];
		_handled = true;
	};
	_handled
}] call WC_fnc_addKeyHandler;

// NUM_1
["KeyDown", DIK_NUMPAD1, [false, false, false], {
	private ["_handled"];
	_handled = false;
	if (wciedchallenge) then {
		if (iedkey == "1") then {
			wciedcount = wciedcount + 1;
		} else {
			wciedexplosed = true;
		};
		playSound "bip1";
		_handled = true;
	};
	_handled
}] call WC_fnc_addKeyHandler;

// NUM_2
["KeyDown", DIK_NUMPAD2, [false, false, false], {
	private ["_handled"];
	_handled = false;
	if (wciedchallenge) then {
		if (iedkey == "2") then {
			wciedcount = wciedcount + 1;
		} else {
			wciedexplosed = true;
		};
		playSound "bip2";
		_handled = true;
	};
	_handled
}] call WC_fnc_addKeyHandler;

// NUM_3
["KeyDown", DIK_NUMPAD3, [false, false, false], {
	private ["_handled"];
	_handled = false;
	if (wciedchallenge) then {
		if (iedkey == "3") then {
			wciedcount = wciedcount + 1;
		} else {
			wciedexplosed = true;
		};
		playSound "bip3";
		_handled = true;
	};
	_handled
}] call WC_fnc_addKeyHandler;

// NUM_4
["KeyDown", DIK_NUMPAD4, [false, false, false], {
	private ["_handled"];
	_handled = false;
	if (wciedchallenge) then {
		if (iedkey == "4") then {
			wciedcount = wciedcount + 1;
		} else {
			wciedexplosed = true;
		};
		playSound "bip4";
		_handled = true;
	};
	_handled
}] call WC_fnc_addKeyHandler;

// NUM_5
["KeyDown", DIK_NUMPAD5, [false, false, false], {
	private ["_handled"];
	_handled = false;
	if (wciedchallenge) then {
		if (iedkey == "5") then {
			wciedcount = wciedcount + 1;
		} else {
			wciedexplosed = true;
		};
		playSound "bip5";
		_handled = true;
	};
	_handled
}] call WC_fnc_addKeyHandler;

// NUM_6
["KeyDown", DIK_NUMPAD6, [false, false, false], {
	private ["_handled"];
	_handled = false;
	if (wciedchallenge) then {
		if (iedkey == "6") then {
			wciedcount = wciedcount + 1;
		} else {
			wciedexplosed = true;
		};
		playSound "bip6";
		_handled = true;
	};
	_handled
}] call WC_fnc_addKeyHandler;

// NUM_7
["KeyDown", DIK_NUMPAD7, [false, false, false], {
	private ["_handled"];
	_handled = false;
	if (wciedchallenge) then {
		if (iedkey == "7") then {
			wciedcount = wciedcount + 1;
		} else {
			wciedexplosed = true;
		};
		playSound "bip7";
		_handled = true;
	};
	_handled
}] call WC_fnc_addKeyHandler;

// NUM_8
["KeyDown", DIK_NUMPAD8, [false, false, false], {
	private ["_handled"];
	_handled = false;
	if (wciedchallenge) then {
		if (iedkey == "8") then {
			wciedcount = wciedcount + 1;
		} else {
			wciedexplosed = true;
		};
		playSound "bip8";
		_handled = true;
	};
	_handled
}] call WC_fnc_addKeyHandler;

// NUM_9
["KeyDown", DIK_NUMPAD9, [false, false, false], {
	private ["_handled"];
	_handled = false;
	if (wciedchallenge) then {
		if (iedkey == "9") then {
			wciedcount = wciedcount + 1;
		} else {
			wciedexplosed = true;
		};
		playSound "bip9";
		_handled = true;
	};
	_handled
}] call WC_fnc_addKeyHandler;

/*
	Shift + N
	Controls cutscene white hot.
*/
["KeyDown", DIK_N, [true, false, false], {
	private ["_handled"];
	_handled = false;
	if (format ["%1", wcanim] != "") then {
		camUseNVG wccamnvg;
		false setCamUseTi 0;
		wccamnvg = !wccamnvg;
		_handled = true;
	};
	_handled
}] call WC_fnc_addKeyHandler;

/*
	Y
	Player jumps.
*/
["KeyDown", DIK_Y, [false, false, false], {
	private ["_handled"];
	_handled = false;
	if (!WC_PlayerMove) then {
		objNull spawn {
			private ["_vel", "_dir", "_speed"];
			if (vehicle player == player) then {
				if ((([player] call WC_fnc_getPos) select 2) < 0.1) then {
					WC_PlayerMove = true;
					_vel = velocity player;
					_dir = direction player;
					if ((abs (_vel select 0) > 1) || {(abs (_vel select 1) > 1)}) then {
						_speed = -0.5;
						player setVelocity [(_vel select 0) + ((sin _dir) * _speed), (_vel select 1) + ((cos _dir) * _speed), 4];
						sleep 0.7;
						player playMove "amovpercmevasraswrfldf";
						player playMove "amovpercmevasraswrfldf";
						sleep 4;
					} else {
						_speed = 0;
						player setVelocity [(_vel select 0) + ((sin _dir) * _speed), (_vel select 1) + ((cos _dir) * _speed), 4];
						sleep 2;
					};
					WC_PlayerMove = false;
				};
			};
		};
		_handled = true;
	};
	_handled
}] call WC_fnc_addKeyHandler;

/*
	T
	Player does a summersault.
*/
["KeyDown", DIK_T, [false, false, false], {
	private ["_handled"];
	_handled = false;
	if (!WC_PlayerMove) then {
		WC_PlayerMove = true;
		objNull spawn {
			player playMove "ActsPercMrunSlowWrflDf_FlipFlopPara";
			sleep 8;
			WC_PlayerMove = false;
		};
		_handled = true;
	};
	_handled
}] call WC_fnc_addKeyHandler;

/*
	+
	Increase and set view distance.
*/
["KeyUp", DIK_EQUALS, [false, false, false], {
	private ["_handled", "_view_dist"];
	_handled = false;
	_view_dist = wcviewdist;
	_view_dist = _view_dist + 500;
	if (_view_dist > wcviewdistance) then {
		_view_dist = wcviewdistance;
	};
	player globalChat format [localize "STR_ACGUI_VM_TXT_VD", _view_dist];
	setViewDistance _view_dist;
	wcviewdist = _view_dist;
	_handled
}] call WC_fnc_addKeyHandler;

/*
	-
	Decrease and set view distance.
*/
["KeyUp", DIK_MINUS, [false, false, false], {
	private ["_handled", "_view_dist"];
	_handled = false;
	_view_dist = wcviewdist;
	_view_dist = _view_dist - 500;
	if (_view_dist < 100) then {
		_view_dist = 100;
	};
	player globalChat format [localize "STR_ACGUI_VM_TXT_VD", _view_dist];
	setViewDistance _view_dist;
	wcviewdist = _view_dist;
	_handled
}] call WC_fnc_addKeyHandler;

nil
