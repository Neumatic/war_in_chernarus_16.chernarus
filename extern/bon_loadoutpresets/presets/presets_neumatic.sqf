private ["_presetname", "_presetclass", "_weapons", "_magazines", "_ruckweps", "_ruckmags", "_weapononback"];

private ["_preset1", "_preset2", "_preset3", "_preset4", "_preset5", "_preset6", "_preset7", "_preset8", "_preset9", "_preset10", "_preset11"];

_presetname = "Sniper no guns";
_presetclass = "Neumatic";
_weapons = ["ItemGPS","ItemMap","ItemCompass","ItemWatch","ItemRadio","ACE_Rangefinder_OD","ACE_Earplugs","ACE_Kestrel4500","ACE_MX2A","ACE_SpottingScope","ACE_SniperTripod"];
_magazines = [];
_ruckweps = [["NVGoggles",1],["ACE_MugLite",1]];
_ruckmags = [];
_weapononback = "ACE_Coyote_Pack_Flora";
_preset1 = [_presetname,_presetclass,_weapons,_magazines,_ruckweps,_ruckmags,_weapononback];

_presetname = "Stock no guns";
_presetclass = "Neumatic";
_weapons = ["ItemGPS","ItemMap","ItemCompass","ItemWatch","ItemRadio","ACE_Earplugs","NVGoggles","ACE_MX2A"];
_magazines = [];
_ruckweps = [];
_ruckmags = [];
_weapononback = "ACE_Coyote_Pack_Flora";
_preset2 = [_presetname,_presetclass,_weapons,_magazines,_ruckweps,_ruckmags,_weapononback];

_presetname = "M110 SD SMAW";
_presetclass = "Neumatic";
_weapons = ["ItemGPS","ItemMap","ItemCompass","ItemWatch","ItemRadio","ACE_Rangefinder_OD","ACE_Earplugs","ACE_Kestrel4500","ACE_SpottingScope","ACE_SniperTripod","SMAW","ACE_M110_SD","ACE_USPSD","ACE_MX2A"];
_magazines = [["ACE_20Rnd_762x51_S_M110",6],["SMAW_HEAA",3],["ACE_SMAW_Spotting",4],["ACE_12Rnd_45ACP_USP",4]];
_ruckweps = [["NVGoggles",1],["ACE_MugLite",1]];
_ruckmags = [["ACE_20Rnd_762x51_S_M110",8,[20,20,20,20,20,20,20,20]],["HandGrenade_West",6,[1,1,1,1,1,1]],["SmokeShellGreen",3,[1,1,1]],["SmokeShellRed",3,[1,1,1]]];
_weapononback = "ACE_Coyote_Pack_Flora";
_preset3 = [_presetname,_presetclass,_weapons,_magazines,_ruckweps,_ruckmags,_weapononback];

_presetname = "M110 SD Mk17 MAAWS";
_presetclass = "Neumatic";
_weapons = ["ItemGPS","ItemMap","ItemCompass","ItemWatch","ItemRadio","ACE_Rangefinder_OD","ACE_Earplugs","ACE_Kestrel4500","ACE_MX2A","ACE_SpottingScope","ACE_SniperTripod","ACE_USPSD","MAAWS","ACE_M110_SD"];
_magazines = [["20Rnd_762x51_SB_SCAR",6],["MAAWS_HEAT",2],["ACE_12Rnd_45ACP_USP",8]];
_ruckweps = [["NVGoggles",1],["ACE_MugLite",1]];
_ruckmags = [["20Rnd_762x51_SB_SCAR",8,[20,20,20,20,20,20,20,20]],["HandGrenade_West",6,[1,1,1,1,1,1]],["SmokeShellGreen",3,[1,1,1]],["SmokeShellRed",3,[1,1,1]],["MAAWS_HEAT",2,[1,1]]];
_weapononback = "ACE_Coyote_Pack_Flora";
_preset4 = [_presetname,_presetclass,_weapons,_magazines,_ruckweps,_ruckmags,_weapononback];

_presetname = "TAC-50 SD MAAWS";
_presetclass = "Neumatic";
_weapons = ["ItemGPS","ItemMap","ItemCompass","ItemWatch","ItemRadio","ACE_Rangefinder_OD","ACE_Earplugs","ACE_Kestrel4500","ACE_SpottingScope","ACE_SniperTripod","ACE_MX2A","ACE_TAC50_SD","MAAWS","ACE_USPSD"];
_magazines = [["ACE_5Rnd_127x99_S_TAC50",6],["MAAWS_HEAT",2],["ACE_12Rnd_45ACP_USP",8]];
_ruckweps = [["NVGoggles",1],["ACE_MugLite",1]];
_ruckmags = [["HandGrenade_West",6,[1,1,1,1,1,1]],["SmokeShellGreen",3,[1,1,1]],["SmokeShellRed",3,[1,1,1]],["ACE_5Rnd_127x99_S_TAC50",6,[5,5,5,5,5,5]]];
_weapononback = "ACE_Coyote_Pack_Flora";
_preset5 = [_presetname,_presetclass,_weapons,_magazines,_ruckweps,_ruckmags,_weapononback];

_presetname = "TAC-50 SD M4/M203 Back up";
_presetclass = "Neumatic";
_weapons = ["ItemGPS","ItemMap","ItemCompass","ItemWatch","ItemRadio","ACE_Rangefinder_OD","ACE_Earplugs","ACE_Kestrel4500","ACE_SpottingScope","ACE_SniperTripod","ACE_MX2A","ACE_Coyote_Pack_Flora","ACE_TAC50_SD"];
_magazines = [["ACE_5Rnd_127x99_S_TAC50",6],["30Rnd_556x45_StanagSD",6],["1Rnd_HE_M203",4],["FlareGreen_M203",1],["FlareYellow_M203",1],["1Rnd_SmokeRed_M203",1],["1Rnd_SmokeGreen_M203",1]];
_ruckweps = [["NVGoggles",1],["ACE_MugLite",1]];
_ruckmags = [["HandGrenade_West",6,[1,1,1,1,1,1]],["SmokeShellGreen",3,[1,1,1]],["SmokeShellRed",3,[1,1,1]],["ACE_5Rnd_127x99_S_TAC50",6,[5,5,5,5,5,5]],["1Rnd_HE_M203",4,[1,1,1,1]],["1Rnd_SmokeRed_M203",2,[1,1]],["1Rnd_SmokeGreen_M203",2,[1,1]],["30Rnd_556x45_StanagSD",3,[30,30,30]],["FlareGreen_M203",2,[1,1]],["FlareYellow_M203",2,[1,1]]];
_weapononback = "M4A1_HWS_GL_SD_Camo";
_preset6 = [_presetname,_presetclass,_weapons,_magazines,_ruckweps,_ruckmags,_weapononback];

_presetname = "M24 M4/M203 Back up";
_presetclass = "Neumatic";
_weapons = ["ItemGPS","ItemMap","ItemCompass","ItemWatch","ItemRadio","ACE_Rangefinder_OD","ACE_Earplugs","ACE_Kestrel4500","ACE_MX2A","ACE_SpottingScope","ACE_SniperTripod","ACE_Coyote_Pack_Flora","M24"];
_magazines = [["5Rnd_762x51_M24",6],["30Rnd_556x45_StanagSD",3],["HandGrenade_West",1],["SmokeShellGreen",1],["1Rnd_HE_M203",4],["1Rnd_SmokeRed_M203",2],["1Rnd_SmokeGreen_M203",2],["SmokeShellRed",1]];
_ruckweps = [["NVGoggles",1],["ACE_MugLite",1]];
_ruckmags = [["5Rnd_762x51_M24",12,[5,4,5,5,5,5,5,5,5,5,5,5]],["30Rnd_556x45_StanagSD",6,[30,30,30,30,30,30]],["1Rnd_HE_M203",8,[1,1,1,1,1,1,1,1]],["1Rnd_SmokeRed_M203",2,[1,1]],["1Rnd_SmokeGreen_M203",2,[1,1]],["HandGrenade_West",6,[1,1,1,1,1,1]],["SmokeShellGreen",1,[1]],["SmokeShellRed",1,[1]]];
_weapononback = "M4A1_HWS_GL_SD_Camo";
_preset7 = [_presetname,_presetclass,_weapons,_magazines,_ruckweps,_ruckmags,_weapononback];

_presetname = "M27 IAR SMAW";
_presetclass = "Neumatic";
_weapons = ["ItemGPS","ItemMap","ItemCompass","ItemWatch","ItemRadio","ACE_Earplugs","NVGoggles","ACE_MX2A","ACE_M27_IAR_ACOG","SMAW"];
_magazines = [["30Rnd_556x45_Stanag",6],["SMAW_HEAA",3],["ACE_SMAW_Spotting",8]];
_ruckweps = [];
_ruckmags = [["30Rnd_556x45_Stanag",6,[30,30,30,30,30,30]],["SMAW_HEAA",2,[1,1]],["HandGrenade_West",6,[1,1,1,1,1,1]],["SmokeShellGreen",3,[1,1,1]],["SmokeShellRed",3,[1,1,1]]];
_weapononback = "ACE_Coyote_Pack_Flora";
_preset8 = [_presetname,_presetclass,_weapons,_magazines,_ruckweps,_ruckmags,_weapononback];

_presetname = "Mk16 TWS SMAW";
_presetclass = "Neumatic";
_weapons = ["ItemGPS","ItemMap","ItemCompass","ItemWatch","ItemRadio","ACE_Earplugs","NVGoggles","ACE_MX2A","SCAR_L_STD_EGLM_TWS","SMAW"];
_magazines = [["30Rnd_556x45_Stanag",6],["1Rnd_HE_M203",4],["SMAW_HEAA",3],["ACE_SMAW_Spotting",4]];
_ruckweps = [];
_ruckmags = [["HandGrenade_West",6,[1,1,1,1,1,1]],["SmokeShellGreen",3,[1,1,1]],["SmokeShellRed",3,[1,1,1]],["30Rnd_556x45_Stanag",6,[30,30,30,30,30,30]],["1Rnd_HE_M203",8,[1,1,1,1,1,1,1,1]],["FlareGreen_M203",3,[1,1,1]],["FlareRed_M203",3,[1,1,1]],["1Rnd_SmokeRed_M203",3,[1,1,1]],["1Rnd_SmokeGreen_M203",3,[1,1,1]],["SMAW_HEAA",1,[1]]];
_weapononback = "ACE_Coyote_Pack_Flora";
_preset9 = [_presetname,_presetclass,_weapons,_magazines,_ruckweps,_ruckmags,_weapononback];

_presetname = "Mk17 TWS SD SMAW";
_presetclass = "Neumatic";
_weapons = ["ItemGPS","ItemMap","ItemCompass","ItemWatch","ItemRadio","ACE_Earplugs","NVGoggles","ACE_MX2A","SCAR_H_STD_TWS_SD","SMAW"];
_magazines = [["20Rnd_762x51_SB_SCAR",6],["SMAW_HEAA",3],["ACE_SMAW_Spotting",8]];
_ruckweps = [];
_ruckmags = [["20Rnd_762x51_SB_SCAR",8,[20,20,20,20,20,20,20,20]],["SMAW_HEAA",2,[1,1]],["HandGrenade_West",6,[1,1,1,1,1,1]],["SmokeShellGreen",3,[1,1,1]],["SmokeShellRed",3,[1,1,1]]];
_weapononback = "ACE_Coyote_Pack_Flora";
_preset10 = [_presetname,_presetclass,_weapons,_magazines,_ruckweps,_ruckmags,_weapononback];

_presetname = "HK417 Holo 4x MAAWS";
_presetclass = "Neumatic";
_weapons = ["ItemGPS","ItemMap","ItemCompass","ItemWatch","ItemRadio","ACE_Earplugs","NVGoggles","ACE_MX2A","ACE_HK417_Eotech_4x","MAAWS"];
_magazines = [["ACE_20Rnd_762x51_B_HK417",6],["MAAWS_HEAT",1],["ACE_MAAWS_HE",1]];
_ruckweps = [];
_ruckmags = [["ACE_20Rnd_762x51_B_HK417",8,[20,20,20,20,20,20,20,20]],["MAAWS_HEAT",2,[1,1]],["ACE_MAAWS_HE",1,[1]],["HandGrenade_West",2,[1,1]]];
_weapononback = "ACE_Coyote_Pack_Flora";
_preset11 = [_presetname,_presetclass,_weapons,_magazines,_ruckweps,_ruckmags,_weapononback];

presets = presets + [_preset1,_preset2,_preset3,_preset4,_preset5,_preset6,_preset7,_preset8,_preset9,_preset10,_preset11];