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
if (!is3DEN && {!_isActivated}) exitWith {};
if (_mode in ["dragged3DEN", "unregisteredFromWorld3DEN"]) exitWith {};

// Variables
//------------------------------------------------------------------------------------------------
private _timeDelay = _module getVariable ["TimeDelay", 5*60];
private _refuelCountMax = _module getVariable ["RefuelCount", -1];
private _runImmediately = _module getVariable "RunImmediately";

// Functions
//------------------------------------------------------------------------------------------------
private _createRefueler = {
    params [
        ["_vehicles", [], [[], objNull]],
        ["_timeDelay", 600, [-1]],
        ["_refuelCountMax", 1, [-1]],
        "_runImmediately"
    ];

    if (_vehicles isEqualType objNull) then {_vehicles = [_vehicles]};
    if (_timeDelay < 0) then {_timeDelay = 0};
    if (_refuelCountMax < 1) then { _refuelCountMax = 1 };

    if (_runImmediately) then {
        {
            private _vehicle = _x;

            // Refuel locally
            [QGVAR(refuelVehicle), [_vehicle], _vehicle] call CBA_fnc_targetEvent;

            _vehicle setVariable [QGVAR(VehicleRefuel_RefuelCount), 1];
        } forEach _vehicles;
    };

    // Repeat loop
    [{
        params ["_vehicles", "_timeDelay", "_refuelCountMax"];

        [{
            params ["_args", "_handle"];
            _args params ["_vehicles", "_timeDelay", "_refuelCountMax"];

            if (isGamePaused) exitWith {};

            if (_vehicles findIf {alive _x} == -1) exitWith {_handle call CBA_fnc_removePerFrameHandler};

            _vehicles apply {
                private _vehicle = _x;

                if !(alive _vehicle) then { continue };

                private _refuelCountCurrent = _vehicle getVariable [QGVAR(VehicleRefuel_RefuelCount), 0];
                if !(_refuelCountCurrent < _refuelCountMax) then { continue };

                // Refuel vehicle locally
                [QGVAR(refuelVehicle), [_vehicle], _vehicle] call CBA_fnc_targetEvent;
                _vehicle setVariable [QGVAR(VehicleRefuel_RefuelCount), _refuelCountCurrent + 1];
            };
        }, _timeDelay, [_vehicles, _timeDelay, _refuelCountMax]] call CBA_fnc_addPerFrameHandler;
    }, [_vehicles, _timeDelay, _refuelCountMax], [_timeDelay, 0] select (_runImmediately)] call CBA_fnc_waitAndExecute;
};

// Code Start
//------------------------------------------------------------------------------------------------
private _vehicles = synchronizedObjects _module select {!(_x isKindOf "EmptyDetector" || _x isKindOf "Module_F")};

switch _mode do {
    case "init": {
        if (is3DEN) exitWith {};

        if (_vehicles isEqualTo []) then {[typeOf _module] call EFUNC(Error,requiresSync)};
        [_vehicles, _timeDelay, _refuelCountMax, _runImmediately] call _createRefueler;
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
