#include "script_component.hpp"

#include "XEH_PREP.sqf"

// Events

/* --------------------------------------------------
    Hide Object Teleport Event
-------------------------------------------------- */
[QGVAR(hideObjectGlobal), {
    params ["_unit", "_value"];

    _unit hideObjectGlobal _value;
    _unit enableSimulationGlobal (!_value);
}] call CBA_fnc_addEventHandler;

[QGVAR(hideObjectForTeleport), {
    params ["_unit", "_value"];

    _unit allowDamage (!_value);
    [QGVAR(hideObjectGlobal), [_unit, _value]] call CBA_fnc_serverEvent;
}] call CBA_fnc_addEventHandler;