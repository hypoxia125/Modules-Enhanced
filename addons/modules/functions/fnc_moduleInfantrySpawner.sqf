// TODO - Need to script the task functions for the unit behavior logic

#include "script_component.hpp"

#define TICKRATE   1

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
if !(isServer) exitWith {};

// Variables
//------------------------------------------------------------------------------------------------
private _position = getPosATL _module;
private _area = _module getVariable "ObjectArea";
private _minimumRadius = _area#0 min _area#1;
private _side = switch (_module getVariable "Side") do {
    case 0: { east };
    case 1: { west };
    case 2: { independent };
    case 3: { civilian };
    default { sideUnknown };
};
private _unitList = _module getVariable "Units";
private _unitLimit = _module getVariable "UnitLimit";
private _unitsPerSquad = _module getVariable "UnitsPerSquad";
private _unitRespawnTime = (_module getVariable "UnitRespawnTime");
private _respawnTickets = _module getVariable "RespawnTickets";
private _waitForFullSquad = _module getVariable "WaitForFullSquad";
private _unitLogic = _module getVariable "UnitLogic";
private _expression = compile (_module getVariable ["Expression", ""]);
private _deactivationRadius = _module getVariable "DeactivationRadius";

private _connectedWaypointModules = synchronizedObjects _module select {_x isKindOf "MEH_ModuleSpawnerWaypoint"};

private _moduleObject = createHashMapObject [[
    ["#type", "ModuleInfantrySpawner"],
    ["activeUnits", []],
    ["module", _module],
    ["position", _position],
    ["area", _area],
    ["minimumRadius", _minimumRadius],
    ["side", _side],
    ["unitList", _unitList],
    ["unitLimit", _unitLimit],
    ["unitsPerSquad", _unitsPerSquad],
    ["unitRespawnTime", _unitRespawnTime],
    ["respawnTickets", _respawnTickets],
    ["waitForFullSquad", _waitForFullSquad],
    ["unitLogic", _unitLogic],
    ["unitRespawnTimeLeft", 0],
    ["expression", _expression],
    ["connectedWaypointModules", _connectedWaypointModules],
    ["deactivationRadius", _deactivationRadius]
]];

LOG("-----------------ModuleInfantrySpawnerObject-----------------");
{
    LOG_2("ModuleInfantrySpawnerObject:: %1: %2",_x,_y);
} forEach _moduleObject;

// Functions
//------------------------------------------------------------------------------------------------

// AddUnitsToActiveUnits
// -- Adds an array of units to the active units array for limit tracking
private _addUnitsToActiveUnits = compileFinal {
    params ["_units"];

    private _activeUnits = _self get "activeUnits";
    _activeUnits insert [-1, _units, true];
    _self set ["activeUnits", _activeUnits];
};
_moduleObject set ["AddUnitsToActiveUnits", _addUnitsToActiveUnits];

// BuildWaypointsFromModules
// -- Takes data from connected modules and builds them into a useable hashmap for the system
private _buildWaypointsFromModules = compileFinal {
    private _connectedWaypointModules = _self get "connectedWaypointModules";

    LOG_1("ModuleInfantrySpawner:: BuildWaypointsFromModules: Connected Modules - %1",_connectedWaypointModules);

    private _wpDataMaster = createHashMap;
    {
        private _wpModule = _x;
        private _wpData = _wpModule getVariable [QGVAR(SpawnerWP_WPData), []];

        _wpData params ["_index", "_wpPos", "_wpType"];
        if (_index < 0) then { continue };

        private _wps = _wpDataMaster getOrDefault [_index, [], true];
        _wps insert [-1, [[_wpPos, _wpType]]];

        _wpDataMaster set [_index, _wps];
    } forEach _connectedWaypointModules;
    
    // return
    LOG("ModuleInfantrySpawner:: WPDataMaster");
    {
        LOG_2("WPDataMaster:: %1: %2",_x,_y);
    } forEach _wpDataMaster;
    _wpDataMaster;
};
_moduleObject set ["BuildWaypointsFromModules", _buildWaypointsFromModules];

// ClearDeadActiveUnits
// -- Removes dead units from the active units lists so that more can spawn
private _clearDeadActiveUnits = compileFinal {
    LOG("ModuleInfantrySpawner:: Clearing dead active units...");
    private _activeUnits = _self get "activeUnits";
    _activeUnits = _activeUnits select {alive _x};

    _self set ["activeUnits", _activeUnits];
};
_moduleObject set ["ClearDeadActiveUnits", _clearDeadActiveUnits];

// CreateGroup
// -- Creates groups and units and gives them waypoints
private _createGroup = compileFinal {
    params ["_unitsToSpawn"];

    private _unitList = _self get "unitList";
    private _side = _self get "side";
    private _position = _self get "position";
    private _minimumRadius = _self get "minimumRadius";

    private _group = createGroup [_side, true];
    {
        deleteWaypoint _x;
    } forEach waypoints _group;

    {
        private _unitType = _x;
        private _unit = _group createUnit [_unitType, _position, [], _minimumRadius, "NONE"];

        // safety check for correct side - remove in case bug is fixed: TODO
        [_unit] joinSilent _group;

        _self call ["AddUnitsToActiveUnits", [[_unit]]];
    } forEach _unitsToSpawn;

    // Save module object to group namespace for later
    _group setVariable [QGVAR(InfantrySpawner_SpawnerObject), _self];

    // return
    _group;
};
_moduleObject set ["CreateGroup", _createGroup];

// GetNumberAvailableSlots
// -- Gets the number of slots available for new units until unit limit is reached
private _getNumberAvailableSlots = compileFinal {
    private _unitLimit = _self get "unitLimit";
    private _activeUnits = _self get "activeUnits";

    // return
    _unitLimit - count _activeUnits;
};
_moduleObject set ["GetNumberAvailableSlots", _getNumberAvailableSlots];

// GetUnitsToSpawn
// -- Gets the unit classes to spawn when provided the amount of units
private _getUnitsToSpawn = compileFinal {
    params ["_numOfUnits"];

    if (_numOfUnits <= 0) exitWith { [] };

    private _unitsToSpawn = [];
    for "_i" from 1 to _numOfUnits do {
        _unitsToSpawn pushBack (selectRandom (_self get "unitList"));
    };

    // return
    _unitsToSpawn;
};
_moduleObject set ["GetUnitsToSpawn", _getUnitsToSpawn];

// HasBeenDisabledByEnemy
// -- Checks to see if enemy units are within the deactivation radius
private _hasBeenDisabledByEnemy = compileFinal {
    private _sides = [_self get "side"] + [civilian];
    private _units = allUnits select {!(side group _x in _sides)};
    private _position = _self get "position";
    private _distanceToDisable = _self get "deactivationRadius";

    // return
    _units findIf {_x distance _position <= _distanceToDisable} != -1;
};
_moduleObject set ["HasBeenDisabledByEnemy", _hasBeenDisabledByEnemy];

// Init
// -- Provides the loop logic for the module
private _init = compileFinal {
    LOG("ModuleInfantrySpawner:: Starting Module Init...");

    [{
        params ["_args", "_handle"];
        _args params ["_self"];

        LOG_1("---------- ModuleInfantrySpawner:: %1 ----------",_self get "#type");

        if (isGamePaused) exitWith {};
        if (!alive (_self get "module")) exitWith {
            LOG_1("ModuleInfantrySpawner:: Module %1 is no longer alive... stopping backend.",_self get "module");
            _handle call CBA_fnc_removePerFrameHandler;
        };
        if (_self call ["HasBeenDisabledByEnemy"]) exitWith {
            LOG("ModuleInfantrySpawner:: Enemies too close to spawner... disabling...");
            _handle call CBA_fnc_removePerFrameHandler;
        };
        if (_self get "respawnTickets" <= 0) exitWith {
            LOG_1("ModuleInfantrySpawner:: Module %1 no longer has respawn tickets... Destroying system.",_self get "module");
            _handle call CBA_fnc_removePerFrameHandler;
        };

        // Exit if its not time to spawn the units
        private _respawnTimeLeft = _self get "unitRespawnTimeLeft";
        if (_respawnTimeLeft > 0) exitWith {
            LOG_1("ModuleInfantrySpawner:: Current Respawn Time Left: %1",_respawnTimeLeft);
            _respawnTimeLeft = _respawnTimeLeft - TICKRATE;
            _self set ["unitRespawnTimeLeft", _respawnTimeLeft];
        };

        // Clear all dead units from system
        _self call ["ClearDeadActiveUnits"];

        // Get units while waiting for full squads
        private _waitForFullSquad = _self get "waitForFullSquad";
        private _numSlots = _self call ["GetNumberAvailableSlots"];
        LOG_1("ModuleInfantrySpawner:: Available slots: %1",_numSlots);
        private _unitsToSpawn = [];
        private _waypoints = [];
        if (
            _waitForFullSquad &&
            _numSlots >= (_self get "unitsPerSquad")
        ) then {
            LOG("ModuleInfantrySpawner:: Spawning infantry (wait for full squad)...");

            _unitsToSpawn = _self call ["GetUnitsToSpawn", [_self get "unitsPerSquad"]];
        };

        // Get units without waiting for full squads
        if (
            !(_waitForFullSquad) &&
            _numSlots > 0
        ) then {
            LOG("ModuleInfantrySpawner:: Spawning infantry (not waiting for full squad)...");

            _unitsToSpawn = _self call ["GetUnitsToSpawn", [_numSlots min (_self get "unitsPerSquad")]];
        };

        // Spawn group and units
        private _group = _self call ["CreateGroup", [_unitsToSpawn]];

        // Choose a behaviour
        switch (_self get "unitLogic") do {
            case 0: {
                // Defend and patrol
                _waypoints = _self call ["TaskPatrol", [_group]];
            };
            case 1: {
                // Garrison
                _self call ["TaskGarrison", [_group]];
            };
            case 2: {
                // Use WP Modules
                _waypoints = _self call ["TaskUseWaypointModules", [_group]];
            };
            default {
                // Do nothing. Handle with expression call below
            };
        };

        // Call custom code on the group
        [_group, _waypoints] call (_self get "expression");

        // Reset timer
        _self call ["ResetUnitRespawnTimeLeft"];

    }, TICKRATE, [_moduleObject]] call CBA_fnc_addPerFrameHandler;
};
_moduleObject set ["Init", _init];

// ModifyRespawnTickets
// -- Modifies the respawn tickets from the module
private _modifyRespawnTickets = compileFinal {
    params ["_change"];

    private _tickets = _self get "respawnTickets";
    _tickets = _tickets + _change;
    _self set ["respawnTickets", _tickets];

    // return
    _tickets;
};

// ResetUnitRespawnTimeLeft
// -- Resets the timer for the module spawn loop
private _resetUnitRespawnTimeLeft = compileFinal {
    LOG("ModuleInfantrySpawner:: Resetting spawn timer...");
    _self set ["unitRespawnTimeLeft", _self get "unitRespawnTime"];
};
_moduleObject set ["ResetUnitRespawnTimeLeft", _resetUnitRespawnTimeLeft];

// SetWaypoints
// -- Sets waypoints for a group of units
private _setWaypoints = compileFinal {
    params ["_group", "_wpData"];

    {
        private _index = _x;
        private _data = selectRandom _y;

        _data params ["_wpPos", "_wpType"];

        LOG("ModuleInfantrySpawner:: Adding waypoint to group...");
        LOG_1("Index: %1",_index);
        LOG_1("Position: %1",_wpPos);
        LOG_1("Type: %1",_wpType);

        private _wp = _group addWaypoint [_wpPos, -1, _index];
        _wp setWaypointType _wpType;
    } forEach _wpData;
};
_moduleObject set ["SetWaypoints", _setWaypoints];

// TaskPatrol
// -- Sets waypoints for a patrol. When finished, it recreates a new set of waypoints
private _taskPatrol = compileFinal {
    params ["_group"];

    [_group] call CBA_fnc_clearWaypoints;
    private _position = _self get "position";
    private _area = _self get "area";
    _area = [_position] + _area;

    for "_i" from 1 to 4 do {
        private _pos = [[_area]] call BIS_fnc_randomPos;
        private _wp = _group addWaypoint [_pos, -1];
        _wp setWaypointBehaviour "SAFE";


        if (_i == 4) then {
            _wp setWaypointStatements [
                toString { true },
                toString {
                    if !(local this) exitWith {};
                    private _group = group this;
                    private _spawnerObject = _group getVariable QGVAR(InfantrySpawner_SpawnerObject);
                    if (isNil "_spawnerObject") exitWith {};
                    _spawnerObject call ["TaskPatrol", [_group]];
                }
            ];
        };
    };

    // return
    waypoints _group;
};
_moduleObject set ["TaskPatrol", _taskPatrol];

// TaskGarrison
// -- Garrisons units in available positions and disables their pathing
private _taskGarrison = compileFinal {
    params ["_group"];

    [_group] call CBA_fnc_clearWaypoints;
    private _position = _self get "position";
    private _area = _self get "area";
    _area = [_position] + _area;
    private _maxRadius = (_area#1 max _area#2) * 2;

    private _nearbyBuildings = nearestTerrainObjects [_position, ["House"], _maxRadius, false, true];
    LOG_1("ModuleInfantrySpawner:: TaskGarrison: Nearby buildings: %1",_nearbyBuildings);

    // filter out buildings outside of area
    _nearbyBuildings = _nearbyBuildings select {_x inArea _area};
    LOG_1("ModuleInfantrySpawner:: TaskGarrison: Nearby buildings filtered: %1",_nearbyBuildings);

    private _allPositions = [];
    {
        private _building = _x;
        private _positions = _building buildingPos -1;
        _allPositions insert [-1, _positions, true];
    } forEach _nearbyBuildings;
    LOG_1("ModuleInfantrySpawner:: TaskGarrison: All building positions: %1",_allPositions);
    
    // convert from AGL to ASL
    LOG("ModuleInfantrySpawner:: TaskGarrison: Converting building positions to ASL...");
    _allPositions = _allPositions apply {AGLToASL _x};
    LOG_1("ModuleInfantrySpawner:: TaskGarrison: All building positions ASL: %1",_allPositions);

    {
        private _unit = _x;
        private _pos = getPosASL _unit;

        for "_i" from 1 to 1000 do {
            private _candidate = selectRandom _allPositions;
            if (allUnits findIf {_x distance _candidate <= 3} == -1) exitWith {
                _pos = _candidate;
            };
        };

        _unit setPosASL _pos;
        _unit disableAI "PATH";
    } forEach (units _group);
};
_moduleObject set ["TaskGarrison", _taskGarrison];

// TaskUseWaypointModules
// -- Uses the connected waypoint modules to create a series of waypoints
private _taskUseWaypointModules = compileFinal {
    params ["_group"];

    private _waypointData = _self call ["BuildWaypointsFromModules"];

    {
        private _index = _x;
        private _waypoint = selectRandom _y;
        _waypoint params ["_wpPos", "_wpType"];

        private _wp = _group addWaypoint [_wpPos, -1, _index];
        _wp setWaypointType _wpType;
    } forEach _waypointData;

    // return
    waypoints _group;
};
_moduleObject set ["TaskUseWaypointModules", _taskUseWaypointModules];

// Code Start
//------------------------------------------------------------------------------------------------
switch _mode do {
    case "init": {
        if (is3DEN) exitWith {};
        if !(_isActivated) exitWith {};

        _moduleObject call ["Init"];
    };
};