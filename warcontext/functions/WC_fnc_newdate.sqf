// -----------------------------------------------
// Author:     code34 nicolas_boiteux@yahoo.fr
// Warcontext: Create a new date after currently date
// Do not use bisextil year
// -----------------------------------------------

private ["_year", "_month", "_day", "_hour", "_minute", "_num_of_days", "_time"];

_year   = (date select 0);
_month  = (date select 1);
_day    = (date select 2);
_hour   = floor (random 23);
_minute = floor (random 59);

_num_of_days = [0,31,28,31,30,31,30,31,31,30,31,30,31];

if (_hour < (date select 3)) then {
	if (_day < (_num_of_days select _month)) then {
		_day = (date select 2) + 1;
	} else {
		_day = 1;
		_month = _month + 1;
	};
} else {
	_day = (date select 2);
};

_time = [_year, _month, _day, _hour, _minute];

_time
