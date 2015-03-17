/*
	Author: Neumatic
	Description: Compiles a file using parameters.

	Parameter(s):
		0: [String] Path to the file.

	Example(s):
		["path/to/file.sqf"] call WC_fnc_compile;

	Optional parameter(s):
		0: [String] Name of function.
		1: [String] Path to the file.

	Example(s):
		["fnc_name", "path/to/file.sqf"] call WC_fnc_compile;

	Optional parameter(s):
		0: [Array] Parameters for script.
		1: [String] Path to the file.

	Example(s):
		[[_param_0, _param_1], "path/to/file.sqf"] call WC_fnc_compile;

	Returns:
		nil
*/

private ["_compile_params", "_compile_type", "_compile_path", "_compile_func", "_compile_code"];

_compile_params = objNull;

switch (count _this) do {
	case 1: {
		_compile_type = "CALL_COMPILE";
		_compile_path = _this select 0;
	};

	case 2: {
		_compile_path = _this select 1;

		switch (typeName (_this select 0)) do {
			case "STRING": {
				_compile_type = "FUNC_COMPILE";
				_compile_func = _this select 0;
			};

			case "ARRAY": {
				_compile_type = "CALL_COMPILE";
				_compile_params = _this select 0;
			};
		};
	};
};

_compile_code = compile preprocessFileLineNumbers _compile_path;

switch (_compile_type) do {
	case "CALL_COMPILE": {
		_compile_params call _compile_code;
	};

	case "FUNC_COMPILE": {
		missionNamespace setVariable [_compile_func, _compile_code];
	};
};

nil
