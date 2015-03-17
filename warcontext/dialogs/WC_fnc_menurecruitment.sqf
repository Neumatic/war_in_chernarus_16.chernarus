// -----------------------------------------------
// Author:     code34 nicolas_boiteux@yahoo.fr
// Edited by:  Neumatic
// Warcontext: Create a recruitment dialog box
// -----------------------------------------------

// DO NOT EDIT.
#define DIAG_MAIN_DISPLAY 4001
#define DIAG_DROP_FACT 4006
#define DIAG_DROP_NUMB 4013
#define DIAG_LIST_MAIN 4007
#define DIAG_LIST_CURR 4009
#define DIAG_LIST_SAVE 4008
#define DIAG_LIST_AVAL 4020

// Numbers array drop down.
#define NUMBERS_ARRAY ["2","4","6","8"]

// Units factions and types.
#define UNITS_FACTIONS (wcwestside select 0)
#define UNITS_TYPES (wcwestside select 1)

private ["_settings", "_index", "_faction", "_saved_squad"];

if !(isFormationLeader player) exitWith {
	[localize "STR_WC_MENURECRUITMENT", "You are not leader of your group", "Create a new group", 10] spawn WC_fnc_playerhint;
	closeDialog DIAG_MAIN_DISPLAY;
};

if !(name player in wcinteam) exitWith {
	[localize "STR_WC_MENURECRUITMENT", "Only members of team can recruit", "Wait to be recruit as team member", 10] spawn WC_fnc_playerhint;
	closeDialog DIAG_MAIN_DISPLAY;
};

if (wcrecruitberanked == 1) then {
	WC_RctMaxSize = switch (rank player) do {
		case "PRIVATE": {   0};
		case "CORPORAL": {  1};
		case "SERGEANT": {  2};
		case "LIEUTENANT": {3};
		case "CAPTAIN": {   4};
		case "MAJOR": {     5};
		case "COLONEL": {   6};
	};
} else {
	WC_RctMaxSize = 64;
};

disableSerialization;
(uiNamespace getVariable "wcdisplay") displayCtrl DIAG_MAIN_DISPLAY;

WC_RctDiagFactions = [];

// Get factions for faction select drop down.
{
	lbAdd [DIAG_DROP_FACT, _x];
	WC_RctDiagFactions set [count WC_RctDiagFactions, _x];
} forEach UNITS_FACTIONS;

// Add numbers to random squad size drop down.
{
	lbAdd [DIAG_DROP_NUMB, _x];
} forEach NUMBERS_ARRAY;

// Set faction and random number from last dialog load.
_settings = player getVariable ["WC_RctDiagSettings", [0,0]];
lbSetCurSel [DIAG_DROP_FACT, (_settings select 0)];
lbSetCurSel [DIAG_DROP_NUMB, (_settings select 1)];

// Get the selected faction.
_index = lbCurSel DIAG_DROP_FACT;
_faction = WC_RctDiagFactions select _index;

WC_RctDiagUnitTypes = [];

// Main recruit list box.
{
	if ((_x select 0) == _faction) then {
		_index = lbAdd [DIAG_LIST_MAIN, [_x select 1] call WC_fnc_getDisplayName];
		WC_RctDiagUnitTypes set [_index, _x select 1];
	};
} forEach UNITS_TYPES;

lbSetCurSel [DIAG_LIST_MAIN, 0];

WC_RctCurrSquad = [];

// Current squad members list box.
{
	if (!isPlayer _x) then {
		_index = lbAdd [DIAG_LIST_CURR, [_x] call WC_fnc_getDisplayName];
		WC_RctCurrSquad set [_index, _x];
	};
} forEach units group player;

lbSetCurSel [DIAG_LIST_CURR, 0];

WC_RctSavedSquad = [];

// Get the current saved units from saved squad variable.
_saved_squad = player getVariable ["WC_RctDiagSavedSquad", []];
if (count _saved_squad > 0) then {
	{
		lbAdd [DIAG_LIST_SAVE, [_x] call WC_fnc_getDisplayName];
		WC_RctSavedSquad set [count WC_RctSavedSquad, _x];
	} forEach _saved_squad;
};

lbSetCurSel [DIAG_LIST_SAVE, 0];

ctrlSetText [DIAG_LIST_AVAL, format ["Recruitment avalaible: %1", WC_RctMaxSize - count WC_RctCurrSquad]];

// Set menuaction variable.
menuaction = -1;

// Add unit handlers.
if (isNil "WC_FNC_RctGroupHandlers") then {
	WC_FNC_RctGroupHandlers = {
		private ["_unit", "_var_name"];

		_unit = _this select 0;

		_unit addEventHandler ["Killed", {
			private ["_unit"];
			_unit = _this select 0;
			_unit setMimic "Hurt";
			wcaddkilled = _unit;
			["wcaddkilled", "server"] call WC_fnc_publicvariable;
			wcaddtogarbage = _unit;
			["wcaddtogarbage", "server"] call WC_fnc_publicvariable;
		}];

		_unit addEventHandler ["Fired", {
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

		_unit removeAllEventHandlers "HandleDamage";

		_unit setVariable ["EH_Selections", []];
		_unit setVariable ["EH_GetHit", []];

		_unit addEventHandler ["HandleDamage", {
			private ["_damage"];
			(_this select 0) setMimic "Hurt";
			_damage = _this call WC_fnc_handleDamage;
			_damage
		}];

		_var_name = objNull call WC_fnc_createObjName;
		[_unit, _var_name] spawn WC_fnc_setVehicleVarName;

		wcaddplayerobj = [getPlayerUID player, _unit];
		["wcaddplayerobj", "server"] call WC_fnc_publicvariable;
	};
};

// Get a random group.
if (isNil "WC_FNC_RctGetGroup") then {
	WC_FNC_RctGetGroup = {
		private ["_faction", "_size", "_types", "_rand"];

		_faction = _this select 0;
		_size    = _this select 1;

		_types = [];

		{
			if ((_x select 0) == _faction) then {
				if !((_x select 1) in wcwestblacklist) then {
					_types set [count _types, _x select 1];
				};
			};
		} forEach UNITS_TYPES;

		if (count _types > _size) then {
			while {count _types > _size} do {
				_rand = random (count _types - 1);
				_types set [_rand, "<DELETE>"];
				_types = _types - ["<DELETE>"];
			};
		};

		_types
	};
};

// Handle menu action.
if (isNil "WC_FNC_RctDiagMenuAction") then {
	WC_FNC_RctDiagMenuAction = {
		private ["_menu_action", "_index", "_select", "_unit", "_faction", "_number", "_units", "_count", "_settings"];

		_menu_action = _this select 0;

		switch (_menu_action) do {
			// Spawn a unit selected in the main units list box.
			case 1: {
				_index = lbCurSel DIAG_LIST_MAIN;
				if (_index >= 0) then {
					_select = WC_RctDiagUnitTypes select _index;

					if (WC_RctMaxSize > count WC_RctCurrSquad) then {
						_unit = (group player) createUnit [_select, [player] call WC_fnc_getPos, [], 5, "FORM"];
						[localize "STR_WC_MENURECRUITMENT", format ["%1 joined your squad.", name _unit], "Manage your squad.", 2] spawn WC_fnc_playerhint;
						[_unit] joinSilent (group player);
						[_unit] spawn WC_FNC_RctGroupHandlers;

						WC_RctCurrSquad set [count WC_RctCurrSquad, _unit];
					} else {
						if (random 1 > 0.02) then {
							[localize "STR_WC_MENURECRUITMENT", "Increase your rank by winning points.", "You are not enough ranked to give some orders.", 10] spawn WC_fnc_playerhint;
						} else {
							[localize "STR_WC_MENURECRUITMENT", "Increase your rank by winning points.", "Ok, recruiter give you one men because you are a friend.", 10] spawn WC_fnc_playerhint;
							sleep 10;

							_unit = (group player) createUnit [_select, [player] call WC_fnc_getPos, [], 5, "FORM"];
							[_unit] joinSilent (group player);
							[_unit] spawn WC_FNC_RctGroupHandlers;

							WC_RctCurrSquad set [count WC_RctCurrSquad, _unit];
						};
					};
				};
			};

			// Add selected unit from units list box to saved units list box.
			case 2: {
				_index = lbCurSel DIAG_LIST_MAIN;
				if (_index >= 0) then {
					_select = WC_RctDiagUnitTypes select _index;

					if (WC_RctMaxSize > count WC_RctSavedSquad) then {
						lbAdd [DIAG_LIST_SAVE, [_select] call WC_fnc_getDisplayName];
						WC_RctSavedSquad set [count WC_RctSavedSquad, _select];
					};
				};
			};

			// Add a selected amount of units to saved units list box.
			case 3: {
				_index = lbCurSel DIAG_DROP_FACT;
				_faction = WC_RctDiagFactions select _index;

				_index = lbCurSel DIAG_DROP_NUMB;
				_number = parseNumber (NUMBERS_ARRAY select _index);

				_units = [_faction, _number] call WC_FNC_RctGetGroup;
				if (count _units > 0) then {
					{
						if (WC_RctMaxSize > count WC_RctSavedSquad) then {
							lbAdd [DIAG_LIST_SAVE, [_x] call WC_fnc_getDisplayName];
							WC_RctSavedSquad set [count WC_RctSavedSquad, _x];
						};
					} forEach _units;
				};
			};

			// Remove selected unit from saved units list box.
			case 4: {
				_index = lbCurSel DIAG_LIST_SAVE;
				if (_index >= 0) then {
					_select = WC_RctSavedSquad select _index;

					WC_RctSavedSquad set [_index, "<DELETE>"];
					WC_RctSavedSquad = WC_RctSavedSquad - ["<DELETE>"];
				};
			};

			// Clear all units from saved units list box.
			case 5: {
				WC_RctSavedSquad = [];
				player setVariable ["WC_RctDiagSavedSquad", WC_RctSavedSquad];
			};

			// Save the current units in the saved units list box.
			case 6: {
				if (count WC_RctSavedSquad > 0) then {
					player setVariable ["WC_RctDiagSavedSquad", WC_RctSavedSquad];
				};
			};

			// Spawn all current units in the saved units list box.
			case 7: {
				if (count WC_RctSavedSquad > 0) then {
					[localize "STR_WC_MENURECRUITMENT", "Spawning all units in saved members list box.", "Manage your squad.", 5] spawn WC_fnc_playerhint;

					{
						if (WC_RctMaxSize > count WC_RctCurrSquad) then {
							_unit = (group player) createUnit [_x, [player] call WC_fnc_getPos, [], 5, "FORM"];
							[_unit] joinSilent (group player);
							WC_RctCurrSquad set [count WC_RctCurrSquad, _unit];
							[_unit] spawn WC_FNC_RctGroupHandlers;
						};
					} forEach WC_RctSavedSquad;
				};
			};

			// Delete the selected unit from current squad members list box.
			case 8: {
				if (count WC_RctCurrSquad > 0) then {
					_index = lbCurSel DIAG_LIST_CURR;
					if (_index >= 0) then {
						_select = WC_RctCurrSquad select _index;

						if (isNull _select || {vehicle _select == _select}) then {
							[localize "STR_WC_MENURECRUITMENT", format ["Removing %1 from your squad.", name _select], "Manage your squad.", 3] spawn WC_fnc_playerhint;

							if (!isNull _select) then {
								[_select] call WC_fnc_deleteObject;
							};

							WC_RctCurrSquad set [_index, "<DELETE>"];
							WC_RctCurrSquad = WC_RctCurrSquad - ["<DELETE>"];
						} else {
							[localize "STR_WC_MENURECRUITMENT", format ["%1 is in a vehicle. Dismount him before deleting.", name _select], "Manage your squad.", 3] spawn WC_fnc_playerhint;
						};
					};
				};
			};

			// Delete all current squad members.
			case 9: {
				if (count WC_RctCurrSquad > 0) then {
					_count = 0;

					{
						if (isNull _x || {vehicle _x == _x}) then {
							WC_RctCurrSquad set [_forEachIndex, "<DELETE>"];
							if (!isNull _x) then {
								[_x] call WC_fnc_deleteObject;
							};
						} else {
							_count = _count + 1;
						};
					} forEach WC_RctCurrSquad;

					WC_RctCurrSquad = WC_RctCurrSquad - ["<DELETE>"];

					if (_count > 0) then {
						[localize "STR_WC_MENURECRUITMENT", format ["%1 units could not be deleted. Dismount them from their vehicle.", _count], "Manage your squad.", 3] spawn WC_fnc_playerhint;
					} else {
						[localize "STR_WC_MENURECRUITMENT", "Deleted all units in your group.", "Manage your squad.", 3] spawn WC_fnc_playerhint;
					};
				};
			};

			// Select faction drop down.
			case 10: {
				_index = lbCurSel DIAG_DROP_FACT;
				_settings = player getVariable ["WC_RctDiagSettings", [0,0]];
				_settings set [0, _index];
				player setVariable ["WC_RctDiagSettings", _settings];
				_faction = WC_RctDiagFactions select _index;

				lbClear DIAG_LIST_MAIN;

				WC_RctDiagUnitTypes = [];

				{
					if ((_x select 0) == _faction) then {
						_index = lbAdd [DIAG_LIST_MAIN, [_x select 1] call WC_fnc_getDisplayName];
						WC_RctDiagUnitTypes set [_index, _x select 1];
					};
				} forEach UNITS_TYPES;

				lbSetCurSel [DIAG_LIST_MAIN, 0];
			};

			// Combo drop down of random squad number.
			case 11: {
				_index = lbCurSel DIAG_DROP_NUMB;
				_settings = player getVariable ["WC_RctDiagSettings", [0,0]];
				_settings set [1, _index];
				player setVariable ["WC_RctDiagSettings", _settings];

				lbClear DIAG_DROP_NUMB;

				{
					lbAdd [DIAG_DROP_NUMB, _x];
				} forEach NUMBERS_ARRAY;
			};

			// Close dialog.
			case 12: {
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
		[menuaction] spawn WC_FNC_RctDiagMenuAction;

		// Reset menuaction variable.
		menuaction = -1;
	};

	// Update list box.
	if (player getVariable ["WC_DiagUpdate", false]) then {
		lbClear DIAG_LIST_CURR;

		// Refresh current squad members list box.
		if (count WC_RctCurrSquad > 0) then {
			{
				lbAdd [DIAG_LIST_CURR, [_x] call WC_fnc_getDisplayName];
			} forEach WC_RctCurrSquad;
		};

		lbClear DIAG_LIST_SAVE;

		// Refresh saved units list box.
		if (count WC_RctSavedSquad > 0) then {
			{
				lbAdd [DIAG_LIST_SAVE, [_x] call WC_fnc_getDisplayName];
			} forEach WC_RctSavedSquad;
		};

		// Update recruitment available text.
		ctrlSetText [DIAG_LIST_AVAL, format ["Recruitment avalaible: %1", WC_RctMaxSize - count WC_RctCurrSquad]];

		player setVariable ["WC_DiagUpdate", false];
	};

	sleep 0.1;
};

// Reset menuaction variable.
menuaction = -1;

// Reset some variables.
WC_RctCurrSquad = [];
WC_RctSavedSquad = [];

// Reset diag update variable.
player setVariable ["WC_DiagUpdate", false];
