// ---------------------------------------------------
// Author:     code34 nicolas_boiteux@yahoo.fr
// Edited by:  Neumatic
// Warcontext: Detect Ied and playSound when near
// ---------------------------------------------------

private ["_exit", "_counter", "_printed", "_respawn_west", "_sounds", "_near_units", "_distance"];

_exit = false;

// Check if the player is allow to detect IEDs
if !((typeOf player) in wcengineerclass) then {
	if (wceverybodyengineer != 1) then {
		_exit = true;
	};
};

if (_exit) exitWith {};

_counter = 0;
_printed = false;
_respawn_west = getMarkerPos "respawn_west";
_sounds = ["bombdetector1","bombdetector2","bombdetector3"];

while {true} do {
	_near_units = nearestObjects [[player] call WC_fnc_getPos, ["All"], 30];
	{
		if (_x getVariable ["wciedactivate", false]) exitWith {
			if (!_printed) then {
				[localize "STR_WC_MESSAGEDETECTORIED", localize "STR_WC_MESSAGETRYTOMOVEAROUND", localize "STR_WC_MESSAGEIEDHASBEENDETECT", 10] spawn WC_fnc_playerhint;
				_printed = true;
				_counter = 0;
			};

			if (vehicle player == player) then {
				_distance = [player, _x] call WC_fnc_getDistance;

				if (_distance > 20) then {
					if (random 1 < 0.8) then {
						playSound "bombdetector2";
					} else {
						playSound (_sounds call WC_fnc_selectRandom);
					};
				} else {
					if (_distance > 10) then {
						if (random 1 < 0.9) then {
							playSound "bombdetector3";
						} else {
							playSound (_sounds call WC_fnc_selectRandom);
						};
					} else {
						if (random 1 < 0.97) then {
							playSound "bombdetector1";
						} else {
							playSound (_sounds call WC_fnc_selectRandom);
						};
					};
				};
			};
		};
	} forEach _near_units;

	// False positive
	if (wciedfalsepositive) then {
		if (random 1 > 0.995 && {([player, _respawn_west] call WC_fnc_getDistance) > 1000}) then {
			if (!_printed) then {
				[localize "STR_WC_MESSAGEDETECTORIED", localize "STR_WC_MESSAGETRYTOMOVEAROUND", localize "STR_WC_MESSAGEIEDHASBEENDETECT", 10] spawn WC_fnc_playerhint;
				_printed = true;
				_counter = 0;
			};

			if (vehicle player == player) then {
				playSound (_sounds call WC_fnc_selectRandom);
			};
		};
	};

	if (_printed) then {
		_counter = _counter + 1;
		if (_counter > 15) then {
			_printed = false;
		};
	};

	sleep 1;
};
