/*
	Author: Neumatic
	Description: Removes an objects killed eventHandler then deletes the object.

	Parameter(s):
		0: [Object] Object to delete.

	Example(s):
		[_object] call WC_fnc_deleteObject;

	Returns:
		nil
*/

#define VEHICLE_TYPES ["LandVehicle","Air"]

private ["_object"];

_object = _this select 0;

_object removeAllEventHandlers "HandleDamage";
_object removeAllEventHandlers "Killed";

_object setPos [0,0,0];

if ({_object isKindOf _x} count VEHICLE_TYPES > 0) then {
	_object setAmmoCargo 0;
	_object setFuelCargo 0;
};

_object setDamage 1;

deleteVehicle _object;

nil
