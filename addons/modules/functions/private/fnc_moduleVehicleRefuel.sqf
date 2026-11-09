/* ----------------------------------------------------------------------------
Function: meh_modules_fnc_moduleVehicleRefuel

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
if (_mode in ["dragged3DEN", "unregisteredFromWorld3DEN"]) exitWith {};

// Variables
//------------------------------------------------------------------------------------------------
private _timeDelay = _module getVariable ["TimeDelay", 5*60];
private _refuelCountMax = _module getVariable ["RefuelCount", -1];
private _refuelPercent = _module getVariable "Percent";
private _runImmediately = _module getVariable "RunImmediately";

// Code Start
//------------------------------------------------------------------------------------------------
private _vehicles = synchronizedObjects _module select {!(_x isKindOf "EmptyDetector" || _x isKindOf "Module_F")};

switch _mode do {
    case "init": {
        if (is3DEN) exitWith {};

        if (_isActivated) then {
            private _handle = [_vehicles, _timeDelay, _refuelCountMax, _refuelPercent, _runImmediately, _module] call FUNC(vehicleRefuel_startRefueling);
            _module setVariable [QGVAR(ModuleVehicleRefuel_Handle), _handle];
        };

        if !(_isActivated) then {
            private _handle = _module getVariable [QGVAR(ModuleVehicleRefuel_Handle), scriptNull];
            terminate _handle;
            _module setVariable [QGVAR(ModuleVehicleRefuel_Handle), nil];
        };
    };

    case "connectionChanged3DEN": {
        private _synced = get3DENConnections _module apply {_x select 1};
        private _invalid = _synced select {!(_x isKindOf "Tank" || _x isKindOf "Ship" || _x isKindOf "Air" || _x isKindOf "Car" || _x isKindOf "EmptyDetector")};
        if (_invalid isNotEqualTo []) then {
            [typeOf _module] call EFUNC(Error,invalidSync);

            // remove connection
            remove3DENConnection ["Sync", _invalid, _module];
        };
    };

    default {};
};
