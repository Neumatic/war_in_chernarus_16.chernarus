/*
	Author: CBA
	Edited by: Neumatic
	Description: Inspired by CBA. Removes key handler.

	Parameter(s):
		0: [String] Key handler type (KeyDown / KeyUp)
		1: [Scalar] Which key
		2: [Scalar] The index to remove

	Example(s):
		_bool = ["KeyDown", DIK_TAB, _index] call WC_fnc_removeKeyHandler;
		-> _bool = true;

	Returns:
		Bool
*/

private ["_type", "_index", "_handlers", "_removed"];

_type  = _this select 0;
_key   = _this select 1;
_index = _this select 2;

_handlers = missionNamespace getVariable [format ["WC_EH_%1_%2", _type, _key], []];

_removed = _index >= 0 && _index < count _handlers;

if (_removed) then {
	if (!isNil {_handlers select _index}) then {
		_handlers set [_index, "<DELETE>"];
		_handlers = _handlers - ["<DELETE>"];
		missionNamespace setVariable [format ["WC_EH_%1_%2", _type, _key], _handlers];
	} else {
		_removed = false;
	};
};

_removed
