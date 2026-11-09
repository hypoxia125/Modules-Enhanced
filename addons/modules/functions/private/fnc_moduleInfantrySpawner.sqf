/* ----------------------------------------------------------------------------
Function: meh_modules_fnc_moduleInfantrySpawner

Author: Hypoxic

Public: False - Requires internal data

Description:
    Function that the module calls upon initialization.
---------------------------------------------------------------------------- */

#include "script_component.hpp"

#define TICKRATE 1

params [["_mode", "", [""]], ["_input", [], [[]]]];
_input params [
    ["_module", objNull, [objNull]],
    ["_isActivated", false, [true]],
    ["_isCuratorPlaced", false, [true]]
];
if (!isServer || {is3DEN} || {_mode != "init"} || {!_isActivated}) exitWith {};

private _position = getPosATL _module;
private _area = _module getVariable "ObjectArea";
private _minimumRadius = (_area#0) min (_area#1);
private _side = switch (_module getVariable "Side") do {
    case 0: {east};
    case 1: {west};
    case 2: {independent};
    case 3: {civilian};
    default {sideUnknown};
};
private _unitList = _module getVariable "Units";
private _unitLimit = _module getVariable "UnitLimit";
private _unitsPerSquad = _module getVariable "UnitsPerSquad";
private _unitRespawnTime = _module getVariable "UnitRespawnTime";
private _respawnTickets = _module getVariable "RespawnTickets";
private _waitForFullSquad = _module getVariable "WaitForFullSquad";
private _unitLogic = _module getVariable "UnitLogic";
private _expression = compile (_module getVariable ["Expression", ""]);
private _deactivationRadius = _module getVariable "DeactivationRadius";
private _connectedWaypointModules = synchronizedObjects _module select {_x isKindOf "MEH_ModuleSpawnerWaypoint"};

[_module, _position, _area, _minimumRadius, _side, _unitList, _unitLimit, _unitsPerSquad, _unitRespawnTime, _respawnTickets, _waitForFullSquad, _unitLogic, _expression, _deactivationRadius, _connectedWaypointModules] spawn {
    params ["_module", "_position", "_area", "_minimumRadius", "_side", "_unitList", "_unitLimit", "_unitsPerSquad", "_unitRespawnTime", "_respawnTickets", "_waitForFullSquad", "_unitLogic", "_expression", "_deactivationRadius", "_connectedWaypointModules"];
    private _activeUnits = [];
    private _unitRespawnTimeLeft = 0;

    while {true} do {
        sleep TICKRATE;
        if (isGamePaused) then {continue};
        if (!alive _module) exitWith {
            LOG_1("ModuleInfantrySpawner:: Module %1 is no longer alive... stopping backend.",_module);
        };
        private _enemySides = [_side, civilian];
        if (allUnits findIf {!(side group _x in _enemySides) && {_x distance _position <= _deactivationRadius}} != -1) exitWith {
            LOG("ModuleInfantrySpawner:: Enemies too close to spawner... disabling...");
        };
        if (_respawnTickets <= 0) exitWith {
            LOG_1("ModuleInfantrySpawner:: Module %1 no longer has respawn tickets... Destroying system.",_module);
        };
        if (_unitRespawnTimeLeft > 0) then {
            _unitRespawnTimeLeft = _unitRespawnTimeLeft - TICKRATE;
            continue;
        };

        _activeUnits = _activeUnits select {alive _x};
        private _numSlots = _unitLimit - count _activeUnits;
        private _numToSpawn = if (_waitForFullSquad) then {
            [0, _unitsPerSquad] select (_numSlots >= _unitsPerSquad)
        } else {
            _numSlots min _unitsPerSquad max 0
        };
        private _unitsToSpawn = [];
        for "_i" from 1 to _numToSpawn do {
            _unitsToSpawn pushBack (selectRandom _unitList);
        };

        private _group = createGroup [_side, true];
        {deleteWaypoint _x} forEach waypoints _group;
        {
            private _unit = _group createUnit [_x, _position, [], _minimumRadius, "NONE"];
            [_unit] joinSilent _group;
            _activeUnits pushBackUnique _unit;
        } forEach _unitsToSpawn;
        _group setVariable [QGVAR(InfantrySpawner_Module), _module];

        private _waypoints = [];
        switch _unitLogic do {
            case 0: {
                _waypoints = [_group, _position, _area] call FUNC(infantrySpawner_taskPatrol);
            };
            case 1: {
                [_group] call CBA_fnc_clearWaypoints;
                private _fullArea = [_position] + _area;
                private _maxRadius = ((_fullArea#1) max (_fullArea#2)) * 2;
                private _buildings = nearestTerrainObjects [_position, ["House"], _maxRadius, false, true];
                _buildings append ((_position nearObjects ["House", _maxRadius]) select {_x buildingPos -1 isNotEqualTo []});
                _buildings = _buildings select {_x inArea _fullArea};
                private _positions = [];
                {_positions append (_x buildingPos -1)} forEach _buildings;
                _positions = _positions apply {AGLToASL _x};
                {
                    private _unit = _x;
                    private _pos = getPosASL _unit;
                    for "_i" from 1 to 1000 do {
                        private _candidate = selectRandom _positions;
                        if (allUnits findIf {_x distance _candidate <= 3} == -1) exitWith {_pos = _candidate};
                    };
                    _unit setPosASL _pos;
                    _unit disableAI "PATH";
                } forEach units _group;
            };
            case 2: {
                private _wpData = createHashMap;
                {
                    (_x getVariable [QGVAR(SpawnerWP_WPData), []]) params ["_index", "_wpPos", "_wpType"];
                    if (_index < 0) then {continue};
                    private _wps = _wpData getOrDefault [_index, [], true];
                    _wps pushBack [_wpPos, _wpType];
                } forEach _connectedWaypointModules;
                {
                    (selectRandom _y) params ["_wpPos", "_wpType"];
                    private _wp = _group addWaypoint [_wpPos, -1, _x];
                    _wp setWaypointType _wpType;
                } forEach _wpData;
                _waypoints = waypoints _group;
            };
        };
        [_group, _waypoints] call _expression;
        _unitRespawnTimeLeft = _unitRespawnTime;
    };
};
