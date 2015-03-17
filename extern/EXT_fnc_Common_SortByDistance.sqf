private ["_count", "_count1", "_current", "_nearest", "_nearestDistance", "_object", "_objects", "_sorted", "_total", "_distance"];

_object = _this select 0;
_objects = +(_this select 1);

_sorted = [];

_total = count _objects;
for [{_count = 0}, {_count < _total}, {_count = _count + 1}] do {
	_nearest = objNull;
	_nearestDistance = 100000;

	for [{_count1 = count _objects - 1}, {_count1 >= 0}, {_count1 = _count1 - 1}] do {
		_current = _objects select _count1;
		_distance = [_current, _object] call WC_fnc_getDistance;

		if (_distance < _nearestDistance) then {_nearest = _current; _nearestDistance = _distance};
	};

	_sorted = _sorted + [_nearest];
	_objects = _objects - [_nearest];
};

_sorted