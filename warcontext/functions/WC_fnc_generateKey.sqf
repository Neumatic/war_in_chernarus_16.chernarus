/*
	Author: Neumatic
	Description: Generate random key.

	Parameter(s):
		0: [String/Side] Header string for key.

	Example(s):
		_key = [west] call WC_fnc_generateKey;
		-> _key = "west_0A4IZP6Q"

	Returns:
		String
*/

#define KEY_LENGHT 8
#define KEY_CHARACTERS ["0","1","2","3","4","5","6","7","8","9","A","B","C","D",\
	"E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W",\
	"X","Y","Z"]

private ["_param", "_key", "_ran", "_sel"];

_param = _this select 0;

switch (typeName _param) do {
	case (typeName ""): {};

	case (typeName objNull): {
		_param = str ([_param] call WC_fnc_getSide);
	};

	case (typeName west): {
		_param = str _param;
	};

	default {
		_param = "WIC";
	};
};

_key = "";
_key = _key + _param + "_";

for "_i" from 1 to KEY_LENGHT do {
	_ran = floor (random count KEY_CHARACTERS);
	_sel = KEY_CHARACTERS select _ran;
	_key = _key + _sel;
};

_key
