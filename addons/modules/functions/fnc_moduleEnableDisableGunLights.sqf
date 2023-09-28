/*
    Author: Hypoxic
    Module that initiates the enable/disable gun lights function on given synchronized units.

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

if (!isServer) exitWith {};
if (!_isActivated) exitWith {};

// Variables
private _state = _module getVariable [QUOTE(State), 0];
private _addAttachment = _module getVariable [QUOTE(AddAttachment), false];
private _attachment = _module getVariable [QUOTE(Attachment), ""];

// Verify variables
if (_units isEqualType objNull) then {_units = [_units]};

// Get groups
private _groups = _units apply {group _x};
_groups = _groups arrayIntersect _groups;

// Wait for mission to start and execute. Won't work otherwise
private _args = [_groups, _state, _addAttachment, _attachment];
[{
    time > 0;
}, {
    _this call FUNC(enableDisableGunLights);
}, _args] call CBA_fnc_waitUntilAndExecute;
