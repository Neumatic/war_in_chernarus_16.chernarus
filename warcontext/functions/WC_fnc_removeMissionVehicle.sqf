/*
	Author: Neumatic
	Description: Removes mission vehicle from vehicle arrays if the mission
	was a success.

	Parameter(s):
		0: [Object] Object to remove.

	Example(s):
		[_object] call WC_fnc_removeMissionVehicle;

	Returns:
		nil
*/

private ["_object", "_object_type"];

_object = _this select 0;

_object_type = typeOf _object;

if (_object isKindOf "Air") then {
	// East air vehicles array.
	if (count wcairpatroltype > 1) then {
		if (_object_type in wcairpatroltype) then {
			[wcairpatroltype, _object_type] call WC_fnc_arrayRemove;
		};
	};

	// West air vehicles arrays.
	if (_object_type in WC_FriendlyJets) then {
		[WC_FriendlyJets, _object_type] call WC_fnc_arrayRemove;
	};

	if (_object_type in WC_FriendlyVehicles) then {
		[WC_FriendlyVehicles, _object_type] call WC_fnc_arrayRemove;
	};
} else {
	// East vehicles arrays.
	if (_object_type in wcvehicleslistE) then {
		[wcvehicleslistE, _object_type] call WC_fnc_arrayRemove;
	};

	{
		if (_object_type in _x) exitWith {
			wcvehicleslistweighedE = wcvehicleslistweighedE - [_x];
		};
	} forEach wcvehicleslistweighedE;

	if (_object_type in WC_EnemyTanks) then {
		[WC_EnemyTanks, _object_type] call WC_fnc_arrayRemove;
	};

	if (_object_type in WC_EnemyApcs) then {
		[WC_EnemyApcs, _object_type] call WC_fnc_arrayRemove;
	};

	// West vehicles array.
	if (_object_type in WC_FriendlyVehicles) then {
		[WC_FriendlyVehicles, _object_type] call WC_fnc_arrayRemove;
	};
};

nil
