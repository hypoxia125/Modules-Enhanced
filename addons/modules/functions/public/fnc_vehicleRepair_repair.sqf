/*
    Function: meh_modules_fnc_vehicleRepair_repair
    Repair every vehicle hit point on its owner. Arguments: [vehicle, fractionToRepair] (default: 1).
    Callable from any machine; returns nothing.
*/
#include "script_component.hpp"

params [["_vehicle", objNull, [objNull]], ["_amount", 1, [0]]];
if (isNull _vehicle || {_amount <= 0}) exitWith {};
[QGVAR(repairVehicle), [_vehicle, _amount], _vehicle] call CBA_fnc_targetEvent;
