/*
    Author: Hypoxic
    Forces a gun light (flashlight) state of a group of units. Can add flashlight attachment if desired (removing other pointer attachments).
    Affects Players && AI

    Arguments:
    0: Units - OBJECT or ARRAY
    1: State - NUMBER
        - 0: Auto
        - 1: Force On
        - 2: Force Off
    2: Add Attachment - BOOL
    3: Attachment Class - STRING

    ReturnValue:
    NONE

    Example:
    [squadLeader_1, squadLeader_2, squadLeader_3] call MEH_Modules_fnc_enableDisableGunLights

    Public: Yes
*/

#include "script_component.hpp"

params [
    ["_groups", [], [[], objNull]],
    ["_state", 0, [-1]],
    ["_addAttachment", false, [true]],
    ["_attachment", "", [""]]
];

// Verify variables
if (_groups isEqualType objNull) then {_groups = [_groups]};

_state = switch _state do {
    case 0: {"Auto"};
    case 1: {"ForceOn"};
    case 2: {"ForceOff"};
};

// Execute on groups
_groups apply {
    private _group = _x;
    private _units = units _x;

    if (_addAttachment) then {
        _units apply {
            private _unit = _x;
            [QGVAR(AddFlashlightAttachment), [_unit, _attachment], _unit] call CBA_fnc_targetEvent;
        };
    };

    // Handle AI
    [QGVAR(enableGunLights), [_group, _state], _group] call CBA_fnc_targetEvent;

    // Handle players
    private _players = _units select {isPlayer _x};
    _players apply {
        private _unit = _x;
        [QGVAR(enableGunLightsPlayer), [_unit], _unit] call CBA_fnc_targetEvent;
    };
};
