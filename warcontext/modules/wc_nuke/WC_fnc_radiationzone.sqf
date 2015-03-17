// --------------------------------------------------------
// Author:     code34 nicolas_boiteux@yahoo.fr
// Edited by:  Neumatic
// Warcontext: Create a radiation zone that damage objects during time
// --------------------------------------------------------

private ["_array"];

while {true} do {
	if (count wcnuclearzone > 0) then {
		{
			_array = _x nearEntities [["Man","LandVehicle"], 500];
			if (count _array > 0) then {
				{
					if (_x isKindOf "Man") then {
						if (!isPlayer _x && {side _x == civilian}) then {
							_x setDamage (damage _x + 0.01);
						} else {
							_x setDamage (damage _x + 0.001);
						};
					} else {
						{
							_x setDamage  (damage _x + 0.001);
						} forEach crew _x;
					};
				} forEach _array;
				sleep 0.1;
			};
		} forEach wcnuclearzone;
		sleep 1;
	} else {
		sleep 60;
	};
};
