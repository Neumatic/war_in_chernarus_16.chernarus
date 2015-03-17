// -----------------------------------------------
// Author:     code34 nicolas_boiteux@yahoo.fr
// Edited by:  Neumatic
// Warcontext: Handler for east and west vehicles
// -----------------------------------------------

private ["_vehicle", "_side", "_var_name"];

_vehicle = _this select 0;
_side    = _this select 1;

switch (_side) do {
	case east: {
		_vehicle addEventHandler ["Killed", {
			wcaddtogarbage = _this select 0;
			["wcaddtogarbage", "server"] call WC_fnc_publicvariable;
			wcnumberofkilledofmissionV = wcnumberofkilledofmissionV + 1;
		}];

		_vehicle removeAllEventHandlers "HandleDamage";

		_vehicle setVariable ["EH_Selections", []];
		_vehicle setVariable ["EH_GetHit", []];

		_vehicle addEventHandler ["HandleDamage", {
			private ["_unit", "_shooter", "_name", "_damage"];
			_unit    = _this select 0;
			_shooter = _this select 3;
			if (isPlayer _shooter || {side _shooter != side _unit}) then {
				_name = getText (configFile >> "CfgMagazines" >> currentMagazine _shooter >> "DisplayNameShort");
				if (_name != "SD") then {
					{
						if (!isNull _x) then {
							_x reveal _shooter;
							_x doTarget _shooter;
							_x doFire _shooter;
						};
					} forEach [gunner _unit, commander _unit, driver _unit];
				};
				_damage = _this call WC_fnc_handleDamage;
				_damage
			};
		}];

		_vehicle setVariable ["EH_GotHit", false];

		_vehicle addEventHandler ["Hit", {
			private ["_unit", "_shooter"];
			_unit    = _this select 0;
			_shooter = _this select 1;
			if (isPlayer _shooter || {side _shooter != side _unit}) then {
				_unit setVariable ["EH_GotHit", true];
			};
		}];

		_vehicle addEventHandler ["Fired", {
			if (([_this select 0, wcmissionposition] call WC_fnc_getDistance) < wcalertzonesize) then {
				wcalerttoadd = ceil (random 3);
				["wcalerttoadd", "server"] call WC_fnc_publicvariable;
			};
		}];

		_vehicle addEventHandler ["FiredNear", {
			private ["_unit", "_shooter", "_magazine", "_name"];
			_unit     = _this select 0;
			_shooter  = _this select 1;
			_magazine = _this select 5;
			if (isPlayer _shooter || {side _shooter != side _unit}) then {
				_name = getText (configFile >> "CfgMagazines" >> _magazine >> "DisplayNameShort");
				if (_name != "SD") then {
					{
						if (!isNull _x) then {
							_x reveal _shooter;
							_x doTarget _shooter;
							_x doFire _shooter;
						};
					} forEach [gunner _unit, commander _unit, driver _unit];
				};
			};
		}];

		wcvehicles set [count wcvehicles, _vehicle];
	};

	case west: {
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
			if (([_this select 0, wcmissionposition] call WC_fnc_getDistance) < wcalertzonesize) then {
				wcalerttoadd = ceil (random 3);
				["wcalerttoadd", "server"] call WC_fnc_publicvariable;
			};
		}];
	};

	case civilian: {
		_vehicle removeAllEventHandlers "HandleDamage";

		_vehicle setVariable ["EH_Selections", []];
		_vehicle setVariable ["EH_GetHit", []];

		_vehicle addEventHandler ["HandleDamage", {
			private ["_damage"];
			_damage = _this call WC_fnc_handleDamage;
			_damage
		}];

		_vehicle addEventHandler ["Fired", {
			if (([_this select 0, wcmissionposition] call WC_fnc_getDistance) < wcalertzonesize) then {
				wcalerttoadd = ceil (random 3);
				["wcalerttoadd", "server"] call WC_fnc_publicvariable;
			};
		}];
	};
};

// Set vehicle var name.
_var_name = objNull call WC_fnc_createObjName;
[_vehicle, _var_name] spawn WC_fnc_setVehicleVarName;
