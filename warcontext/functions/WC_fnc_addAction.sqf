/*
	Author: Neumatic
	Description: Adds action menu to target object.

	Parameter(s):
		0: [Object] Target to add action menu to.
		1: [String] Text of the action menu.
		2: [String/Code] Code to run.

	Optional parameter(s):
		3: [Anything] Arguments to pass to script.
		4: [Scalar] Priority of action menu.
		5: [Boolean] Text at mid screen.
		6: [Boolean] Hide action menu after use.
		7: [String] Bind action to key name.
		8: [String] Condition script code.
		9: [String] Variable name to store action index.

	Example(s):
		[player, "Action menu", "path/to/script.sqf"] call WC_fnc_addAction;

	Returns:
		Scalar
*/

private [
	"_target", "_text", "_script", "_arguments", "_priority", "_show_window", "_hide_on_use", "_shortcut", "_condition",
	"_var_name", "_act_id"
];

_target = _this select 0;
_text   = _this select 1;
_script = _this select 2;

_arguments   = if (count _this > 3) then {_this select 3} else {[]};
_priority    = if (count _this > 4) then {_this select 4} else {1.5};
_show_window = if (count _this > 5) then {_this select 5} else {true};
_hide_on_use = if (count _this > 6) then {_this select 6} else {true};
_shortcut    = if (count _this > 7) then {_this select 7} else {""};
_condition   = if (count _this > 8) then {_this select 8} else {"true"};
_var_name    = if (count _this > 9) then {_this select 9} else {"nil"};

_act_id = _target addAction [_text, _script, _arguments, _priority, _show_window, _hide_on_use, _shortcut, _condition];

if (format ["%1", _var_name] != "nil") then {
	_target setVariable [_var_name, _act_id];
};

_act_id
