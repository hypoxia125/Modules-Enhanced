#include "script_component.hpp"

#include "XEH_PREP.hpp"

[QGVAR(lightningStrike_Local), {
    params ["_pos", "_dir", "_class"];

    _this call EFUNC(effects,lightningStrike)
}] call CBA_fnc_addEventHandler;
