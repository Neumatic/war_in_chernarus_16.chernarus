/****************************************************************************
 Copyright (C) 2010 Team ~R3F~

 This program is free software under the terms of the GNU General Public License version 3.
 You should have received a copy of the GNU General Public License
 along with this program.  If not, see <http://www.gnu.org/licenses/>.

@authors team-r3f.org
@version 0.01
@date 20101003
*****************************************************************************/
/*-----------------------------------------------------------------------------
Description :
Set Skill of IA

Call by :
[skill] call R3F_DEBUG_fnc_SetSkill;
skill : 1=easy, 2=normal, 3=hard
------------------------------------------------------------------------------*/
/*-----------------------------------------------------------------------------
Description :
Régler le niveau des IA

Appel par :
[skill] call R3F_DEBUG_fnc_SetSkill;
skill : 1=facile, 2=normal, 3=difficile
------------------------------------------------------------------------------*/

#include "constants_R3F_DEBUG.sqf";

R3F_DEBUG_fnc_SetSkill = {
	private ["_skill"];
	_skill = _this select 0;
	VAR_R3F_DEBUG_OptionValueIndices set [1, _skill];
	switch (_skill) do {
		case 1: {VAR_R3F_DEBUG_Skill = CONST_R3F_DEBUG_SKILL_POOR};
		case 2: {VAR_R3F_DEBUG_Skill = CONST_R3F_DEBUG_SKILL_NORMAL};
		default {VAR_R3F_DEBUG_Skill = CONST_R3F_DEBUG_SKILL_GOOD};
	};
	true
};
