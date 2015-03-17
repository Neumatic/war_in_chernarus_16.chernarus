// -----------------------------------------------
// Author:     code34 nicolas_boiteux@yahoo.fr
// Edited by:  Neumatic
// Warcontext: Unlock vehicle for engineer
// -----------------------------------------------

private [
	"_caller", "_object", "_name", "_locked", "_lock", "_count", "_numbers", "_last_num", "_last_count", "_number",
	"_time"
];

_caller = _this select 1;
_object = _this select 3;

// Player is not close enough yet.
_name = [_object] call WC_fnc_getDisplayName;
if (([_caller, _object] call WC_fnc_getDistance) > 5) exitWith {
	["Lock/Unlock", format ["%1", _name], "Get closer to the vehicle", 3] spawn WC_fnc_playerhint;
};

// Check if vehicle is locked or not.
if (locked _object) then {_locked = true; _lock = false} else {_locked = false; _lock = true};

/*
	If the vehicle is local to the player calling the action. We assume he owns
	it. So it's a simple lock command.
*/
if (local _object) then {
	if (_locked) then {
		["Unlocking vehicle", format ["%1", _name], "", 2] spawn WC_fnc_playerhint;
	} else {
		["Locking vehicle", format ["%1", _name], "", 2] spawn WC_fnc_playerhint;
	};

	sleep 2;

	if (alive _caller && {alive _object}) then {
		_object lock _lock;
	};
} else {
	/*
		If the vehicle is not local to the player calling the action. We assume
		he does not own it. The player then has to complete a random amount of
		onscreen numpad numbers to lock/unlock the vehicle.
	*/
	if (_locked) then {
		["Unlocking vehicle", format ["%1", _name], "Press the same numpad keys printed on the screen", 6] spawn WC_fnc_playerhint;
	} else {
		["Locking vehicle", format ["%1", _name], "Press the same numpad keys printed on the screen", 6] spawn WC_fnc_playerhint;
	};

	sleep 6;

	if (alive _caller && {alive _object}) then {
		_count = ceil (wclevel + random 10);

		_numbers = ["1","2","3","4","5","6","7","8","9"];

		wciedcount = 0;
		wciedexplosed = false;
		wciedchallenge = true;

		_caller playMove "AinvPknlMstpSlayWrflDnon_medic";
		["GO"] spawn BIS_fnc_dynamicText;
		sleep 1;

		[""] spawn BIS_fnc_dynamicText;

		_last_num = "";

		while {wciedcount < _count && {!wciedexplosed}} do {
			_last_count = wciedcount;
			if (animationState _caller != "AinvPknlMstpSlayWrflDnon_medic") then {
				_caller switchMove "AinvPknlMstpSlayWrflDnon_medic";
			};
			waitUntil {_number = _numbers call WC_fnc_selectRandom; _number != _last_num};
			_last_num = _number;
			iedkey = _number;
			_time = ceil (random 4);
			2 cutRsc [format ["keypad%1", _number], "PLAIN"];
			2 cutFadeOut _time;
			sleep _time;
			if ((wciedcount - _last_count) != 1) then {wciedexplosed = true};
		};

		if (alive _caller && {alive _object}) then {
			if (wciedexplosed) then {
				["FAILED"] spawn BIS_fnc_dynamicText;
			} else {
				["SUCCESS"] spawn BIS_fnc_dynamicText;

				if (_locked) then {
					wchintW = parseText format ["<t color='#FF0000'>%1</t> has unlocked<br/><t color='#33CC00'>%2</t>", name _caller, _name];
				} else {
					wchintW = parseText format ["<t color='#FF0000'>%1</t> has locked<br/><t color='#33CC00'>%2</t>", name _caller, _name];
				};

				["wchintW", "client"] call WC_fnc_publicvariable;

				wclock = [_object, _lock];
				["wclock", "server"] call WC_fnc_publicvariable;
			};
		};

		wciedchallenge = false;
	};
};
