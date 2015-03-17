// -----------------------------------------------
// Author:     code34 nicolas_boiteux@yahoo.fr
// Edited by:  Neumatic
// Warcontext: Restore menu action when player died
// -----------------------------------------------

// Default menu
player addAction ["<t color='#ff4500'>Mission Info</t>","warcontext\dialogs\WC_fnc_createmenumissioninfo.sqf", [], 5, false];

if (wcwithteleporttent == 1) then {
	player addAction [localize "STR_WC_MENUDEPLOYTENT", "warcontext\actions\WC_fnc_dobuildtent.sqf", [], -1, false];
};

//player addAction [localize "STR_WC_MENUBUILDTRENCH", "warcontext\actions\WC_fnc_dodigtrench.sqf", [], -1, false];

// Admin menu
if (wcadmin) then {
	wcbombingsupport = -1;
	wccancelmission = nil;
	wcmanageteam = nil;
	wcspectate = false;
};

// Check operation Plan
if (wcchoosemission) then {
	if (wcchoosemissionmenu < 0) then {
		wcchoosemissionmenu = player addAction ["<t color='#dddd00'>" + localize "STR_WC_MENUCHOOSEMISSION" + "</t>", "warcontext\dialogs\WC_fnc_createmenuchoosemission.sqf", [], 6, false];
	};
};
