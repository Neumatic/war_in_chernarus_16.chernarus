// by Bon_Inf* for my 10th mates. Requires ACE2

if (!local player) exitWith {};

waitUntil {!isNull player};

private ["_uid", "_presetdlg"];

_uid = _this select 0;

if (!isMultiplayer) then {_uid = "my_uid"};

presets = [];
#include "presets\presets_eightbit.sqf"
#include "presets\presets_neumatic.sqf"
#include "presets\presets_xyber.sqf"

_presetdlg = createDialog "PresetDialog";