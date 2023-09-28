/*
    Author: Hypoxic
    Deletes vanilla BI "ModuleRespawnPosition_F" respawn and respawn position.

    Arguments:
    0: Modules - OBJECT or ARRAY

    ReturnValue:
    0: Handle - CBA_fnc_addPerFrameHandler Handle - NUMBER

    Example:
    [myRespawnPositionModule] call MEH_Modules_fnc_deleteRespawnPosition

    Public: Yes
*/

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
