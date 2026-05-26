/* ----------------------------------------------------------------------------
Function: meh_modules_fnc_moduleWorldTimeScale

Author: Hypoxic

Public: False - Requires internal data

Description:
    Function that the module calls upon initialization.
---------------------------------------------------------------------------- */

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
if (!isServer) exitWith {};
if !(_mode in ["init"]) exitWith {};

// Variables
//------------------------------------------------------------------------------------------------
private _dayTimeHours = _module getVariable ["DayTimeScale", 12/2];
private _nightTimeHours = _module getVariable ["NightTimeScale", 12/2];

if (isNil QGVAR(WorldTimeScaleSystem)) then {
    GVAR(WorldTimeScaleSystem) = createHashMapObject [[
        ["#type", QGVAR(WorldTimeScaleSystem)],
        ["#str", {str _module}],

        ["_updateRate", 1],

        ["_dayTimeHours", _dayTimeHours],
        ["_nightTimeHours", _nightTimeHours],
        
        ["#create", {
            if (!isServer) exitWith {};
            if (((_self get "#type" select 0)) == "SystemBase") exitWith {};

            _self call ["SystemStart"];
        }],

        ["Update", {
            private _dayTimeHours = _self get "_dayTimeHours";
            private _nightTimeHours = _self get "_nightTimeHours";
            
            private _dayMultiplier = 24 / _dayTimeHours / 2;
            private _nightMultiplier = 24 / _nightTimeHours / 2;
            
            _dayMultiplier = (_dayMultiplier min 120) max 0.1;
            _nightMultiplier = (_nightMultiplier min 120) max 0.1;
            
            if (sunOrMoon >= 0.5) then {
                // day time
                setTimeMultiplier _dayMultiplier;
            } else {
                // night time
                setTimeMultiplier _nightMultiplier;
            };
        }],

        ["SystemStart", {
            if (!isServer) exitWith {};
            private _handle = [{
                params ["_args", "_handle"];
                _args params ["_self"];

                if (!isMultiplayer && isGamePaused) exitWith {};

                _self call ["Update", []];
            }, _self get "_updateRate", [_self]] call CBA_fnc_addPerFrameHandler;

            LOG(QFUNC(moduleWorldTimeScaleSystem) + ":: System started...");

            _self set ["_frameSystemHandle", _handle];
        }]
    ]]
} else {
    // overwrite times
    GVAR(WorldTimeScaleSystem) set ["_dayTimeHours", _dayTimeHours];
    GVAR(WorldTimeScaleSystem) set ["_nightTimeHours", _nightTimeHours];
};