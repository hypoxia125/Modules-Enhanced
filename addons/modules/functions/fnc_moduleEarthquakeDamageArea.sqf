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
if !(isServer) exitWith {};

// Variables
//------------------------------------------------------------------------------------------------
private _area = [ASLToAGL getPosASL _module] + (_module getVariable "ObjectArea");
private _dmgBuilding = _module getVariable "TypeBuilding";
private _dmgWall = _module getVariable "TypeWall";
private _dmgTree = _module getVariable "TypeTree";
private _dmgPowerlines = _module getVariable "TypePowerlines";

private _self = createHashMapObject [[
    ["module", _module],
    ["area", _area],
    ["damageTypes", []],
    ["maxRadius", (_area#1) max (_area#2)]
]];
_module setVariable [QGVAR(EarthquakeDamageArea_ModuleObject), _self];

if (_dmgBuilding) then {
    (_self get "damageTypes") insert [-1, ["BUILDING", "BUNKER", "CHAPEL", "CHURCH", "FORTRESS", "FUELSTATION", "HOSPITAL", "HOUSE", "LIGHTHOUSE", "TOURISM", "WATERTOWER", "VIEW-TOWER", "TRANSMITTER"]];
};
if (_dmgWall) then {
    (_self get "damageTypes") insert [-1, ["WALL", "FENCE"]];
};
if (_dmgTree) then {
    (_self get "damageTypes") insert [-1, ["TREE"]];
};
if (_dmgPowerlines) then {
    (_self get "damageTypes") insert [-1, ["POWERLINE"]];
};

if (_area#4) then {
    _self set ["maxRadius", sqrt((_area#1)^2 + (_area#2)^2)];
};

// Functions
//------------------------------------------------------------------------------------------------
private _getTerrainObjects = compileFinal {
    private _objects = nearestTerrainObjects [
        (_self get "area")#0,
        _self get "damageTypes",
        _self get "maxRadius",
        false,
        false
    ];
    _objects = _objects select {_x inArea (_self get "area")};

    // return
    _objects;
};
_self set ["GetTerrainObjects", _getTerrainObjects];

// Code Start
//------------------------------------------------------------------------------------------------
switch _mode do {
    case "init": {
        if (is3DEN) exitWith {};

        // we don't really do anything on this module itself - handled from connected epicenter
    };

    case "connectionChanged3DEN": {
        private _synced = get3DENConnections _module apply {_x select 1};
        private _invalid = _synced select {!(_x isKindOf "MEH_ModuleEarthquakeEpicenter")};
        if (_invalid isNotEqualTo []) then {
            [typeOf _module] call EFUNC(Error,invalidSync);

            // remove connection
            remove3DENConnection ["Sync", _invalid, _module];
        };
    };
};