/*******************************************************************************************
 Copyright (C) 2010 Team ~R3F~

 This program is free software under the terms of the GNU General Public License version 3.
 You should have received a copy of the GNU General Public License
 along with this program.  If not, see <http://www.gnu.org/licenses/>.

@authors team-r3f.org
@version 0.01
@date 20100422

@function void FNCT_R3F_DEBUG_KillThemAll
@param1 (array) Position
@param2 (int) Rayon
@return void
********************************************************************************************/

#include "constants_R3F_DEBUG.sqf";

FNCT_R3F_DEBUG_KillThemAll = {
	private ["_pos", "_rayon", "_arr_unit", "_side"];
	if (count _this == 1) then {
		_pos = _this select 0;
	} else {
		_pos = getPos player;
	};
	if (count _this == 2) then {
		_rayon = _this select 1;
	} else {
		_rayon = CONST_R3F_DEBUG_DEFAULT_RADIUS;
	};
	_arr_unit = nearestObjects [_pos, ["Man","Land","Air"], _rayon];
	{
		_side = side _x;
		if ((playerSide != _side) && {(_side != civilian)}) then {
			{
				(vehicle _x) setDamage 1;
				_x setDamage 1;
			} forEach units _x;
			(vehicle _x) setDamage 1;
			_x setDamage 1;
		};
	} forEach _arr_unit;
};
