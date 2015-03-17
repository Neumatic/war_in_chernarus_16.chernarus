// -----------------------------------------------
// Author:     code34 nicolas_boiteux@yahoo.fr
// Edited by:  Neumatic
// Warcontext: Manage player score
// -----------------------------------------------

private ["_player_name", "_player", "_point", "_score"];

while {true} do {
	{
		_player_name = _x select 0;
		_player      = _x select 1;
		_point       = _x select 2;
		if (score _player < 0) then {
			_score = (score _player) * -1;
			_player addScore _score;
		} else {
			if (score _player != _point) then {
				_score = _point - (score _player);
				_player addScore _score;
			};
		};
		sleep 0.01;
	} forEach wcscoreboard;
	sleep 1;
};
