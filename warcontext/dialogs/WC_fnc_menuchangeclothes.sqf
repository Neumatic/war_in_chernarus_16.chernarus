// -----------------------------------------------
// Author:     code34 nicolas_boiteux@yahoo.fr
// Edited by:  Neumatic
// Warcontext: Change clothes ingame
// -----------------------------------------------

private ["_last_body", "_array", "_name", "_index", "_type", "_group", "_unit", "_position", "_new_group", "_count"];

if (wcoriginalclothes != typeOf player) exitWith {
	_last_body = player;
	_last_body removeAllEventHandlers "Killed";
	_last_body setPos [0,0,0];

	wcbackupbody setPos wcbackupposition;
	selectPlayer wcbackupbody;

	_last_body setDamage 1;

	ppEffectDestroy wccameffect;
	wccam cameraEffect ["terminate", "back"];
	camDestroy wccam;
	wccam = objNull;

	menuaction = -1;
	closeDialog 0;
};

waitUntil {isNull wccam};
wccam = "camera" camCreate [0,0,1000];
wccam cameraEffect ["internal", "back"];

showCinemaBorder false;
wccam camSetTarget clothes;
wccam camSetRelPos [-5, -10, 2.5];
wccam camCommit 0;
wccameffect = ppEffectCreate ["ColorCorrections", 1999];
wccameffect ppEffectEnable true;
wccameffect ppEffectAdjust [0.5, 0.7, 0.0, [1.0,1.0,1.0,0.0], [1.0,1.0,1.0,0.0], [1.0,1.0,1.0,1.0]];
wccameffect ppEffectCommit 0;

disableSerialization;
(uiNamespace getVariable "wcdisplay") displayCtrl 5001;

_array = [];
{
	_name = [_x] call WC_fnc_getDisplayName;
	_index = lbAdd [5002, _name];
	_array set [_index, _x];
} forEach wcchangeclothes;

lbSetCurSel [5002, 0];

ctrlSetText [5005, "Change clothes"];

menuaction = -1;

while {dialog && {alive player}} do {
	_index = lbCurSel 5002;
	_type = _array select _index;

	if (menuaction > 0) then {
		switch (menuaction) do {
			case 1: {
				if (!isNil "_type") then {
					ppEffectDestroy wccameffect;
					wccam cameraEffect ["terminate", "back"];
					camDestroy wccam;
					wccam = objNull;
					closeDialog 0;

					objNull call WC_fnc_saveloadout;

					if (_type in wcchangeclothescivil) then {
						_group = creategroup civilian;
					} else {
						if (_type in wcchangeclotheswest) then {
							_group = creategroup west;
						} else {
							if (_type in wcchangeclotheseast) then {
								_group = creategroup east;
							};
						};
					};

					_unit = _group createUnit [_type, [player] call WC_fnc_getPos, [], 0, "NONE"];
					{
						_unit disableAI _x;
					} forEach ["AUTOTARGET","TARGET","MOVE","ANIM"];

					wcbackupbody = player;
					wcbackupposition = [player] call WC_fnc_getPos;

					_position = [wcinitpos, 0, 10, 10, player] call WC_fnc_findEmptyPosition;
					wcbackupbody setPosASL _position;

					_unit addEventHandler ["Killed", {
						wcaddtogarbage = _this select 0;
						["wcaddtogarbage", "server"] call WC_fnc_publicvariable;

						_this spawn WC_fnc_restorebody;

						// Removes the dead bodies addActions.
						for "_i" from 0 to 20 do {
							(_this select 0) removeAction _i;
						};

						// Change the scoring based on param
						if (wcdefaultscore == 1) then {
							wcplayeraddscore = switch (rank player) do {
								case "PRIVATE": {   [player, -1]};
								case "CORPORAL": {  [player, -2]};
								case "SERGEANT": {  [player, -3]};
								case "LIEUTENANT": {[player, -4]};
								case "CAPTAIN": {   [player, -5]};
								case "MAJOR": {     [player, -7]};
								case "COLONEL": {   [player, -10]};
							};
						} else {
							wcplayeraddscore = switch (rank player) do {
								case "PRIVATE": {   [player, -1]};
								case "CORPORAL": {  [player, -1]};
								case "SERGEANT": {  [player, -1]};
								case "LIEUTENANT": {[player, -1]};
								case "CAPTAIN": {   [player, -1]};
								case "MAJOR": {     [player, -1]};
								case "COLONEL": {   [player, -1]};
							};
						};

						["wcplayeraddscore", "server"] call WC_fnc_publicvariable;

						wcaddscore = -1;
						["wcaddscore", "server"] call WC_fnc_publicvariable;
					}];

					selectPlayer _unit;

					// Leave the group of players
					_new_group = createGroup west;
					[wcbackupbody] joinSilent _new_group;

					objNull call WC_fnc_clienteventhandler;
					objNull call WC_fnc_restoreactionmenu;
					objNull call WC_fnc_restoreloadout;

					if (count (units group player) > 0) then {
						_count = 0;
						{
							if (isPlayer _x) then {
								_count = _count + 1;
							};
						} forEach units group player;

						if (_count == 1) then {
							(group player) selectLeader player;
						};
					};

					[player] spawn WC_fnc_stealth;
				};
			};

			case 2: {
				closeDialog 0;
			};
		};

		menuaction = -1;
	};

	sleep 0.1;
};

ppEffectDestroy wccameffect;
wccam cameraEffect ["terminate", "back"];
camDestroy wccam;
wccam = objNull;

menuaction = -1;
