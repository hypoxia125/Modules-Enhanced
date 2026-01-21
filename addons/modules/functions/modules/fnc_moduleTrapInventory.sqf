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
if (_mode in ["dragged3DEN", "unregisteredFromWorld3DEN"]) exitWith {};

// Variables
//------------------------------------------------------------------------------------------------
private _explosiveType = _module getVariable ["ExplosiveType", "GrenadeHand"];
private _explodeChance = _module getVariable "ExplodeChance";
private _canDisable = _module getVariable "CanDisable";
private _persist = _module getVariable "Persist";

if (
    _explosiveType isEqualTo "" ||
    (!(isClass (configFile >> "CfgAmmo" >> _explosiveType)))
) exitWith {[typeOf _module] call EFUNC(Error,invalidArgs)};

// Functions
//------------------------------------------------------------------------------------------------
private _trapInventory = {
    params ["_objects", "_explosiveType", "_explodeChance", "_canDisable", "_persist"];

    LOG_1("ModuleTrapInventory: Attempting to add traps to targets: %1",_objects);
    // Set global object data
    {
        private _object = _x;

        _object setVariable [QGVAR(TrapInventory_Data), [
            _explosiveType,
            _explodeChance,
            _canDisable,
            _persist,
            true
        ], true];
    } forEach _objects;

    // Global InventoryOpened EH
    private _InventoryOpenedEHCode = {
        params ["_object", "_container", "_secondaryContainer"];

        if !(local _object) exitWith {};

        // Check if container is a trap
        private _trapData = _container getVariable QGVAR(TrapInventory_Data);
        if (isNil "_trapData") exitWith {};

        // Check if trap is active
        _trapData params ["_explosiveType", "_explodeChance", "_canDisable", "_persist", "_active"];
        if (!_active) exitWith {
            LOG_1("ModuleTrapInventory: %1 is no longer active",_container);
        };

        // Check explode chance, and apply explosion
        private _explode = _explodeChance >= random 1;
        if (_explode) then {
            private _position = (ASLToAGL (getPosASL _object));
            private _explosive = createVehicle [_explosiveType, _position, [], 0, "NONE"];

            // Hide explosive if not grenade, or explode munition instantly (bombs)
            if !(_explosiveType isKindOf "Grenade") then {
                [QGVAR(HideObjectServer), [_explosive, true]] call CBA_fnc_serverEvent;
            };

            // Play pin pull sound
            [QGVAR(Say3DGlobal), [_object, "MEH_Tripwire_Pull"]] call CBA_fnc_globalEvent;

            // If in vehicle
            // If grenade, kill the crew
            // If bomb, kill whole vehicle, then all crew
            private _inVehicle = vehicle _object isNotEqualTo _object;
            if (_inVehicle) then {
                _explosive attachTo [_object, [0,0,0]];

                private _crew = crew vehicle _object;
                if (_explosiveType isKindOf "Grenade") then {
                    private _crew = crew vehicle _object;
                    {
                        [QGVAR(KillUnitServer), [_x]] call CBA_fnc_serverEvent;
                    } forEach _crew;
                } else {
                    // Add vehicle to destruction array
                    _crew = _crew + [vehicle _object];
                    {
                        [QGVAR(KillUnitServer), [_x]] call CBA_fnc_serverEvent;
                    } forEach _crew;
                }
            } else {
                if !(_explosiveType isKindOf "Grenade") then {
                    _explosive enableSimulationGlobal false;
                    [{
                        params ["_explosive"];

                        _explosive enableSimulationGlobal true;
                        triggerAmmo _explosive;
                    }, [_explosive], 2.5] call CBA_fnc_waitAndExecute;
                };
            };

            // Set trap data to inactive
            _trapData set [4, false];
            _object setVariable [QGVAR(TrapInventory_Data), _trapData, true];
        } else {
            // Not exploding, set persistance and warn player
            if (!_persist) then {
                _trapData set [4, false];
                _object setVariable [QGVAR(TrapInventory_Data), _trapData, true];
                hint LLSTRING(TrapInventory_SuccessUnknown);
            } else {
                hint LLSTRING(TrapInventory_SuccessFailed);
            };
        };
    };

    [QGVAR(AddTrapInventoryEHLocal), [_InventoryOpenedEHCode], QGVAR(TrapInventory_InventoryOpened_GlobalJIP)] call CBA_fnc_globalEventJIP;

    // Make these persist on respawns
    private _respawnEHHandler = addMissionEventHandler ["EntityRespawned", {
        params ["_newEntity", "_oldEntity"];
        _thisArgs params [["_InventoryOpenedEHCode", {}]];

        if !(isPlayer _newEntity) exitWith {};

        [QGVAR(AddTrapInventoryEHLocal), [_InventoryOpenedEHCode], _newEntity] call CBA_fnc_targetEvent;
    }];

    // Add disable action to the objects
    [QGVAR(AddTrapDisableActionLocal), [_objects], QGVAR(TrapInventory_DisableTrapAction_GlobalJIP)] call CBA_fnc_globalEventJIP;
};

meh_modules_fnc_trapInventoryActionShow = compileFinal {
    params ["_target", "_caller"];

    // If inventory is a man, only show if the man is dead
    if (typeOf _target isKindOf "CAManBase" && alive _target) exitWith {false};

    /*-----Distance Calcualation-----*/

    private _boundingBox = boundingBoxReal _target;
    _boundingBox params ["_min", "_max"];

    // find bounding box center
    private _boundingX = abs ((_min select 0) max (_max select 0));
    private _boundingY = abs ((_min select 1) max (_max select 1));
    private _boundingZ = abs ((_min select 2) max (_max select 2));

    // create area around box for later use + make it slightly bigger
    private _center = ASLToAGL (getPosASL _target);
    private _area = [_center, _boundingX + 2, _boundingY + 2, getDir _target, true, _boundingZ + 2];

    if (!(_caller inArea _area)) exitWith {false};

    /*----- Execute -----*/

    private _data = _target getVariable QGVAR(TrapInventory_Data);
    if (isNil QUOTE(_data)) exitWith {false};

    private _canDisable = _data select 2;
    private _isActive = _data select 4;

    if (!_isActive) exitWith {false};

    private _isSpecialist = _caller getUnitTrait "explosiveSpecialist";
    private _hasEquipment = (
        items _caller findIf {_x in ["ToolKit", "ACE_DefusalKit"]} != -1 &&
        items _caller findIf {_x in ["MineDetector"]} != -1
    );

    private _return = switch _canDisable do {
        case 0: {false};
        case 1: {true};
        case 2: {_hasEquipment};
        case 3: {_isSpecialist && _hasEquipment};
    };

    _return;
};

// Code Start
//------------------------------------------------------------------------------------------------
switch _mode do {
    case "init": {
        if (is3DEN) exitWith {};

        private _objects = synchronizedObjects _module select {!(_x isKindOf "EmptyDetector" || _x isKindOf "Module_F")};
        if (_objects isEqualTo []) then {[typeOf _module] call EFUNC(Error,requiresSync)};
        [_objects, _explosiveType, _explodeChance, _canDisable, _persist] call _trapInventory;
    };

    case "connectionChanged3DEN": {
        private _synced = get3DENConnections _module apply {_x select 1};
        private _invalid = _synced select {(_x isKindOf "EmptyDetector" || _x isKindOf "Module_F")};
        if (_invalid isNotEqualTo []) then {
            [typeOf _module] call EFUNC(Error,invalidSync);

            // remove connection
            remove3DENConnection ["Sync", _invalid, _module];
        };
    };

    default {};
};
