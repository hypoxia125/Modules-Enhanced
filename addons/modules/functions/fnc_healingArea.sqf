#include "script_component.hpp"

params [
    ["_object", objNull, [objNull]],
    ["_area", [20, 20, 0, false, -1], [[]], 5],
    ["_affected", 0, [-1]],
    ["_rate", 0.10, [-1]],
    ["_showArea", true, [true]] // TODO: add show area
];

if (!isServer) exitWith {};

// Validation
_area = [ASLToAGL getPosASL _object] + _area;
if (_rate < 0) then {_rate = 0};
if (_rate > 1) then {_rate = 1};

private _types = switch _affected do {
    case 0: {["CAManBase"]};
    case 1: {["LandVehicles", "Air", "Ship"]};
};

// Execute
[{
    params ["_args", "_handle"];
    _args params ["_object", "_area", "_types", "_rate", "_showArea"];

    // Early exits
    if (!alive _object) exitWith {
        _handle call CBA_fnc_removePerFrameHandler;
    };

    private _affectedUnits = entities [_types, [], false, true] select {_x inArea _area};
    LOG_1("Healing Area - Affected Units:: %1", _affectedUnits);

    if (_affectedUnits isEqualTo []) exitWith {};
    _affectedUnits apply {
        private _unit = _x;
        getAllHitPointsDamage _unit params ["_hitpoints", "_selections", "_values"];

        for "_i" from 0 to (count _hitpoints - 1) do {
            if (_values#_i < 1) then {
                [QGVAR(HealingArea_HealUnit), [_unit, _hitpoints # _i, (_values # _i - _rate) max 0], owner _unit] call CBA_fnc_ownerEvent;
            };
        };
        if ({_x > 0} count _values == 1) then {
            _unit setDamage 0;
        };
    };
}, 1, [_object, _area, _types, _rate, _showArea]] call CBA_fnc_addPerFrameHandler;