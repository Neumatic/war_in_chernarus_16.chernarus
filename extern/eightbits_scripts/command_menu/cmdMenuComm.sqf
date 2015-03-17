private ["_command", "_friendlyGroups", "_allGroups", "_choosedGroup", "_selectedUnits", "_vehicle", "_unitsInCargo", "_failedJumpers"];

_command = _this select 0;

switch (_command) do
{
	case 'SendUnits':
	{
		_friendlyGroups = [];
		_allGroups = allGroups;
		{
			if (side _x == side player) then
			{
				_friendlyGroups = _friendlyGroups + [_x];
			};
		} forEach _allGroups;
		if (count _friendlyGroups > 0) then
		{
			_choosedGroup = [_friendlyGroups] call BIS_FNC_CMDMENUCOMM_TEAMSELECT;
			_selectedUnits = BIS_WF_GROUPSELECTEDUNITS;
			// Remove the selected units from the sending player's assigned team. eg. soldier1 is part of team red, so we unassign his team.
			{
				unassignTeam _x;
			} forEach _selectedUnits;
			_selectedUnits join _choosedGroup;
		};
	};

	case 'DismissSelected':
	{
		{
			if (!isPlayer _x && {vehicle _x == _x}) then
			{
				_x removeAllEventHandlers "Killed";
				_x setPos [0,0,0];
				_x setDamage 1;
				deleteVehicle _x;
			};
		} forEach BIS_SQL_SelectedUnits;
	};

	case 'Paradrop':
	{
		_vehicle = vehicle player;
		if (_vehicle isKindOf "Air") then
		{
			_unitsInCargo = assignedCargo _vehicle;
			{
				_x action ["Eject", _vehicle];
				unassignVehicle _x;
				sleep 0.6;
			} forEach _unitsInCargo;
		}
		else
		{
			hint "Must be in air vehicle";
		};
	};

	case 'ParadropSelection':
	{
		_failedJumpers = [];
		{
			_vehicle = vehicle _x;
			if ((driver _vehicle != _x) && {(_vehicle isKindOf "Air")}) then
			{
				_x action ["Eject", _vehicle];
				unassignVehicle _x;
				sleep 0.6;
			}
			else
			{
				_failedJumpers = _failedJumpers + [_x];
			};
		} forEach BIS_WF_GROUPSELECTEDUNITS;

		if (count _failedJumpers > 0) then
		{
			player sideChat (str _failedJumpers) + " failed to paradrop";
		};
	};

	case 'Halo':
	{
		_vehicle = vehicle player;
		if (_vehicle isKindOf "air") then
		{
			_unitsInCargo = assignedCargo _vehicle;
			{
				_x action ["Eject", _vehicle];
				unassignVehicle _x;
				_x spawn BIS_fnc_halo;
				_x setVelocity [0,120 * 0.8,0];
				_x setDir 0;
				sleep 0.6;
			} forEach _unitsInCargo;
		}
		else
		{
			hint "Must be in air vehicle";
		};
	};

	case 'HaloSelection':
	{
		_failedJumpers = [];
		{
			_vehicle = vehicle _x;
			if ((driver _vehicle != _x) && {(_vehicle isKindOf "Air")}) then
			{
				_x action ["Eject", _vehicle];
				unassignVehicle _x;
				_x spawn BIS_fnc_halo;
				_x setVelocity [0,120 * 0.8,0];
				_x setDir (getDir _vehicle);
				sleep 0.6;
			}
			else
			{
				_failedJumpers = _failedJumpers + [_x];
			};
		} forEach BIS_WF_GROUPSELECTEDUNITS;

		if (count _failedJumpers > 0) then
		{
			player sideChat (str _failedJumpers) + " failed to Halo";
		};
	};

	default {};
};
/*
	Handles request for Join to other squad
	by Vilem
*/
/*
private [
	"_teams","_command","_leader","_choosedGroup","_friendlygroups","_allgroups","_selectedUnits","_amount","_unitsincargo","_vehicle","_failedjumpers",
	"_newGroup","_menInVehicles","_menNotInVehicles","_nic","_receiverID","_base","_funds"
];

_command = _this select 0;

switch (_command) do
{
	case 'Join':
	{
		_teams = [];
		if !(isNil "BIS_WF_Client") then {_teams = Call Compile format["%1Teams",sideJoinedText];}; // TODO: second branch - not using WF - rework to receveive teams as param?
		_choosedGroup = [_teams] call BIS_FNC_CMDMENUCOMM_TEAMSELECT;
		_leader = leader _choosedGroup;
	};

	case 'SendUnits':
	{
		_allgroups = allgroups;
		_friendlygroups = [];

		{
			if ((side _x) == (side player)) then
			{
				_friendlygroups = _friendlygroups + [_x];
			};
		} forEach _allgroups;
		_teams = [];
		if (1 == 1) then {_teams = _friendlygroups};  // TODO: second branch - not using WF - rework to receveive teams as param?
		_choosedGroup = [_teams] call BIS_FNC_CMDMENUCOMM_TEAMSELECT;

		_selectedUnits = BIS_WF_GROUPSELECTEDUNITS;
		// Remove the selected units from the sending player's assigned team. eg. soldier1 is part of team red, so we unassign his team.
		{
			unassignTeam _x;
		} forEach _selectedUnits;
		_selectedUnits join _choosedGroup;
	};

	case 'SendMoney':
	{
		if (isNil {BIS_WF_GetPlayerFunds}) exitWith {};

		// Warfare specific (teams, player funds change functions, print function)
		_amount = floor (([] call BIS_WF_GetPlayerFunds) /2);
		if !(isNil "BIS_WF_Client") then {_teams = Call Compile format["%1Teams",sideJoinedText];}; // TODO: second branch - not using WF - rework to receveive teams as param?
		_choosedGroup = [_teams] call BIS_FNC_CMDMENUCOMM_TEAMSELECT;

		//[MSG,(format [localize "strwftransferamountto", _amount] + " " + localize format ["str_short_%1",rank Leader _choosedGroup]  + " " + Name Leader _choosedGroup)] call CLTFNCSideMessage;
		//player globalChat format [localize "strwftransferamountto", _amount] + " " + localize format ["str_short_%1",rank Leader _choosedGroup]  + " " + Name Leader _choosedGroup;

		((format [localize "strwftransferamountto", _amount]) + " " + (localize format ["str_short_%1",rank Leader _choosedGroup])  + " " + Name Leader _choosedGroup) Call BIS_WF_GroupChatMessage;

		_receiverID = _choosedGroup call BIS_WF_GetTeamID;

		if (isPlayer (leader _choosedGroup)) then
		{
			if (clientID != _receiverID) then
			{
				-_amount call BIS_WF_ChangePlayerFunds;
				[_amount, sideJoined, _receiverID] call ChangeClientFunds;
			};
		}
		else
		{
			// Change AI funds
			[_amount, sideJoined,_receiverID] call ChangeAIFunds;
			-_amount call BIS_WF_ChangePlayerFunds;
		};
	};

	case 'Dismiss': {_leader = (leader group player);};

	case 'DismissSelected':
	{
		{
			if (_x != player) then
			{
				_x removeAllEventHandlers "Killed";
				_x setPos [0,0,0];
				_x setDamage 1;
				deleteVehicle _x;
			};
		} forEach BIS_SQL_SelectedUnits;
	};

	case 'HCRespawnSelected':
	{ // HC - respawn teams, _x is group here
		{
			_base = Call Compile format["%1Base",sideJoinedText];
			_funds = [_x,_base,BIS_WF_Constants getVariable "BASERANGE"] Call BIS_WF_RefundTeam;

			// Refund money for old team.
			[_funds,sideJoined,Leader _x Call GetClientID] Call ChangeAIFunds;

			// Respawn leader if away from base (or wounded).
			_leader = Leader _x;
			if (getDammage _leader > 0.5 || _leader Distance _base > (BIS_WF_Constants getVariable "BASERANGE")) then
			{
				_leader setDamage 1;
			};
		} forEach BIS_SQL_SelectedUnits;
	};

	case 'HCAutomaticBehavior':
	{ // HC - setting WF autonomous mode - BIS
		{
			// TODO: remove WPs?
			if (_x getVariable "BIS_HC_disableAutonomousAI") then {_x setVariable ["BIS_HC_disableAutonomousAI", false, true]};

			// Remove all WPs
			while {(count (waypoints _x) > 0)} do
			{
				deleteWaypoint [_x,0];
			};
		} forEach BIS_SQL_SelectedUnits;
	};

	case 'HCTeamType':
	{ // HC - setting AI team type.
		showCommandingMenu '#USER:HC_Custom_0';
		{
		} forEach BIS_SQL_SelectedUnits;
	};

	case 'Paradrop':
	{
		_vehicle = vehicle player;
		if (_vehicle isKindOf "Air") then
		{
			_unitsincargo = assignedCargo _vehicle;
			hint str _unitsincargo;
			{
				_x action ["Eject", _vehicle];
				unassignVehicle _x;
				sleep 0.6;
			} forEach _unitsincargo;
		}
		else
		{
			hint "Must be in air vehicle";
		};
	};

	case 'ParadropSelection':
	{
		_failedjumpers = [];
		{
			_vehicle = vehicle _x;
			if (((driver _vehicle) != _x) && (_vehicle isKindOf "Air")) then
			{
				_x action ["Eject", _vehicle];
				unassignVehicle _x;
				sleep 0.6;
			}
			else
			{
				_failedjumpers = _failedjumpers + [_x];
			};
		} forEach BIS_WF_GROUPSELECTEDUNITS;

		if ((count _failedjumpers) != 0) then
		{
			player sideChat (str _failedjumpers) + " failed to Para";
		};
	};

	case 'Halo':
	{
		_vehicle = vehicle player;
		if (_vehicle isKindOf "air") then
		{
			_unitsincargo = assignedCargo _vehicle;
			hint str _unitsincargo;
			{
				_x action ["Eject", _vehicle];
				unassignVehicle _x;
				_x spawn BIS_fnc_halo;
				_x setVelocity [0,120 * 0.8,0];
				_x setDir 0;
				sleep 0.6;
			} forEach _unitsincargo;
		}
		else
		{
			hint "Must be in air vehicle";
		};
	};

	case 'HaloSelection':
	{
		_failedjumpers = [];
		{
			_vehicle = vehicle _x;
			if (((driver _vehicle) != _x) && (_vehicle isKindOf "Air")) then
			{
				_x action ["Eject", _vehicle];
				unassignVehicle _x;
				_x spawn BIS_fnc_halo;
				_x setVelocity [0,120 * 0.8,0];
				_x setDir 0;
				sleep 0.6;
			}
			else
			{
				_failedjumpers = _failedjumpers + [_x];
			};
		} forEach BIS_WF_GROUPSELECTEDUNITS;

		if ((count _failedjumpers) != 0) then
		{
			player sideChat (str _failedjumpers) + " failed to Halo";
		};
	};

	case 'CreatGroupSelection':
	{
		_newGroup = createGroup (side player);

		_selectedUnits = BIS_WF_GROUPSELECTEDUNITS;
		// Remove the selected units from the sending player's assigned team. eg. soldier1 is part of team red, so we unassign his team.
		{
			unassignTeam _x;
		} forEach _selectedUnits;
		BIS_WF_GROUPSELECTEDUNITS join _newGroup;

		(units _newGroup) allowGetIn false;
		player hcSetGroup [_newGroup];
	};

	case 'CreatGroupSelectionMixed':
	{
		_newGroup = createGroup (side player);
		_menInVehicles = [];
		_menNotInVehicles = [];
		BIS_WF_GROUPSELECTEDUNITS join _newGroup;


		{
			if ((vehicle _x) != _x) then
			{
				player globalChat "In veh";
				_menInVehicles = _menInVehicles + [_x];
				_newGroup addVehicle (vehicle _x);
			}
			else
			{
				player globalChat "Not in veh";
				_menNotInVehicles = _menNotInVehicles + [_x];
			}
		} forEach (units _newGroup);

		//(_menNotInVehicles) allowGetIn false;

		//player globalchat str _menNotInVehicles;
		//player globalchat str _menInVehicles;
		//player globalchat str (assignedVehicle _newGroup);
		player hcSetGroup [_newGroup];
	};

	case 'DismissHcGroup':
	{
		{
			{
				_x removeAllEventHandlers "Killed";
				_x setPos [0,0,0];
				_x setDamage 1;
				deleteVehicle _x
			} forEach units _x;

			deleteGroup _x;
		} forEach BIS_WF_GROUPSELECTEDUNITS;

	};

	case 'absorbHcGroup':
	{
		{
			(units _x) join player;
			(units _x) allowGetIn true;
			deleteGroup _x;
		} forEach BIS_WF_GROUPSELECTEDUNITS;
	};

	case 'deleteEmptyGroup':
	{
		_allGroups = allGroups;
		_friendlyGroups = [];
		{
			if ((side _x) == (side player)) then
			{
				_friendlyGroups set [count _friendlyGroups, _x];
			}
		} forEach _allGroups;

		{
			if ((count (units _x)) < 1) then
			{
				deleteGroup _x;
			}
		} forEach _friendlyGroups;
	};

	default {};
};

//Add topics (over network) and wait for apply
if !(_leader kbHasTopic "sqlComm") then {_nic = [objNull, _leader, rKBADDTOPIC, "sqlComm", "\ca\Warfare2\Scripts\SQC\kb\sqlComm.bikb", "\ca\Warfare2\Scripts\SQC\kb\sqlComm.fsm",  {call compile preprocessFileLineNumbers "\ca\Warfare2\Scripts\SQC\kb\sqlComm.sqf"}] call RE;}; waitUntil {_leader kbhastopic "sqlComm"};
if !(player kbHasTopic "sqlComm") then {_nic = [objNull, player, rKBADDTOPIC, "sqlComm", "\ca\Warfare2\Scripts\SQC\kb\sqlComm.bikb", "\ca\Warfare2\Scripts\SQC\kb\sqlComm.fsm",  {call compile preprocessFileLineNumbers "\ca\Warfare2\Scripts\SQC\kb\sqlComm.sqf"}] call RE;}; waitUntil {player kbhastopic "sqlComm"};


switch (_command) do
{
	case 'Join': {_nic = [objNull, player, rKBTELL, _leader, "sqlComm", "RequestingPermissionToJoin"] call RE;};
	case 'Dismiss': {_nic = [objNull, player, rKBTELL, leader group player, 'sqlComm', 'RequestingPermissionToLeave'] call RE;};

	default {};
};
*/