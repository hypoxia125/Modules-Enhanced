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

GVAR(WorldTimeScaleDayHours) = _dayTimeHours;
GVAR(WorldTimeScaleNightHours) = _nightTimeHours;

if (isNil QGVAR(WorldTimeScaleHandle) || {scriptDone GVAR(WorldTimeScaleHandle)}) then {
    GVAR(WorldTimeScaleHandle) = [] spawn {
        while {true} do {
            sleep 1;
            if (!isMultiplayer && isGamePaused) then { continue };

            private _hours = [GVAR(WorldTimeScaleNightHours), GVAR(WorldTimeScaleDayHours)] select (sunOrMoon >= 0.5);
            setTimeMultiplier ((12 / _hours) min 120 max 0.1);
        };
    };
    LOG(QFUNC(moduleWorldTimeScaleSystem) + ":: System started...");
};
