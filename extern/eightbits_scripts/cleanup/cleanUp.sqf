private ["_objects", "_count"];

_count = 0;
_objects = nearestObjects [wcmapcenter, ["man", "landvehicle", "air", "weaponholder", "ACE_UsedTubes", "ACE_Rucksack_crate", "ACE_BAG", "ACE_T72WreckTurret", "ACE_K36"], 20000];

{
	if ((!alive _x) && ((_x isKindOf "man") || (_x isKindOf "landvehicle") || (_x isKindOf "air"))) then {
		_count = _count + 1;
		deleteVehicle _x;
	} else {
		if (_x isKindOf "weaponholder" || _x isKindOf "ACE_UsedTubes" || _x isKindOf "ACE_Rucksack_crate"|| _x isKindOf "ACE_BAG" || _x isKindOf "ACE_T72WreckTurret" || (_x isKindOf "landvehicle" && (damage _x) > 0.8) || (_x isKindOf "air" && (damage _x) > 0.8)) then {
			deleteVehicle _x;
			_count = _count +1;
		};
	};
} forEach _objects;

hint format ["%1 shit removed", _count];
Body_Reporter globalChat str _count + " stuff removed";