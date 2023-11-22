#include "script_component.hpp"

params [
    ["_module", objNull, [objNull, []]],
    ["_area", [100, 100, 0, false, -1], [[]], 5],
    ["_timeBetweenStrikes", 0.25, [-1]],
    ["_strikeRandomness", 0.5, [-1]],
    ["_areaDamage", 15, [-1]]
];

if (!isServer) exitWith {};

// Check variables
if (
    _timeBetweenStrikes < 0 ||
    _strikeRandomness < 0 ||
    _areaDamage < 0
) exitWith {};
if (_module isEqualType []) then {
    _module = createVehicle ["Land_HelipadEmpty_F", _module];
};
_area = [getPosATL _module] + _area;

// Execute
private _handle = [{
    params ["_args", "_handle"];
    _args params ["_module", "_area", "_areaDamage"];

    // Exit code if module is dead
    if (!alive _module) exitWith {_handle call CBA_fnc_removePerFrameHandler};

    private _strikes = 1;
    if (random 1 < 0.10) then {_strikes = 2};

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
}, _timeBetweenStrikes + (random _strikeRandomness), [_module, _area, _areaDamage]] call CBA_fnc_addPerFrameHandler;

// Return
_handle
