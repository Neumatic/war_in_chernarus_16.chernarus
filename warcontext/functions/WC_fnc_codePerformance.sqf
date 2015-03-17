/*
	Author: BIS Wiki / CBA
	Edited by: Neumatic
	Description: Test codes performance.

	Parameter(s):
		0: [Code] Code to test.
		1: [Array] Parameters to pass.
		2: [Scalar] Iterations to run.

	Example(s):
		[{// code...}, [_param_0, _param_1], 100] call WC_fnc_codePerformance;

	Returns:
		Scalar
*/

private ["_code", "_params", "_iterate", "_tick_time", "_total_time"];

_code    = _this select 0;
_params  = if (count _this > 1) then {_this select 1} else {[]};
_iterate = if (count _this > 2) then {_this select 2} else {1};

_tick_time = diag_tickTime;

for "_i" from 1 to _iterate do {
	_params call _code;
};

_total_time = (diag_tickTime - _tick_time) / _iterate;

player globalChat (str _total_time);

_total_time
