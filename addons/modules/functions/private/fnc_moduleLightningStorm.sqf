/* ----------------------------------------------------------------------------
Function: meh_modules_fnc_moduleLightningStorm

Author: Hypoxic

Public: False - Requires internal data

Description:
    Function that the module calls upon initialization.
---------------------------------------------------------------------------- */

#include "script_component.hpp"

#define TICKRATE 0.1

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

// Functions
//------------------------------------------------------------------------------------------------
private _startStorm = {
    params ["_module", "_area", "_timeBetweenStrikes", "_strikeRandomness", "_areaDamage"];

    private _handle = [_module, _area, _timeBetweenStrikes, _strikeRandomness, _areaDamage] spawn {
        params ["_module", "_area", "_timeBetweenStrikes", "_strikeRandomness", "_areaDamage"];
        private _timeTillNextStrike = _timeBetweenStrikes;
        private _totalStrikes = 0;

        while {alive _module} do {
            sleep TICKRATE;
            if (!alive _module) exitWith {};
            if (isGamePaused) then { continue };

            if (_totalStrikes > 0 && _timeTillNextStrike > 0) then {
                _timeTillNextStrike = _timeTillNextStrike - TICKRATE;
                continue;
            };

            private _strikes = 1;
            if (random 1 < 0.10) then {
                _strikes = selectRandom [2,3];
            };

            for "_i" from 0 to _strikes - 1 do {
                private _pos = [[_area]] call BIS_fnc_randomPos;
                _pos set [2, 0];

                [_pos, _areaDamage] call FUNC(lightningStorm_strike);
                _totalStrikes = _totalStrikes + 1;
            };

            // Determine new wait time
            private _randomness = random _strikeRandomness;
            if (random 1 < 0.5) then {
                _timeTillNextStrike = _timeBetweenStrikes * (1 + _randomness);
            } else {
                _timeTillNextStrike = _timeBetweenStrikes * (1 - _randomness);
            };
        };
    };

    // Return
    _handle
};

// Code Start
//------------------------------------------------------------------------------------------------
switch _mode do {
    case "init": {
        if (is3DEN) exitWith {};

        if (_isActivated) then {
            private _handle = [_module, _area, _timeBetweenStrikes, _strikeRandomness, _areaDamage] call _startStorm;
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
