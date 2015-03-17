// -----------------------------------------------
// Author:     code34 nicolas_boiteux@yahoo.fr
// Edited by:  Neumatic
// Warcontext: Attach an ied to an existing object or unit
// -----------------------------------------------

private ["_object", "_last_pos", "_count", "_mission_complete", "_enemys", "_enemy", "_position", "_cibles", "_list"];

_object = _this select 0;

_object setVariable ["wciedactivate", true, true];

if (_object isKindOf "Man") then {
	_last_pos = _object getVariable ["lastpos", []];
	if (count _last_pos == 0) then {
		_object setVariable ["lastpos", getPos _object];
	};
	_object allowFleeing 0;
};

wcaddactions = [_object, "DISARM_IED"];
["wcaddactions", "client"] call WC_fnc_publicvariable;

_count = 0;
_mission_complete = false;

while {!_mission_complete} do {
	_count = _count + 1;

	if (alive _object) then {
		_enemys = (getPos _object) nearEntities [["CAManBase", "LandVehicle"], 10];
		if (count _enemys > 0) then {
			{
				_enemy = _x;
				if (isPlayer _enemy) then {
					if (side _enemy in wcside) then {
						if (_enemy isKindOf "CAManBase" && !(typeOf _enemy in wcengineerclass)
						|| {_enemy isKindOf "LandVehicle" && count crew _enemy > 0 && side driver _enemy in wcside}
						) then {
							_position = getPos _object;

							"ARTY_R_227mm_HE" createVehicle _position;
							"Bo_GBU12_LGB" createVehicle _position;

							if (_enemy isKindOf "LandVehicle") then {
								{
									_x setDamage 1;
								} forEach crew _enemy;

								wchintW = localize "STR_WC_MESSAGEANIEDEXPLOSIONNEARVEHICLE";
							} else {
								wcallahsound = name _enemy;
								["wcallahsound", "client"] call WC_fnc_publicvariable;

								wchintW = format [localize "STR_WC_MESSAGEANIEDEXPLOSION", name _enemy];
							};

							["wchintW", "client"] call WC_fnc_publicvariable;

							_mission_complete = true;
							_object setVariable ["wciedactivate", false, true];
							_object setDamage 1;
						};
					};
				};
			} forEach _enemys;
		};

		if (_object isKindOf "Man") then {
			if (_count > 30) then {
				_cibles = [];

				_list = (getPos _object) nearEntities ["CAManBase", 150];
				if (count _list > 0) then {
					{
						if (isPlayer _x) then {
							if (side _x in wcside) then {
								_cibles set [count _cibles, _x];
							};
						};
					} forEach _list;

					if (count _cibles > 0) then {
						_position = getPos (([_object, _cibles] call EXT_fnc_SortByDistance) select 0);
					} else {
						_position = [0,0,0];
					};
				} else {
					if (count ((getPos _object) nearObjects ["House", 300]) > 0) then {
						_position = ([_last_pos, "all", 300] call WC_fnc_gethousespositions) call WC_fnc_selectRandom;
					} else {
						_position = [0,0,0];
					};
				};

				if (format ["%1", _position] != "[0,0,0]") then {
					_object setVariable ["destination", _position, false];
					_object doMove _position;
				};

				_count = 0;
			};
		};
	};

	if (isNull _object) then {
		_mission_complete = true;
	};
	if (!alive _object) then {
		_mission_complete = true;
	};
	if !(_object getVariable "wciedactivate") then {
		_mission_complete = true;
	};

	sleep 1;
};
