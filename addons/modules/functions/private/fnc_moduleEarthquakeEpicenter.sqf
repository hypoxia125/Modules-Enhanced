/* ----------------------------------------------------------------------------
Function: meh_modules_fnc_moduleEarthquakeEpicenter

Author: Hypoxic

Public: False - Requires internal data

Description:
    Function that the module calls upon initialization.
---------------------------------------------------------------------------- */

#include "script_component.hpp"

params [["_mode", "", [""]], ["_input", [], [[]]]];
_input params [
    ["_module", objNull, [objNull]],
    ["_isActivated", false, [true]],
    ["_isCuratorPlaced", false, [true]]
];

if (_mode == "connectionChanged3DEN") exitWith {
    private _synced = get3DENConnections _module apply {_x select 1};
    private _invalid = _synced select {!(_x isKindOf "MEH_ModuleEarthquakeDamageArea") && {!(_x isKindOf "EmptyDetector")}};
    if (_invalid isNotEqualTo []) then {
        [typeOf _module] call EFUNC(Error,invalidSync);
        remove3DENConnection ["Sync", _invalid, _module];
    };
};
if (_mode != "init" || {is3DEN} || {!_isActivated}) exitWith {};

private _magnitude = _module getVariable "Magnitude";
waitUntil {time > 0};

private _soundParams = switch _magnitude do {
    case 1;
    case 2;
    case 3: {["Earthquake_01", 10.012]};
    case 4;
    case 5;
    case 6: {["Earthquake_02", 12.773]};
    case 7;
    case 8: {["Earthquake_03", 13.832]};
    case 9;
    case 10: {["Earthquake_04", 15.167]};
};
_soundParams params ["_soundPath", "_duration"];

if (hasInterface) then {
    private _power = 19 * log _magnitude + 1;
    private _frequency = 99 * log _magnitude + 1;
    private _distance = player distance (ASLToAGL getPosASL _module);
    private _coef = 1 - (log (1 + _distance / (worldSize / 2)) / log 2);
    _power = _power * _coef;
    _frequency = _frequency * _coef;

    private _offset = 1;
    playSound _soundPath;
    enableCamShake true;
    player forceWalk true;
    "DynamicBlur" ppEffectEnable true;
    "DynamicBlur" ppEffectAdjust [_power / 2];
    "DynamicBlur" ppEffectCommit _offset;
    "DynamicBlur" ppEffectAdjust [0];
    "DynamicBlur" ppEffectCommit _duration;
    addCamShake [_power, _duration * 2, _frequency];

    [_duration, _offset] spawn {
        params ["_duration", "_offset"];
        sleep _offset;
        sleep _duration;
        player forceWalk false;
    };
};

if (!isServer) exitWith {};

private _buildings = [];
{
    private _damageModule = _x;
    private _area = [ASLToAGL getPosASL _damageModule] + (_damageModule getVariable "ObjectArea");
    private _radius = if (_area#4) then {sqrt ((_area#1)^2 + (_area#2)^2)} else {(_area#1) max (_area#2)};
    private _types = [];
    if (_damageModule getVariable "TypeBuilding") then {
        _types append ["BUILDING", "BUNKER", "CHAPEL", "CHURCH", "FORTRESS", "FUELSTATION", "HOSPITAL", "HOUSE", "LIGHTHOUSE", "TOURISM", "WATERTOWER", "VIEW-TOWER", "TRANSMITTER"];
    };
    if (_damageModule getVariable "TypeWall") then {_types append ["WALL", "FENCE"]};
    if (_damageModule getVariable "TypeTree") then {_types pushBack "TREE"};
    if (_damageModule getVariable "TypePowerlines") then {_types pushBack "POWERLINE"};

    private _objects = nearestTerrainObjects [_area#0, _types, _radius, false, false] select {_x inArea _area};
    if (_damageModule getVariable "TypeMissionBuilding") then {
        private _placed = [];
        {_placed append (allMissionObjects _x)} forEach ["BUILDING", "HOUSE"];
        _objects append (_placed select {_x inArea _area});
    };
    LOG_1("ModuleEarthquakeDamageArea.GetTerrainObjects:: Objects found: %1",count _objects);
    _buildings append _objects;
} forEach (synchronizedObjects _module select {_x isKindOf "MEH_ModuleEarthquakeDamageArea"});

private _rate = _duration / (count _buildings max 1);
private _destroyChance = _magnitude / 10;
[_buildings, _magnitude, _destroyChance, _rate] spawn {
    params ["_buildings", "_magnitude", "_destroyChance", "_rate"];
    while {_buildings isNotEqualTo []} do {
        sleep (_rate max 0.01);
        if (_buildings isEqualTo []) exitWith {};
        private _building = selectRandom _buildings;
        TRACE_1("ModuleEarthquakeEpicenter.DamageBuildings:: Selected building:",_building);
        if (_destroyChance <= random 1) then {
            _building setDamage 1;
        } else {
            _building setDamage (_magnitude / 10);
        };
        _buildings deleteAt (_buildings find _building);
    };
};
