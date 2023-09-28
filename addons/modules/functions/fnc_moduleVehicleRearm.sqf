/*
    Author: Hypoxic
    Module that initiates the vehicle rearm system for synchronized units.
    
    Arguments:
    0: Module - OBJECT
    1: Vehicles - ARRAY or OBJECT
    2: Activated - BOOL

    ReturnValue:
    NONE

    Public: No
*/

#include "script_component.hpp"

params [
    ["_module", objNull, [objNull]],
    ["_vehicles", [], [objNull, []]],
    ["_isActivated", false, [true]]
];

if (!isServer) exitWith {};
if (!_isActivated) exitWith {};

// Variables
private _timeDelay = _module getVariable [QUOTE(TimeDelay), 0];

// Validate variables
if (_vehicles isEqualType objNull) then {_vehicles = [_vehicles]};
if (_timeDelay < 0) then {_timeDelay = 0};

[_vehicles, _timeDelay] call FUNC(vehicleRearm);
