#include "script_component.hpp"

#include "XEH_PREP.hpp"

[QGVAR(SystemMsg), {
    params ["_string"];

    systemChat _string;
}] call CBA_fnc_addEventHandler;
