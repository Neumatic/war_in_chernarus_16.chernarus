/**
 * Fait réapparaître un joueur en attente de réanimation à la base.
 * La position de réapparition est la même que celle qu'ArmA a
 * déterminé à l'aide du système de marqueurs "respawn_XXX".
 *
 * Copyright (C) 2010 madbull ~R3F~
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

// On ferme tout les fils d'exécution éventuels
terminate R3F_REV_fil_exec_attente_reanimation;
terminate R3F_REV_fil_exec_reapparaitre_camp;
terminate R3F_REV_fil_exec_effet_inconscient;

private ["_camp"];

_camp = _this select 0;

// Mémorisation du fil d'exécution lancé
R3F_REV_fil_exec_reapparaitre_camp = [_camp] spawn
{
	private ["_camp", "_position"];

	_camp = _this select 0;

	// Camp can be base, tent or hq
	if (_camp == "tent") then {
		if (isNil "wctent") then {
			_camp = "base";
			wcrespawnmarker setMarkerPosLocal [0,0];
			wcrespawnmarker setMarkerSizeLocal [0,0];
			wcrespawnmarker setMarkerTextLocal "";
		} else {
			if (isNull wctent || {!alive wctent}) then {
				_camp = "base";
				wcrespawnmarker setMarkerPosLocal [0,0];
				wcrespawnmarker setMarkerSizeLocal [0,0];
				wcrespawnmarker setMarkerTextLocal "";
			};
		};
	};

	if (_camp == "hq") then {
		if (format ["%1", wcteleport] == "any") then {
			_camp = "base";
		};
	};

	closeDialog 0;

	// Change the scoring based on param
	if (wcdefaultscore == 1) then {
		wcplayeraddscore = switch (rank player) do {
			case "PRIVATE": {   [player, -1]};
			case "CORPORAL": {  [player, -2]};
			case "SERGEANT": {  [player, -3]};
			case "LIEUTENANT": {[player, -4]};
			case "CAPTAIN": {   [player, -5]};
			case "MAJOR": {     [player, -7]};
			case "COLONEL": {   [player, -10]};
		};
	} else {
		wcplayeraddscore = switch (rank player) do {
			case "PRIVATE": {   [player, -1]};
			case "CORPORAL": {  [player, -1]};
			case "SERGEANT": {  [player, -1]};
			case "LIEUTENANT": {[player, -1]};
			case "CAPTAIN": {   [player, -1]};
			case "MAJOR": {     [player, -1]};
			case "COLONEL": {   [player, -1]};
		};
	};

	["wcplayeraddscore", "server"] call WC_fnc_publicvariable;

	if (R3F_REV_CFG_afficher_marqueur) then
	{
		player setVariable ["deadmarker", false, true];
	};

	// On masque ce qui se passe au joueur (joueur dans les airs + animations forcés)
	R3F_REV_effet_video_couleur ppEffectAdjust [0.25, 1, 0, [0,0,0,0], [0,0,0,0], [0,0,0,0]];
	R3F_REV_effet_video_couleur ppEffectCommit 0;

	R3F_REV_corps_avant_mort = player;

	// Isoler le corps
	player setPos [getPos player select 0, getPos player select 1, 2000];
	player setDamage 0;

	// Stop animation blessé, reprise arme debout
	player selectWeapon (primaryWeapon player);
	player playMoveNow "AmovPercMstpSlowWrflDnon";

	sleep 3;

	// Retour du corps au marqueur de réapparition
	player setVelocity [0,0,0];

	switch (_camp) do {
		case "base": {
			[localize "STR_R3F_REV_dontrespawnatbase"] call BIS_fnc_dynamicText;
			wcrespawntobase = name player;
			["wcrespawntobase", "server"] call WC_fnc_publicvariable;
			_position = [getMarkerPos "respawn_west", 0, 10, 10, player] call WC_fnc_findEmptyPosition;
			player setPosASL _position;
			R3F_REV_nb_reanimations = R3F_REV_CFG_nb_reanimations;
		};

		case "hq": {
			[localize "STR_R3F_REV_dontrespawnatbase"] call BIS_fnc_dynamicText;
			wcrespawntohq = name player;
			["wcrespawntohq", "server"] call WC_fnc_publicvariable;
			_position = [wcteleport, 10, 20, 10, player] call WC_fnc_findEmptyPosition;
			player setPosASL _position;
		};

		case "tent": {
			[localize "STR_R3F_REV_dontrespawnatbase"] call BIS_fnc_dynamicText;
			wcrespawntotent = name player;
			["wcrespawntotent", "server"] call WC_fnc_publicvariable;
			_position = [wcrespawnposition select 0, 5, 10, 0, player] call WC_fnc_findEmptyPosition;
			player setPosASL _position;
		};
	};

	player setCaptive false;

	objNull call WC_fnc_restoreactionmenu;

	if (wcwithACE == 1) then {
		if !(player hasWeapon "ACE_Earplugs") then {
			player addWeapon "ACE_Earplugs";
		};
	};

	ppEffectDestroy R3F_REV_effet_video_flou;
	ppEffectDestroy R3F_REV_effet_video_couleur;

	sleep 5;

	player allowDamage true;
};