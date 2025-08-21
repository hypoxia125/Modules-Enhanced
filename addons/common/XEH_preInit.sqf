#include "script_component.hpp"

#include "XEH_PREP.hpp"

// CBA Settings
[
    QGVAR(ModuleMarkerHide),
    "CHECKBOX",
    "Hide 3D Module Markers",
    "Modules Enhanced",
    false,
    0,
    {},
    false
] call CBA_fnc_addSetting;

[
    QGVAR(ModuleMarkerDistanceLimit),
    "SLIDER",
    "3D Marker Distance Limit",
    "Modules Enhanced",
    [100, 750, 750, 0],
    0,
    {},
    false
] call CBA_fnc_addSetting;

[
    QGVAR(ModuleMarkerColor),
    "COLOR",
    "3D Marker Color",
    "Modules Enhanced",
    [1, 0.41, 0.71, 1],
    0,
    {},
    false
] call CBA_fnc_addSetting;

// Load 3D Module Markers
call FUNC(3DEN_3DModuleMarkers);
