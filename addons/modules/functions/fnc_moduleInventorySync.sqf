#include "script_component.hpp"

// Parameters
//------------------------------------------------------------------------------------------------
params [
    ["_mode", "", [""]],
    ["_input", [], [[]]]
];
_input params [
    ["_module", objNull, [objNull]],
    ["_isActivated", false, [true]],
    ["_isCuratorPlaced", false, [true]]
];

// Pre-Execution Checks
//------------------------------------------------------------------------------------------------
if (!is3DEN && {!_isActivated}) exitWith {};
if !(_mode in ["init"]) exitWith {};

private _identifier = _module getVariable ["Identifier", ""];
_identifier = toLowerANSI _identifier;
if (_identifier == "") exitWith {};

private _saveLocation = _module getVariable "SaveLocation";
switch _saveLocation do {
    case 0: { _saveLocation = "SERVER" };
    case 1: { _saveLocation = "EVERYONE" };
};

private _synchronizedInventories = [];
private _syncedObjects = [_module, ["AMMOBOX"]] call FUNC(getSynchronizedObjectsFiltered);
{
    _x setVariable [QGVAR(InventorySync_Identifier), _identifier, true];
    _x setVariable [QGVAR(InventorySync_Mode), _saveLocation, true];

    _synchronizedInventories pushBack _x;
} forEach _syncedObjects;
missionNamespace setVariable [QGVAR(InventorySync_Inventories), _synchronizedInventories, true];

{
    _x addEventHandler ["Put", {
        params ["_unit", "_container", "_item"];

        private _inventories = missionNamespace getVariable [QGVAR(InventorySync_Inventories), []];
        if (!(_container in _inventories)) exitWith {};

        private _identifier = _container getVariable [QGVAR(InventorySync_Identifier), ""];
        if (_identifier == "") exitWith {};

        private _mode = _container getVariable [QGVAR(InventorySync_Mode), "SERVER"];

        private _data = profileNamespace getVariable [QGVAR(InventorySyncData), createHashmap];
        private _inventoryData = _data getOrDefault [_identifier, []];

        _inventoryData pushBack _item;

        [QGVAR(UpdateInventories), [_identifier, _inventoryData]] call CBA_fnc_serverEvent;

        if (_mode == "EVERYONE") then {
            [QGVAR(InventorySync_SendData), [_identifier, _inventoryData], format["%1: InventoryData", _container]] call CBA_fnc_globalEventJIP;
        };
    }];

    _x addEventHandler ["Take", {
        params ["_unit", "_container", "_item"];

        private _inventories = missionNamespace getVariable [QGVAR(InventorySync_Inventories), []];
        if (!(_container in _inventories)) exitWith {};

        private _identifier = _container getVariable [QGVAR(InventorySync_Identifier), ""];
        if (_identifier == "") exitWith {};

        private _mode = _container getVariable [QGVAR(InventorySync_Mode), "SERVER"];

        private _data = profileNamespace getVariable [QGVAR(InventorySyncData), createHashmap];
        private _inventoryData = _data getOrDefault [_identifier, []];

        private _index = _inventoryData find _item;
        if (_index != -1) then { _inventoryData deleteAt _index };

        [QGVAR(UpdateInventories), [_identifier, _inventoryData]] call CBA_fnc_serverEvent;

        if (_mode == "EVERYONE") then {
            [QGVAR(InventorySync_SendData), [_identifier, _inventoryData], format["%1: InventoryData", _container]] call CBA_fnc_globalEventJIP;
        };
    }];
} forEach _syncedObjects;