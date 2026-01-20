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
private _distance = _module getVariable [QUOTE(Distance), 10];
private _explode = _module getVariable [QUOTE(Explode), false];

private _vehicles = synchronizedObjects _module select {!(_x isKindOf "EmptyDetector" || _x isKindOf "Module_F")};
if (_distance < 0) then {_distance = 0};

// Functions
//------------------------------------------------------------------------------------------------
private _createJammers = {
    params [
        ["_vehicles", [], [[], objNull]],
        ["_distance", 10, [-1]],
        ["_explode", false, [true]]
    ];

    if (_vehicles isEqualType objNull) then {_vehicles = [_vehicles]};
    if (_distance < 0) then {_distance = 0};

    _vehicles apply {
        private _vehicle = _x;
        // Frame handler for mines
        [{
            params ["_args", "_handle"];
            _args params ["_vehicle", "_distance", "_explode"];

            if (!alive _vehicle) exitWith {_handle call CBA_fnc_removePerFrameHandler};
            if (allMines isEqualTo []) exitWith {};
            
            private _nearMines = allMines select {_x distance _vehicle <= _distance};

            // Deactivate near mines
            _nearMines apply {
                if (_explode) then {
                    _x setDamage 1;
                    continue;
                };
                if (simulationEnabled _x) then {
                    [QGVAR(enableMine), [_x, false]] call CBA_fnc_serverEvent;
                };
            };

            // Reactivate distant mines
            allMines - _nearMines apply {
                if (!simulationEnabled _x) then {
                    [QGVAR(enableMine), [_x, true]] call CBA_fnc_serverEvent;
                };
            };
        }, 0, [_vehicle, _distance, _explode]] call CBA_fnc_addPerFrameHandler;
    };
};

// Code Start
//------------------------------------------------------------------------------------------------
switch _mode do {
    case "init": {
        if (is3DEN) exitWith {};

        if (_vehicles isEqualTo []) then {[typeOf _module] call EFUNC(Error,requiresSync)};
        [_vehicles, _distance, _explode] call _createJammers;
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
