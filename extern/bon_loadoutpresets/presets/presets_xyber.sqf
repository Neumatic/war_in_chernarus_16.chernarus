private ["_presetname", "_presetclass", "_weapons", "_magazines", "_ruckweps", "_ruckmags", "_weapononback"];

private ["_preset1"];

// Xyber - test preset 1
_presetname = "HK416 / RPG29";
_presetclass = "Xyber";
_weapons = ["NVGoggles","ACE_Rangefinder_OD","M9SD","ItemGPS","ItemMap","ItemCompass","ItemWatch","ItemRadio","ACE_Earplugs","ACE_HK416_D14_TWS","ACE_RPG29","ACE_Kestrel4500","ACE_HuntIR_monitor"];
_magazines = [["ACE_30Rnd_556x45_T_Stanag",6],["ACE_RPG29_PG29",3],["ACE_Medkit",7],["15Rnd_9x19_M9SD",1]];
_ruckweps = [];
_ruckmags = [];
_weapononback = "";
_preset1 = [_presetname,_presetclass,_weapons,_magazines,_ruckweps,_ruckmags,_weapononback];

presets = presets + [_preset1];