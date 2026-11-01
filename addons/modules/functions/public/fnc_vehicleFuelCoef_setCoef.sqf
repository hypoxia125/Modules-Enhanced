/*
    Function: meh_modules_fnc_vehicleFuelCoef_setCoef
    Set a vehicle's fuel-consumption coefficient on its owner. Arguments: [vehicle, coefficient].
    Callable from any machine; returns nothing.
*/
#include "script_component.hpp"

params [["_vehicle", objNull, [objNull]], ["_coef", 1, [0]]];
if (isNull _vehicle || {_coef < 0}) exitWith {};
[QGVAR(VehicleFuelCoef_SetCoef), [_vehicle, _coef], _vehicle] call CBA_fnc_targetEvent;
