// -----------------------------------------------
// Author:     code34 nicolas_boiteux@yahoo.fr
// Edited by:  Neumatic
// warcontext: Fast time effect
// -----------------------------------------------

private ["_hour", "_minute", "_done", "_clock_format", "_original", "_cible", "_curr_hour", "_curr_minute", "_clock"];

_hour   = _this select 3;
_minute = _this select 4;

_done = false;
_clock_format = [_hour, _minute] call WC_fnc_clockformat;

switch (wcskiptime) do {
	case 1: {
		waitUntil {vehicle player == player};
		waitUntil {isNull wccam};

		wccam = player;
		wcadvancetodate = _this;

		setViewDistance 1500;
		wccameffect = ppEffectCreate ["ColorCorrections", 1999];
		wccameffect ppEffectEnable true;
		wccameffect ppEffectAdjust [0.5, 0.7, 0.0, [1.0,1.0,1.0,0.0], [1.0,1.0,1.0,0.0], [1.0,1.0,1.0,1.0]];
		wccameffect ppEffectCommit 0;

		_original = dateToNumber date;
		_cible = dateToNumber _this;

		if (((_cible - _original) < 0.000015) || {((_original - _cible) > 0.000001)}) then {
			setDate _this;
			_done = true;
			_curr_hour   = date select 3;
			_curr_minute = date select 4;
			_clock = [_curr_hour, _curr_minute] call WC_fnc_clockformat;
		};

		while {!_done} do {
			_curr_hour   = date select 3;
			_curr_minute = date select 4;
			_clock = [_curr_hour, _curr_minute] call WC_fnc_clockformat;

			if (_hour != _curr_hour) then {
				skipTime 0.009;
			} else {
				setDate _this;
				_done = true;
				_curr_hour   = date select 3;
				_curr_minute = date select 4;
				_clock = [_curr_hour, _curr_minute] call WC_fnc_clockformat;
			};

			hintSilent format ["Fast time: %1 -> %2 \nPress Tab key to skip fast time", _clock, _clock_format];
			sleep 0.0005;
		};

		ppEffectDestroy wccameffect;
		setViewDistance wcviewdist;
		wccam = objNull;
		wcadvancetodate = [];
	};

	// If instant fast forward
	case 2: {
		setDate _this;
		_curr_hour   = date select 3;
		_curr_minute = date select 4;
		_clock = [_curr_hour, _curr_minute] call WC_fnc_clockformat;
		hintSilent format ["Fast time: %1", _clock];
	};
};
