#include "script_component.hpp"

params [
    ["_mode", "", [""]],
    ["_input", [], [[]]]
];
_input params [
    ["_module", objNull, [objNull]],
    ["_isActivated", false, [true]],
    ["_isCuratorPlaced", false, [true]]
];

if (!isServer) exitWith {};
if (_mode in ["dragged3DEN", "unregisteredFromWorld3DEN"]) exitWith {};

private _area = _module getVariable "ObjectArea";
private _affected = _module getVariable "Affected";
private _rate = _module getVariable "Rate";
private _showArea = _module getVariable ["ShowArea", true];

// Validation
if (_rate < 0) then {_rate = 0};
if (_rate > 1) then {_rate = 1};

switch _mode do {
    case "init": {
        if (is3DEN) exitWith {};

        [_module, _area, _affected, _rate, _showArea] call FUNC(healingArea);
    };

    default {};
}