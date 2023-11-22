#include "script_component.hpp"

params ["_unit"];

private _handle = _unit addEventHandler ["InventoryOpened", {
    params ["_object", "_container", "_secondaryContainer"];

    // Check locality
    if (!local _object) exitWith {};

    // Check if container is a trap
    private _trapData = _container getVariable QGVAR(TrapInventory_Data);
    if (isNil QUOTE(_trapData)) exitWith {};

    // Check if trap is active
    _trapData params ["_explosiveType", "_explodeChance", "_canDisable", "_persist", "_active"];
    if (!_active) exitWith {INFO_1("Inventory Trap: %1 is no longer active", _container)};

    // Check explode chance - if exploding, exit early
    private _explode = _explodeChance >= random 1;
    if (_explode) exitWith {
        // Create explosion
        private _explosive = createVehicle [_explosiveType, getPosASL _object vectorAdd [0,0,0.2], [], 0, "NONE"];
        // Hide explosive if not a grenade
        if (!(_explosiveType isKindOf "Grenade")) then {
            [QGVAR(HideObjectGlobal), [_explosive, true]] call CBA_fnc_serverEvent;
        };
        _explosive setDamage 1;

        // Set trap data to inactive
        _trapData set [4, false];
        _object setVariable [QGVAR(TrapInventory_Data), _trapData, true];
    };

    // If not exploding, set peristance
    if (!_persist) then {
        _trapData set [4, false];
        _object setVariable [QGVAR(TrapInventory_Data), _trapData, true];
        hint LLSTRING(TrapInventory_SuccessUnknown);
    } else {
        hint LLSTRING(TrapInventory_SuccessFailed);
    };
}];

// Store handle in object namespace
_unit setVariable [QGVAR(TrapInventory_EH), ["InventoryOpened", _handle]];
