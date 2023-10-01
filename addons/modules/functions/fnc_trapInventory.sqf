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
        
        _object setVariable [QGVAR(TrapInventory_Data), [_explosiveType, _explodeChance, _canDisable, _persist, true], true];
    }; 
};

if (hasInterface) then {
    // Add event handler
    private _handle = player addEventHandler ["InventoryOpened", {
        params ["_object", "_container", "_secondaryContainer"];

        private _trapData = _container getVariable QGVAR(TrapInventory_Data);
        if (isNil QUOTE(_trapData)) exitWith {};

        _trapData params ["_explosiveType", "_explodeChance", "_canDisable", "_persist", "_active"];

        if (!_active) exitWith {};
        
        if (_explodeChance >= random 1) exitWith {
            private _explosive = createVehicle [_explosiveType, getPosASL _object vectorAdd [0,0,2], [], 0, "NONE"];
            [QGVAR(HideObjectGlobal), [_explosive, true]] call CBA_fnc_serverEvent;
            _explosive setDamage 1;

            _trapData set [4, false];
            _object setVariable [QGVAR(TrapInventory_Data), _trapData, true];
        };

        if (!_persist) then {
            _trapData set [4, false];
            _object setVariable [QGVAR(TrapInventory_Data), _trapData, true];
            hint LLSTRING(TrapInventory_SuccessUnknown);
        } else {
            hint LLSTRING(TrapInventory_SuccessFailed);
        };
    }];
    player setVariable [QGVAR(TrapInventory_EH), ["InventoryOpened", _handle]];

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
            30,
            1e6,
            true,
            false,
            true] call BIS_fnc_holdActionAdd;
            _object setVariable [QGVAR(TrapInventory_HoldAction), _holdAction];
        };
    };
};