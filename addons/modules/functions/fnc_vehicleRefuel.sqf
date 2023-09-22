#include "script_component.hpp"

params [
    ["_vehicles", [], [[], objNull]],
    ["_repeatable", true, [true]],
    ["_timeDelay", 600, [-1]]
];

// Validate variables
if (_vehicles isEqualType objNull) then {_vehicles = [_vehicles]};
if (_timeDelay < 0) then {_timeDelay = 0};

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
