if (isNil "BIS_MENU_GroupCommunication") then
{
	[] call BIS_fnc_commsMenuCreate;
};

BIS_MENU_GroupCommunication set [count BIS_MENU_GroupCommunication,["Sling Menu",[2],"#USER:SLING_MENU",-5,[["expression",""]],"1","1"]];
BIS_MENU_GroupCommunication set [count BIS_MENU_GroupCommunication,["Send units (%SELECTED_UNIT_ID)",[3],"",-5,[["expression","showCommandingMenu ''; BIS_WF_GROUPSELECTEDUNITS = groupSelectedUnits player;['SendUnits'] execVM BIS_FNC_CMDMENUCOMM; "]],"1","1"]];
BIS_MENU_GroupCommunication set [count BIS_MENU_GroupCommunication,["",[],"",-1,[],"0","0"]];
BIS_MENU_GroupCommunication set [count BIS_MENU_GroupCommunication,["Paradrop Cargo",[4],"",-5,[["expression","showCommandingMenu ''; BIS_WF_GROUPSELECTEDUNITS = groupSelectedUnits player; ['Paradrop'] execVM BIS_FNC_CMDMENUCOMM; "]],"1","1"]];
BIS_MENU_GroupCommunication set [count BIS_MENU_GroupCommunication,["Halo Cargo",[5],"",-5,[["expression","showCommandingMenu ''; BIS_WF_GROUPSELECTEDUNITS = groupSelectedUnits player; ['Halo'] execVM BIS_FNC_CMDMENUCOMM; "]],"1","1"]];
BIS_MENU_GroupCommunication set [count BIS_MENU_GroupCommunication,["",[],"",-1,[],"0","0"]];
BIS_MENU_GroupCommunication set [count BIS_MENU_GroupCommunication,["Paradrop Selection (%SELECTED_UNIT_ID)",[6],"",-5,[["expression","showCommandingMenu ''; BIS_WF_GROUPSELECTEDUNITS = groupSelectedUnits player; ['ParadropSelection'] execVM BIS_FNC_CMDMENUCOMM; "]],"1","1"]];
BIS_MENU_GroupCommunication set [count BIS_MENU_GroupCommunication,["Halo Selection (%SELECTED_UNIT_ID)",[7],"",-5,[["expression","showCommandingMenu ''; BIS_WF_GROUPSELECTEDUNITS = groupSelectedUnits player; ['HaloSelection'] execVM BIS_FNC_CMDMENUCOMM; "]],"1","1"]];
BIS_MENU_GroupCommunication set [count BIS_MENU_GroupCommunication,["",[],"",-1,[],"0","0"]];
BIS_MENU_GroupCommunication set [count BIS_MENU_GroupCommunication,["Disband selected (%SELECTED_UNIT_ID)",[8],"",-5,[["expression","BIS_SQL_SelectedUnits = groupSelectedUnits player; showCommandingMenu ''; ['DismissSelected'] execVM BIS_FNC_CMDMENUCOMM; "]],"1","1"]];
//BIS_MENU_GroupCommunication set [count BIS_MENU_GroupCommunication,["",[],"",-1,[],"0","0"]];
//BIS_MENU_GroupCommunication set [count BIS_MENU_GroupCommunication,["High Command Menu",[9],"#USER:HIGH_COMMAND_MENU",-5,[["expression",""]],"1","1"]];
//BIS_MENU_GroupCommunication set [count BIS_MENU_GroupCommunication,["",[],"",-1,[],"0","0"]];

HIGH_COMMAND_MENU =
[
	["High Command Menu",false],
	["Create Group (%SELECTED_UNIT_ID)",[2],"",-5,[["expression","showCommandingMenu ''; BIS_WF_GROUPSELECTEDUNITS = groupSelectedUnits player;['CreatGroupSelection'] execVM BIS_FNC_CMDMENUCOMM; "]],"1","1"],
	["Create Group (experimental) (%SELECTED_UNIT_ID)",[3],"",-5,[["expression","showCommandingMenu ''; BIS_WF_GROUPSELECTEDUNITS = groupSelectedUnits player;['CreatGroupSelectionMixed'] execVM BIS_FNC_CMDMENUCOMM; "]],"1","1"],
	["Absord HC Group (%SELECTED_UNIT_ID)",[4],"",-5,[["expression","showCommandingMenu ''; BIS_WF_GROUPSELECTEDUNITS = hcSelected player;['absorbHcGroup'] execVM BIS_FNC_CMDMENUCOMM; "]],"1","1"],
	["Disband HC Group (%SELECTED_UNIT_ID)",[5],"",-5,[["expression","showCommandingMenu ''; BIS_WF_GROUPSELECTEDUNITS = hcSelected player;['DismissHcGroup'] execVM BIS_FNC_CMDMENUCOMM; "]],"1","1"],
	["Delete Empty Group (%SELECTED_UNIT_ID)",[6],"",-5,[["expression","showCommandingMenu ''; BIS_WF_GROUPSELECTEDUNITS = hcSelected player;['deleteEmptyGroup'] execVM BIS_FNC_CMDMENUCOMM; "]],"1","1"]
];

SLING_MENU =
[
	["Sling Menu",false],
	["Sling Load Attach",[2],"",-5,[["expression", "execVM 'extern\heli_extras\helicopter\heli_scripts\heli_options\heli_AI_attach_cargo.sqf'"]],"1","1"],
	["Sling Load Detach",[3],"",-5,[["expression",  "execVM 'extern\heli_extras\helicopter\heli_scripts\heli_options\heli_AI_detach_cargo.sqf'"]],"1","1"]
];