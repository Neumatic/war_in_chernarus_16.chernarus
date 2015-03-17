// -----------------------------------------------
// Author:     code34 nicolas_boiteux@yahoo.fr
// Edited by:  Neumatic
// Warcontext: Create a mission dialog box
// -----------------------------------------------

private [
	"_score", "_count", "_text_box", "_map", "_mission_number", "_name", "_objective", "_city", "_num_of_groups",
	"_num_of_vehicles", "_position", "_time", "_weight", "_intel", "_marker", "_index", "_text", "_hour", "_minute",
	"_clock", "_day", "_current_mission"
];

waitUntil {isNull wccam};
wccam = "camera" camCreate [0,0,1000];
wccam cameraEffect ["internal", "back"];

showCinemaBorder false;
wccam camSetTarget board;
wccam camSetRelPos [-1, -3, 0.5];
wccam camCommit 0;
wccameffect = ppEffectCreate ["ColorCorrections", 1999];
wccameffect ppEffectEnable true;
wccameffect ppEffectAdjust [0.5, 0.7, 0.0, [1.0,1.0,1.0,0.0], [1.0,1.0,1.0,0.0], [1.0,1.0,1.0,1.0]];
wccameffect ppEffectCommit 0;

_score = score player;
_count = 0;
{
	if (isPlayer _x && {score _x > _score}) then {
		_count = _count + 1;
	};
} forEach allUnits;

disableSerialization;
_text_box = (uiNamespace getVariable "wcdisplay") displayCtrl 1100;
_map = (uiNamespace getVariable "wcdisplay") displayCtrl 1307;

_mission_number = [];
_name = [];
_objective = [];
_city = [];
_num_of_groups = [];
_num_of_vehicles = [];
_position = [];
_time = [];
_weight = [];
_intel = [];

{
	_mission_number set [count _mission_number, _x select 0];
	_name set [count _name, _x select 1];
	lbAdd [1500, _x select 1];
	_objective set [count _objective, _x select 2];
	_city set [count _city, _x select 3];
	_num_of_groups set [count _num_of_groups, _x select 4];
	_num_of_vehicles set [count _num_of_vehicles, _x select 5];
	_position set [count _position, _x select 6];
	_time set [count _time, _x select 7];
	_weight set [count _weight, _x select 8];
	_intel set [count _intel, _x select 9];
} forEach wclistofmissions;
lbSetCurSel [1500, 0];

_marker = ["choosemission", [0,0,0], 800, "ColorGreen", "ELLIPSE", "FDIAGONAL", "", 0, "", 1] call WC_fnc_createmarkerlocal;

if !((_count < 4) && {name player in wcinteam}) then {
	ctrlSetText [1600, localize "STR_ACGUI_MM_BTN_CLOSE"];
};

if (!wcadmin) then {
	ctrlShow [1601, false];
};

menuaction = -1;

while {dialog && {alive player}} do {
	_index = lbCurSel 1500;
	_text = lbText [1500, _index];

	_hour = ((_time select _index) select 3);
	if (_hour < 10) then {_hour = format ["0%1", _hour]} else {_hour = format ["%1", _hour]};
	_minute = ((_time select _index) select 4);
	if (_minute < 10) then {_minute = format ["0%1", _minute]} else {_minute = format ["%1", _minute]};
	_clock = format ["%1:%2", _hour, _minute];

	if (((_time select _index) select 3) < (date select 3)) then {_day = wcday + 1} else {_day = wcday};
	if (((_time select _index) select 3) == (date select 3)) then {
		if (((_time select _index) select 4) < (date select 4)) then {
			_day = wcday + 1;
		} else {
			_day = wcday;
		};
	};

	_text = _text + "\n\n" + format ["\nDay: %1 Time: %2\n", _day, _clock] + format ["Near: %1\n\n", (_city select _index)] + (_objective select _index) + format ["\n\nOpposition forces:\n\n  %1 groups \n  %2 vehicles", (_num_of_groups select _index), (_num_of_vehicles select _index)] + format ["\n\nVehicle intel report:\n\n  %1", (_intel select _index)];

	ctrlSetText [1100, format ["%1", _text]];
	_current_mission = (_mission_number select _index);
	_map ctrlMapAnimAdd [1, 0.5, (_position select _index)];
	_marker setMarkerPosLocal (_position select _index);
	ctrlMapAnimCommit _map;

	sleep 0.1;

	ctrlMapAnimClear _map;

	if (!wcchoosemission) then {
		menuaction = -1;
		closeDialog 0;

		deleteMarkerLocal _marker;
		ppEffectDestroy wccameffect;
		wccam cameraEffect ["terminate", "back"];
		camDestroy wccam;
		wccam = objNull;
	};

	if (menuaction > 0) then {
		switch (menuaction) do {
			case 1: {
				deleteMarkerLocal _marker;
				ppEffectDestroy wccameffect;
				wccam cameraEffect ["terminate", "back"];
				camDestroy wccam;
				wccam = objNull;
				closeDialog 0;

				if ((_count < 4) && {name player in wcinteam}) then {
					["Headquarter radio", "Sending information to headquarter...", "Wait during mission computation", 3] spawn WC_fnc_playerhint;
					sleep 3;

					wcaskformission = [player, _current_mission];
					["wcaskformission", "server"] call WC_fnc_publicvariable;

					if (WC_isServer) then {
						if (wcchoosemissionmenu >= 0) then {
							player removeAction wcchoosemissionmenu;
							wcchoosemissionmenu = -1;
						};
					};
				} else {
					["Headquarter radio", "You can not talk with headquarter", "Be one of the three best team members to talk with headquarter", 10] spawn WC_fnc_playerhint;
				};
			};

			case 2: {
				wcrecomputemission = true;
				["wcrecomputemission", "server"] call WC_fnc_publicvariable;

				closeDialog 0;
			};
		};

		menuaction = -1;
	};
};

menuaction = -1;
deleteMarkerLocal _marker;
ppEffectDestroy wccameffect;
wccam cameraEffect ["terminate", "back"];
camDestroy wccam;
wccam = objNull;
