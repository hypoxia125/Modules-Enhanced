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
if !(_mode in ["init", "registeredToWorld3DEN", "attributesChanged3DEN", "unregisteredFromWorld3DEN"]) exitWith {};

// Variables
//------------------------------------------------------------------------------------------------
private _side = switch (_module getVariable ["Side", 0]) do {
    case 0: {east};
    case 1: {west};
    case 2: {independent};
    case 3: {civilian};
    default {sideUnknown};
};
private _time = _module getVariable ["Time", 15*60];

// Functions
//------------------------------------------------------------------------------------------------
private _reportTargets = {
    params ["_vehicles", "_side", "_time"];

    {
        [QGVAR(CreateRemoteTarget_ReportTarget), [_x, _side, _time]] call CBA_fnc_globalEventJIP;
    } forEach _vehicles;
};

private _createDummyTarget = {
    params ["_module"];

    private _position = ASLToAGL getPosASL _module;
    private _dummy = createVehicle ["laserTarget", _position, [], 0, "CAN_COLLIDE"];

    // return
    _dummy;
};

// Code Start
//------------------------------------------------------------------------------------------------
private _vehicles = synchronizedObjects _module select {!(_x isKindOf "EmptyDetector" || _x isKindOf "Module_F")};

switch _mode do {
    case "init": {
        if (is3DEN) exitWith {};
        if (!_isActivated) exitWith {};

        if (_vehicles isEqualTo []) then {
            private _dummy = [_module] call _createDummyTarget;
            _vehicles pushBack _dummy;
        };
        
        [_vehicles, _side, _time] call _reportTargets;
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