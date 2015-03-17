// -----------------------------------------------
// Author:     code34 nicolas_boiteux@yahoo.fr
// Edited by:  Neumatic
// Warcontext: Create a building vehicles dialog box
// -----------------------------------------------

// DO NOT EDIT.
#define DIAG_MAIN_DISPLAY 7001
#define DIAG_DROP_FACT 7006
#define DIAG_LIST_VEHS 7007
#define DIAG_LIST_CURR 7008

/*
	Direction on vehicle spawn.
	Set for War in Chernarus.

	Direction for northern FOB.
		Vehicles: 337
		Air: 240

	Direction for southern FOB.
		Vehicles: 30
		Air: 209
*/
#define SET_DIR_VEH 337
#define SET_DIR_AIR 240

// Position for spawning vehicles.
#define SET_POS_VEH getMarkerPos "build_vehicle_marker"
#define SET_POS_AIR getMarkerPos "build_air_marker"

private ["_index", "_curr_vehicles", "_faction"];

if !(name player in wcinteam) exitWith {
	[localize "STR_WC_MENURECRUITMENT", "Only members of team can build", "Wait to be recruit as team member", 10] spawn WC_fnc_playerhint;
	closeDialog DIAG_MAIN_DISPLAY;
};

disableSerialization;
(uiNamespace getVariable "wcdisplay") displayCtrl DIAG_MAIN_DISPLAY;

switch (wcwithvehicles) do {
	case 1: {
		WC_VehDiagVehicles = [];
		WC_VehDiagFactions = [];
	};

 	case 2: {
		WC_VehDiagVehicles = wcvehicleslistathq select 1;
		WC_VehDiagFactions = wcvehicleslistathq select 0;
	};

	case 3: {
		WC_VehDiagVehicles = wcvehicleslistW select 1;
		WC_VehDiagFactions = wcvehicleslistW select 0;
	};
};

WC_VehDiagFactionsArray = [];

// Get factions for faction select drop down.
if (count WC_VehDiagFactions > 0) then {
	{
		lbAdd [DIAG_DROP_FACT, _x];
		WC_VehDiagFactionsArray set [count WC_VehDiagFactionsArray, _x];
	} forEach WC_VehDiagFactions;
};

if (count WC_VehDiagFactionsArray > 0) then {
	// Set faction from last dialog load.
	_index = player getVariable ["WC_VehDiagSettings", 0];
	lbSetCurSel [DIAG_DROP_FACT, _index];

	// Get the selected faction.
	_faction = WC_VehDiagFactionsArray select _index;
};

WC_VehDiagVehiclesArray = [];

// Main vehicles list box.
if (count WC_VehDiagVehicles > 0) then {
	{
		if ((_x select 0) == _faction) then {
			_index = lbAdd [DIAG_LIST_VEHS, [_x select 1] call WC_fnc_getDisplayName];
			WC_VehDiagVehiclesArray set [_index, _x select 1];
		};
	} forEach WC_VehDiagVehicles;
};

lbSetCurSel [DIAG_LIST_VEHS, 0];

// Current vehicles list box.
_curr_vehicles = player getVariable ["WC_VehDiagCurrVehicles", []];
if (count _curr_vehicles > 0) then {
	{
		if (!isNull _x) then {
			lbAdd [DIAG_LIST_CURR, [_x] call WC_fnc_getDisplayName];
		};
	} forEach _curr_vehicles;
};

lbSetCurSel [DIAG_LIST_CURR, 0];

// Set menuaction variable.
menuaction = -1;

// Add vehicle event handlers.
if (isNil "WC_FNC_VehDiagVehicleHandler") then {
	WC_FNC_VehDiagVehicleHandler = {
		private ["_vehicle", "_var_name"];

		_vehicle = _this select 0;

		_vehicle addEventHandler ["Killed", {
			wcaddtogarbage = _this select 0;
			["wcaddtogarbage", "server"] call WC_fnc_publicvariable;
		}];

		_vehicle removeAllEventHandlers "HandleDamage";

		_vehicle setVariable ["EH_Selections", []];
		_vehicle setVariable ["EH_GetHit", []];

		_vehicle addEventHandler ["HandleDamage", {
			private ["_damage"];
			_damage = _this call WC_fnc_handleDamage;
			_damage
		}];

		_vehicle addEventHandler ["Fired", {
			if (!wcdetected) then {
				if ((_this select 0) distance wcselectedzone < wcalertzonesize) then {
					wcalerttoadd = ceil (random 5);
					["wcalerttoadd", "server"] call WC_fnc_publicvariable;
				};
			};
		}];

		// Broadcast vehicle variables.
		_vehicle setVariable ["WC_VehiclePlayer", true, true];
		_var_name = objNull call WC_fnc_createObjName;
		[_vehicle, _var_name] spawn WC_fnc_setVehicleVarName;

		wcaddplayerobj = [getPlayerUID player, _vehicle];
		["wcaddplayerobj", "server"] call WC_fnc_publicvariable;
	};
};

// Add group unit handlers.
if (isNil "WC_FNC_VehDiagGroupHandler") then {
	WC_FNC_VehDiagGroupHandler = {
		private ["_group", "_var_name"];

		_group = _this select 0;

		{
			_x addEventHandler ["Killed", {
				private ["_unit"];
				_unit = _this select 0;
				_unit setMimic "Hurt";
				wcaddkilled = _unit;
				["wcaddkilled", "server"] call WC_fnc_publicvariable;
				wcaddtogarbage = _unit;
				["wcaddtogarbage", "server"] call WC_fnc_publicvariable;
			}];

			_x addEventHandler ["Fired", {
				private ["_unit", "_magazine", "_name"];
				_unit     = _this select 0;
				_magazine = _this select 5;
				_unit setMimic "Agresive";
				_name = getText (configFile >> "CfgMagazines" >> _magazine >> "DisplayNameShort");
				if (_name != "SD") then {
					if (!wcdetected) then {
						if (_unit distance wcselectedzone < wcalertzonesize) then {
							wcalerttoadd = ceil (random 3);
							["wcalerttoadd", "server"] call WC_fnc_publicvariable;
						};
					};
				};
			}];

			_x removeAllEventHandlers "HandleDamage";

			_x setVariable ["EH_Selections", []];
			_x setVariable ["EH_GetHit", []];

			_x addEventHandler ["HandleDamage", {
				private ["_damage"];
				(_this select 0) setMimic "Hurt";
				_damage = _this call WC_fnc_handleDamage;
				_damage
			}];

			_var_name = objNull call WC_fnc_createObjName;
			[_x, _var_name] spawn WC_fnc_setVehicleVarName;

			wcaddplayerobj = [getPlayerUID player, _x];
			["wcaddplayerobj", "server"] call WC_fnc_publicvariable;
		} forEach units _group;
	};
};

// Add vehicle to current vehicles.
if (isNil "WC_FNC_VehDiagAddVehicle") then {
	WC_FNC_VehDiagAddVehicle = {
		private ["_vehicle", "_vehicles"];

		_vehicle = _this select 0;

		_vehicles = player getVariable ["WC_VehDiagCurrVehicles", []];
		_vehicles set [count _vehicles, _vehicle];
		player setVariable ["WC_VehDiagCurrVehicles", _vehicles];
	};
};

// Set fuel and ammo.
if (isNil "NEU_FNC_SetFuelAmmo") then {
	NEU_FNC_SetFuelAmmo = {
		private ["_vehicle", "_fuel", "_ammo"];

		_vehicle = _this select 0;

		_fuel = 0.2 + random 0.8;
		_ammo = 0.5 + random 0.5;

		_vehicle setFuel _fuel;
		_vehicle setVehicleAmmo _ammo;

		nil
	};
};

// Handle menu action.
if (isNil "WC_FNC_VehDiagMenuAction") then {
	WC_FNC_VehDiagMenuAction = {
		private [
			"_menu_action", "_index", "_select", "_position", "_vehicle", "_dir", "_vehicle_array", "_group",
			"_vehicle_crew", "_curr_vehicles", "_count", "_faction"
		];

		_menu_action = _this select 0;

		switch (_menu_action) do {
			// Spawn vehicle without crew.
			case 1: {
				if (count WC_VehDiagVehiclesArray > 0) then {
					_index = lbCurSel DIAG_LIST_VEHS;
					if (_index >= 0) then {
						_select = WC_VehDiagVehiclesArray select _index;

						// If in the fob then spawn on the marker.
						if (([player, SET_POS_VEH] call WC_fnc_getDistance) > 300) then {
							_position = [player, 0, 60, sizeOf "M1A1", 0.2] call WC_fnc_getEmptyPosition;
						} else {
							_position = SET_POS_VEH;
						};

						if (count _position == 0) then {
							["Build a vehicle", "Try again to create your vehicle.", "No position to create vehicle.", 3] spawn WC_fnc_playerhint;
						} else {
							["Build a vehicle", "Wait while the building of your vehicle.", "The vehicle will appear near you in few seconds.", 3] spawn WC_fnc_playerhint;
							sleep 3;

							if (_select isKindOf "Plane") then {
								if (_select == "MV22") then {
									_vehicle = createVehicle [_select, _position, [], 0, "NONE"];
								} else {
									_vehicle = createVehicle [_select, SET_POS_AIR, [], 0, "NONE"];
									_vehicle setDir SET_DIR_AIR;
								};
							} else {
								_vehicle = createVehicle [_select, _position, [], 0, "NONE"];
							};

							if !(_select isKindOf "Plane") then {
								_vehicle setDir SET_DIR_VEH;
							};

							[_vehicle] call WC_fnc_alignToTerrain;

							if (wcwithrandomfuel == 1) then {
								[_vehicle] call NEU_FNC_SetFuelAmmo;
							};

							[_vehicle] call WC_FNC_VehDiagAddVehicle;

							[_vehicle] spawn WC_FNC_VehDiagVehicleHandler;
						};
					};
				};
			};

			// Spawn vehicle with crew in it.
			case 2: {
				if (count WC_VehDiagVehiclesArray > 0) then {
					_index = lbCurSel DIAG_LIST_VEHS;
					if (_index >= 0) then {
						_select = WC_VehDiagVehiclesArray select _index;

						// If in the fob then spawn on the marker.
						if (([player, SET_POS_VEH] call WC_fnc_getDistance) > 300) then {
							_position = [player, 0, 60, sizeOf "M1A1", 0.2] call WC_fnc_getEmptyPosition;
						} else {
							_position = SET_POS_VEH;
						};

						if (count _position == 0) then {
							["Build a vehicle", "Try again to create your vehicle.", "No position to create vehicle.", 3] spawn WC_fnc_playerhint;
						} else {
							["Build a vehicle", "Vehicle with crew will be spawned near you.", "Vehicle will spawn near you.", 3] spawn WC_fnc_playerhint;
							sleep 3;

							if (([_select] call WC_fnc_getSide) != west) then {
								if (_select isKindOf "Air") then {
									if (_select isKindOf "Plane") then {
										_dir = [wcmapbottomright, player] call WC_fnc_dirTo;
										_vehicle_array = [[wcmapbottomright select 0, wcmapbottomright select 1, 200], _dir, _select, west, "USMC_Soldier_Pilot"] call WC_fnc_spawnVehicle;
										_vehicle = _vehicle_array select 0;
										_group   = _vehicle_array select 2;
										_vehicle flyInHeight 200 + round (random 100);
									} else {
										_group = createGroup west;
										_vehicle = createVehicle [_select, _position, [], 0, "NONE"];
										[_vehicle, _group, false, "", "USMC_Soldier_Pilot"] call BIS_fnc_spawnCrew;
									};
								} else {
									if (_select isKindOf "Tank" || {_select isKindOf "Wheeled_APC"}) then {
										_vehicle_array = [_position, 0, _select, west, "USMC_Soldier_Crew"] call WC_fnc_spawnVehicle;
									} else {
										_vehicle_array = [_position, 0, _select, west, "USMC_Soldier"] call WC_fnc_spawnVehicle;
									};
									_vehicle = _vehicle_array select 0;
									_group   = _vehicle_array select 2;
								};
							} else {
								if (_select isKindOf "Air") then {
									if (_select isKindOf "Plane") then {
										if (_select == "MV22") then {
											_group = createGroup west;
											_vehicle = createVehicle [_select, _position, [], 0, "NONE"];
											[_vehicle, _group] call BIS_fnc_spawnCrew;
										} else {
											_dir = [wcmapbottomright, player] call WC_fnc_dirTo;
											_vehicle_array = [[wcmapbottomright select 0, wcmapbottomright select 1, 200], _dir, _select, west] call WC_fnc_spawnVehicle;
											_vehicle = _vehicle_array select 0;
											_group   = _vehicle_array select 2;
											_vehicle flyInHeight 200 + round (random 100);
										};
									} else {
										_group = createGroup west;
										_vehicle = createVehicle [_select, _position, [], 0, "NONE"];
										[_vehicle, _group] call BIS_fnc_spawnCrew;
									};
								} else {
									_vehicle_array = [_position, 0, _select, west] call WC_fnc_spawnVehicle;
									_vehicle = _vehicle_array select 0;
									_group   = _vehicle_array select 2;
								};
							};

							if !(_select isKindOf "Plane") then {
								_vehicle setDir SET_DIR_VEH;
							};

							[_vehicle] call WC_fnc_alignToTerrain;

							if (wcwithrandomfuel == 1) then {
								[_vehicle] call NEU_FNC_SetFuelAmmo;
							};

							[_vehicle] call WC_FNC_VehDiagAddVehicle;

							_vehicle_crew = [];

							{
								[_x] joinSilent (group player);
								_vehicle_crew set [count _vehicle_crew, _x];
							} forEach units _group;

							deleteGroup _group;

							if !(_vehicle isKindOf "Plane") then {
								doStop _vehicle;
							};

							_vehicle setVariable ["WC_VehicleCrew", _vehicle_crew, true];

							[_vehicle] spawn WC_FNC_VehDiagVehicleHandler;
							[_group] spawn WC_FNC_VehDiagGroupHandler;
						};
					};
				};
			};

			// Delete the selected vehicle from current vehicles list box.
			case 3: {
				_index = lbCurSel DIAG_LIST_CURR;
				if (_index >= 0) then {
					_curr_vehicles = player getVariable ["WC_VehDiagCurrVehicles", []];
					if (count _curr_vehicles > 0) then {
						_vehicle = _curr_vehicles select _index;

						if ({isPlayer _x} count crew _vehicle == 0) then {
							["Build a vehicle", "Wait for the deletion of the vehicle.", "The vehicle you selected will deleted.", 3] spawn WC_fnc_playerhint;
							sleep 3;

							_vehicle setPos [0,0,0];

							// Get crew members that spawned with the vehicle.
							_vehicle_crew = _vehicle getVariable "WC_VehicleCrew";
							if (isNil "_vehicle_crew") then {
								_vehicle_crew = crew _vehicle;
							};

							if (count _vehicle_crew > 0) then {
								{
									[_x] call WC_fnc_deleteObject;
								} forEach _vehicle_crew;
							};

							[_vehicle] call WC_fnc_deleteObject;

							_curr_vehicles set [_index, objNull];
							_curr_vehicles = _curr_vehicles - [objNull];

							player setVariable ["WC_VehDiagCurrVehicles", _curr_vehicles];
						} else {
							["Build a vehicle", "Player in your vehicle.", "The vehicle you selected cannot be deleted.", 3] spawn WC_fnc_playerhint;
						};
					};
				};
			};

			// Delete all the vehicles in vehicles array.
			case 4: {
				_curr_vehicles = player getVariable ["WC_VehDiagCurrVehicles", []];
				if (count _curr_vehicles > 0) then {
					["Build a vehicle", "Wait for the deletion of all your vehicles.", "All your vehicles will be deleted.", 3] spawn WC_fnc_playerhint;
					sleep 3;

					_count = 0;

					for "_i" from 0 to (count _curr_vehicles - 1) do {
						_vehicle = _curr_vehicles select _i;

						if ({isPlayer _x} count crew _vehicle == 0) then {
							_vehicle setPos [0,0,0];

							// Get crew members that spawned with the vehicle.
							_vehicle_crew = _vehicle getVariable "WC_VehicleCrew";
							if (isNil "_vehicle_crew") then {
								_vehicle_crew = crew _vehicle;
							};

							if (count _vehicle_crew > 0) then {
								{
									[_x] call WC_fnc_deleteObject;
								} forEach _vehicle_crew;
							};

							[_vehicle] call WC_fnc_deleteObject;

							_curr_vehicles set [_i, objNull];
						} else {_count = _count + 1};
					};

					_curr_vehicles = _curr_vehicles - [objNull];

					player setVariable ["WC_VehDiagCurrVehicles", _curr_vehicles];

					if (_count > 0) then {
						["Build a vehicle", format ["%1 vehicles could not be deleted.", _count], "Player in vehicle.", 3] spawn WC_fnc_playerhint;
					};
				};
			};

			// Select faction drop down.
			case 5: {
				_index = lbCurSel DIAG_DROP_FACT;
				player setVariable ["WC_VehDiagSettings", _index];
				_faction = WC_VehDiagFactionsArray select _index;

				lbClear DIAG_LIST_VEHS;

				WC_VehDiagVehiclesArray = [];

				if (count WC_VehDiagVehicles > 0) then {
					{
						if ((_x select 0) == _faction) then {
							_index = lbAdd [DIAG_LIST_VEHS, [_x select 1] call WC_fnc_getDisplayName];
							WC_VehDiagVehiclesArray set [_index, _x select 1];
						};
					} forEach WC_VehDiagVehicles;
				};

				lbSetCurSel [DIAG_LIST_VEHS, 0];
			};

			// Close dialog.
			case 6: {
				closeDialog DIAG_MAIN_DISPLAY;
			};
		};

		player setVariable ["WC_DiagUpdate", true];
	};
};

// Dialog main loop.
while {dialog && {alive player}} do {
	// Menu action was called.
	if (menuaction > 0) then {
		[menuaction] spawn WC_FNC_VehDiagMenuAction;

		// Reset menuaction variable.
		menuaction = -1;
	};

	// Update current vehicles list box.
	if (player getVariable ["WC_DiagUpdate", false]) then {
		lbClear DIAG_LIST_CURR;

		_curr_vehicles = player getVariable ["WC_VehDiagCurrVehicles", []];
		{
			if (!isNull _x) then {
				lbAdd [DIAG_LIST_CURR, [_x] call WC_fnc_getDisplayName];
			};
		} forEach _curr_vehicles;

		player setVariable ["WC_DiagUpdate", false];
	};

	sleep 0.1;
};

// Reset menuaction variable.
menuaction = -1;

// Reset diag update variable.
player setVariable ["WC_DiagUpdate", false];
