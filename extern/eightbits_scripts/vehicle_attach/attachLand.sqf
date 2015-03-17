private
[
	"_attachedVehicles",
	"_currentVehicle",
	"_headVehicle",
	"_numAttachedVehicles",
	"_slingPos",
	"_z"
];

_attachedVehicles = [];
_currentVehicle = objNull;
_headVehicle = (vehicle Player);
_numAttachedVehicles = 0;
_slingPos = [0, 0, 0];

// Setup the object variable
if (isNull ((_headVehicle getVariable ["Attached Vehicles", [objNull]]) select 0)) then
{
	_headVehicle setVariable ["Attached Vehicles", [_headVehicle], true];
	_attachedVehicles = _headVehicle getVariable "Attached Vehicles";
}
else
{
	_attachedVehicles = _headVehicle getVariable "Attached Vehicles";
};

// Adding the attach script and detach script into a switch statement for extra confusion
switch (_this select 3) do
{
	case 'Attach':
	{
		//player globalChat str _attachedVehicles;
		_numAttachedVehicles = count _attachedVehicles;
		
		// Check for duplciate vehicles, and "isKindOf" prevents trying to attach the plane to itself
		//if ((_currentVehicle isKindOf "LandVehicle") && (_numAttachedVehicles < 5)) then
		if (_numAttachedVehicles < 5) then
		{
			_slingPos = getPos _headVehicle;
			_currentVehicle = cursorTarget;

				for [{_z = 0}, {_z < _numAttachedVehicles}, {_z = _z + 1}] do
				{
					if ((_currentVehicle == _attachedVehicles select _z) || (!(_currentVehicle isKindOf "LandVehicle"))) then
					{
						_currentVehicle = objNull;
						//player globalChat "Invalid Vehicle";
						vehicle player vehicleChat "Invalid Vehicle";
						// Break the loop so we can begin checking the next vehicle from the previous loop
						_z = _numAttachedVehicles;
					}
					else
					{
						_currentVehicle = cursorTarget;
						//_z = _numAttachedVehicles;
					};
				};

			if !(isNull _currentVehicle) then
			{
				_attachedVehicles set [count _attachedVehicles, _currentVehicle];
				_headVehicle setVariable ["Attached Vehicles", _attachedVehicles, true];

				if ((count _attachedVehicles) == 2) then
				{
					_currentVehicle attachTo [_headVehicle, [0, -10, 0]];
					//player globalChat "1 Vehicle Attached";
					vehicle player vehicleChat "1 Vehicle Attached";
				};

				if ((count _attachedVehicles) == 3) then
				{
					_currentVehicle attachTo [_headVehicle, [0, -20, 0]];
					//player globalChat "2 Vehicles Attached";
					vehicle player vehicleChat "2 Vehicles Attached";
				};

				if ((count _attachedVehicles) == 4) then
				{
					_currentVehicle attachTo [_headVehicle, [0, -30, 0]];
					//player globalChat "3 Vehicles Attached";
					vehicle player vehicleChat "3 Vehicles Attached";
				};

				if ((count _attachedVehicles) == 5) then
				{
					_currentVehicle attachTo [_headVehicle, [0, -40, 0]];
					//player globalChat "4 Vehicles Attached";
					vehicle player vehicleChat "4 Vehicles Attached";
				};
			};
			//player globalChat format ["%1", getText (configFile >> "CfgVehicles" >> (typeOf _currentVehicle) >> "DisplayName")];
			vehicle player vehicleChat format ["%1", getText (configFile >> "CfgVehicles" >> (typeOf _currentVehicle) >> "DisplayName")];
		};
	};

	// Detach script
	case 'Detach':
	{
		{
			detach _x;
		} forEach _attachedVehicles;

		//player globalChat "Detached";
		vehicle player vehicleChat "Detached all vehicles";

		// Clear the variable stored on the _headVehicle
		(vehicle player) setVariable ["Attached Vehicles", nil, true];
		// Set a default value that we can check for to ensure the variable exists and can be setup again
		(vehicle player) setVariable ["Attached Vehicles", [objNull], true];
	};
};