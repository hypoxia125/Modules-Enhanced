/*
    Author: Hypoxic
    Turns a vehicle into a mine jamming vehicle. Either the jamming will disable the mine, or can set it to explode instead.

    Arguments:
    0: Vehicles - ARRAY or OBJECT
    1: Radius - NUMBER
    2: Explode - BOOL

    ReturnValue:
    NONE

    Example:
    [vehicle_1, 5, true] call MEH_Modules_fnc_vehicleMineJammer;

    Public: Yes
*/

#include "script_component.hpp"

params [
    ["_vehicles", [], [[], objNull]],
    ["_distance", 25, [-1]],
    ["_explode", false, [true]]
];

// Verify variables
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
