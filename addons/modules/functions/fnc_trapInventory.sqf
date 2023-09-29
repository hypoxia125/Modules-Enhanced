#include "script_component.hpp"

params [
    ["_objects", [], [[], objNull]],
    ["_explosiveType", "", [""]],
    ["_canDisable", false, [true]],
    ["_persist", false, [true]]
];

// Verify variables
if (_objects isEqualType objNull) then {_objects = [_objects]};
if (_explosiveType isEqualTo "") exitWith {};
if (_explodeChance < 0 || _explodeChance > 1) exitWith {};

// Execute
_objects apply {
    private _object = _x;
    private _objectType = typeOf _x;

    // Save variables
    _object setVariable [QGVAR(ExplosiveType), _explosiveType];
    _object setVariable [QGVAR(Persist), _persist];

    _object addEventHandler ["InventoryOpened", {
        params ["_object", "_container", "_secondaryContainer"];

        private _explosiveType = _object getVariable [QGVAR(ExplosiveType), "GrenadeHand"];
        private _persist = _object getVariable [QGVAR(Persist), false];

        if (_explodeChance <= random 1) then {
            private _explosive = createVehicle [_explosiveType, getPosATL _object vectorAdd [0,0,2], [], 0, "CAN_COLLIDE"];
            [QGVAR(HideObjectGlobal), [_explosive, true]] call CBA_fnc_serverEvent;
            _explosive setDamage 1;

            if (!_persist) then {
                _object removeEventHandler [_thisEvent, _thisEventHandler];
            };
        };
    }];

    // Add check for traps option
};