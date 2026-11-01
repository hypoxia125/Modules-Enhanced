/*
    Function: meh_modules_fnc_lightningStorm_strike
    Create one lightning strike and optionally damage nearby objects.
    Arguments: [positionATL, damageRadius] (default 15). Call on the server.
    Returns: lightning bolt object, or objNull when invalid/not on server.
*/
#include "script_component.hpp"

params [["_position", [], [[]]], ["_damageRadius", 15, [0]]];
if (!isServer || {count _position < 2} || {_damageRadius < 0}) exitWith {objNull};

private _pos = +_position;
_pos set [2, 0];
private _bolt = createVehicle ["MEH_LightningBolt", [100,100,100], [], 0, "CAN_COLLIDE"];
_bolt setPosATL _pos;
_bolt setDamage 1;

[QEGVAR(effects,lightningStrike_Local), [_pos, random 360, selectRandom ["Lightning1_F", "Lightning2_F"]]] call CBA_fnc_globalEvent;

private _nearObjects = _pos nearObjects _damageRadius;
private _terrainObjects = nearestTerrainObjects [_pos, [], _damageRadius];
_nearObjects insert [-1, _terrainObjects];
_nearObjects = _nearObjects select {!(_x isKindOf "Logic")};
_nearObjects apply {_x setDamage 1};

_bolt
