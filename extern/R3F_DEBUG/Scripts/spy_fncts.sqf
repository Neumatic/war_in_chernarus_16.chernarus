/*******************************************************************************************
 Copyright (C) 2010 Team ~R3F~

 This program is free software under the terms of the GNU General Public License version 3.
 You should have received a copy of the GNU General Public License
 along with this program.  If not, see <http://www.gnu.org/licenses/>.

@authors team-r3f.org
@version 0.01
@date 20100909
********************************************************************************************/

#include "r3f_debug_command_panel_includes.h"
#include "constants_R3F_DEBUG.sqf";

private ["_action", "_dlg", "_edit", "_list", "_btn_del", "_var_name", "_index"];

_action = _this select 0;

disableSerialization;

[] call FNCT_R3F_DEBUG_Resize_list;

_dlg = uiNamespace getVariable "R3F_SPY_DLG";
_edit = _dlg displayCtrl R3F_DEBUG_ID_SPY_EDIT;
_list = _dlg displayCtrl R3F_DEBUG_ID_SPY_LIST;
_btn_del = _dlg displayCtrl R3F_DEBUG_ID_SPY_BTNDEL;

switch (_action) do {
	case "do_init": {
		ctrlSetFocus _edit;
		_btn_del ctrlEnable false;
		[] call FNCT_R3F_DEBUG_Fill_Spy_List;
		[] call FNCT_R3F_DEBUG_Resize_list;
	};

	case "do_add": {
		ctrlSetFocus _edit;
		_var_name = ctrlText _edit;
		if (_var_name != "") then {
			[_var_name] call FNCT_R3F_DEBUG_Spy_Add;
			[] call FNCT_R3F_DEBUG_Fill_Spy_List;
			[] call FNCT_R3F_DEBUG_Resize_list;
		};
		_btn_del ctrlEnable false;
	};

	case "do_del": {
		ctrlSetFocus _edit;
		_index = lbCurSel _list;
		_var_name = _list lbText _index;
		[_var_name] call FNCT_R3F_DEBUG_Spy_Del;
		_edit ctrlSetText "";
		_btn_del ctrlEnable false;
		[] call FNCT_R3F_DEBUG_Fill_Spy_List;
		[] call FNCT_R3F_DEBUG_Resize_list;
	};

	case "do_select": {
		ctrlSetFocus _edit;
		_index = lbCurSel _list;
		_var_name = _list lbText _index;
		_edit ctrlSetText _var_name;
		_btn_del ctrlEnable true;
	};

	case "do_close": {
		closeDialog 0;
	};
};
