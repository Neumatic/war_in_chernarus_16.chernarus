// ANTI-TURNOVER TANK v1.0, By Miguel Rodriguez (mgllgm@hotmail.com - Murcielago_ESP)
// sanity vehicle by code34

private ["_vehicle", "_vel", "_dir", "_velocidad", "_pos"];

_vehicle = _this select 0;

while {alive _vehicle} do {
	_vel = velocity _vehicle;
	_dir = direction _vehicle;
	_velocidad = (velocity _vehicle select 2);

	if ((vectorUp _vehicle select 2) < 0.55) then {
		_vehicle setVectorUp [(vectorUp _vehicle select 0) * 0.5, (vectorUp _vehicle select 1) * 0.5, 0.60];
	};

	if ((velocity _vehicle select 2) - _velocidad > 4) then {
		_pos = [_vehicle] call WC_fnc_getPos;
		_vehicle setPos [_pos select 0, _pos select 1, 0.5];
		_vehicle setVelocity [((_vel select 0) + (sin _dir)) * 0.5, ((_vel select 1) + (cos _dir)) * 0.5, 0];
	};
	sleep 0.5;
};