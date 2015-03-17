/*
	Author: CBA
	Edited by: Neumatic
	Description: Inspired by CBA. Handles key presses.

	Parameter(s):
		0: [String] Key handler type (KeyDown / KeyUp)
		1: [Array] Key data

	Example(s):
		_bool = ["KeyDown", _this] call WC_fnc_keyHandler;
		-> _bool = true;

	Returns:
		Bool
*/

#include <dik_codes.h>

private ["_type", "_params", "_result", "_handled", "_handlers", "_index", "_check", "_mod"];

_type   = _this select 0;
_params = _this select 1;

_result = false;
_handled = false;

_handlers = switch (_type) do {
	case "KeyDown": {WC_EH_KeyDown};
	case "KeyUp": {WC_EH_KeyUp};
};

if (count _handlers > 0) then {
	{
		_index = _x;
		if (!isNil "_index") then {
			if ((_index select 0) == (_params select 1)) then {
				_check = true;
				_mod = _index select 1;

				for "_i" from 0 to 2 do {
					if (((_mod select _i) && {!(_params select (_i + 2))})
					|| {(!(_mod select _i) && {(_params select (_i + 2))})}
					) exitWith {
						_check = false;
					};
				};

				if (_check) then {
					_result = _params call (_index select 2);
				};
			};
		};

		if (_result) exitWith {_handled = true};
	} forEach _handlers;
};

_handled
