// -----------------------------------------------
// Author:     code34 nicolas_boiteux@yahoo.fr
// Edited by:  Neumatic
// Warcontext: Random weather
// -----------------------------------------------

private ["_rain", "_last_rain", "_overcast", "_fog", "_wind", "_time_forecast"];

// Random time before new forecast
#define FORECAST_TIME_RANDOM

// Min time seconds (real time) before a new weather forecast
#define FORECAST_TIME_MIN 600

// Max time seconds (real time) before a new weather forecast
#define FORECAST_TIME_MAX 1200

_rain = 0;
_last_rain = 0;
_overcast = 0;

while {true} do {
	_overcast = random 1;
	if (_overcast > 0.68) then {
		_rain = random 1;
	} else {
		_rain = 0;
	};

	if (objNull call WC_fnc_sunAngle) then {
		_fog = 0.4 + (random 0.6);
	} else {
		if ((_last_rain > 0.6) && (_rain < 0.2)) then {
			_fog = random 0.3;
		} else {
			_fog = 0;
		};
	};

	_last_rain = _rain;

	if (random 1 > 0.95) then {
		_wind = [random 7, random 7, true];
	} else {
		_wind = [random 3, random 3, true];
	};

	setWind _wind;

	wcweather = [_rain, _fog, _overcast, _wind];
	["wcweather", "client"] call WC_fnc_publicvariable;

	#ifdef FORECAST_TIME_RANDOM
		_time_forecast = FORECAST_TIME_MIN + (random (FORECAST_TIME_MAX - FORECAST_TIME_MIN));
	#else
		_time_forecast = FORECAST_TIME_MIN;
	#endif

	sleep _time_forecast;
};
