// -----------------------------------------------
// Author:     code34 nicolas_boiteux@yahoo.fr
// Edited by:  Neumatic
// Warcontext: Create a hint marker local
// -----------------------------------------------

private ["_marker", "_turn", "_size"];

_marker = _this select 0;

_turn = 0;
_size = 2;

_marker setMarkerSizeLocal [_size, _size];

while {true} do {
	if (format ["%1", wcselectedzone] != "[0,0,0]") then {
		_turn = _turn + 5;

		_marker setMarkerDirLocal _turn;
		_marker setMarkerPosLocal wcselectedzone;
		_marker setMarkerAlphaLocal 1;

		if (_turn > 355) then {_turn = 0};

		sleep 0.05;
	} else {
		_marker setMarkerPosLocal wcselectedzone;
		_marker setMarkerAlphaLocal 0;

		sleep 5;
	};
};
