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

// Variables
//------------------------------------------------------------------------------------------------
private _magnitude = _module getVariable "Magnitude";

private _moduleObject = createHashMapObject [[
    ["module", _module],
    ["magnitude", _magnitude],
    ["activeSound", objNull],
    ["quakeActive", false]
]];

_module setVariable [QGVAR(EarthquakeEpicenter_ModuleObject), _moduleObject];

// Functions
//------------------------------------------------------------------------------------------------
private _createEarthquake = compileFinal {
    // set variables for earthquake start
    _self set ["quakeActive", true];

    // start effects - locally
    _self call ["EarthquakeEffectLocal"];
    
    // destroy buildings - server only
    if (isServer) then {
        private _duration = (_self call ["GetEarthquakeSoundParams"]) param [1];
        _self call ["DamageBuildings", [
            _self call ["GetConnectedDamageAreaBuildings"],
            _self get "magnitude",
            _duration
        ]];
    };
};
_moduleObject set ["CreateEarthquake", _createEarthquake];

private _getEarthquakeSoundParams = compileFinal {
    private _soundPathAndDuration = switch (_self get "magnitude") do {
        case 1;
        case 2;
        case 3: { ["Earthquake_01", 10.012] };
        case 4;
        case 5;
        case 6: { ["Earthquake_02", 12.773] };
        case 7;
        case 8: { ["Earthquake_03", 13.832] };
        case 9;
        case 10: { ["Earthquake_04", 15.167] };
    };

    // return
    _soundPathAndDuration;
};
_moduleObject set ["GetEarthquakeSoundParams", _getEarthquakeSoundParams];

private _getEarthquakeParams = compileFinal {
    params ["_magnitude"];

    // y = 19 * log(x) + 1
    private _power = 19 * log(_magnitude) + 1;

    // y = 99 * log(x) + 1
    private _frequency = 99 * log(_magnitude) + 1;

    // return
    [_power, _frequency];
};
_moduleObject set ["GetEarthquakeParams", _getEarthquakeParams];

private _getEarthquakeParamsCoef = compileFinal {
    params ["_distance"];

    private _worldSize = worldSize / 2;
    private _normalizedDistance = _distance / _worldSize;

    // y = 1 - (log(1 + x) / log(2));
    private _coef = 1 - (log(1 + _normalizedDistance) / log(2));

    // return
    _coef;
};
_moduleObject set ["GetEarthquakeParamsCoef", _getEarthquakeParamsCoef];

private _getConnectedDamageAreaBuildings = compileFinal {
    private _synchronizedModules = synchronizedObjects (_self get "module");
    _synchronizedModules = _synchronizedModules select {_x isKindOf "MEH_ModuleEarthquakeDamageArea"};

    private _buildingsToDamage = [];
    {
        private _module = _x;
        private _moduleObject = _x getVariable [QGVAR(EarthquakeDamageArea_ModuleObject), createHashMapObject [[]]];
        private _buildings = _moduleObject call ["GetTerrainObjects"];

        _buildingsToDamage insert [-1, _buildings];
    } forEach _synchronizedModules;

    // return
    _buildingsToDamage;
};
_moduleObject set ["GetConnectedDamageAreaBuildings", _getConnectedDamageAreaBuildings];

private _damageBuildings = compileFinal {
    params ["_buildings", "_magnitude", "_duration"];

    private _buildingCount = count _buildings;
    private _rate = _duration / (_buildingCount max 1);
    private _buildingDestroyChance = 1 * (_magnitude / 10);

    [{
        params ["_args", "_handle"];
        _args params ["_self", "_magnitude", "_buildings", "_buildingDestroyChance"];

        if (_buildings isEqualTo []) exitWith {
            _handle call CBA_fnc_removePerFrameHandler;
        };

        private _building = selectRandom _buildings;
        TRACE_1("ModuleEarthquakeEpicenter.DamageBuildings:: Selected building:",_building);
        private _destroy = _buildingDestroyChance <= random 1;
        if (_destroy) then {
            _building setDamage 1;
        } else {
            _building setDamage (_magnitude / 10);
        };

        private _index = _buildings find _building;
        if (_index != -1) then {
            _buildings deleteAt _index;
        };
    }, _rate, [_self, _magnitude, _buildings, _buildingDestroyChance]] call CBA_fnc_addPerFrameHandler;
};
_moduleObject set ["DamageBuildings", _damageBuildings];

// EarthquakeEffectLocal
// -- Starts the earthquake effects locally
private _earthquakeEffectLocal = compileFinal {
    if (!hasInterface) exitWith {};

    private _module = _self get "module";

    // calculate the power and frequency from magnitude
    private _earthquakeParams = _self call ["GetEarthquakeParams", [_self get "magnitude"]];
    _earthquakeParams params [["_power", 1], ["_frequency", 1]];

    // get player distance and use that to determine final outputs
    private _positionAGL = ASLToAGL (getPosASL _module);
    private _distance = player distance _positionAGL;
    private _earthquakeParamsCoef = _self call ["GetEarthquakeParamsCoef", [_distance]];

    _power = _power * _earthquakeParamsCoef;
    _frequency = _frequency * _earthquakeParamsCoef;

    // add a offset so that there is a delay before the drop off
    // of the screen shake starts to end
    private _offset = 1;
    
    // play earthquake sound looping
    private _soundPathAndDuration = _self call ["GetEarthquakeSoundParams"];
    _soundPathAndDuration params ["_soundPath", "_duration"];
    private _sound = playSound _soundPath;

    // shake it baby
    enableCamShake true;
    player forceWalk true;
    "DynamicBlur" ppEffectEnable true;
    "DynamicBlur" ppEffectAdjust [_power/2];
    "DynamicBlur" ppEffectCommit _offset;

    "DynamicBlur" ppEffectAdjust [0];
    "DynamicBlur" ppEffectCommit _duration;
    addCamShake [_power, _duration*2, _frequency];

    // start the fade off effects after offset time
    [{
        params ["_self", "_power", "_duration", "_frequency"];

        if (player inArea (_self get "effectRange")) then {
            "DynamicBlur" ppEffectAdjust [0];
            "DynamicBlur" ppEffectCommit _duration;
        };

        [{
            params ["_self"];

            player forceWalk false;
            _self set ["quakeActive", false];
        }, [_self], _duration] call CBA_fnc_waitAndExecute;
    }, [_self, _power, _duration, _frequency], _offset] call CBA_fnc_waitAndExecute;
};
_moduleObject set ["EarthquakeEffectLocal", _earthquakeEffectLocal];

// Code Start
//------------------------------------------------------------------------------------------------
switch _mode do {
    case "init": {
        if (is3DEN) exitWith {};
        if (!_isActivated) exitWith {};

        _moduleObject call ["CreateEarthquake"];
    };

    case "connectionChanged3DEN": {
        private _synced = get3DENConnections _module apply {_x select 1};
        private _invalid = _synced select {!(_x isKindOf "MEH_ModuleEarthquakeDamageArea") && !(_x isKindOf "EmptyDetector")};
        if (_invalid isNotEqualTo []) then {
            [typeOf _module] call EFUNC(Error,invalidSync);

            // remove connection
            remove3DENConnection ["Sync", _invalid, _module];
        };
    };
};