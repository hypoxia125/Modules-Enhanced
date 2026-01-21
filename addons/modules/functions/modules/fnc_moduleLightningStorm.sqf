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

    private _handle = [{
        params ["_args", "_handle"];
        _args params ["_module", "_area", "_timeBetweenStrikes", "_strikeRandomness", "_areaDamage"];

        // Exit code if module is dead
        if (!alive _module) exitWith {_handle call CBA_fnc_removePerFrameHandler};
        if (isGamePaused) exitWith {};

        private _timeTillNextStrike = _module getVariable [QGVAR(ModuleLightningStorm_TimeTillNextStrike), _timeBetweenStrikes];
        private _totalStrikes = _module getVariable [QGVAR(ModuleLightningStorm_TotalStrikes), 0];
        if ((_totalStrikes > 0 && _timeTillNextStrike > 0)) exitWith {
            _module setVariable [QGVAR(ModuleLightningStorm_TimeTillNextStrike), _timeTillNextStrike - TICKRATE];
        };

        private _strikes = 1;
        if (random 1 < 0.10) then {
            _strikes = selectRandom [2,3];
        };

        for "_i" from 0 to _strikes - 1 do {
            private _pos = [[_area]] call BIS_fnc_randomPos;
            _pos set [2, 0];

            // Play sound
            private _bolt = createVehicle ["MEH_LightningBolt", [100,100,100], [], 0, "CAN_COLLIDE"];
            _bolt setPosATL _pos;
            _bolt setDamage 1;

            // Call Event - Creates Lightning Effect
            [QEGVAR(effects,lightningStrike_Local), [_pos, random 360, selectRandom ["Lightning1_F", "Lightning2_F"]]] call CBA_fnc_globalEvent;

            // Damage things around the strike
            private _nearObjects = _pos nearObjects _areaDamage;
            private _terrainObjects = nearestTerrainObjects [_pos, [], _areaDamage];

            _nearObjects insert [-1, _terrainObjects];
            _nearObjects = _nearObjects select {!(_x isKindOf "Logic")};
            _nearObjects apply {_x setDamage 1};

            _totalStrikes = _totalStrikes + 1;
            _module setVariable [QGVAR(ModuleLightningStorm_TotalStrikes), _totalStrikes];
        };

        // Determine new wait time
        private _newValue = _timeBetweenStrikes;
        private _randomness = random _strikeRandomness;
        if (random 1 < 0.5) then {
            _newValue = _newValue * (1 + _randomness);
        } else {
            _newValue = _newValue * (1 - _randomness);
        };
        _module setVariable [QGVAR(ModuleLightningStorm_TimeTillNextStrike), _newValue];

    }, TICKRATE, [_module, _area, _timeBetweenStrikes, _strikeRandomness, _areaDamage]] call CBA_fnc_addPerFrameHandler;

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
                _handle call CBA_fnc_removePerFrameHandler;
                _module setVariable [QGVAR(lightningStorm_Handle), nil];
            };
        };
    };

    default {};
};
