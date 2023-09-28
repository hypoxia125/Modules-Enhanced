/*
    Author: Hypoxic
    Refuels the provided vehicles. Can optionally be put on a loop to constantly rearm at given interval.

    Arguments:
    0: Vehicles - ARRAY or OBJECT
    2: Time Delay - NUMBER
        0: Disable

    ReturnValue:
    ARRAY of ARRAYS:
        0: Vehicles - ARRAY
        1: Time Delay - NUMBER

    Example:
    [vehicle_1, 300] call MEH_Modules_fnc_vehicleRefuel;

    Public: Yes
*/

#include "script_component.hpp"

params [
    ["_vehicles", [], [[], objNull]],
    ["_timeDelay", 600, [-1]]
];

// Validate variables
if (_vehicles isEqualType objNull) then {_vehicles = [_vehicles]};
if (_timeDelay < 0) then {_timeDelay = 0};

private _repeatable = true;
if (_timeDelay == 0) then {_repeatable = false};

// Set vehicle's fuel to max
_vehicles apply {
    private _vehicle = _x;
    [QGVAR(refuelVehicle), [_vehicle], _vehicle] call CBA_fnc_targetEvent;

    // Repeat handler
    if (_repeatable) then {
        [{
            params ["_args", "_handle"];
            _args params ["_vehicle"];

            if (!alive _vehicle) exitWith {
                _handle call CBA_fnc_removePerFrameHandler;
            };

            [QGVAR(refuelVehicle), [_vehicle], _vehicle] call CBA_fnc_targetEvent;
        }, _timeDelay, [_vehicle]] call CBA_fnc_addPerFrameHandler;
    };
};

// Return
[_vehicles, _timeDelay];
