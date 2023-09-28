/*
    Author: Hypoxic
    Module that initiates the speed limiter system for synchronized units.
    
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
private _speed = _module getVariable [QUOTE(Speed), 0];
private _affectPlayer = _module getVariable [QUOTE(AffectPlayer), true];
private _affectAI = _module getVariable [QUOTE(AffectAI), true];

// Verify variables
if (_vehicles isEqualType objNull) then {_vehicles = [_vehicles]};
if (_speed < 0) then {_speed = abs _speed};
if ((!_affectPlayer) && (!_affectAI)) exitWith {};

[_vehicles, _speed, _affectPlayer, _affectAI] call FUNC(speedLimiter);
