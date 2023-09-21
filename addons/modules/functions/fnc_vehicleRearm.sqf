#include "script_component.hpp"

params [
    ["_module", objNull, [objNull]],
    ["_vehicles", [], [objNull, []]],
    ["_isActivated", false, [true]]
];

if (!isServer) exitWith {};

// Variables
private _repeatable = _module getVariable [QUOTE(Repeatable), true];
private _timeDelay = _module getVariable [QUOTE(TimeDelay), 600];

// Validate variables
if (_vehicles isEqualType objNull) then {_vehicles = [_vehicles]};
if (_timeDelay < 0) then {_timeDelay = 0};

// Set vehicle's ammo to max
_vehicles apply {
    private _vehicle = _x;
    _vehicle setVehicleAmmo 1;

    // Repeat handler
    if (_repeatable) then {
        [{
            params ["_args", "_handle"];
            _args params ["_vehicle"];

            if (!alive _vehicle) exitWith {
                _handle call CBA_fnc_removePerFrameHandler;
            };

            _vehicle setVehicleAmmo 1;
        }, _timeDelay, [_vehicle]] call CBA_fnc_addPerFrameHandler;
    };
};

// Return
[_vehicles, _timeDelay];