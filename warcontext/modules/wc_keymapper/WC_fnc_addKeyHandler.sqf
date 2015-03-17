/*
	Author: CBA
	Edited by: Neumatic
	Description: Inspired by CBA. Adds key handler using parameters. Code must
	return a boolean.

	Parameter(s):
		0: [String] Key handler type (KeyDown / KeyUp)
		1: [Scalar] Which key
		2: [Array] Key modifier
		3: [Code] Code to run

	Example(s):
		_index = ["KeyDown", 15, [false, false, false], { // code... }] call WC_fnc_addKeyHandler;
		-> _index = 0;

	Returns:
		Scalar
*/

private ["_type", "_key", "_mod", "_code", "_handlers", "_index"];

_type = _this select 0;
_key  = _this select 1;
_mod  = _this select 2;
_code = _this select 3;

_handlers = switch (_type) do {
	case "KeyDown": {WC_EH_KeyDown};
	case "KeyUp": {WC_EH_KeyUp};
};

_index = count _handlers;
_handlers set [_index, [_key, _mod, _code]];

_index
