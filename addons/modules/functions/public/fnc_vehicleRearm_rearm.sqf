/*
    Function: meh_modules_fnc_vehicleRearm_rearm
    Fully rearm a vehicle on its owner. Arguments: [vehicle].
    Callable from any machine; returns nothing.
*/
#include "script_component.hpp"

params [["_vehicle", objNull, [objNull]]];
if (isNull _vehicle) exitWith {};
[QGVAR(rearmVehicle), [_vehicle], _vehicle] call CBA_fnc_targetEvent;
