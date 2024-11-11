/*
    moduleEffectFlareLauncher.sqf
    Author: Hypoxic

    Public: no

    As long as the module is alive, this will continually launch flare rounds from the module's location.
*/

#include "script_component.hpp"
#include "\z\meh\addons\modules\moduleDefaults.inc"

#define TICKRATE    0.1

params [
    ["_mode", "", [""]],
    ["_input", [], [[]]]
];
_input params [
    ["_module", objNull, [objNull]],
    ["_isActivated", false, [true]],
    ["_isCuratorPlaced", false, [true]]
];

if (!isServer) exitWith {};
if (_mode in ["dragged3DEN", "unregisteredFromWorld3DEN"]) exitWith {};

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

switch _mode do {
    case "init": {
        if (is3DEN) exitWith {};

        private _flareClasses = switch _flareColor do {
            case 0: {["F_40mm_Green"]};
            case 1: {["F_40mm_Red"]};
            case 2: {["F_40mm_White"]};
            case 3: {["F_40mm_Yellow"]};
            case 4;
            case 5: {["F_40mm_Green", "F_40mm_Red", "F_40mm_White", "F_40mm_Yellow"]};
        };

        private _cycle = false;
        if (_flareColor == 4) then { _cycle = true };

        private _random = false;
        if (_flareColor == 5) then { _random = true };

        [{
            params ["_args", "_handle"];
            _args params ["_module", "_flareClasses", "_cycle", "_random", "_flareDeployHeight", "_timeBetweenLaunches", "_launchRandomness", "_launchDispersion"];

            private _timeTillNextLaunch = _module getVariable [QGVAR(ModuleEffectFlareLauncher_TimeTillNextLaunch), _timeBetweenLaunches];
            
            if (!alive _module) exitWith {_handle call CBA_fnc_removePerFrameHandler};
            if (isGamePaused) exitWith {};

            if !(_timeTillNextLaunch <= 0) exitWith {
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
            if (random 1 < 0.5) then {
                _newValue = _newValue - (random _launchRandomness);
            } else {
                _newValue = _newValue + (random _launchRandomness);
            };
            _module setVariable [QGVAR(ModuleEffectFlareLauncher_TimeTillNextLaunch), _newValue];

        }, TICKRATE, [_module, _flareClasses, _cycle, _random, _flareDeployHeight, _timeBetweenLaunches, _launchRandomness, _launchDispersion]] call CBA_fnc_addPerFrameHandler;
    };

    default {};
};