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

LOG_1("ModuleInventorySync | Initializing Module: %1",_module);

// Pre-Execution Checks
//------------------------------------------------------------------------------------------------
if (is3DEN) exitWith {};
if !(_mode in ["init"]) exitWith {};

private _identifier = _module getVariable ["Identifier", ""];
_identifier = toLowerANSI _identifier;
if (_identifier == "") exitWith {};

private _saveLocation = _module getVariable "SaveLocation";
switch _saveLocation do {
    case 0: { _saveLocation = "SERVER" };
    case 1: { _saveLocation = "EVERYONE" };
};

private _clearIdentifier = _module getVariable "ClearIdentifier";
private _refreshRate = _module getVariable ["RefreshRate", 0.5];
if (_refreshRate < 0) then { _refreshRate = 0 };

// Initialize profile var
if (isNil { profileNamespace getVariable QGVAR(InventorySyncData) }) then {
    profileNamespace setVariable [QGVAR(InventorySyncData), createHashMap];
};
if (_clearIdentifier) then {
    private _data = profileNamespace getVariable QGVAR(InventorySyncData);
    _data set [_identifier, []];
};

// Initialize Inventories
private _synchronizedInventories = [];
private _syncedObjects = [_module, ["AMMOBOX"]] call FUNC(getSynchronizedObjectsFiltered);
LOG_1("ModuleInventorySync | Synced Objects: %1",count _syncedObjects);

{
    private _container = _x;

    _container setVariable [QGVAR(InventorySync_Identifier), _identifier, true];
    _container setVariable [QGVAR(InventorySync_Mode), _saveLocation, true];

    _synchronizedInventories pushBack _container;
} forEach _syncedObjects;
missionNamespace setVariable [QGVAR(InventorySync_Inventories), _synchronizedInventories, true];

{
    private _container = _x;

    // Sync inventories at start
    INFO_1("moduleInventorySync | Container [%1], clearing inventory",_container);
    clearItemCargo _container;
    clearMagazineCargo _container;
    clearWeaponCargo _container;
    clearBackpackCargo _container;

    INFO_1("moduleInventorySync | Container [%1], syncing inventory",_container);

    private _data = profileNamespace getVariable QGVAR(InventorySyncData);
    private _inventoryData = _data getOrDefault [_identifier, []];

    [QGVAR(UpdateInventories), [_identifier, _inventoryData]] call CBA_fnc_serverEvent;
} forEach _syncedObjects;

// Per Frame Handler
if (isNil { missionNamespace getVariable QGVAR(InventorySync_FrameHandler) }) then {
    private _handle = [{
        params ["_args", "_handle"];
        
        private _inventories = missionNamespace getVariable [QGVAR(InventorySync_Inventories), []];
        if (_inventories isEqualTo []) exitWith {};

        {
            private _container = _x;
            private _identifier = _container getVariable [QGVAR(InventorySync_Identifier), ""];
            private _mode = _container getVariable [QGVAR(InventorySync_Mode), "SERVER"];

            private _data = profileNamespace getVariable QGVAR(InventorySyncData);
            private _inventoryData = _data getOrDefault [_identifier, []];

            LOG_1("ModuleInventorySync::PerFrameHandler | InventoryData: %1",_inventoryData);

            private _currentInventory =
                magazineCargo _container +
                itemCargo _container +
                weaponCargo _container +
                backpackCargo _container;
            LOG_2("ModuleInventorySync::PerFrameHandler | Current inventory for container %1: %2",_container,_currentInventory);

            // Check to see if inventory data is equal (but originals are out of order so you can't use isEqualTo)
            private _inventoryDataCount = createHashMap;
            private _currentInventoryCount = createHashMap;
            { _inventoryDataCount set [_x, (_inventoryDataCount getOrDefault [_x, 0]) + 1] } forEach _inventoryData;
            { _currentInventoryCount set [_x, (_currentInventoryCount getOrDefault [_x, 0]) + 1] } forEach _currentInventory;
            private _allKeys = (keys _inventoryDataCount) + (keys _currentInventoryCount);
            private _isEqual = true;
            {
                if ((_inventoryDataCount getOrDefault [_x, 0]) != (_currentInventoryCount getOrDefault [_x, 0])) exitWith { _isEqual = false };
            } forEach _allKeys;

            if (_isEqual) then { continue };

            LOG_1("ModuleInventorySync::PerFrameHandler | Difference in inventory found for container [%1]",_container);

            _data set [_identifier, _currentInventory];
            [QGVAR(UpdateInventories), [_identifier, _currentInventory]] call CBA_fnc_serverEvent;

            if (_mode == "EVERYONE") then {
                [QGVAR(InventorySync_SendData), [_identifier, _currentInventory], format["%1: InventoryData", _container]] call CBA_fnc_globalEventJIP;
            };
        } forEach _inventories;
    }, _refreshRate, []] call CBA_fnc_addPerFrameHandler;

    missionNamespace setVariable [QGVAR(InventorySync_FrameHandler), _handle];
};
