// -----------------------------------------------
// Author:     code34 nicolas_boiteux@yahoo.fr
// Edited by:  Neumatic
// Warcontext: Handler for east and west units
// -----------------------------------------------

private ["_group", "_side", "_mags", "_var_name"];

_group = _this select 0;
_side  = _this select 1;

{
	switch (_side) do {
		case east: {
			//[_x, wcskill] spawn WC_fnc_setskill;

			if (isNil {_x getVariable "Action_HandsUp"}) then {
				wcaddactions = [_x, "HANDS_UP"];
				["wcaddactions", "client"] call WC_fnc_publicvariable;
			};

			if (vehicle _x == _x) then {
				wcunits set [count wcunits, _x];
				_mags = [primaryWeapon _x] call WC_fnc_weaponcanflare;
				if (_mags select 0) then {
					[_x, _mags] spawn WC_fnc_fireflare;
				};
			} else {
				wcblinde set [count wcblinde, _x];
			};

			_x addEventHandler ["Killed", {
				private ["_unit", "_name"];
				_unit = _this select 0;
				_name = getText (configFile >> "CfgMagazines" >> currentMagazine (_this select 1) >> "DisplayNameShort");
				if (_name != "SD") then {
					if (([_unit, wcmissionposition] call WC_fnc_getDistance) < wcalertzonesize) then {
						wcalerttoadd = ceil (random 3);
						["wcalerttoadd", "server"] call WC_fnc_publicvariable;
					};
				};
				wcaddtogarbage = _unit;
				["wcaddtogarbage", "server"] call WC_fnc_publicvariable;
				_unit setMimic "Hurt";
				wcnumberofkilledofmissionE = wcnumberofkilledofmissionE + 1;
				wcenemykilled = wcenemykilled + 1;
				["wcenemykilled", "client"] call WC_fnc_publicvariable;
				if (WC_MarkerAlpha > 0) then {
					_marker = [format ["dead%1", wcenemykilled], _unit, 0.1, "ColorRed", "ICON", "FDIAGONAL", "Camp", 0, "dead", WC_MarkerAlpha] call WC_fnc_createmarkerlocal;
					wcambiantmarker set [count wcambiantmarker, _marker];
				};
			}];

			_x addEventHandler ["Fired", {
				private ["_unit", "_name"];
				_unit = _this select 0;
				_unit setMimic "Agresive";
				_name = getText (configFile >> "CfgMagazines" >> _this select 5 >> "DisplayNameShort");
				if (_name != "SD") then {
					if (([_unit, wcmissionposition] call WC_fnc_getDistance) < wcalertzonesize) then {
						wcalerttoadd = ceil (random 3);
						["wcalerttoadd", "server"] call WC_fnc_publicvariable;
					};
				};
			}];

			_x removeAllEventHandlers "HandleDamage";

			_x setVariable ["EH_Selections", []];
			_x setVariable ["EH_GetHit", []];

			_x addEventHandler ["HandleDamage", {
				private ["_unit", "_shooter", "_name", "_damage"];
				_unit    = _this select 0;
				_shooter = _this select 3;
				if (isPlayer _shooter || {side _shooter != side _unit}) then {
					_unit setMimic "Hurt";
					_name = getText (configFile >> "CfgMagazines" >> currentMagazine _shooter >> "DisplayNameShort");
					if (_name != "SD") then {
						_unit doTarget _shooter;
						_unit doFire _shooter;
						_unit reveal _shooter;
					};
					_damage = _this call WC_fnc_handleDamage;
					_damage
				};
			}];

			_x setVariable ["EH_GotHit", false];

			_x addEventHandler ["Hit", {
				private ["_unit", "_shooter"];
				_unit    = _this select 0;
				_shooter = _this select 1;
				if (isPlayer _shooter || {side _shooter != side _unit}) then {
					_unit setVariable ["EH_GotHit", true];
				};
			}];

			_x addEventHandler ["FiredNear", {
				private ["_unit", "_shooter", "_name"];
				_unit    = _this select 0;
				_shooter = _this select 1;
				if (isPlayer _shooter || {side _shooter != side _unit}) then {
					_name = getText (configFile >> "CfgMagazines" >> _this select 5 >> "DisplayNameShort");
					if (_name != "SD") then {
						_unit doTarget _shooter;
						_unit doFire _shooter;
						_unit reveal _shooter;
						_unit setMimic "Agresive";
					};
				};
			}];
		};

		case west: {
			_x addEventHandler ["Killed", {
				private ["_unit"];
				_unit = _this select 0;
				wcaddtogarbage = _unit;
				["wcaddtogarbage", "server"] call WC_fnc_publicvariable;
				_unit setMimic "Hurt";
				wcaddkilled = _unit;
				["wcaddkilled", "server"] call WC_fnc_publicvariable;
			}];

			_x addEventHandler ["Fired", {
				private ["_unit", "_name"];
				_unit = _this select 0;
				_unit setMimic "Agresive";
				_name = getText (configFile >> "CfgMagazines" >> _this select 5 >> "DisplayNameShort");
				if (_name != "SD") then {
					if (([_unit, wcmissionposition] call WC_fnc_getDistance) < wcalertzonesize) then {
						wcalerttoadd = ceil (random 3);
						["wcalerttoadd", "server"] call WC_fnc_publicvariable;
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

			_x setVariable ["EH_GotHit", false];

			_x addEventHandler ["Hit", {
				private ["_unit", "_shooter"];
				_unit    = _this select 0;
				_shooter = _this select 1;
				if (side _shooter != side _unit) then {
					_unit setVariable ["EH_GotHit", true];
				};
			}];
		};

		case civilian: {
			if (_x isKindOf "Civilian") then {
				//[_x, wccivilianskill] spawn WC_fnc_setskill;

				_x addEventHandler ["Killed", {
					private ["_unit", "_killer"];
					_unit   = _this select 0;
					_killer = _this select 1;
					wcaddtogarbage = _unit;
					["wcaddtogarbage", "server"] call WC_fnc_publicvariable;
					_unit setMimic "Hurt";
					if (name _killer in wcinteam) then {
						wcnumberofkilledofmissionC = wcnumberofkilledofmissionC + 1;
						wccivilkilled = wccivilkilled + 1;
						["wccivilkilled", "client"] call WC_fnc_publicvariable;
						wcfame = wcfame - (random 0.1);
					};
				}];

				if !((typeOf _x) in wccivilwithoutweapons) then {
					_x addEventHandler ["Fired", {
						private ["_unit"];
						_unit = _this select 0;
						_unit setVehicleAmmo 1;
						_unit setMimic "Agresive";
					}];
				};

				_x removeAllEventHandlers "HandleDamage";

				_x setVariable ["EH_Selections", []];
				_x setVariable ["EH_GetHit", []];

				_x addEventHandler ["HandleDamage", {
					private ["_unit", "_shooter", "_damage"];
					_unit    = _this select 0;
					_shooter = _this select 3;
					if (isPlayer _shooter || {side _shooter != side _unit}) then {
						_unit setMimic "Hurt";
						_damage = _this call WC_fnc_handleDamage;
						_damage
					};
				}];

				_x addEventHandler ["FiredNear", {
					private ["_unit", "_shooter"];
					_unit    = _this select 0;
					_shooter = _this select 1;
					if (isPlayer _shooter || {side _shooter != side _unit}) then {
						_name = getText (configFile >> "CfgMagazines" >> currentMagazine _shooter >> "DisplayNameShort");
						if (_name != "SD") then {
							_unit playMove "AmovPercMstpSnonWnonDnon_AmovPercMstpSsurWnonDnon";
							_unit setMimic "Surprised";
							_unit stop true;
						};
					};
				}];
			} else {
				if (_x isKindOf "Animal") then {
					_x addEventHandler ["Killed", {
						wcaddtogarbage = _this select 0;
						["wcaddtogarbage", "server"] call WC_fnc_publicvariable;
						if (name (_this select 1) in wcinteam) then {
							wcnumberofkilledofmissionC = wcnumberofkilledofmissionC + 1;
							wccivilkilled = wccivilkilled + 1;
							["wccivilkilled", "client"] call WC_fnc_publicvariable;
							wcfame = wcfame - (random 0.1);
						};
					}];

					_x removeAllEventHandlers "HandleDamage";

					_x setVariable ["EH_Selections", []];
					_x setVariable ["EH_GetHit", []];

					_x addEventHandler ["HandleDamage", {
						private ["_shooter", "_damage"];
						_shooter = _this select 3;
						if (isPlayer _shooter || {side _shooter in wcside}) then {
							_damage = _this call WC_fnc_handleDamage;
							_damage
						};
					}];
				};
			};
		};
	};

	// Set unit var name.
	_var_name = objNull call WC_fnc_createObjName;
	[_x, _var_name] spawn WC_fnc_setVehicleVarName;
} forEach units _group;

// Mortar radio - handler
if (_side in wcenemyside) then {
	[_group] spawn {
		private ["_group", "_leader", "_target"];
		_group = _this select 0;
		while {{alive _x} count units _group > 0} do {
			_leader = leader _group;
			_target = assignedTarget _leader;
			if (!isNull _target && {([_target, _leader] call WC_fnc_getDistance) > 60}) then {
				wcmortarposition set [count wcmortarposition, [_target] call WC_fnc_getPos];
			};
			if (count wcmortarposition > 3) then {
				wcmortarposition set [0, objNull];
				wcmortarposition = wcmortarposition - [objNull];
			};
			sleep 30 + random 30;
		};
	};
};
