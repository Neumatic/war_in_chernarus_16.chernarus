/*
	Author: Neumatic
	Description: Takes an array of strings and converts the strings to UPPER
	or lower case based on parameter.

	Parameter(s):
		0: [Array] Array to convert.
		1: [String] Convert type.

	Example(s):
		_array = [["String0","strING1","STRIng2"], "toUpper"] call WC_fnc_convertStrings;
		-> _array = ["STRING0","STRING1","STRING2"];

	Returns:
		Array
*/

private ["_temp", "_case", "_array", "_sel"];

_temp = _this select 0;
_case = _this select 1;

_array = [];
_case = toUpper _case;

for "_i" from 0 to (count _temp - 1) do {
	_sel = _temp select _i;
	switch (typeName _sel) do {
		case (typeName ""): {
			_sel = switch (_case) do {
				case "TOUPPER": {toUpper _sel};
				case "TOLOWER": {toLower _sel};
			};
		};
		case (typeName []): {
			_sel = [_sel, _case] call WC_fnc_convertStrings;
		};
		default {};
	};
	_array set [_i, _sel];
};

_array
