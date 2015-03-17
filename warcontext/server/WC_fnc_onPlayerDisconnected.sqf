/*
	Author: Neumatic
	Description: Handles when a player disconnects from the server.

	Parameter(s):
		0: [Number] Player id
		1: [String] Player name
		2: [Number] Player unique id

	Example(s):
		onPlayerDisconnected {[_id, _uid, _name] call WC_fnc_onPlayerDisconnected};

	Returns:
		nil
*/

private ["_id", "_uid", "_name", "_group", "_player", "_objects", "_object"];

_id   = _this select 0;
_uid  = _this select 1;
_name = _this select 2;

if (_name == "__SERVER__" || {_uid == ""}) exitWith {};

_group = grpNull;
_player = objNull;

// Get the disconnecting player.
{
	if (getPlayerUID _x == _uid || {name _x == _name}) exitWith
	{
		_group = group _x;
		_player = _x;
	};
} forEach playableUnits;

// Have we found the player?
if (!isNull _player) then
{
	// Try to retrieve player variable.
	if (!isNil {missionNamespace getVariable format ["WC_%1_Objects", _uid]}) then
	{
		_objects = missionNamespace getVariable [format ["WC_%1_Objects", _uid], []];

		// If there are objects then handle them.
		if (count _objects > 0) then
		{
			// Could not find players group.
			if (isNull _group) then
			{
				["ERROR", "WC_fnc_onPlayerDisconnected", format ["Could not retrieve players group. [%1 : %2]", _name, _uid]] call WC_fnc_log;
			};

			// Handle players object.
			{
				_object = _x;

				if (!isNull _object) then
				{
					if (_object isKindOf "Man") then
					{
						// Check if the object is actually in the players group.
						if (isNull _group || {group _object == _group}) then
						{
							// If in a vehicle then eject.
							if (vehicle _object != _object) then
							{
								_object action ["EJECT", vehicle _object];
							};

							[_object] call WC_fnc_deleteObject;
						};
					}
					else
					{
						// Check if a player is in the current vehicle.
						if ({isPlayer _x} count crew _object == 0) then
						{
							[_object] call WC_fnc_deleteObject;
						};
					};
				};
			} forEach _objects;

			// Clear the players object variable.
			missionNamespace setVariable [format ["WC_%1_Objects", _uid], []];
		};
	}
	else
	{
		["ERROR", "WC_fnc_onPlayerDisconnected", format ["Could not retrieve [%1 : %2] objects variable", _name, _uid]] call WC_fnc_log;
	};

	["INFO", format ["Player [%1 : %2] has disconnected", _name, _uid]] call WC_fnc_log;
}
else
{
	["ERROR", "WC_fnc_onPlayerDisconnected", "Could not find disconnecting player"] call WC_fnc_log;
};

if (_name in wcplayerready) then
{
	wcplayerready = wcplayerready - [_name];
};

nil
