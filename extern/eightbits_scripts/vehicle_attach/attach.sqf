/*
	Author: Eightbit
	Edited by: Neumatic
	Description: Attaches vehicles to players vehicle when player addAction is
	called.

	Parameter(s):
		3: [String] addAction type

	Returns:
		nil
*/

// Object types.
#define OBJECT_ATTACH_TYPE ["Car","Motorcycle","Tank"]

// Min alt to detach object.
#define MIN_DETACH_ALT 5

// Max alt to detach object.
#define MAX_DETACH_ALT 15

private
[
	"_attachedVehicles",
	"_currentVehicle",
	"_headVehicle",
	"_nearestVehicles",
	"_numAttachedVehicles",
	"_currPos",
	"_slingPos",
	"_maxNumVehicles",
	"_vehicleAlreadyAttached",
	"_vehicleXOffset",
	"_vehicleYOffset",
	"_vehicleZOffset",
	"_slingCenterXOffset",
	"_slingCenterYOffset",
	"_slingCenterZOffset",
	"_x",
	"_z",
	"_checkDetach"
];

_attachedVehicles = [];
_currentVehicle = objNull;
_headVehicle = vehicle player;
_nearestVehicles = [];
_numAttachedVehicles = 0;
_currPos = [0,0,0];
_slingPos = [0,0,0];
_maxNumVehicles = 4; // Default: 4 - choose 1, 2, 3, or a max of 4.
_vehicleAlreadyAttached = false; // We assume the vehicle we are trying to attach is not already attached, we later prove this.
_vehicleXOffset = 2.5;
_vehicleYOffset = 4.3;
_vehicleZOffset = -6.5;

_slingCenterXOffset = 0;
_slingCenterYOffset = 0;
_slingCenterZOffset = 0; // Varies with vehicles, for instance the huey is way forward for some reason.

// Setup the object variable.
if (isNull ((_headVehicle getVariable ["Attached Vehicles", [objNull]]) select 0)) then
{
	_headVehicle setVariable ["Attached Vehicles", [_headVehicle], true];
	_attachedVehicles = _headVehicle getVariable "Attached Vehicles";
}
else
{
	_attachedVehicles = _headVehicle getVariable "Attached Vehicles";
};

// Switch statement for player addAction.
switch (_this select 3) do
{
	// Player calls attach addAction.
	case "Attach":
	{
		// Is the player vehicle a helicopter or an mv22?
		if ((_headVehicle isKindOf "Helicopter") || {((typeOf _headVehicle) == "MV22")}) then
		{
			// Get the current vehicle position.
			_currPos = [_headVehicle] call WC_fnc_getPos;

			// This is to keep the vehicle from attaching vehicles from 10000m in the air.
			if (((_currPos select 2) >= MIN_DETACH_ALT) && {((_currPos select 2) <= MAX_DETACH_ALT)}) then
			{
				_numAttachedVehicles = count _attachedVehicles;

				if (_numAttachedVehicles < (_maxNumVehicles + 1)) then
				{
					_slingPos = [_headVehicle] call WC_fnc_getPos;

					_nearestVehicles = nearestObjects [[_slingPos select 0, _slingPos select 1, (_slingPos select 2) - 0], OBJECT_ATTACH_TYPE, 20];
					_nearestVehicles = _nearestVehicles - [_headVehicle];

					// Loop through each of the nearby vehicles and compare it against our list of already attached vehicles.
					for "_x" from 0 to (count _nearestVehicles - 1) step 1 do
					{
						_currentVehicle = objNull;
						_vehicleAlreadyAttached = false;

						// We need to check our list of already attached vehicles so we do not try to attach the same ones.
						for "_z" from 0 to (_numAttachedVehicles - 1) step 1 do
						{
							if ((_nearestVehicles select _x) == (_attachedVehicles select _z)) exitWith
							{
								_vehicleAlreadyAttached = true;
							};
						};

						// Finally, if the vehicle we are trying to attach is not already attached, we can attach it.
						if ((!_vehicleAlreadyAttached) && {((_nearestVehicles select _x) getVariable ["curNotAttached", true])}) exitWith
						{
							_currentVehicle = (_nearestVehicles select _x);
							_currentVehicle setVariable ["curNotAttached", false, true];
						};
					};

					// We have a vehicle to attach.
					if !(isNull _currentVehicle) then
					{
						_attachedVehicles set [count _attachedVehicles, _currentVehicle];
						_numAttachedVehicles = count _attachedVehicles;
						_headVehicle setVariable ["Attached Vehicles", _attachedVehicles, true];

						switch (_numAttachedVehicles) do
						{
							case 2:
							{
								_currentVehicle attachTo [_headVehicle, [_slingCenterXOffset, _slingCenterYOffset, (_slingCenterZOffset + _vehicleZOffset)]];
							};

							case 3:
							{
								_currentVehicle attachTo [_headVehicle, [_slingCenterXOffset, (_slingCenterYOffset + _vehicleYOffset), (_slingCenterZOffset + _vehicleZOffset)]];
								(_attachedVehicles select 1) attachTo [_headVehicle, [_slingCenterXOffset, (_slingCenterYOffset - _vehicleYOffset), (_slingCenterZOffset + _vehicleZOffset)]];
							};

							case 4:
							{
								_currentVehicle attachTo [_headVehicle, [(_slingCenterXOffset + _vehicleXOffset), (_slingCenterYOffset + _vehicleYOffset), (_slingCenterZOffset + _vehicleZOffset)]];
								(_attachedVehicles select 1) attachTo [_headVehicle, [(_slingCenterXOffset - _vehicleXOffset), (_slingCenterYOffset + _vehicleYOffset), (_slingCenterZOffset + _vehicleZOffset)]];
								(_attachedVehicles select 2) attachTo [_headVehicle, [_slingCenterXOffset, (_slingCenterYOffset - _vehicleYOffset), (_slingCenterZOffset + _vehicleZOffset)]];
							};

							case 5:
							{
								_currentVehicle attachTo [_headVehicle, [(_slingCenterXOffset + _vehicleXOffset), (_slingCenterYOffset - _vehicleYOffset), (_slingCenterZOffset + _vehicleZOffset)]];
								(_attachedVehicles select 2) attachTo [_headVehicle, [(_slingCenterXOffset - _vehicleXOffset), (_slingCenterYOffset - _vehicleYOffset), (_slingCenterZOffset + _vehicleZOffset)]];
							};
						};

						_headVehicle vehicleChat format ["%1: %2", (_numAttachedVehicles - 1), format ["%1", getText (configFile >> "CfgVehicles" >> (typeOf _currentVehicle) >> "DisplayName")]];
					};
				};
			};
		}
		else
		{
			// If the players vehicle is not a helicopter then it must be a LandVehicle.
			if ((_headVehicle isKindOf "Car") || {(_headVehicle isKindOf "Tank")}) then
			{
				_numAttachedVehicles = count _attachedVehicles;

				if (_numAttachedVehicles < (_maxNumVehicles + 1)) then
				{
					_currentVehicle = cursorTarget;

					// Make sure it's a LandVehicle but not a static.
					if ({_currentVehicle isKindOf _x} count OBJECT_ATTACH_TYPE > 0) then
					{
						_vehicleAlreadyAttached = false;

						// Check if the cursorTarget vehicle is already attached.
						{
							if (_currentVehicle == _x) exitWith
							{
								_vehicleAlreadyAttached = true;
								_currentVehicle = objNull;
							};
						} forEach _attachedVehicles;

						// Vehicle isn't attached. So let's attach it.
						if ((!_vehicleAlreadyAttached) && (_currentVehicle getVariable ["curNotAttached", true])) then
						{
							_currentVehicle setVariable ["curNotAttached", false, true];
						};

						// We have a vehicle to attach.
						if !(isNull _currentVehicle) then
						{
							_attachedVehicles set [count _attachedVehicles, _currentVehicle];
							_numAttachedVehicles = count _attachedVehicles;
							_headVehicle setVariable ["Attached Vehicles", _attachedVehicles, true];

							switch (_numAttachedVehicles) do
							{
								case 2:
								{
									_currentVehicle attachTo [_headVehicle, [0, -10, 0]];
								};

								case 3:
								{
									_currentVehicle attachTo [_headVehicle, [0, -20, 0]];
								};

								case 4:
								{
									_currentVehicle attachTo [_headVehicle, [0, -30, 0]];
								};

								case 5:
								{
									_currentVehicle attachTo [_headVehicle, [0, -40, 0]];
								};
							};

							_headVehicle vehicleChat format ["%1: %2", (_numAttachedVehicles - 1), format ["%1", getText (configFile >> "CfgVehicles" >> (typeOf _currentVehicle) >> "DisplayName")]];
						};
					};
				};
			};
		};
	};

	// Player calls detach addAction.
	case "Detach":
	{
		_checkDetach = true;

		// Is the player vehicle a helicopter or an mv22?
		if ((_headVehicle isKindOf "Helicopter") || {((typeOf _headVehicle) == "MV22")}) then
		{

			// Get the current vehicle position.
			_currPos = [_headVehicle] call WC_fnc_getPos;

			// This is to keep the vehicle from detaching vehicles from 10000m in the air.
			if !(((_currPos select 2) >= MIN_DETACH_ALT) && {((_currPos select 2) <= MAX_DETACH_ALT)}) then
			{
				_checkDetach = false;
			};
		};

		// If true then we can drop the sling load.
		if (_checkDetach) then
		{
			// Remove the player vehicle from the attached vehicles array.
			_attachedVehicles = _attachedVehicles - [_headVehicle];

			// Check if there are vehicles to detach. Reset the variables just incase.
			if (count _attachedVehicles > 0) then
			{
				{
					_x setVariable ["curNotAttached", true, true];
					detach _x;
					_currPos = [_x] call WC_fnc_getPos;
					_x setPos [_currPos select 0, _currPos select 1, 0];
					_x setVelocity [0,0,0];
				} forEach _attachedVehicles;

				_headVehicle vehicleChat "Detached all vehicles";
			};

			// Clear the variable stored on the _headVehicle
			_headVehicle setVariable ["Attached Vehicles", nil, true];
			// Set a default value that we can check for to ensure the variable exists and can be setup again
			_headVehicle setVariable ["Attached Vehicles", [objNull], true];
		};
	};
};

// Data requirements
//  aircraft center point offset, aircraft sling amount, possible type (heli's cant carry tanks)
//  vehicle, width offset, length offset, height offset
//
//
// Vehicles:
//  Humvee W: 1.2 L: 2.5 H: -3