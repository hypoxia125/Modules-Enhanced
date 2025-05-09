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
private _repairCountMax = _module getVariable ["RepairCount", -1];
private _repairPercent = _module getVariable ["Percent", 1];
private _runImmediately = _module getVariable "RunImmediately";

// Functions
//------------------------------------------------------------------------------------------------
private _createRepairer = {
    params [
        "_module",
        ["_vehicles", [], [[], objNull]],
        ["_timeDelay", 600, [-1]],
        ["_repairCountMax", 1, [-1]],
        ["_repairPercent", 1, [-1]],
        "_runImmediately"
    ];

    if (_vehicles isEqualType objNull) then {_vehicles = [_vehicles]};
    if (_timeDelay < 0) then {_timeDelay = 0};
    if (_repairCountMax < 1) then { _repairCountMax = 1 };

    if (_runImmediately) then {
        {
            private _vehicle = _x;

            LOG("ModuleRepairVehicle:: Running immediately... repairing...");
            // Repair locally
            [QGVAR(repairVehicle), [_vehicle, _repairPercent], _vehicle] call CBA_fnc_targetEvent;

            _vehicle setVariable [QGVAR(VehicleRepair_RepairCount), 1];
        } forEach _vehicles;
    };

    // Repeat loop
    [{
        params ["_module", "_vehicles", "_timeDelay", "_repairCountMax", "_repairPercent"];

        LOG("ModuleVehicleRepair:: Starting repair loop...");

        private _handle = [{
            params ["_args", "_handle"];
            _args params ["_module", "_vehicles", "_timeDelay", "_repairCountMax", "_repairPercent"];

            if (isGamePaused) exitWith {};

            if (_vehicles findIf {alive _x} == -1) exitWith {_handle call CBA_fnc_removePerFrameHandler};

            LOG_1("ModuleVehicleRepair:: Repairing vehicles: %1",_vehicles);
            _vehicles apply {
                private _vehicle = _x;

                if !(alive _vehicle) then { continue };

                private _repairCountCurrent = _vehicle getVariable [QGVAR(VehicleRepair_RepairCount), 0];
                if (_repairCountCurrent >= _repairCountMax) then { continue };

                // Repair vehicle locally
                [QGVAR(repairVehicle), [_vehicle, _repairPercent], _vehicle] call CBA_fnc_targetEvent;
                _vehicle setVariable [QGVAR(VehicleRepair_RepairCount), _repairCountCurrent + 1];
            };
        }, _timeDelay, [_module, _vehicles, _timeDelay, _repairCountMax, _repairPercent]] call CBA_fnc_addPerFrameHandler;

        _module setVariable [QGVAR(ModuleVehicleRepair_Handle), _handle];
    }, [_module, _vehicles, _timeDelay, _repairCountMax, _repairPercent], [_timeDelay, 0] select (_runImmediately)] call CBA_fnc_waitAndExecute;
};

// Code Start
//------------------------------------------------------------------------------------------------
private _vehicles = synchronizedObjects _module select {!(_x isKindOf "EmptyDetector" || _x isKindOf "Module_F")};

switch _mode do {
    case "init": {
        if (is3DEN) exitWith {};

        if (_isActivated) then {
            [_module, _vehicles, _timeDelay, _repairCountMax, _repairPercent, _runImmediately] call _createRepairer;
        };

        if !(_isActivated) then {
            private _handle = _module getVariable [QGVAR(ModuleVehicleRepair_Handle), -1];
            _handle call CBA_fnc_removePerFrameHandler;
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