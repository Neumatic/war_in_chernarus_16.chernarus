///////////////////////////////////////////////////////////////////////////
/// Base Classes
///////////////////////////////////////////////////////////////////////////

class RscDisplayMission
{
	idd = 3000;
	movingenable = 0;
	controlsBackground[] = {"RscStructuredText_1101","RscListbox_1500","RscMap_1307","RscStructuredText_1100","RscButton_1600","RscText_1000","RscButton_1601"};
	onLoad = "objNull execVM ""warcontext\dialogs\WC_fnc_menuchoosemission.sqf""; uiNamespace setVariable [""wcdisplay"", _this select 0]; menuaction = -1;";

	class RscStructuredText_1101 : RscStructuredText
	{
		idc = 1101;
		x = 0.181213 * safezoneW + safezoneX;
		y = 0.075 * safezoneH + safezoneY;
		w = 0.636565 * safezoneW;
		h = 0.84775 * safezoneH;
		colorBackground[] = {0,0,0,0.5};
		colorBackgroundActive[] = {0,0,0,0};
	};

	class RscListbox_1500 : RscListBox
	{
		idc = 1500;
		x = 0.189011 * safezoneW + safezoneX;
		y = 0.155 * safezoneH + safezoneY;
		w = 0.20 * safezoneW;
		h = 0.687 * safezoneH;
	};

	class RscStructuredText_1100 : RscText
	{
		idc = 1100;
		x = 0.40 * safezoneW + safezoneX;
		y = 0.105 * safezoneH + safezoneY;
		w = 0.40 * safezoneW;
		h = 0.742 * safezoneH;
		SizeEx = 0.025;
		style = ST_MULTI;
		lineSpacing = 0.7;
		colorText[] = {1, 1, 1, 1};
		colorBackground[] = {0, 0, 0, 0};
	};

	class RscMap_1307 : RscMapControl
	{
		idc = 1307;
		x = 0.45 * safezoneW + safezoneX;
		y = 0.45 * safezoneH + safezoneY;
		w = 0.3 * safezoneW;
		h = 0.4 * safezoneH;
		default = true;
		showCountourInterval = true;
	};

	class RscButton_1600 : RscButton
	{
		idc = 1600;
		text = "Validate";
		x = 0.663526 * safezoneW + safezoneX;
		y = 0.862 * safezoneH + safezoneY;
		w = 0.141702 * safezoneW;
		h = 0.052 * safezoneH;
		action = "menuaction = 1;";
	};

	class RscText_1000 : RscText
	{
		idc = 1000;
		text = $STR_WC_MENUCHOOSEMISSION;
		x = 0.190591 * safezoneW + safezoneX;
		y = 0.094 * safezoneH + safezoneY;
		w = 0.2 * safezoneW;
		h = 0.048 * safezoneH;
	};

	class RscButton_1601 : RscButton
	{
		idc = 1601;
		text = "Recompute";
		x = 0.50 * safezoneW + safezoneX;
		y = 0.862 * safezoneH + safezoneY;
		w = 0.141702 * safezoneW;
		h = 0.052 * safezoneH;
		action = "menuaction = 2;";
	};
};

class RscDisplayrecruitment
{
	idd = 4000;
	movingenable = 0;
	controlsBackground[] = {"RCT_BackGround","RCT_HeaderTop","RCT_HeaderTopText","RCT_HeaderBottom","RCT_ButtonCloseDialog","RCT_ComboFactions","RCT_ListBoxUnitsAll","RCT_ListBoxUnitsSaved","RCT_ListBoxUnitsCurrent","RCT_ButtonSpawnSelected","RCT_ButtonAddSelected","RCT_ButtonRandom","RCT_ComboRandomNumber","RCT_ButtonSavedRemoveSelected","RCT_ButtonSavedClearAll","RCT_ButtonSavedSave","RCT_ButtonSavedSpawnAll","RCT_ButtonCurrentRemoveSelected","RCT_ButtonCurrentDeleteAll","RCT_TextNumberOfRecruits"};
	onLoad = "objNull execVM ""warcontext\dialogs\WC_fnc_menurecruitment.sqf""; uiNamespace setVariable [""wcdisplay"", _this select 0]; menuaction = -1;";
	/*
	// Safezone - Avoid
	class RCT_BackGround : RscStructuredText
	{
		idc = 4001;
		x = 0.237593 * safezoneW + safezoneX;
		y = 0.18493 * safezoneH + safezoneY;
		w = 0.525458 * safezoneW;
		h = 0.631338 * safezoneH;
		colorBackground[] = {0,0,0,0.7};
	};

	class RCT_HeaderTop : RscStructuredText
	{
		idc = 4002;
		x = 0.237593 * safezoneW + safezoneX;
		y = 0.18493 * safezoneH + safezoneY;
		w = 0.525253 * safezoneW;
		h = 0.0484483 * safezoneH;
		colorBackground[] = {0,0,0,0.7};
	};

	class RCT_HeaderTopText : RscStructuredText
	{
		idc = 4003;
		text = "Recruit squad";
		x = 0.447284 * safezoneW + safezoneX;
		y = 0.193942 * safezoneH + safezoneY;
		w = 0.104465 * safezoneW;
		h = 0.0309444 * safezoneH;
		colorBackground[] = {0,0,0,0};
	};

	class RCT_HeaderBottom : RscStructuredText
	{
		idc = 4004;
		x = 0.237593 * safezoneW + safezoneX;
		y = 0.769383 * safezoneH + safezoneY;
		w = 0.525457 * safezoneW;
		h = 0.0452704 * safezoneH;
		colorBackground[] = {0,0,0,0.7};
	};

	class RCT_ButtonCloseDialog : RscShortcutButton
	{
		idc = 4005;
		text = "Close";
		x = 0.673523 * safezoneW + safezoneX;
		y = 0.753963 * safezoneH + safezoneY;
		w = 0.0854286 * safezoneW;
		h = 0.0791322 * safezoneH;
		action = "menuaction = 12;";
	};

	class RCT_ComboFactions : RscCombo
	{
		idc = 4006;
		x = 0.242133 * safezoneW + safezoneX;
		y = 0.238743 * safezoneH + safezoneY;
		w = 0.171091 * safezoneW;
		h = 0.0322467 * safezoneH;
		colorText[] = {1,1,1,1};
		colorBackground[] = {0,0,0,0.7};
		onLBSelChanged = "menuaction = 10;";
	};

	class RCT_ListBoxUnitsAll : RscListbox
	{
		idc = 4007;
		x = 0.244476 * safezoneW + safezoneX;
		y = 0.2799 * safezoneH + safezoneY;
		w = 0.166698 * safezoneW;
		h = 0.395607 * safezoneH;
		colorBackground[] = {0,0,0,0.7};
	};

	class RCT_ListBoxUnitsSaved : RscListbox
	{
		idc = 4008;
		x = 0.420195 * safezoneW + safezoneX;
		y = 0.243433 * safezoneH + safezoneY;
		w = 0.171092 * safezoneW;
		h = 0.433378 * safezoneH;
		colorBackground[] = {0,0,0,0.7};
	};

	class RCT_ListBoxUnitsCurrent : RscListbox
	{
		idc = 4009;
		x = 0.600305 * safezoneW + safezoneX;
		y = 0.242131 * safezoneH + safezoneY;
		w = 0.15718 * safezoneW;
		h = 0.433378 * safezoneH;
		colorBackground[] = {0,0,0,0.7};
	};

	class RCT_ButtonSpawnSelected : RscShortcutButton
	{
		idc = 4010;
		text = "Spawn";
		x = 0.236421 * safezoneW + safezoneX;
		y = 0.661494 * safezoneH + safezoneY;
		w = 0.092751 * safezoneW;
		h = 0.0856443 * safezoneH;
		action = "menuaction = 1;";
	};

	class RCT_ButtonAddSelected : RscShortcutButton
	{
		idc = 4011;
		text = "Add";
		x = 0.32721 * safezoneW + safezoneX;
		y = 0.662796 * safezoneH + safezoneY;
		w = 0.0912861 * safezoneW;
		h = 0.0830391 * safezoneH;
		action = "menuaction = 2;";
	};

	class RCT_ButtonRandom : RscShortcutButton
	{
		idc = 4012;
		text = "Random";
		x = 0.235689 * safezoneW + safezoneX;
		y = 0.705775 * safezoneH + safezoneY;
		w = 0.0927501 * safezoneW;
		h = 0.0830393 * safezoneH;
		action = "menuaction = 3;";
	};

	class RCT_ComboRandomNumber : RscCombo
	{
		idc = 4013;
		x = 0.331604 * safezoneW + safezoneX;
		y = 0.730521 * safezoneH + safezoneY;
		w = 0.069321 * safezoneW;
		h = 0.0322469 * safezoneH;
		colorText[] = {1,1,1,1};
		colorBackground[] = {0,0,0,0.7};
		onLBSelChanged = "menuaction = 11;";
	};

	class RCT_ButtonSavedRemoveSelected : RscShortcutButton
	{
		idc = 4014;
		text = "Remove";
		x = 0.415801 * safezoneW + safezoneX;
		y = 0.664099 * safezoneH + safezoneY;
		w = 0.0934825 * safezoneW;
		h = 0.0804346 * safezoneH;
		action = "menuaction = 4;";
	};

	class RCT_ButtonSavedClearAll : RscShortcutButton
	{
		idc = 4015;
		text = "Clear";
		x = 0.505126 * safezoneW + safezoneX;
		y = 0.664099 * safezoneH + safezoneY;
		w = 0.0912859 * safezoneW;
		h = 0.0804346 * safezoneH;
		action = "menuaction = 5;";
	};

	class RCT_ButtonSavedSave : RscShortcutButton
	{
		idc = 4016;
		text = "Save";
		x = 0.415802 * safezoneW + safezoneX;
		y = 0.705775 * safezoneH + safezoneY;
		w = 0.0890893 * safezoneW;
		h = 0.0804346 * safezoneH;
		action = "menuaction = 6;";
	};

	class RCT_ButtonSavedSpawnAll : RscShortcutButton
	{
		idc = 4017;
		text = "Spawn";
		x = 0.502928 * safezoneW + safezoneX;
		y = 0.70317 * safezoneH + safezoneY;
		w = 0.0920184 * safezoneW;
		h = 0.0843417 * safezoneH;
		action = "menuaction = 7;";
	};

	class RCT_ButtonCurrentRemoveSelected : RscShortcutButton
	{
		idc = 4018;
		text = "Remove";
		x = 0.630323 * safezoneW + safezoneX;
		y = 0.6641 * safezoneH + safezoneY;
		w = 0.10959 * safezoneW;
		h = 0.0791322 * safezoneH;
		action = "menuaction = 8;";
	};

	class RCT_ButtonCurrentDeleteAll : RscShortcutButton
	{
		idc = 4019;
		text = "Delete all";
		x = 0.630324 * safezoneW + safezoneX;
		y = 0.701868 * safezoneH + safezoneY;
		w = 0.108857 * safezoneW;
		h = 0.0830393 * safezoneH;
		action = "menuaction = 9;";
	};

	class RCT_TextNumberOfRecruits : RscText
	{
		idc = 4020;
		x = 0.238368 * safezoneW + safezoneX;
		y = 0.193942 * safezoneH + safezoneY;
		w = 0.179877 * safezoneW;
		h = 0.0309445 * safezoneH;
		colorBackground[] = {0,0,0,0};
	};
	*/
	class RCT_BackGround : RscStructuredText
	{
		idc = 4001;
		x = -5.96046e-007;
		y = 0.0500004;
		w = 1.00123;
		h = 0.90171;
		colorBackground[] = {0,0,0,0.7};
	};

	class RCT_HeaderTop : RscStructuredText
	{
		idc = 4002;
		x = -5.96046e-007;
		y = 0.0500004;
		w = 1.00084;
		h = 0.0691964;
		colorBackground[] = {0,0,0,0.7};
	};

	class RCT_HeaderTopText : RscStructuredText
	{
		idc = 4003;
		text = "Recruit squad";
		x = 0.399553;
		y = 0.0628718;
		w = 0.199052;
		h = 0.0441964;
		colorBackground[] = {0,0,0,0};
	};

	class RCT_HeaderBottom : RscStructuredText
	{
		idc = 4004;
		x = -5.96046e-007;
		y = 0.884747;
		w = 1.00123;
		h = 0.0646576;
		colorBackground[] = {0,0,0,0.7};
	};

	class RCT_ButtonCloseDialog : RscShortcutButton
	{
		idc = 4005;
		text = "Close";
		x = 0.830638;
		y = 0.862723;
		w = 0.162779;
		h = 0.113021;
		action = "menuaction = 12;";
	};

	class RCT_ComboFactions : RscCombo
	{
		idc = 4006;
		x = 0.00865009;
		y = 0.126859;
		w = 0.326004;
		h = 0.0460564;
		colorText[] = {1,1,1,1};
		colorBackground[] = {0,0,0,0.7};
		onLBSelChanged = "menuaction = 10;";
	};

	class RCT_ListBoxUnitsAll : RscListbox
	{
		idc = 4007;
		x = 0.0131145;
		y = 0.185642;
		w = 0.317633;
		h = 0.565027;
		colorBackground[] = {0,0,0,0.7};
	};

	class RCT_ListBoxUnitsSaved : RscListbox
	{
		idc = 4008;
		x = 0.347936;
		y = 0.133557;
		w = 0.326005;
		h = 0.618973;
		colorBackground[] = {0,0,0,0.7};
	};

	class RCT_ListBoxUnitsCurrent : RscListbox
	{
		idc = 4009;
		x = 0.691125;
		y = 0.131698;
		w = 0.299497;
		h = 0.618973;
		colorBackground[] = {0,0,0,0.7};
	};

	class RCT_ButtonSpawnSelected : RscShortcutButton
	{
		idc = 4010;
		text = "Spawn";
		x = -0.00223377;
		y = 0.730654;
		w = 0.176731;
		h = 0.122322;
		action = "menuaction = 1;";
	};

	class RCT_ButtonAddSelected : RscShortcutButton
	{
		idc = 4011;
		text = "Add";
		x = 0.170759;
		y = 0.732514;
		w = 0.17394;
		h = 0.118601;
		action = "menuaction = 2;";
	};

	class RCT_ButtonRandom : RscShortcutButton
	{
		idc = 4012;
		text = "Random";
		x = -0.00362855;
		y = 0.793899;
		w = 0.17673;
		h = 0.118601;
		action = "menuaction = 3;";
	};

	class RCT_ComboRandomNumber : RscCombo
	{
		idc = 4013;
		x = 0.179132;
		y = 0.829242;
		w = 0.132087;
		h = 0.0460567;
		colorText[] = {1,1,1,1};
		colorBackground[] = {0,0,0,0.7};
		onLBSelChanged = "menuaction = 11;";
	};

	class RCT_ButtonSavedRemoveSelected : RscShortcutButton
	{
		idc = 4014;
		text = "Remove";
		x = 0.339564;
		y = 0.734375;
		w = 0.178125;
		h = 0.114881;
		action = "menuaction = 4;";
	};

	class RCT_ButtonSavedClearAll : RscShortcutButton
	{
		idc = 4015;
		text = "Clear";
		x = 0.509767;
		y = 0.734375;
		w = 0.17394;
		h = 0.114881;
		action = "menuaction = 5;";
	};

	class RCT_ButtonSavedSave : RscShortcutButton
	{
		idc = 4016;
		text = "Save";
		x = 0.339566;
		y = 0.793899;
		w = 0.169754;
		h = 0.114881;
		action = "menuaction = 6;";
	};

	class RCT_ButtonSavedSpawnAll : RscShortcutButton
	{
		idc = 4017;
		text = "Spawn";
		x = 0.505579;
		y = 0.790178;
		w = 0.175335;
		h = 0.120461;
		action = "menuaction = 7;";
	};

	class RCT_ButtonCurrentRemoveSelected : RscShortcutButton
	{
		idc = 4018;
		text = "Remove";
		x = 0.748323;
		y = 0.734376;
		w = 0.208817;
		h = 0.113021;
		action = "menuaction = 8;";
	};

	class RCT_ButtonCurrentDeleteAll : RscShortcutButton
	{
		idc = 4019;
		text = "Delete all";
		x = 0.748325;
		y = 0.788319;
		w = 0.20742;
		h = 0.118601;
		action = "menuaction = 9;";
	};

	class RCT_TextNumberOfRecruits : RscText
	{
		idc = 4020;
		x = 0.00474393;
		y = 0.0591512;
		w = 0.342745;
		h = 0.0441966;
		colorBackground[] = {0,0,0,0};
	};
};

class RscDisplayclothes
{
	idd = 5000;
	movingenable = 0;
	controlsBackground[] = {"control5001","control5002","control5004","control5005","control5006"};
	onLoad = "objNull execVM ""warcontext\dialogs\WC_fnc_menuchangeclothes.sqf""; uiNamespace setVariable [""wcdisplay"", _this select 0]; menuaction = -1;";

	class control5001 : RscStructuredText
	{
		idc = 5001;
		x = 0.2 * safezoneW + safezoneX;
		y = 0.075 * safezoneH + safezoneY;
		w = 0.25 * safezoneW;
		h = 0.84775 * safezoneH;
		colorBackground[] = {0,0,0,0.5};
		colorBackgroundActive[] = {0,0,0,0};
	};

	class control5002 : RscListBox
	{
		idc = 5002;
		x = 0.2 * safezoneW + safezoneX;
		y = 0.155 * safezoneH + safezoneY;
		w = 0.25 * safezoneW;
		h = 0.687 * safezoneH;
	};

	class control5004 : RscButton
	{
		idc = 5004;
		text = "Take this";
		x = 0.22 * safezoneW + safezoneX;
		y = 0.862 * safezoneH + safezoneY;
		w = 0.12 * safezoneW;
		h = 0.052 * safezoneH;
		action = "menuaction = 1;";
	};

	class control5005 : RscText
	{
		idc = 5005;
		text = $STR_WC_MENURECRUITMENT;
		x = 0.22 * safezoneW + safezoneX;
		y = 0.094 * safezoneH + safezoneY;
		w = 0.22 * safezoneW;
		h = 0.048 * safezoneH;
	};

	class control5006 : RscButton
	{
		idc = 5006;
		text = "Close";
		x = 0.36 * safezoneW + safezoneX;
		y = 0.862 * safezoneH + safezoneY;
		w = 0.08 * safezoneW;
		h = 0.052 * safezoneH;
		action = "menuaction = 2;";
	};
};

class RscDisplayTeam
{
	idd = 6000;
	movingenable = 0;
	controlsBackground[] = {"control6001","control6002","control6003","control6004","control6005","control6006","control6007","control6008"};
	onLoad = "objNull execVM ""warcontext\dialogs\WC_fnc_menumanagementteam.sqf""; uiNamespace setVariable [""wcdisplay"", _this select 0]; menuaction = -1;";

	class control6001 : RscStructuredText
	{
		idc = 6001;
		x = 0.2 * safezoneW + safezoneX;
		y = 0.075 * safezoneH + safezoneY;
		w = 0.25 * safezoneW;
		h = 0.84775 * safezoneH;
		colorBackground[] = {0,0,0,0.5};
		colorBackgroundActive[] = {0,0,0,0};
	};

	class control6002 : RscListBox
	{
		idc = 6002;
		x = 0.2 * safezoneW + safezoneX;
		y = 0.155 * safezoneH + safezoneY;
		w = 0.25 * safezoneW;
		h = 0.687 * safezoneH;
	};

	class control6003 : RscStructuredText
	{
		idc = 6003;
		x = 0.5 * safezoneW + safezoneX;
		y = 0.075 * safezoneH + safezoneY;
		w = 0.4 * safezoneW;
		h = 0.84775 * safezoneH;
		colorBackground[] = {0,0,0,0.5};
		colorBackgroundActive[] = {0,0,0,0};
		SizeEx = 0.025;
		style = ST_MULTI;
		lineSpacing = 0.7;
	};

	class control6004 : RscButton
	{
		idc = 6004;
		text = "Recruit";
		x = 0.3 * safezoneW + safezoneX;
		y = 0.862 * safezoneH + safezoneY;
		w = 0.141702 * safezoneW;
		h = 0.052 * safezoneH;
		action = "menuaction = 1;";
	};

	class control6005 : RscText
	{
		idc = 6005;
		text = $STR_WC_MENUTEAMMANAGEMENT;
		x = 0.22 * safezoneW + safezoneX;
		y = 0.094 * safezoneH + safezoneY;
		w = 0.22 * safezoneW;
		h = 0.048 * safezoneH;
	};

	class control6006 : RscButton
	{
		idc = 6006;
		text = $STR_ACGUI_MM_BTN_CLOSE;
		x = 0.75 * safezoneW + safezoneX;
		y = 0.862 * safezoneH + safezoneY;
		w = 0.141702 * safezoneW;
		h = 0.052 * safezoneH;
		action = "closeDialog 0;";
	};

	class control6007 : RscButton
	{
		idc = 6007;
		text = "Fire";
		x = 0.55 * safezoneW + safezoneX;
		y = 0.862 * safezoneH + safezoneY;
		w = 0.141702 * safezoneW;
		h = 0.052 * safezoneH;
		action = "menuaction = 2;";
	};

	class control6008 : RscListBox
	{
		idc = 6008;
		x = 0.5 * safezoneW + safezoneX;
		y = 0.27 * safezoneH + safezoneY;
		w = 0.4 * safezoneW;
		h = 0.58 * safezoneH;
	};
};

class RscDisplayvehicles
{
	idd = 7000;
	movingenable = 0;
	controlsBackground[] = {"BLD_BackGround","BLD_HeaderTop","BLD_HeaderBottom","BLD_HeaderText","BLD_ButtonClose","BLD_ComboFactions","BLD_ListBoxVehicles","BLD_ListBoxCurrentVehicles","BLD_ButtonSpawnVehicle","BLD_ButtonSpawnVehicleWC","BLD_ButtonDeleteSelectedVehicle","BLD_ButtonDeleteAllVehicles"};
	onLoad = "objNull execVM ""warcontext\dialogs\WC_fnc_menubuildvehicles.sqf""; uiNamespace setVariable [""wcdisplay"", _this select 0]; menuaction = -1;";
	/*
	// Safezone - Avoid
	class BLD_BackGround : RscStructuredText
	{
		idc = 7001;
		x = 0.319595 * safezoneW + safezoneX;
		y = 0.149922 * safezoneH + safezoneY;
		w = 0.360663 * safezoneW;
		h = 0.701774 * safezoneH;
		colorBackground[] = {0,0,0,0.7};
	};

	class BLD_HeaderTop : RscStructuredText
	{
		idc = 7002;
		x = 0.319595 * safezoneW + safezoneX;
		y = 0.149922 * safezoneH + safezoneY;
		w = 0.360721 * safezoneW;
		h = 0.0452704 * safezoneH;
		colorBackground[] = {0,0,0,0.7};
	};

	class BLD_HeaderBottom : RscStructuredText
	{
		idc = 7003;
		x = 0.320619 * safezoneW + safezoneX;
		y = 0.80736 * safezoneH + safezoneY;
		w = 0.359257 * safezoneW;
		h = 0.0426659 * safezoneH;
		colorBackground[] = {0,0,0,0.7};
	};

	class BLD_HeaderText : RscStructuredText
	{
		idc = 7004;
		text = "Build vehicles";
		x = 0.452409 * safezoneW + safezoneX;
		y = 0.156173 * safezoneH + safezoneY;
		w = 0.0949467 * safezoneW;
		h = 0.0335491 * safezoneH;
		colorBackground[] = {0,0,0,0};
	};

	class BLD_ButtonClose : RscShortcutButton
	{
		idc = 7005;
		text = "Close";
		x = 0.588591 * safezoneW + safezoneX;
		y = 0.79043 * safezoneH + safezoneY;
		w = 0.0905537 * safezoneW;
		h = 0.0791322 * safezoneH;
		action = "menuaction = 6;";
	};

	class BLD_ComboFactions : RscCombo
	{
		idc = 7006;
		x = 0.325013 * safezoneW + safezoneX;
		y = 0.204361 * safezoneH + safezoneY;
		w = 0.175484 * safezoneW;
		h = 0.033549 * safezoneH;
		colorText[] = {1,1,1,1};
		colorBackground[] = {0,0,0,0.7};
		onLBSelChanged = "menuaction = 5;";
	};

	class BLD_ListBoxVehicles : RscListbox
	{
		idc = 7007;
		x = 0.327211 * safezoneW + safezoneX;
		y = 0.253851 * safezoneH + safezoneY;
		w = 0.171091 * safezoneW;
		h = 0.452913 * safezoneH;
		colorBackground[] = {0,0,0,0.7};
	};

	class BLD_ListBoxCurrentVehicles : RscListbox
	{
		idc = 7008;
		x = 0.505857 * safezoneW + safezoneX;
		y = 0.208269 * safezoneH + safezoneY;
		w = 0.166699 * safezoneW;
		h = 0.498496 * safezoneH;
		colorBackground[] = {0,0,0,0.7};
	};

	class BLD_ButtonSpawnVehicle : RscShortcutButton
	{
		idc = 7009;
		text = "Spawn vehicle";
		x = 0.334531 * safezoneW + safezoneX;
		y = 0.696659 * safezoneH + safezoneY;
		w = 0.151324 * safezoneW;
		h = 0.0856439 * safezoneH;
		action = "menuaction = 1;";
	};

	class BLD_ButtonSpawnVehicleWC : RscShortcutButton
	{
		idc = 7010;
		text = "Spawn with crew";
		x = 0.335264 * safezoneW + safezoneX;
		y = 0.740939 * safezoneH + safezoneY;
		w = 0.148395 * safezoneW;
		h = 0.0830392 * safezoneH;
		action = "menuaction = 2;";
	};

	class BLD_ButtonDeleteSelectedVehicle : RscShortcutButton
	{
		idc = 7011;
		text = "Delete selected";
		x = 0.516107 * safezoneW + safezoneX;
		y = 0.697961 * safezoneH + safezoneY;
		w = 0.150591 * safezoneW;
		h = 0.0804345 * safezoneH;
		action = "menuaction = 3;";
	};

	class BLD_ButtonDeleteAllVehicles : RscShortcutButton
	{
		idc = 7012;
		text = "Delete all";
		x = 0.51684 * safezoneW + safezoneX;
		y = 0.740939 * safezoneH + safezoneY;
		w = 0.149127 * safezoneW;
		h = 0.081737 * safezoneH;
		action = "menuaction = 4;";
	};
	*/
	class BLD_BackGround : RscStructuredText
	{
		idc = 7001;
		x = 0.156249;
		y = 1.04308e-007;
		w = 0.687221;
		h = 1.00231;
		colorBackground[] = {0,0,0,0.7};
	};

	class BLD_HeaderTop : RscStructuredText
	{
		idc = 7002;
		x = 0.156249;
		y = 1.04308e-007;
		w = 0.687332;
		h = 0.0646576;
		colorBackground[] = {0,0,0,0.7};
	};

	class BLD_HeaderBottom : RscStructuredText
	{
		idc = 7003;
		x = 0.1582;
		y = 0.938988;
		w = 0.684542;
		h = 0.0609377;
		colorBackground[] = {0,0,0,0.7};
	};

	class BLD_HeaderText : RscStructuredText
	{
		idc = 7004;
		text = "Build vehicles";
		x = 0.409318;
		y = 0.00892812;
		w = 0.180915;
		h = 0.0479166;
		colorBackground[] = {0,0,0,0};
	};

	class BLD_ButtonClose : RscShortcutButton
	{
		idc = 7005;
		text = "Close";
		x = 0.668805;
		y = 0.914807;
		w = 0.172545;
		h = 0.113021;
		action = "menuaction = 6;";
	};

	class BLD_ComboFactions : RscCombo
	{
		idc = 7006;
		x = 0.166573;
		y = 0.0777528;
		w = 0.334374;
		h = 0.0479165;
		colorText[] = {1,1,1,1};
		colorBackground[] = {0,0,0,0.7};
		onLBSelChanged = "menuaction = 5;";
	};

	class BLD_ListBoxVehicles : RscListbox
	{
		idc = 7007;
		x = 0.170761;
		y = 0.148437;
		w = 0.326004;
		h = 0.646874;
		colorBackground[] = {0,0,0,0.7};
	};

	class BLD_ListBoxCurrentVehicles : RscListbox
	{
		idc = 7008;
		x = 0.51116;
		y = 0.0833344;
		w = 0.317635;
		h = 0.711978;
		colorBackground[] = {0,0,0,0.7};
	};

	class BLD_ButtonSpawnVehicle : RscShortcutButton
	{
		idc = 7009;
		text = "Spawn vehicle";
		x = 0.184709;
		y = 0.780879;
		w = 0.288339;
		h = 0.122321;
		action = "menuaction = 1;";
	};

	class BLD_ButtonSpawnVehicleWC : RscShortcutButton
	{
		idc = 7010;
		text = "Spawn with crew";
		x = 0.186106;
		y = 0.844122;
		w = 0.282758;
		h = 0.118601;
		action = "menuaction = 2;";
	};

	class BLD_ButtonDeleteSelectedVehicle : RscShortcutButton
	{
		idc = 7011;
		text = "Delete selected";
		x = 0.530691;
		y = 0.782738;
		w = 0.286942;
		h = 0.114881;
		action = "menuaction = 3;";
	};

	class BLD_ButtonDeleteAllVehicles : RscShortcutButton
	{
		idc = 7012;
		text = "Delete all";
		x = 0.532088;
		y = 0.844122;
		w = 0.284152;
		h = 0.116741;
		action = "menuaction = 4;";
	};
};

class acInfoDLG
{
	idd = 10000;
	movingEnable = 0;
	enableSimulation = 1;
	enableDisplay = 1;
	fadein   = 0;
	fadeout  = 0;
	duration = 10;
	name = "ac_info_dlg";
	controlsBackground[] = {New_BackGround};
	objects[] = {};
	controls[] = {MM_MENU1,MM_MENU2,MM_MENU3,MM_MENU4,MM_MENU5,MM_sendreport,MM_TAG,infomainmission,infosidemission,MM_BtnOk,MM_BtnOpt,MM_BtnLogs,MM_BtnCredits,MM_Label,MM_PLAYERROLE,MM_BtnObj,MM_BtnTEAMSTATUS};
	onLoad = "objNull execVM ""warcontext\dialogs\WC_fnc_menumissioninfo.sqf""; uiNamespace setVariable [""ac_INFO_DLG"", _this select 0];";

	class New_BackGround : RscPicture
	{
		style = 48;
		x = 0;
		y = 0;
		w = 1.498;
		h = 1.2;
		moving = 0;
		text = "\ca\ui\data\ui_wiz_background_ca.paa";
	};

	class MM_TAG : RscPicture
	{
		style = 48;
		x = 0.41;
		y = 0.12;
		w = 0.69;
		h = 0.73;
		colorText[] = {0.9,0.9,0.9,0.9};
		text = "pics\escapefromhell2.paa";
	};

	class infomainmission : RscText
	{
		idc = 10001;
		x = 0.410;
		y = 0.12;
		w = 0.69;
		h = 0.11;
		SizeEx = 0.040;
		style = ST_MULTI;
		lineSpacing = 0.7;
		colorText[] = {1,1,1,1};
		colorBackground[] = {0.3,0.3,0.3,0.3};
	};

	class infosidemission : RscText
	{
		idc = 10006;
		x = 0.410;
		y = 0.24;
		w = 0.69;
		h = 0.34;
		SizeEx = 0.040;
		style = ST_MULTI;
		lineSpacing = 0.7;
		colorText[] = {1,1,1,1};
		colorBackground[] = {0.3,0.3,0.3,0.3};
	};

	class MM_Label : RscText
	{
		text = $STR_ACGUI_MM_LABEL;
		x = 0.04;
		y = 0.05;
	};

	class MM_MENU1 : RscText
	{
		idc = 10005;
		x = 0.04;
		y = 0.12;
		SizeEx = 0.030;
	};

	class MM_MENU2 : RscText
	{
		idc = 10007;
		x = 0.04;
		y = 0.16;
		SizeEx = 0.030;
	};

	class MM_MENU3 : RscText
	{
		idc = 10011;
		x = 0.04;
		y = 0.20;
		SizeEx = 0.030;
	};

	class MM_MENU4 : RscText
	{
		idc = 10013;
		x = 0.04;
		y = 0.24;
		SizeEx = 0.030;
	};

	class MM_MENU5 : RscText
	{
		idc = 10012;
		x = 0.04;
		y = 0.28;
		SizeEx = 0.030;
	};

	class MM_BtnObj : New_Btn
	{
		x = 0.04;
		y = 0.32;
		w = 0.30;
		text = $STR_ACGUI_MM_BTN_Obj;
		action = "closeDialog 0; wcanim = [(wcobjective select 1), 6] spawn WC_fnc_camfocus;";
	};

	class MM_sendreport : New_Btn
	{
		x = 0.04;
		y = 0.38;
		w = 0.30;
		text = $STR_SENDREPORT;
		action = "closeDialog 0; objNull execVM ""warcontext\dialogs\WC_fnc_createmenusendreport.sqf""";
	};


	class MM_BtnOpt : New_Btn
	{
		x = 0.04;
		y = 0.44;
		w = 0.30;
		text = $STR_ACGUI_MM_BTN_Opt;
		action = "closeDialog 0; objNull execVM ""warcontext\dialogs\WC_fnc_createmenusettings.sqf""";
	};

	class MM_BtnTEAMSTATUS : New_Btn
	{
		idc = 10002;
		x = 0.04;
		y = 0.50;
		w = 0.30;
		text = $STR_ACGUI_MM_BTN_TEAMSTATUS;
		action = "closeDialog 0; [""DeleteRemovedAI"",""AllowAILeaderSelect"",""AllowAIRecruitment"",""AllowPlayerInvites""] call WC_fnc_teamstatus;";
	};

	class MM_BtnLogs : New_Btn
	{
		idc = 10003;
		x = 0.04;
		y = 0.56;
		w = 0.30;
		text = $STR_ACGUI_MM_BTN_Logs;
		action = "closeDialog 0; wcanim = objNull execVM ""warcontext\dialogs\WC_fnc_createmenureadlogs.sqf"";";
	};

	class MM_BtnCredits : New_Btn
	{
		idc = 10002;
		x = 0.04;
		y = 0.62;
		w = 0.30;
		text = $STR_ACGUI_MM_BTN_CREDITS;
		action = "closeDialog 0; wcanim = execVM ""warcontext\camera\WC_fnc_credits.sqf"";";
	};

	class MM_BtnOk : New_Btn
	{
		x = 0.87;
		y = 0.892;
		w = 0.22;
		default = true;
		text = $STR_ACGUI_MM_BTN_CLOSE;
		action = "closeDialog 0;";
	};

	class MM_PLAYERROLE : RscText
	{
		idc = 10009;
		x = 0.410;
		y = 0.64;
		w = 0.69;
		h = 0.20;
		SizeEx = 0.040;
		style = ST_MULTI;
		lineSpacing = 0.7;
		colorText[] = {1,1,1,1};
		colorBackground[] = {0.3,0.3,0.3,0.3};
	};
};

class SettingsDialog
{
	idd = 13000;
	movingEnable = 0;
	enableSimulation = 1;
	enableDisplay = 1;
	objects[] = {};
	controlsBackground[] = {New_BackGround};
	controls[] = {VM_VD_TXT,VM_VD_SDR,VM_TG_TXT,VM_TG_SDR,VM_BtnClose,VM_GAMESETTINGS,VM_TG_VAL,VM_LABEL,VM_WELMSG,MM_BtnWeapons,MM_BtnHBfix};
	onLoad = "objNull execVM ""warcontext\dialogs\WC_fnc_menusettings.sqf""";

	class New_BackGround : RscPicture
	{
		style = 48;
		x = 0;
		y = 0;
		w = 1.498;
		h = 1.2;
		text = "\ca\ui\data\ui_wiz_background_ca.paa";
	};

	class VM_VD_TXT : RscText
	{
		idc = 13001;
		text = "";
		x = 0.04;
		y = 0.25;
		sizeEx = 0.03;
	};

	class VM_VD_SDR : RscXSliderH
	{
		idc = 13002;
		x = 0.04;
		y = 0.29;
		w = 0.28;
	};

	class VM_TG_TXT : RscText
	{
		idc = 13003;
		text = "";
		x = 0.04;
		y = 0.33;
		sizeEx = 0.03;
	};

	class VM_TG_SDR : RscXSliderH
	{
		idc = 13004;
		x = 0.04;
		y = 0.37;
		w = 0.28;
	};

	class MM_BtnWeapons : New_Btn
	{
		idc = 13005;
		x = 0.04;
		y = 0.41;
		w = 0.30;
		text = $STR_ACGUI_MM_BTN_WEAPONS;
		action = "objNull call WC_fnc_exportweaponsplayer;";
	};

	class MM_BtnHBfix : New_Btn
	{
		idc = 10002;
		x = 0.04;
		y = 0.46;
		w = 0.30;
		text = $STR_ACGUI_MM_BTN_HBFIX;
		action = "objNull call WC_fnc_fixheadbug;";
	};

	class VM_BtnClose : New_Btn
	{
		x = 0.87;
		y = 0.892;
		w = 0.22;
		default = true;
		text = $STR_ACGUI_VM_BTN_CLOSE;
		action = "menuaction = 2";
	};

	//class VM_GAMESETTINGS : RscText
	//{
	//	idc = 13007;
	//	x = 0.410;
	//	y = 0.120;
	//	w = 0.69;
	//	h = 0.73;
	//	SizeEx = 0.030;
	//	style = ST_MULTI;
	//	lineSpacing = 0.7;
	//	colorText[] = {1,1,1,1};
	//	colorBackground[] = {0.3,0.3,0.3,0.3};
	//};

	class VM_GAMESETTINGS : RscListBox
	{
		idc = 13007;
		x = 0.410;
		y = 0.120;
		w = 0.69;
		h = 0.73;
	};

	class VM_TG_VAL : RscText
	{
		idc = 13008;
		text = "%";
		x = 0.25;
		y = 0.33;
		sizeEx = 0.03;
	};

	class VM_LABEL : RscText
	{
		text = $STR_ACGUI_MM_LABEL;
		x = 0.04;
		y = 0.05;
	};

	class VM_WELMSG : RscText
	{
		idc = 13009;
		x = 0.04;
		y = 0.12;
		SizeEx = 0.030;
	};
};

class RscDisplayPaperboard
{
	idd = 14000;
	movingenable = 0;
	onLoad = "ctrlSetFocus MyButtonOK;";

	class Controls
	{
		class MyBackground : RscText
		{
			idc = 14001;
			x = 0.3125 * safezoneW + safezoneX;
			y = 0.35 * safezoneH + safezoneY;
			w = 0.375 * safezoneW;
			h = 0.38 * safezoneH;
			colorBackground[] = {0,0,0,0.5};
		};

		class MyHeader : RscText
		{
			style = ST_CENTER;
			idc = 14002;
			text = "Paperboard";
			x = 0.3125 * safezoneW + safezoneX;
			y = 0.35 * safezoneH + safezoneY;
			w = 0.375 * safezoneW;
			h = 0.05 * safezoneH;
			colorBackground[] = {0,0,0,0.5};
		};

		class MyEditbox : RscEdit
		{
			idc = 14003;
			x = 0.328125 * safezoneW + safezoneX;
			y = 0.425 * safezoneH + safezoneY;
			w = 0.34375 * safezoneW;
			h = 0.15 * safezoneH;
		};

		class MyButtonOK : RscShortcutButton
		{
			onButtonClick = "if (count wcmotd > 5) then {wcmotd = wcmotd - [wcmotd select 0]}; wcmotd set [count wcmotd, ctrltext ((ctrlParent (_this select 0)) displayCtrl 14003)]; publicVariable 'wcmotd'; closeDialog 0;";
			idc = 14004;
			text = "Write Paperboard";
			x = 0.53125 * safezoneW + safezoneX;
			y = 0.575 * safezoneH + safezoneY;
			w = 0.140625 * safezoneW;
			h = 0.1 * safezoneH;
		};

		class MyButtonBack: RscShortcutButton
		{
			onButtonClick = "wcmotd = []; publicVariable 'wcmotd'; closeDialog 0;";
			idc = 14005;
			text = "Clear Paperboard";
			x = 0.328125 * safezoneW + safezoneX;
			y = 0.575 * safezoneH + safezoneY;
			w = 0.140625 * safezoneW;
			h = 0.1 * safezoneH;
		};
	};
};

class RscDisplayLogs
{
	idd = 15000;
	movingEnable = 0;
	enableSimulation = 1;
	objects[] = {};
	controlsBackground[] = {Logbackground};
	controls[] = {LogLabel,Logtext,LogClose,Logbtmanage,Logbtspectator,Logbtunlockallvehicles,Logbtlockallvehicles,Logbtbombingsupport,Logbtcancelmission};
	onLoad = "objNull execVM ""warcontext\dialogs\WC_fnc_menureadlogs.sqf"";";

	class LogLabel : RscText
	{
		idc = 15001;
		text = $STR_ACGUI_MM_LABEL;
		x = 0.04;
		y = 0.05;
	};

	class Logbackground : RscPicture
	{
		idc = 15002;
		style = 48;
		x = 0;
		y = 0;
		w = 1.498;
		h = 1.2;
		text = "\ca\ui\data\ui_wiz_background_ca.paa";
	};

	class Logtext : RscListBox
	{
		idc = 15003;
		x = 0.410;
		y = 0.120;
		w = 0.69;
		h = 0.73;
	};

	class LogClose : New_Btn
	{
		idc = 15004;
		x = 0.87;
		y = 0.892;
		w = 0.22;
		default = true;
		text = $STR_ACGUI_MM_BTN_CLOSE;
		action = "closeDialog 0;";
	};

	class Logbtmanage : New_Btn
	{
		idc = 15005;
		x = 0.04;
		y = 0.10;
		w = 0.30;
		text = "Manage team";
		action = "closeDialog 0; objNull execVM ""warcontext\dialogs\WC_fnc_createmenumanageteam.sqf"";";
	};

	class Logbtspectator : New_Btn
	{
		idc = 15006;
		x = 0.04;
		y = 0.16;
		w = 0.30;
		text = $STR_WC_MENUSPECTATOR;
		action = "closeDialog 0; objNull execVM ""extern\spect\specta.sqf""";
	};

	class Logbtunlockallvehicles : New_Btn
	{
		idc = 15007;
		x = 0.04;
		y = 0.22;
		w = 0.30;
		text = "Unlock all vehicles";
		action = "closeDialog 0; wclockall = false; ['wclockall', 'server'] call WC_fnc_publicvariable;";
	};

	class Logbtlockallvehicles : New_Btn
	{
		idc = 15008;
		x = 0.04;
		y = 0.28;
		w = 0.30;
		text = "Lock all vehicles";
		action = "closeDialog 0; wclockall = true; ['wclockall', 'server'] call WC_fnc_publicvariable;";
	};

	class Logbtbombingsupport : New_Btn
	{
		idc = 15009;
		x = 0.04;
		y = 0.34;
		w = 0.30;
		text = "Bombing support";
		action = "closeDialog 0; wcbombingrequest = true; ['wcbombingrequest', 'server'] call WC_fnc_publicvariable;";
	};

	class Logbtcancelmission : New_Btn
	{
		idc = 15010;
		x = 0.04;
		y = 0.40;
		w = 0.30;
		text = $STR_WC_MENUCANCELMISSION;
		action = "closeDialog 0; objNull execVM ""warcontext\actions\WC_fnc_docancelmission.sqf""";
	};
};

class RscDisplaySendreport
{
	idd = 16000;
	movingEnable = 0;
	enableSimulation = 1;
	objects[] = {};
	controlsBackground[] = {Sendreportbackground};
	controls[] = {SendreportLabel,Sendreportslidertext,Sendreportslider,Sendreportlist,Sendreportbttransfert,Sendreportmaintext,Sendreportclose};
	onLoad = "objNull execVM ""warcontext\dialogs\WC_fnc_menusendreport.sqf"";";

	class SendreportLabel : RscText
	{
		idc = 16001;
		text = $STR_ACGUI_MM_LABEL;
		x = 0.04;
		y = 0.05;
	};

	class Sendreportbackground : RscPicture
	{
		idc = 16002;
		style = 48;
		x = 0;
		y = 0;
		w = 1.498;
		h = 1.2;
		text = "\ca\ui\data\ui_wiz_background_ca.paa";
	};

	class Sendreportslidertext : RscText
	{
		idc = 16004;
		x = 0.55;
		y = 0.34;
		SizeEx = 0.030;
	};

	class Sendreportslider : RscXSliderH
	{
		idc = 16005;
		x = 0.55;
		y = 0.38;
		w = 0.30;
	};

	class Sendreportlist : RscCombo
	{
		idc = 16006;
		x = 0.55;
		y = 0.42;
		w = 0.30;
		SizeEx = 0.030;
	};

	class Sendreportbttransfert : New_Btn
	{
		x = 0.55;
		y = 0.46;
		w = 0.30;
		text = $STR_ACGUI_MM_BTN_TRANSFERT;
		action = "objNull call WC_fnc_transfert;";
	};

	class Sendreportmaintext : RscText
	{
		x = 0.410;
		y = 0.12;
		w = 0.69;
		h = 0.20;
		SizeEx = 0.040;
		style = ST_MULTI;
		lineSpacing = 0.7;
		text = $STR_SENDREPORTTEXT;
		colorText[] = {1,1,1,1};
		colorBackground[] = {0.3,0.3,0.3,0.3};
	};

	class Sendreportclose : New_Btn
	{
		x = 0.87;
		y = 0.892;
		w = 0.22;
		default = true;
		text = $STR_ACGUI_MM_BTN_CLOSE;
		action = "closeDialog 0;";
	};
};


class infomessage
{
	idd = 10100;
	movingEnable = 0;
	duration = 1000000000;
	fadein = 0;
	name = "infomessage";
	controlsBackground[] = {"wctext","wcteamtext"};
	onLoad = "uiNamespace setVariable ['wcdisplay', _this select 0];";
	onunLoad = "uiNamespace setVariable ['wcdisplay', objNull];";

	class wctext
	{
		idc = 10101;
		type = CT_STRUCTURED_TEXT;
		style = ST_LEFT;
		x = (SafeZoneX + 0.02);
		y = (SafeZoneY + 0.25);
		w = 0.3;
		h = 0.6;
		size = 0.018;
		colorBackground[] = {0,0,0,0};
		colortext[] = {0,0,0,0.7};
		text = "";
	};

	class wcteamtext
	{
		idc = 10103;
		type = CT_STRUCTURED_TEXT;
		style = ST_LEFT;
		x = (SafeZoneW + SafezoneX) - 0.25;
		y = (1 + ((0 + SafeZoneY) * -1) - 0.14);
		w = 0.25;
		h = 0.14;
		size = 0.02;
		colorBackground[] = {0,0,0,0};
		colortext[] = {0,0,0,0.7};
		text = "";
	};
};