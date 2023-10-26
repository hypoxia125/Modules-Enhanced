/*
    Author: Hypoxic
    Turn an object's inventory into a trapped surprise. Can work on crates, vehicles, and units (armed when dead).

    Arguments:
    0: Objects - ARRAY or OBJECT
    1: Explosive Type - STRING - CfgAmmo Classname - ie. "grenadeHand", "Bo_GBU12_LGB"
    2: Explosive Chance - NUMBER - 0 to 1 - ie. 0.3 (30% chance)
    3: Can Disable - NUMBER
        0: Disabled
        1: Anyone
        2: Require Equipment (ToolKit, ACE_DefusalKit, MineDetector)
        3: Require Specialist + Equipment
    
    ReturnValue:
    NONE

    Example:
    [vehicle_1, "grenadeHand", 0.3, 2] call MEH_Modules_fnc_trapInventory;

    Public Events:
        "MEH_Modules_TrapInventory_Created"
            Passed Variables: [Object, [_explosiveType, _explodeChance, _canDisable, _persist, _isActive]]

    Public: Yes
*/

#include "script_component.hpp"

params [
    ["_objects", [], [[], objNull]],
    ["_explosiveType", "", [""]],
    ["_explodeChance", 0.5, [-1]],
    ["_canDisable", 0, [-1]],
    ["_persist", false, [true]]
];

// Verify variables
if (_objects isEqualType objNull) then {_objects = [_objects]};
if (_explosiveType isEqualTo "") exitWith {};
if (_explodeChance < 0 || _explodeChance > 1) exitWith {};

// Execute
if (isServer) then {
    // Set variables and broadcast
    _objects apply {
        private _object = _x;
        
        private _data = [_explosiveType, _explodeChance, _canDisable, _persist, true];
        _object setVariable [QGVAR(TrapInventory_Data), _data, true];

        // Broadcast event for modders
        [QGVAR(TrapInventory_Created), [_object, _data]] call CBA_fnc_globalEvent;
    };
};

// Make handler exist globally
allUnits apply {
    private _unit = _x;

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
            private _position = (ASLToAGL (getPosASL _object));
            private _explosive = createVehicle [_explosiveType, _position, [], 0, "NONE"];
            // Hide explosive if not a grenade
            if (!(_explosiveType isKindOf "Grenade")) then {
                [QGVAR(HideObjectGlobal), [_explosive, true]] call CBA_fnc_serverEvent;
            };
            _explosive setDamage 1;
            // If in vehicle, kill the unit
            if (vehicle _object isNotEqualTo _object) then {
                _explosive attachTo [_object, [0,0,0]];
                [{
                    params ["_object", "_explosive"];

                    isNull _explosive;
                }, {
                    params ["_object", "_explosive"];
                    
                    _object setDamage 1;
                }, [_object, _explosive], 20, {}] call CBA_fnc_waitUntilAndExecute;
            };

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
};

// Add disable interface to players
if (hasInterface) then {

    // Add disable action
    if (_canDisable >= 0) then {
        _objects apply {
            private _object = _x;

            private _holdAction = [_object,
            LLSTRING(TrapInventory_Action_DisableTrap),
            "a3\ui_f\data\igui\cfg\holdactions\holdaction_search_ca.paa",
            "a3\ui_f\data\igui\cfg\holdactions\holdaction_search_ca.paa",
            toString {
                [_target, _this] call FUNC(trapInventoryActionShow)
            }, // condition show
            "true", // condition progress
            {}, // code start
            {}, // code progress
            {
                params ["_target", "_caller", "_actionId", "_arguments"];

                private _data = _target getVariable QGVAR(TrapInventory_Data);
                _data set [4, false];
                _target setVariable [QGVAR(TrapInventory_Data), _data, true];
                
                hint LLSTRING(TrapInventory_TrapDisabled);

                // Remove actions from all clients
                private _JIP = [QGVAR(RemoveTrapDisableAction), _target] call CBA_fnc_globalEventJIP;
                [_JIP, _target] call CBA_fnc_removeGlobalEventJIP;
            }, // code completed
            {}, // code interrupted
            nil,
            8,
            1e6,
            true,
            false,
            true] call BIS_fnc_holdActionAdd;
            _object setVariable [QGVAR(TrapInventory_HoldAction), _holdAction];
        };
    };
};
