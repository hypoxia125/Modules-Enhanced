#include "script_component.hpp"

// Parameters
//------------------------------------------------------------------------------------------------
params [
    ["_mode", "", [""]],
    ["_input", [], [[]]]
];
_input params [
    ["_module", objNull, [objNull]],
    ["_isActivated", false, [true]],
    ["_isCuratorPlaced", false, [true]]
];

// Pre-Execution Checks
//------------------------------------------------------------------------------------------------
if (!isServer) exitWith {};
if !(_mode in ["init", "connectionChanged3DEN"]) exitWith {};

// Functions
//------------------------------------------------------------------------------------------------
private _deleteRespawnPosition = {
    params ["_respawnModules"];

    if (_respawnModules isEqualType objNull) then { _respawnModules = [_respawnModules] };

    {
        private _module = _x;

        private _respawn = (_module getVariable [QUOTE(respawn), []]) param [0, [], [[], ""]];
        if (!(_respawn isEqualType [])) exitWith {false};
        if (!(count _respawn == 2)) exitWith {false};

        _respawn call BIS_fnc_removeRespawnPosition;

        // Module Respawn Position Cleanup
        deleteVehicle _module;
    } forEach _respawnModules;
};

// Code Start
//------------------------------------------------------------------------------------------------
switch _mode do {
    case "init": {
        if (is3DEN) exitWith {};
        if (!_isActivated) exitWith {};

        private _respawnModules = (_module call BIS_fnc_moduleModules) select {_x isKindOf "ModuleRespawnPosition_F"};
        [_respawnModules] call _deleteRespawnPosition;

        // Cleanup Module
        deleteVehicle _module;
    };

    case "connectionChanged3DEN": {
        private _synced = get3DENConnections _module apply {_x#1};
        private _invalid = _synced select {!(_x isKindOf "ModuleRespawnPosition_F")};
        if (_invalid isNotEqualTo []) then {
            [typeOf _module] call EFUNC(Error,invalidSync);

            // remove connection
            remove3DENConnection ["Sync", _invalid, _module];
        };
    };

    default {};
};
