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

// Variables
private _area = _module getVariable ["ObjectArea", [100, 100, 0, false, -1]];
private _timeBetweenStrikes = _module getVariable ["TimeBetweenStrikes", 0.25];
private _strikeRandomness = _module getVariable ["StrikeRandomness", 0.5];
private _areaDamage = _module getVariable ["AreaDamage", 15];

if (
    _timeBetweenStrikes < 0 ||
    _strikeRandomness < 0 ||
    _areaDamage < 0
) then {
    [typeOf _module] call EFUNC(Error,invalidArgs)
};

switch _mode do {
    case "init": {
        if (is3DEN) exitWith {};

        if (_isActivated) then {
            private _handle = [_module, _area, _timeBetweenStrikes, _strikeRandomness, _areaDamage] call FUNC(lightningStorm);
            _module setVariable [QGVAR(lightningStorm_Handle), _handle];
        } else {
            private _handle = _module getVariable [QGVAR(lightningStorm_Handle), nil];
            if (!isNil "_handle") then {
                _handle call CBA_fnc_removePerFrameHandler;
                _module setVariable [QGVAR(lightningStorm_Handle), nil];
            };
        };
    };

    default {};
};
