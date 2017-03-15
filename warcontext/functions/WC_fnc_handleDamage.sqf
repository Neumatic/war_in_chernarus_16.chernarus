/*
	Author: Unknown (forgot)
	Edited by: Neumatic
	Description: Handles object damage using "HandleDamage" event handler.

	Parameter(s):
		[Array] HandleDamage array.

	Example(s):
		_damage = _this call WC_fnc_handleDamage;

	Returns:
		Scalar
*/

// Uncomment for debug chat.
//#define DEBUG_CHAT

#define VEHICLE_TYPES ["LandVehicle","Air","Ship"]

private ["_object", "_selection", "_damage", "_scale", "_selections", "_get_hit", "_index", "_old_damage"];

_object    = _this select 0;
_selection = _this select 1;
_damage    = _this select 2;

//if (_object isKindOf "Helicopter" && {_selection == "fuel_hit"}) then {
//	_damage = 0;
//} else {
	if ({_object isKindOf _x} count VEHICLE_TYPES > 0) then {
		_scale = wcdammagethreshold;
	} else {
		_scale = 1;
	};

	if (isNil {_object getVariable "EH_Selections"}) then {
		_object setVariable ["EH_Selections", []];
	};

	_selections = _object getVariable "EH_Selections";

	if (isNil {_object getVariable "EH_GetHit"}) then {
		_object setVariable ["EH_GetHit", []];
	};

	_get_hit = _object getVariable "EH_GetHit";

	if !(_selection in _selections) then {
		_selections set [count _selections, _selection];
		_get_hit set [count _get_hit, 0];
	};

	_index = _selections find _selection;
	_old_damage = _get_hit select _index;
	_damage = _old_damage + (_damage - _old_damage) * _scale;
	_get_hit set [_index, _damage];
//};

#ifdef DEBUG_CHAT
	player sideChat format ["%1 : %2", _selection, _damage];
#endif

_damage
