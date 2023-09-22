#include "script_component.hpp"

params [
    ["_module", objNull, [objNull]]
];

if (!isServer) exitWith {false};

// Find synchronized modules
private _respawnModules = (_module call BIS_fnc_moduleModules) select {_x isKindOf "ModuleRespawnPosition_F"};

[_respawnModules] call FUNC(deleteRespawnPosition);
