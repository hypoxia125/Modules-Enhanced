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
if (!hasInterface) exitWith {};
if (is3DEN) exitWith {};
if (_mode != "init") exitWith {};

// Variables
//------------------------------------------------------------------------------------------------
private _forced = _module getVariable "Force";
private _affectedUnitsNum = _module getVariable "AffectedUnits";
private _finalDelay = _module getVariable ["FinalDelay", 3];

private _affectedUnits = switch _affectedUnitsNum do {
    case 0: { units west };
    case 1: { units east };
    case 2: { units independent };
    case 3: { units civilian };
    case 4: { allUnits };
    case 5: { synchronizedObjects _module select {_x isKindOf "CAManBase"} };
};

// Functions
//------------------------------------------------------------------------------------------------
private _moduleObject = createHashMapObject [[
    ["m_forced", _forced],
    ["m_affectedUnits", _affectedUnits],
    ["m_addModulesOrdered", []],
    ["m_timeStack", 0],
    ["m_finalDelay", _finalDelay],

    ["FindAllModules", {
        params ["_startModuleObj", "_currModule", ["_lastModule", objNull]];

        private _syncedModules = synchronizedObjects _currModule;
        _syncedModules = _syncedModules select {_x isKindOf "MEH_ModuleMapAnimationAdd"};
        _syncedModules = _syncedModules - [_lastModule];

        if (count _syncedModules > 1) exitWith {
            systemChat format["ModuleMapAnimationStart::FindAllModules | Too many modules connected to module: %1. You should only have a before and after MapAnimationStart module.", _currModule];
        };
        if (count _syncedModules <= 0) exitWith {};

        private _nextModule = _syncedModules#0;

        private _addModulesOrdered = _startModuleObj get "m_addModulesOrdered";
        _addModulesOrdered insert [-1, [_nextModule]];
        _startModuleObj set ["m_addModulesOrdered", _addModulesOrdered];

        // recursive call
        _startModuleObj call ["FindAllModules", [_startModuleObj, _nextModule, _currModule]];
    }],

    ["Execute", {
        openMap [true, _self get "m_forced"];
        private _modules = _self get "m_addModulesOrdered";

        {
            private _module = _x;

            private _time = _module getVariable ["Time", 3];
            private _zoom = _module getVariable "Zoom";
            private _timeUntilStart = _module getVariable ["TimeUntilStart", 5];
            private _expression = _module getVariable ["Expression", "true"];
            private _position = ASLToAGL (getPosASL _module);
            
            private _timeStack = _self get "m_timeStack";
            private _delay = _timeStack + _timeUntilStart;
            _self set ["m_timeStack", _delay];

            [{
                params ["_time", "_zoom", "_position", "_expression"];
                mapAnimAdd [_time, _zoom, _position];
                mapAnimCommit;
                call compile _expression;
            }, [_time, _zoom, _position, _expression], _delay] call CBA_fnc_waitAndExecute;
        } forEach _modules;

        private _finalDelay = (_self get "m_timeStack") + (_self get "m_finalDelay");
        [{
            params ["_self"];

            openMap [false, false];
        }, [_self], _finalDelay] call CBA_fnc_waitAndExecute;
    }]
]];

// Code Start
//------------------------------------------------------------------------------------------------
switch _mode do {
    case "init": {
        if (is3DEN) exitWith {};

        if !(player in _affectedUnits) exitWith {};

        _moduleObject call ["FindAllModules", [_moduleObject, _module, objNull]];
        _moduleObject call ["Execute"];
    };
};