/* ----------------------------------------------------------------------------
Function: meh_modules_fnc_moduleLightningStorm

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
if (_mode in ["dragged3DEN", "unregisteredFromWorld3DEN"]) exitWith {};

// Variables
//------------------------------------------------------------------------------------------------
private _area = _module getVariable ["ObjectArea", [100, 100, 0, false, -1]];
private _timeBetweenStrikes = _module getVariable ["TimeBetweenStrikes", 5];
private _strikeRandomness = _module getVariable ["StrikeRandomness", 1];
private _areaDamage = _module getVariable ["AreaDamage", 15];

_timeBetweenStrikes = abs _timeBetweenStrikes;

if (_areaDamage < 0) then { _areaDamage = 0 };
_area = [getPosATL _module] + _area;

// Code Start
//------------------------------------------------------------------------------------------------
switch _mode do {
    case "init": {
        if (is3DEN) exitWith {};

        if (_isActivated) then {
            private _handle = [_area, _timeBetweenStrikes, _strikeRandomness, _areaDamage, _module] call FUNC(lightningStorm_startStorm);
            _module setVariable [QGVAR(lightningStorm_Handle), _handle];
        } else {
            private _handle = _module getVariable [QGVAR(lightningStorm_Handle), nil];
            if (!isNil "_handle") then {
                terminate _handle;
                _module setVariable [QGVAR(lightningStorm_Handle), nil];
            };
        };
    };

    default {};
};
