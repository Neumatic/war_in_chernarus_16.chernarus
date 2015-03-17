// -----------------------------------------------
// Author:     code34 nicolas_boiteux@yahoo.fr
// Edited by:  Neumatic
// Warcontext: Do light depending overcast
// -----------------------------------------------

private ["_density", "_vehicle", "_light"];

while {true} do {
	_density = overCast;
	_vehicle = vehicle player;

	if (_vehicle == player) then {
		_light = 1.4 - _density;
	} else {
		if (_vehicle isKindOf "Air") then {
			_light = 1.6 - _density;
		} else {
			_light = 1.4 - _density;
		};
	};

	if (!wcplayerinnuclearzone) then {
		if (wcwithlight == 1) then {
			"colorCorrections" ppEffectEnable true;
			"colorCorrections" ppEffectAdjust [1, _light, 0, [0,0.0,0.0,0], [1,1,1,1], [0.0001,1,0.01,1]];
			"colorCorrections" ppEffectCommit 1;
		};

		if (wcwithinjuredeffect == 1) then {
			sleep 10 - (damage player * 10);

			if (damage player > 0.2) then {
				"colorCorrections" ppEffectEnable true;
				"colorCorrections" ppEffectAdjust [1, _light, 0, [1,0,0,0], [0.6,0,0,0], [1,0,0,0]];
				"colorCorrections" ppEffectCommit 1;

				sleep 1;
			};
		};
	} else {
		sleep 1;
	};
};
