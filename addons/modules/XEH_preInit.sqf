#include "script_component.hpp"

#include "XEH_PREP.sqf"

// Events
[QGVAR(refuelVehicle), {
    params ["_vehicle"];

    _vehicle setFuel 1;
}] call CBA_fnc_addEventHandler;