// -----------------------------------------------
// Author:     code34 nicolas_boiteux@yahoo.fr
// Edited by:  Neumatic
// Warcontext: Delete of mission list, all missions in safe zone
// -----------------------------------------------

wcallhangars = nearestObjects [wcmapcenter, wckindofhangars, 20000];
{
	wcallhangars = [wcallhangars, _x, wcalertzonesize] call WC_fnc_farofpos;
} forEach wcsecurezone;
if (count wcallhangars == 0) then {
	wcmissiondone = wcmissiondone + [4,5,6,10,11,12,46];
};

wcallfuelstations = nearestObjects [wcmapcenter, wckindoffuelstations, 20000];
{
	wcallfuelstations = [wcallfuelstations, _x, wcalertzonesize] call WC_fnc_farofpos;
} forEach wcsecurezone;
if (count wcallfuelstations == 0) then {
	wcmissiondone = wcmissiondone + [13];
};

wcallfueltanks = nearestObjects [wcmapcenter, wckindoffueltanks, 20000];
{
	wcallfueltanks = [wcallfueltanks, _x, wcalertzonesize] call WC_fnc_farofpos;
} forEach wcsecurezone;
if (count wcallfueltanks == 0) then {
	wcmissiondone = wcmissiondone + [14];
};

wcallbaracks = nearestObjects [wcmapcenter, wckindofbarracks, 20000];
{
	wcallbaracks = [wcallbaracks, _x, wcalertzonesize] call WC_fnc_farofpos;
} forEach wcsecurezone;
if (count wcallbaracks == 0) then {
	wcmissiondone = wcmissiondone + [15];
};

wcallcontroltowers = nearestObjects [wcmapcenter, wckindofcontroltowers, 20000];
{
	wcallcontroltowers = [wcallcontroltowers, _x, wcalertzonesize] call WC_fnc_farofpos;
} forEach wcsecurezone;
if (count wcallcontroltowers == 0) then {
	wcmissiondone = wcmissiondone + [33,37];
};

wcallfactory = nearestObjects [wcmapcenter, wckindoffactory, 20000];
{
	wcallfactory = [wcallfactory, _x, wcalertzonesize] call WC_fnc_farofpos;
} forEach wcsecurezone;
if (count wcallfactory == 0) then {
	wcmissiondone = wcmissiondone + [34];
};

wcallcastle = nearestObjects [wcmapcenter, wckindofcastle, 20000];
{
	wcallcastle = [wcallcastle, _x, wcalertzonesize] call WC_fnc_farofpos;
} forEach wcsecurezone;
if (count wcallcastle == 0) then {
	wcmissiondone = wcmissiondone + [35,48];
};

wcalldam = nearestObjects [wcmapcenter, wckindofdam, 20000];
{
	wcalldam = [wcalldam, _x, wcalertzonesize] call WC_fnc_farofpos;
} forEach wcsecurezone;
if (count wcalldam == 0) then {
	wcmissiondone = wcmissiondone + [47];
};

nil
