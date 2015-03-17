/*
	Author: Neumatic
	Description: Count empty positions of a vehicle.

	Parameter(s):
		0: [Object] Object to count positions.

	Example(s):
		_count = [vehicle player] call WC_fnc_countEmptyPositions;
		-> _count = 3;

	Returns:
		Scalar
*/

private ["_count", "_positions"];

_count = 0;
_positions = ["Driver","Gunner","Commander","Cargo"];

for "_i" from 0 to (count _positions - 1) do {
	_count = _count + ((_this select 0) emptyPositions (_positions select _i));
};

_count
