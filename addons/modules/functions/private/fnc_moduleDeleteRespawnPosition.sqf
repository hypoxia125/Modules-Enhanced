/* ----------------------------------------------------------------------------
Function: meh_modules_fnc_moduleDeleteRespawnPosition

Author: Hypoxic

Public: False - Requires internal data

Description:
    Function that the module calls upon initialization.
---------------------------------------------------------------------------- */

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

// Code Start
//------------------------------------------------------------------------------------------------
switch _mode do {
    case "init": {
        if (is3DEN) exitWith {};
        if (!_isActivated) exitWith {};

        private _respawnModules = (_module call BIS_fnc_moduleModules) select {_x isKindOf "ModuleRespawnPosition_F"};
        [_respawnModules] call FUNC(deleteRespawnPosition_delete);

        // Cleanup Module
        deleteVehicle _module;
    };

    case "connectionChanged3DEN": {
        private _synced = get3DENConnections _module apply {_x#1};
        private _invalid = _synced select {!(_x isKindOf "ModuleRespawnPosition_F") && !(_x isKindOf "EmptyDetector")};
        if (_invalid isNotEqualTo []) then {
            [typeOf _module] call EFUNC(Error,invalidSync);

            // remove connection
            remove3DENConnection ["Sync", _invalid, _module];
        };
    };

    default {};
};
