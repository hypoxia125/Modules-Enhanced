#include "script_component.hpp"

#include "XEH_PREP.sqf"

// Events
[QGVAR(hideObjectForTeleportServer), {
    params ["_unit", "_value"];

    _unit hideObjectGlobal _value;
}] call CBA_fnc_addEventHandler;

[QGVAR(hideObjectForTeleport), {
    params ["_unit", "_value"];

    _unit allowDamage (!_value);
    [QGVAR(hideObjectForTeleportServer), [_unit, _value]] call CBA_fnc_serverEvent;
}];