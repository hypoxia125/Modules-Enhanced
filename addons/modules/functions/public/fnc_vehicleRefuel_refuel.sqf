/*
    Function: meh_modules_fnc_vehicleRefuel_refuel
    Refuel a vehicle on its owner. Arguments: [vehicle, fractionToAdd] (default: 1).
    Callable from any machine; returns nothing.
*/
#include "script_component.hpp"

params [["_vehicle", objNull, [objNull]], ["_amount", 1, [0]]];
if (isNull _vehicle || {_amount <= 0}) exitWith {};
[QGVAR(refuelVehicle), [_vehicle, _amount], _vehicle] call CBA_fnc_targetEvent;
