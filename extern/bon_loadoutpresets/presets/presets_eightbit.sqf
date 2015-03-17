private ["_presetname", "_presetclass", "_weapons", "_magazines", "_ruckweps", "_ruckmags", "_weapononback"];

private ["_preset1", "_preset2", "_preset3", "_preset4", "_preset5", "_preset6"];

// Eightbit - M16 m203 MAWS Hunt IR
_presetname = "M16 203 Maws";
_presetclass = "Eightbit";
_weapons = ["ItemMap","ItemCompass","ItemWatch","ItemRadio","NVGoggles","ItemGPS","ACE_Earplugs","ACE_Rangefinder_OD","MAAWS","ACE_HuntIR_monitor","ACE_Kestrel4500","ACE_M16A4_CCO_GL","ACE_DAGR"];
_magazines = [["ACE_Battery_Rangefinder",1],["MAAWS_HEAT",2],["30Rnd_556x45_Stanag",5],["1Rnd_HE_M203",4],["1Rnd_SmokeGreen_M203",2],["ACE_HuntIR_M203",2]];
_ruckweps = [];
_ruckmags = [["MAAWS_HEAT",4],["30Rnd_556x45_Stanag",5],["1Rnd_HE_M203",12],["1Rnd_SmokeGreen_M203",8],["ACE_HuntIR_M203",8]];
_weapononback = "ACE_BackPack_ACR_MTP";
_preset1 = [_presetname,_presetclass,_weapons,_magazines,_ruckweps,_ruckmags,_weapononback];

//Eightbit - Stock No guns
_presetname = "Stock no guns";
_presetclass = "Eightbit";
_weapons = ["ItemMap","ItemCompass","ItemWatch","ItemRadio","NVGoggles","ItemGPS","ACE_Earplugs","ACE_Rangefinder_OD","ACE_HuntIR_monitor","ACE_Kestrel4500","ACE_DAGR"];
_magazines = [["ACE_Battery_Rangefinder",1]];
_ruckweps = [];
_ruckmags = [];
_weapononback = "ACE_BackPack_ACR_MTP";
_preset2 = [_presetname,_presetclass,_weapons,_magazines,_ruckweps,_ruckmags,_weapononback];

//Eightbit - m60 smaw 84kg
_presetname = "m60 Smaw 84kg";
_presetclass = "Eightbit";
_weapons = ["ItemMap","ItemCompass","ItemWatch","ItemRadio","NVGoggles","ItemGPS","ACE_Earplugs","ACE_Rangefinder_OD","ACE_HuntIR_monitor","ACE_Kestrel4500","ACE_DAGR","ACE_SpareBarrel","ACE_M60","SMAW"];
_magazines = [["ACE_Battery_Rangefinder",1],["100Rnd_762x51_M240",5],["ACE_SMAW_Spotting",3],["SMAW_HEAA",1]];
_ruckweps = [];
_ruckmags = [["100Rnd_762x51_M240",3],["SMAW_HEAA",2]];
_weapononback = "ACE_BackPack_ACR_MTP";
_preset3 = [_presetname,_presetclass,_weapons,_magazines,_ruckweps,_ruckmags,_weapononback];

//Eightbit - Tac 50 sd + m4 sd 62kg
_presetname = "Tac 50 sd + m4 sd 62kg";
_presetclass = "Eightbit";
_weapons = ["ItemMap","ItemCompass","ItemWatch","ItemRadio","ItemGPS","ACE_Earplugs","ACE_Rangefinder_OD","ACE_HuntIR_monitor","ACE_Kestrel4500","ACE_DAGR","ACE_SpottingScope","ACE_VTAC_RUSH72_OD","NVGoggles","ACE_SOC_M4A1_GL_SD"];
_magazines = [["ACE_Battery_Rangefinder",1],["ACE_5Rnd_127x99_S_TAC50",7],["30Rnd_556x45_StanagSD",4],["ACE_1Rnd_HE_M203",8]];
_ruckweps = [["NVGoggles",0],["ACE_MX2A",1]];
_ruckmags = [["ACE_5Rnd_127x99_S_TAC50",15,[5,5,5,5,5,5,5,5,5,5,5,5,5,5,5]],["ACE_1Rnd_HE_M203",8,[1,1,1,1,1,1,1,1]],["ACE_HuntIR_M203",8,[1,1,1,1,1,1,1,1]],["1Rnd_SmokeRed_M203",2,[1,1]],["1Rnd_Smoke_M203",2,[1,1]],["FlareGreen_M203",8,[1,1,1,1,1,1,1,1]],["30Rnd_556x45_StanagSD",6,[30,30,30,30,30,30]]];
_weapononback = "ACE_TAC50_SD";
_preset4 = [_presetname,_presetclass,_weapons,_magazines,_ruckweps,_ruckmags,_weapononback];

//Eightbit - AS50 12mag + m4 sd 64kg
_presetname = "AS50 12mag + m4 sd 64kg";
_presetclass = "Eightbit";
_weapons = ["ItemMap","ItemCompass","ItemWatch","ItemRadio","ItemGPS","ACE_Earplugs","ACE_Rangefinder_OD","ACE_HuntIR_monitor","ACE_Kestrel4500","ACE_DAGR","ACE_SpottingScope","ACE_VTAC_RUSH72_OD","NVGoggles","ACE_SOC_M4A1_GL_SD"];
_magazines = [["ACE_Battery_Rangefinder",1],["30Rnd_556x45_StanagSD",4],["5Rnd_127x99_as50",7],["ACE_1Rnd_HE_M203",8]];
_ruckweps = [["NVGoggles",0],["ACE_MX2A",1]];
_ruckmags = [["ACE_1Rnd_HE_M203",8,[1,1,1,1,1,1,1,1]],["ACE_HuntIR_M203",8,[1,1,1,1,1,1,1,1]],["1Rnd_SmokeRed_M203",2,[1,1]],["1Rnd_Smoke_M203",2,[1,1]],["FlareGreen_M203",8,[1,1,1,1,1,1,1,1]],["30Rnd_556x45_StanagSD",6,[30,30,30,30,30,30]],["5Rnd_127x99_as50",5,[5,5,5,5,5]]];
_weapononback = "ACE_AS50";
_preset5 = [_presetname,_presetclass,_weapons,_magazines,_ruckweps,_ruckmags,_weapononback];

//Eightbit L115A3 + m4 sd 64kg
_presetname = "L115A3 + m4 sd 64kg";
_presetclass = "Eightbit";
_weapons = ["ItemMap","ItemCompass","ItemWatch","ItemRadio","ItemGPS","ACE_Earplugs","ACE_Rangefinder_OD","ACE_HuntIR_monitor","ACE_Kestrel4500","ACE_DAGR","ACE_SpottingScope","NVGoggles","ACE_VTAC_RUSH72_OD","ACE_SOC_M4A1_GL_SD"];
_magazines = [["ACE_Battery_Rangefinder",1],["5Rnd_86x70_L115A1",7],["30Rnd_556x45_StanagSD",4],["ACE_1Rnd_HE_M203",8]];
_ruckweps = [["ACE_MX2A",1],["ACE_M72A2",4]];
_ruckmags = [["ACE_1Rnd_HE_M203",8,[1,1,1,1,1,1,1,1]],["ACE_HuntIR_M203",8,[1,1,1,1,1,1,1,1]],["1Rnd_SmokeRed_M203",2,[1,1]],["1Rnd_Smoke_M203",2,[1,1]],["FlareGreen_M203",8,[1,1,1,1,1,1,1,1]],["30Rnd_556x45_StanagSD",6,[30,30,30,30,30,30]],["5Rnd_86x70_L115A1",19,[5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5]]];
_weapononback = "BAF_LRR_scoped_W";
_preset6 = [_presetname,_presetclass,_weapons,_magazines,_ruckweps,_ruckmags,_weapononback];

presets = presets + [_preset1,_preset2,_preset3,_preset4, _preset5, _preset6];