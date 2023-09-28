/*
    Author: Hypoxic
    Module that initiates the move on combat system for synchronized units.
    
    Arguments:
    0: Module - OBJECT
    1: Units - ARRAY or OBJECT
    2: Activated - BOOL

    ReturnValue:
    NONE

    Public: No
*/

#include "script_component.hpp"

params [
    ["_module", objNull, [objNull]],
    ["_units", [], [objNull, []]],
    ["_isActivated", false, [true]]
];

if (!isServer) exitWith {false};
if (!_isActivated) exitWith {};

// Variables
private _delay = _module getVariable [QUOTE(Delay), 0];

// Validate variables
if (_units isEqualType objNull) then {_units = [_units]};

// Get groups
private _groups = _units apply {group _x};
_groups = _groups arrayIntersect _groups;

[_groups, _delay] call FUNC(moveOnCombat);
