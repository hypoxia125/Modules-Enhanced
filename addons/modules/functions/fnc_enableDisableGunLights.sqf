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
