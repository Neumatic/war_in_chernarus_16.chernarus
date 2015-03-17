/*
	Author: Neumatic
	Description: Select an index from an array using parameters.

	Parameter(s):
		0: [Array] Array to select from.
		1: [Scalar] Index of array to select.

	Optional parameter(s):
		2: [Any] Default parameter to return.
		3: [Any] Parameter types that are acceptible.

	Example(s):
		_param = [_this, 0, objNull, [objNull]] call WC_fnc_param;

	Returns:
		Any
*/

private ["_array", "_index", "_default", "_types", "_param", "_select"];

_array   = _this select 0;
_index   = _this select 1;
_default = if (count _this > 2) then {_this select 2} else {"nil"};
_types   = if (count _this > 3) then {_this select 3} else {[]};

switch (count _this) do {
	// Select an entry from an array.
	case 2: {
		if (count _array > _index) then {
			_param = _array select _index;
		} else {
			_param = _default;
		};
	};

	// If no entry then return a default parameter.
	case 3: {
		if (count _array > _index) then {
			_param = _array select _index;
		} else {
			_param = _default;
		};
	};

	// Select an entry index and check if it is a correct typeName.
	case 4: {
		if (count _array > _index) then {
			_select = _array select _index;

			if ({typeName _select == typeName _x} count _types > 0) then {
				_param = _select;
			} else {
				_param = _default;
			};
		} else {
			_param = _default;
		};
	};

	// Something went wrong.
	default {_param = _default};
};

_param
