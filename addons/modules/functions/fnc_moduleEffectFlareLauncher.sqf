/*
    moduleEffectFlareLauncher.sqf
    Author: Hypoxic

    Public: no

    As long as the module is alive, this will continually launch flare rounds from the module's location.
*/

#include "script_component.hpp"
#include "\z\meh\addons\modules\moduleDefaults.inc"

#define TICKRATE    0.1

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
if (!isServer) exitWith {};
if (_mode in ["dragged3DEN", "unregisteredFromWorld3DEN"]) exitWith {};

// Variables
//------------------------------------------------------------------------------------------------
private _flareColor = _module getVariable ["FlareColor", DEFAULT_FLARECOLOR];
private _timeBetweenLaunches = _module getVariable ["TimeBetweenLaunches", DEFAULT_TIMEBETWEENLAUNCHES];
private _launchRandomness = _module getVariable ["LaunchRandomness", DEFAULT_LAUNCHRANDOMNESS];
private _launchDispersion = _module getVariable ["LaunchDispersion", DEFAULT_LAUNCHDISPERSION];
private _flareDeployHeight = parseSimpleArray (_module getVariable ["FlareDeployHeight", DEFAULT_FLAREDEPLOYHEIGHT]);

if !([_flareColor, _timeBetweenLaunches, _launchRandomness, _launchDispersion] isEqualTypeAll 0) exitWith {
    [typeOf _module] call EFUNC(error,invalidArgs)
};
if (!(_flareDeployHeight isEqualTypeAll 0)) exitWith {
    [typeOf _module] call EFUNC(error,invalidArgs)
};

if (_timeBetweenLaunches < 0) then {_timeBetweenLaunches = 0};
if (_launchRandomness < 0) then {_launchRandomness = 0};
if (_launchDispersion < 0) then {_launchDispersion = 0};
if (_launchDispersion >= 90) then {_launchDispersion = 89};

// Code Start
//------------------------------------------------------------------------------------------------
switch _mode do {
    case "init": {
        if (is3DEN) exitWith {};

        if (_isActivated) then {
            private _flareClasses = switch _flareColor do {
                // Blue
                case 0: {["MEH_40mm_Blue_60"]};
                case 1: {["MEH_40mm_Blue_180"]};
                case 2: {["MEH_40mm_Blue_300"]};
                // Green
                case 3: {["MEH_40mm_Green_60"]};
                case 4: {["MEH_40mm_Green_180"]};
                case 5: {["MEH_40mm_Green_300"]};
                // Orange
                case 6: {["MEH_40mm_Orange_60"]};
                case 7: {["MEH_40mm_Orange_180"]};
                case 8: {["MEH_40mm_Orange_300"]};
                // Purple
                case 9: {["MEH_40mm_Purple_60"]};
                case 10: {["MEH_40mm_Purple_180"]};
                case 11: {["MEH_40mm_Purple_300"]};
                // Red
                case 12: {["MEH_40mm_Red_60"]};
                case 13: {["MEH_40mm_Red_180"]};
                case 14: {["MEH_40mm_Red_300"]};
                // White
                case 15: {["MEH_40mm_White_60"]};
                case 16: {["MEH_40mm_White_180"]};
                case 17: {["MEH_40mm_White_300"]};
                // Yellow
                case 18: {["MEH_40mm_Yellow_60"]};
                case 19: {["MEH_40mm_Yellow_180"]};
                case 20: {["MEH_40mm_Yellow_300"]};
                // Random
                case 21: {[
                    "MEH_40mm_Blue_60", "MEH_40mm_Green_60", "MEH_40mm_Orange_60",
                    "MEH_40mm_Purple_60", "MEH_40mm_Red_60", "MEH_40mm_White_60",
                    "MEH_40mm_Yellow_60"
                ]};
                case 22: {[
                    "MEH_40mm_Blue_180", "MEH_40mm_Green_180", "MEH_40mm_Orange_180",
                    "MEH_40mm_Purple_180", "MEH_40mm_Red_180", "MEH_40mm_White_180",
                    "MEH_40mm_Yellow_180"
                ]};
                case 23: {[
                    "MEH_40mm_Blue_300", "MEH_40mm_Green_300", "MEH_40mm_Orange_300",
                    "MEH_40mm_Purple_300", "MEH_40mm_Red_300", "MEH_40mm_White_300",
                    "MEH_40mm_Yellow_300"
                ]};
                // Cycle (Order of Rainbow)
                case 24: {[
                    "MEH_40mm_Red_60", "MEH_40mm_Orange_60", "MEH_40mm_Yellow_60", 
                    "MEH_40mm_Green_60", "MEH_40mm_Blue_60", "MEH_40mm_Purple_60",
                    "MEH_40mm_White_60"
                ]};
                case 25: {[
                    "MEH_40mm_Red_180", "MEH_40mm_Orange_180", "MEH_40mm_Yellow_180", 
                    "MEH_40mm_Green_180", "MEH_40mm_Blue_180", "MEH_40mm_Purple_180",
                    "MEH_40mm_White_180"
                ]};
                case 26: {[
                    "MEH_40mm_Red_300", "MEH_40mm_Orange_300", "MEH_40mm_Yellow_300", 
                    "MEH_40mm_Green_300", "MEH_40mm_Blue_300", "MEH_40mm_Purple_300",
                    "MEH_40mm_White_300"
                ]};
            };

            private _cycle = false;
            if (_flareColor in [24, 25, 26]) then { _cycle = true };

            private _random = false;
            if (_flareColor in [21, 22, 23]) then { _random = true };

            // Start per frame handler
            private _handle = [{
                params ["_args", "_handle"];
                _args params ["_module", "_flareClasses", "_cycle", "_random", "_flareDeployHeight", "_timeBetweenLaunches", "_launchRandomness", "_launchDispersion"];
                
                if (!alive _module) exitWith {_handle call CBA_fnc_removePerFrameHandler};
                if (isGamePaused) exitWith {};

                private _timeTillNextLaunch = _module getVariable [QGVAR(ModuleEffectFlareLauncher_TimeTillNextLaunch), _timeBetweenLaunches];
                private _flaresShot = _module getVariable [QGVAR(ModuleEffectFlareLauncher_FlaresShot), 0];
                if (_flaresShot > 0 && !(_timeTillNextLaunch <= 0)) exitWith {
                    _module setVariable [QGVAR(ModuleEffectFlareLauncher_TimeTillNextLaunch), _timeTillNextLaunch - TICKRATE];
                };

                // Determine round to launch
                private _flareClass = _flareClasses#0;
                if (_cycle) then {
                    private _currentFlareIndex = _module getVariable [QGVAR(ModuleEffectFlareLauncher_CurrentFlareIndex), 0];
                    _flareClass = _flareClasses#_currentFlareIndex;
                    
                    _currentFlareIndex = _currentFlareIndex + 1;
                    if !(_currentFlareIndex < count _flareClasses) then {
                        _currentFlareIndex = 0;
                    };
                    _module setVariable [QGVAR(ModuleEffectFlareLauncher_CurrentFlareIndex), _currentFlareIndex];
                };

                if (_random) then {_flareClass = selectRandom _flareClasses};

                // Launch round
                private _round = createVehicle [_flareClass, getPosATL _module vectorAdd [0,0,1]];
                private _dir = random 360;
                private _pitch = 90 - (random _launchDispersion);

                _round setDir _dir;
                [_round, _pitch, 0] call BIS_fnc_setPitchBank;
                _round setVelocityModelSpace [0, 900, 0];

                _flaresShot = _flaresShot + 1;
                _module setVariable [QGVAR(ModuleEffectFlareLauncher_FlaresShot), _flaresShot];

                [{
                    params ["_round", "_flareDeployHeight"];
                    _flareDeployHeight params ["_min", "_max"];

                    private _height = [_min, _max] call BIS_fnc_randomInt;

                    if !(alive _round) exitWith {true};
                    getPosATL _round # 2 >= _height;
                }, {
                    params ["_round", "_flareDeployHeight"];
                    if !(alive _round) exitWith {true};
                    _round setVelocityModelSpace [0, -1, 0];
                }, [_round, _flareDeployHeight], 20, {}] call CBA_fnc_waitUntilAndExecute;

                // Determine new wait time
                private _newValue = _timeBetweenLaunches;
                private _randomness = random _launchRandomness;
                if (random 1 < 0.5) then {
                    _newValue = _newValue - _randomness;
                } else {
                    _newValue = _newValue + _randomness;
                };
                _module setVariable [QGVAR(ModuleEffectFlareLauncher_TimeTillNextLaunch), _newValue];

            }, TICKRATE, [_module, _flareClasses, _cycle, _random, _flareDeployHeight, _timeBetweenLaunches, _launchRandomness, _launchDispersion]] call CBA_fnc_addPerFrameHandler;

            _module setVariable [QGVAR(ModuleEffectFlareLauncher_PFHandler), _handle];
        } else {

            private _handle = _module getVariable [QGVAR(ModuleEffectFlareLauncher_PFHandler), -1];
            _handle call CBA_fnc_removePerFrameHandler;
        };
    };

    default {};
};
