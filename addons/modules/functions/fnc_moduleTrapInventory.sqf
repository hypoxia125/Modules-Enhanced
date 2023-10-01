/*
    Author: Hypoxic
    Module that traps an inventory. Chance to explode on next opening.
    
    Arguments:
    0: Module - OBJECT
    1: Objects - ARRAY or OBJECT
    2: Activated - BOOL

    ReturnValue:
    NONE

    Public: No
*/

#include "script_component.hpp"

params [
    ["_module", objNull, [objNull]],
    ["_objects", [], [objNull, []]],
    ["_isActivated", false, [true]]
];

// Variables
private _explosiveType = _module getVariable [QUOTE(ExplosiveType), "GrenadeHand"];
private _explodeChance = _module getVariable [QUOTE(ExplodeChance), 0.5];
private _canDisable = _module getVariable [QUOTE(CanDisable), 0];
private _persist = _module getVariable [QUOTE(Persist), false];

// Verify variables
if (_objects isEqualType objNull) then {_objects = [_objects]};
if (_explosiveType isEqualTo "") exitWith {};
if (_explodeChance < 0 || _explodeChance > 1) exitWith {};

// Execute
[_objects, _explosiveType, _explodeChance, _canDisable, _persist] call FUNC(trapInventory);
