#include "script_component.hpp"

params [
    ["_module", objNull, [objNull]],
    ["_synced", [], [objNull, []]],
    ["_isActivated", false, [true]]
];

if (!isServer) exitWith {false};
if (!_isActivated) exitWith {false};

// Find synchronized modules
private _respawnModules = (_module call BIS_fnc_moduleModules) select {_x isKindOf "ModuleRespawnPosition_F"};

_respawnModules apply {
    private _module = _x;

    private _respawn = (_module getVariable [QUOTE(respawn), []]) param [0, [], [[], ""]];
    if (!(_respawn isEqualType [])) exitWith {false};
    if (!(count _respawn == 2)) exitWith {false};

    _respawn call BIS_fnc_removeRespawnPosition;

    // Module Respawn Position Cleanup
    deleteVehicle _module;
};

// DeleteRespawnPosition Module Cleanup
deleteVehicle _module;
