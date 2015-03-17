// -----------------------------------------------
// Author:     code34 nicolas_boiteux@yahoo.fr
// Edited by:  Neumatic
// Warcontext: Public variable event handler
// -----------------------------------------------

#define QUOTE(var) #var
#define PUBLIC_VARIABLE wc_pv

WC_fnc_publicvariable = {
	private ["_event", "_target", "_uid", "_params"];

	_event  = _this select 0;
	_target = _this select 1;
	_uid    = if (count _this > 2) then {_this select 2};

	_params = missionNamespace getVariable [_event, []];
	PUBLIC_VARIABLE = [_event, _target, _params];

	switch (toUpper _target) do {
		case "CLIENT": {
			if (!isNil "_uid") then {
				if (WC_isServer) then {
					_uid publicVariableClient QUOTE(PUBLIC_VARIABLE);
				} else {
					if (owner player == _uid) then {
						PUBLIC_VARIABLE spawn WC_fnc_publicVariableExec;
					} else {
						PUBLIC_VARIABLE = ["wcclientforward", "server", [_event, _target, _uid, _params]];
						publicVariableServer QUOTE(PUBLIC_VARIABLE);
					};
				};
			} else {
				if (WC_isClient) then {
					PUBLIC_VARIABLE spawn WC_fnc_publicVariableExec;
				};

				publicVariable QUOTE(PUBLIC_VARIABLE);
			};
		};

		case "SERVER": {
			if (WC_isServer) then {
				PUBLIC_VARIABLE spawn WC_fnc_publicVariableExec;
			} else {
				publicVariableServer QUOTE(PUBLIC_VARIABLE);
			};
		};
	};

	nil
};

WC_fnc_publicVariableExec = {
	private ["_event", "_target", "_params", "_exec", "_func"];

	_event  = _this select 0;
	_target = _this select 1;
	_params = _this select 2;

	switch (toUpper _target) do {
		case "CLIENT": {
			if (WC_isClient) then {
				_func = missionNamespace getVariable format ["WC_fnc_netcode_%1", _event];
				_exec = true;
			} else {
				_exec = false;
			};
		};

		case "SERVER": {
			if (WC_isServer) then {
				_func = missionNamespace getVariable format ["WC_fnc_netcode_server_%1", _event];
				_exec = true;
			} else {
				_exec = false;
			};
		};
	};

	if (_exec) then {
		if (!isNil "_func") then {
			if (typeName _params != "ARRAY") then {
				_params = [_this select 2];
			};

			_params spawn _func;
		} else {
			["ERROR", "WC_fnc_publicVariableExec", format ["_event=%1 : _target=%2 : _params=%3 : _func=%4", _event, _target, _params, !isNil "_func"]] call WC_fnc_log;
		};
	};

	_exec
};

QUOTE(PUBLIC_VARIABLE) addPublicVariableEventHandler {
	(_this select 1) spawn WC_fnc_publicVariableExec;
};

nil
