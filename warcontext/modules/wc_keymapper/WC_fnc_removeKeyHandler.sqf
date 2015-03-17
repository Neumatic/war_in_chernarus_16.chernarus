/*
	Author: CBA
	Edited by: Neumatic
	Description: Inspired by CBA. Removes key handler.

	Parameter(s):
		0: [String] Key handler type (KeyDown / KeyUp)
		1: [Scalar] The index to remove

	Example(s):
		_bool = ["KeyDown", _index] call WC_fnc_removeKeyHandler;
		-> _bool = true;

	Returns:
		Bool
*/

private ["_type", "_index", "_handlers", "_removed"];

_type  = _this select 0;
_index = _this select 1;

_handlers = switch (_type) do {
	case "KeyDown": {WC_EH_KeyDown};
	case "KeyUp": {WC_EH_KeyUp};
};

_removed = _index >= 0 && _index < count _handlers;

if (_removed) then {
	if (!isNil {_handlers select _index}) then {
		_handlers set [_index, nil];
	} else {
		_removed = false;
	};
};

_removed
