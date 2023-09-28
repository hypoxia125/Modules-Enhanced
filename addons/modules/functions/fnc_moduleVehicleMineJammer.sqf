/*
    Author: Hypoxic
    Module that initiates the vehicle mine jammer system for synchronized units.
    
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
private _distance = _module getVariable [QUOTE(Distance), 25];
private _explode = _module getVariable [QUOTE(Explode), false];

// Verify variables
if (_vehicles isEqualType objNull) then {_vehicles = [_vehicles]};
if (_distance < 0) then {_distance = 0};

[_vehicles, _distance, _explode] call FUNC(vehicleMineJammer);
