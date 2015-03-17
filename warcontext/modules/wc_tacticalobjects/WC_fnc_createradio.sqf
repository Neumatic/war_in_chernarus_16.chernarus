// -----------------------------------------------
// Author:     code34 nicolas_boiteux@yahoo.fr
// Edited by:  Neumatic
// Warcontext: Create a radio tower
// -----------------------------------------------

// Check for an electrical outage
if (random 1 > wcenemyglobalelectrical) exitWith {
	wcmessageW = ["Radio tower", "Electrical outage"];
	["wcmessageW", "client"] call WC_fnc_publicvariable;

	wcradioalive = false;
	["wcradioalive", "client"] call WC_fnc_publicvariable;
	objNull
};

private ["_position", "_radio_type", "_protect", "_type", "_radio", "_text"];

_position   = _this select 0;
_radio_type = _this select 1;

if (count _position == 0) then {
	wcmessageW = ["Radio tower", "Electrical outage"];
	["wcmessageW", "client"] call WC_fnc_publicvariable;

	wcradioalive = false;
	["wcradioalive", "client"] call WC_fnc_publicvariable;
	objNull
};

_protect = wccurrentmission select 4;

_type = _radio_type call WC_fnc_selectRandom;
_radio = createVehicle [_type, [0,0,0], [], 0, "NONE"];
_radio setDir (random 360);
_radio setPos _position;
[_radio] call WC_fnc_alignToTerrain;

_radio removeAllEventHandlers "HandleDamage";
_radio addEventHandler ["HandleDamage", {
	private ["_damage", "_shooter"];
	_damage  = _this select 2;
	_shooter = _this select 3;
	if (isPlayer _shooter || {side _shooter in wcside}) then {
		_damage
	};
}];

_radio addEventHandler ["Killed", {
	wcradioalive = false;
	["wcradioalive", "client"] call WC_fnc_publicvariable;

	wcmessageW = ["Radio tower", localize "STR_WC_MESSAGEHASBEENDESTROYED"];
	["wcmessageW", "client"] call WC_fnc_publicvariable;

	["INFO", "Radio tower was destroyed"] call WC_fnc_log;
}];

_text = [_position] call WC_fnc_getLocationText;
["INFO", format ["Created a radio %1 near %2", [_type] call WC_fnc_getDisplayName, _text]] call WC_fnc_log;

if (wcwithradiomarkers == 1) then {
	["radiotower", _radio, 0.5, "ColorRed", "ICON", "FDIAGONAL", "mil_triangle", 0, "Radio site", 1] call WC_fnc_createmarker;
};

wcradioalive = true;
["wcradioalive", "client"] call WC_fnc_publicvariable;

if (_protect > 0) then {
	if (random 1 > 0.2) then {
		[_radio, 1, 30, 4] spawn WC_fnc_protectobject;
	};
};

_radio
