#include "script_component.hpp"

params [
    ["_respawnModules", [], [[], objNull]]
];

// Verify variables
if (_respawnModules isEqualType objNull) then {_respawnModules = [_respawnModules]};

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
