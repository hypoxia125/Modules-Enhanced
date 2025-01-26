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
private _coef = _module getVariable ["Coef", 0];

// Functions
//------------------------------------------------------------------------------------------------
private _setCoef = {
    params ["_vehicles", "_coef"];

    {
        [QGVAR(VehicleFuelCoef_SetCoef), [_x, _coef], _x] call CBA_fnc_targetEvent;
    } forEach _vehicles;
};

// Code Start
//------------------------------------------------------------------------------------------------
private _vehicles = synchronizedObjects _module select {!(_x isKindOf "EmptyDetector" || _x isKindOf "Module_F")};

switch _mode do {
    case "init": {
        if (is3DEN) exitWith {};

        if (_vehicles isEqualTo []) then {[typeOf _module] call EFUNC(Error,requiresSync)};
        [_vehicles, _coef] call _setCoef;
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