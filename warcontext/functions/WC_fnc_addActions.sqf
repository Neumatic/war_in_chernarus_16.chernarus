/*
	Author: Neumatic
	Description: Add actions using parameters.

	Paramter(s):
		0: [Object] Add action target.
		1: [String] Add action type.

	Example(s):
		[_object, "DEFEND_AREA"] call WC_fnc_addActions;

	Returns:
		nil
*/

private [
	"_target", "_type", "_act_params", "_text", "_script", "_arguments", "_priority", "_show_window", "_hide_on_use",
	"_shortcut", "_condition", "_var_name", "_act_id"
];

_target = _this select 0;
_type   = _this select 1;

_act_params = [];
_act_params set [0, _target];

_text = "nil";
_script = "nil";
_arguments = "nil";
_priority = "nil";
_show_window = "nil";
_hide_on_use = "nil";
_shortcut = "nil";
_condition = "nil";
_var_name = "nil";

switch (toUpper _type) do {
	case "DEFEND_AREA": {
		_text = "<t color='#ff4500'>Defend the area</t>";
		_script = "warcontext\actions\WC_fnc_dobegindefend.sqf";
		_arguments = [];
		_priority = 6;
		_show_window = false;
		_hide_on_use = true;
		_shortcut = "";
		_condition = "true";
		_var_name = "Action_Defend";
	};

	case "REPLACE_GUARD": {
		_text = "<t color='#ff4500'>Replace the guard</t>";
		_script = "warcontext\actions\WC_fnc_dobeginguard.sqf";
		_arguments = [];
		_priority = 6;
		_show_window = false;
		_hide_on_use = true;
		_shortcut = "";
		_condition = "true";
		_var_name = "Action_Guard";
	};

	case "TELEPORT_BASE": {
		_text = "<t color='#dddd00'>Teleport to base</t>";
		_script = "warcontext\actions\WC_fnc_doreturntobase.sqf";
		_arguments = [];
		_priority = 1.5;
		_show_window = false;
	};

	case "DROP_AMMOBOX": {
		_text = "Drop an Ammobox";
		_script = "warcontext\actions\WC_fnc_docreateammobox.sqf";
		_arguments = [];
		_priority = 1.5;
		_show_window = false;
	};

	case "BUILD_VEHICLE": {
		_text = "<t color='#FFFFFF'>Build a vehicle</t>";
		_script = "warcontext\dialogs\WC_fnc_createmenubuildvehicles.sqf";
		_arguments = [];
		_priority = 1.5;
		_show_window = false;
	};

	case "HALO_JUMP": {
		_text = "Halo Jump";
		_script = "warcontext\actions\WC_fnc_dohalojump.sqf";
		_arguments = [];
		_priority = 1.5;
		_show_window = false;
	};

	case "TELEPORT_TENT": {
		_text = "Teleport to TENT";
		_script = "warcontext\actions\WC_fnc_doteleporttotent.sqf";
		_arguments = [];
		_priority = 1.5;
		_show_window = false;
	};

	case "TELEPORT_MHQ": {
		_text = "Teleport to MHQ";
		_script = "warcontext\actions\WC_fnc_doteleporttomhq.sqf";
		_arguments = [];
		_priority = 1.5;
		_show_window = false;
	};

	case "FOLLOW_ME": {
		_text = "<t color='#ff4500'>Follow me</t>";
		_script = "warcontext\actions\WC_fnc_dofollowme.sqf";
		_arguments = [];
		_priority = 6;
		_show_window = false;
		_hide_on_use = true;
		_shortcut = "";
		_condition = "true";
		_var_name = "Action_FollowMe";
	};

	case "SEARCH_UNIT": {
		_text = "<t color='#ffcb00'>Search unit</t>";
		_script = "warcontext\actions\WC_fnc_dosearchsomeone.sqf";
		_arguments = [];
		_priority = 6;
		_show_window = false;
		_hide_on_use = true;
		_shortcut = "";
		_condition = "true";
		_var_name = "Action_Search";
	};

	case "HANDS_UP": {
		_text = "<t color='#ffcb00'>Hands up</t>";
		_script = "warcontext\actions\WC_fnc_dohandsup.sqf";
		_arguments = [];
		_priority = 6;
		_show_window = false;
		_hide_on_use = true;
		_shortcut = "";
		_condition = "true";
		_var_name = "Action_HandsUp";
	};

	case "BUILD_OBJECT": {
		_text = "<t color='#ff4500'>Build</t>";
		_script = "warcontext\actions\WC_fnc_dobuild.sqf";
		_arguments = [];
		_priority = 6;
		_show_window = false;
		_hide_on_use = true;
		_shortcut = "";
		_condition = "true";
		_var_name = "Action_Build";
	};

	case "SABOTAGE_OBJECT": {
		_text = "<t color='#ff4500'>Sabotage</t>";
		_script = "warcontext\actions\WC_fnc_dosabotage.sqf";
		_arguments = [];
		_priority = 6;
		_show_window = false;
		_hide_on_use = true;
		_shortcut = "";
		_condition = "true";
		_var_name = "Action_Sabotage";
	};

	case "DISARM_IED": {
		_text = "<t color='#ff4500'>Disarm IED</t>";
		_script = "warcontext\actions\WC_fnc_dodisarmied.sqf";
		_arguments = [];
		_priority = 6;
		_show_window = false;
		_hide_on_use = true;
		_shortcut = "";
		_condition = "true";
		_var_name = "Action_IED";
	};
};

{
	if (format ["%1", _x] != "nil") then {
		_act_params set [count _act_params, _x];
	};
} forEach [
	_text,
	_script,
	_arguments,
	_priority,
	_show_window,
	_hide_on_use,
	_shortcut,
	_condition,
	_var_name
];

_act_id = _act_params spawn WC_fnc_addAction;

_act_id
