// -----------------------------------------------
// Author:     code34 nicolas_boiteux@yahoo.fr
// Edited by:  Neumatic
// Warcontext: A part is modified code from WINSE - Valhalla mission
// -----------------------------------------------

private ["_text", "_vehicle", "_name", "_key", "_ctrl", "_ctrl_2", "_team_promote"];

disableSerialization;
uiNamespace setVariable ["wcdisplay", objNull];

while {true} do {
	if (isNull (uiNamespace getVariable "wcdisplay")) then {10199 cutRsc ["infomessage", "PLAIN"]};
	if (vehicle player != player) then {
		_text = "";
		_vehicle = vehicle player;
		_name = [_vehicle] call WC_fnc_getDisplayName;
		_text = _text + format ["<t size='1.35' shadow='true' color='#AAAAFF'>%1</t><br/>", _name];
		{
			_name = name _x;
			if ((format ["%1", _name] != "") && {(format ["%1", _name] != "Error: No unit")}) then {
				switch (_x) do {
					case (commander _vehicle): {
						_text = _text + format ["<t size='1.5'><img image='pics\i_commander_ca.paa'></t> <t size='1.35' shadow='true' color='#AAAAFF'>%1</t><br/>", _name];
					};

					case (gunner _vehicle): {
						_text = _text + format ["<t size='1.5'><img image='pics\i_gunner_ca.paa'></t> <t size='1.35' shadow='true' color='#FF8888'>%1</t><br/>", _name];
					};

					case (driver _vehicle): {
						_text = _text + format ["<t size='1.5'><img image='pics\i_driver_ca.paa'></t> <t size='1.35' shadow='true' color='#88FF88'>%1</t><br/>", _name];
					};

					default {
						if (((assignedVehicleRole _x) select 0) != "Turret") then {
							_text = _text + format ["<t size='1.5'><img image='pics\i_cargo_ca.paa'></t> <t size='1.35' shadow='true' color='#EEEEEE'>%1</t><br/>", _name];
						} else {
							_text = _text + format ["<t size='1.5'><img image='pics\i_gunner_ca.paa'></t> <t size='1.35' shadow='true' color='#FF8888'>%1</t><br/>", _name];
						};
					};
				};
			};
			sleep 0.05;
		} forEach crew _vehicle;
	} else {
		if (wcrankchanged || wcrankactivate) then {
			if (format ["%1", wcanim] == "") then {
				_text = "<t size='1.35' shadow='true' color='#EEEEEE'>Team Rank [""TAB""]<br/></t>";
				{
					_name = name _x;
					if ((format ["%1", _name] != "") && {(format ["%1", _name] != "Error: No unit")}) then {
						switch (rank _x) do {
							case "PRIVATE": {
								_text = _text + format ["<t size='1.5'><img image='\CA\warfare2\Images\rank_private.paa'></t> <t size='1.35' shadow='true' color='#EEEEEE'>%1</t><br/>", _name];
							};

							case "CORPORAL": {
								_text = _text + format ["<t size='1.5'><img image='\CA\warfare2\Images\rank_corporal.paa'></t> <t size='1.35' shadow='true' color='#EEEEEE'>%1</t><br/>", _name];
							};

							case "SERGEANT": {
								_text = _text + format ["<t size='1.5'><img image='\CA\warfare2\Images\rank_sergeant.paa'></t> <t size='1.35' shadow='true' color='#EEEEEE'>%1</t><br/>", _name];
							};

							case "LIEUTENANT": {
								_text = _text + format ["<t size='1.5'><img image='\CA\warfare2\Images\rank_lieutenant.paa'></t> <t size='1.35' shadow='true' color='#EEEEEE'>%1</t><br/>", _name];
							};

							case "CAPTAIN": {
								_text = _text + format ["<t size='1.5'><img image='\CA\warfare2\Images\rank_captain.paa'></t> <t size='1.35' shadow='true' color='#EEEEEE'>%1</t><br/>", _name];
							};

							case "MAJOR": {
								_text = _text + format ["<t size='1.5'><img image='\CA\warfare2\Images\rank_major.paa'></t> <t size='1.35' shadow='true' color='#EEEEEE'>%1</t><br/>", _name];
							};

							case "COLONEL": {
								_text = _text + format ["<t size='1.5'><img image='\CA\warfare2\Images\rank_colonel.paa'></t> <t size='1.35' shadow='true' color='#EEEEEE'>%1</t><br/>", _name];
							};
						};
					};
					sleep 0.05;
				} forEach playableUnits;
				wcrankchanged = false;
			} else {
				_key = format ["%1", actionKeysNames ["CancelAction", 2]];
				if (_key == "") then {
					_text = "<t size='1.5'>Press [""TAB""] to pass Video</t><br/><t size='1.5'>Press [""Cancel Action""] to change Music</t>";
				} else {
					_text = format ["<t size='1.5'>Press [""TAB""] to pass Video</t><br/><t size='1.5'>Press [%1] to change Music</t>", _key];
				};
			};
		} else {
			_text = "";
		};
	};

	_ctrl = (uiNamespace getVariable "wcdisplay") displayCtrl 10101;
	_ctrl ctrlSetStructuredText (parseText _text);

	_text = "";
	_ctrl_2 = (uiNamespace getVariable "wcdisplay") displayCtrl 10103;

	_text = _text + format ["Day %1 %2<br/>", wcday];
	if (wcradioalive) then {
		switch (true) do {
			case (wcalert > 99): {
				wcalert = 100;
				_text = _text + format ["<t color='#CC0000'>Detection: %1</t><br/>", format ["%1", wcalert] + "%"];
			};

			case (wcalert > 66): {
				_text = _text + format ["<t color='#FF6619'>Detection: %1</t><br/>", format ["%1", wcalert] + "%"];
			};

			case (wcalert > 33): {
				_text = _text + format ["<t color='#FFFF00'>Detection: %1</t><br/>", format ["%1", wcalert] + "%"];
			};

			default {
				_text = _text + format ["<t color='#33CC00'>Detection: %1</t><br/>", format ["%1", wcalert] + "%"];
			};
		};
	} else {
		_text = _text + "Detection: No more radio<br/>";
	};

	if (([currentMagazine player] call WC_fnc_getDisplayNameShort) == "SD") then {
		_text = _text + "Mode: Stealth<br/>";
	} else {
		_text = _text + "Mode: Combat<br/>"
	};

	_text = _text + format ["<t size='0.8'><img image='\CA\warfare2\Images\rank_%1.paa'></t> <t size='1' shadow='true' color='#EEEEEE'>%1</t><br/>", rank player];

	if (wckindofserver != 3) then {
		if (name player in wcinteam) then {
			_team_promote = localize format ["STR_WC_TEAM%1", wcteamlevel];
		} else {
			_team_promote = localize "STR_WC_TEAM0";
		};
		_text = _text + format ["<t size='1.35'>%1 - L%2</t><br/>", _team_promote, wclevel];
		if (wcteamplayscore > 10) then {
			_text = _text + format ["<t color='#CC0000'>%2: %1</t><br/>", wcteamplayscore, localize "STR_WC_INFOPOINTSTOSHARE"];
		} else {
			_text = _text + format ["%2: %1<br/>", wcteamplayscore, localize "STR_WC_INFOPOINTSTOSHARE"];
		};
	} else {
		_text = _text + format ["No team - Level: %1<br/>", wclevel];
	};

	_ctrl_2 ctrlSetStructuredText (parseText _text);
	_ctrl ctrlCommit 0;
	_ctrl_2 ctrlCommit 0;

	sleep 1;
};
