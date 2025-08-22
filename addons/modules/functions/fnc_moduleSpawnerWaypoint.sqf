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

// Variables
//------------------------------------------------------------------------------------------------
private _position = getPosATL _module;
private _waypointTypeNum = _module getVariable "WaypointType";
private _waypointIndex = _module getVariable ["WaypointIndex", 0];

// Functions
//------------------------------------------------------------------------------------------------
if (isNil QFUNC(SpawnerWP_GetWaypointType)) then {
    FUNC(SpawnerWP_GetWaypointType) = compileFinal {
        params ["_typeNumber"];

        // Return
        switch _typeNumber do {
            case 0: { "MOVE" };
            case 1: { "SAD" };
            case 2: { "SENTRY" };

            default { "MOVE" };
        };
    };
};

// Code Start
//------------------------------------------------------------------------------------------------
switch _mode do {
    case "attributesChanged3DNE";
    case "registeredToWorld3DEN";
    case "init": {
        // Get waypoint type
        private _wpType = [_waypointTypeNum] call FUNC(SpawnerWP_GetWaypointType);

        // Set data
        private _wpData = [
            _waypointIndex,
            _position,
            _wpType
        ];

        _module setVariable [QGVAR(SpawnerWP_WPData), _wpData, true];
    };
};
