/* ----------------------------------------------------------------------------
Function: meh_modules_fnc_moduleEffectFlareLauncher

Author: Hypoxic

Public: False - Requires internal data

Description:
    Function that the module calls upon initialization.
---------------------------------------------------------------------------- */

#include "script_component.hpp"
#include "\z\meh\addons\modules\moduleDefaults.inc"

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
private _flareColor = _module getVariable ["FlareColor", 21];
private _timeBetweenLaunches = _module getVariable ["TimeBetweenLaunches", 30];
private _launchRandomness = _module getVariable ["LaunchRandomness", 0.1];
private _launchDispersion = _module getVariable ["LaunchDispersion", 30];
private _flareDeployHeight_Min = _module getVariable ["FlareDeployHeight_Min", 100];
private _flareDeployHeight_Max = _module getVariable ["FlareDeployHeight_Max", 250];

_timeBetweenLaunches = abs _timeBetweenLaunches;
_flareDeployHeight_Min = abs _flareDeployHeight_Min;
_flareDeployHeight_Max = abs _flareDeployHeight_Max;

if (_flareDeployHeight_Max < _flareDeployHeight_Min) then {
    _flareDeployHeight_Max = _flareDeployHeight_Min
};

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

            private _handle = [
                _module, _flareClasses, _cycle, _random, _flareDeployHeight_Min, _flareDeployHeight_Max,
                _timeBetweenLaunches, _launchRandomness, _launchDispersion, _module
            ] call FUNC(effectFlareLauncher_startLaunching);

            _module setVariable [QGVAR(ModuleEffectFlareLauncher_ScriptHandler), _handle];
        } else {

            private _handle = _module getVariable [QGVAR(ModuleEffectFlareLauncher_ScriptHandler), scriptNull];
            terminate _handle;
            _module setVariable [QGVAR(ModuleEffectFlareLauncher_ScriptHandler), nil];
        };
    };

    default {};
};
