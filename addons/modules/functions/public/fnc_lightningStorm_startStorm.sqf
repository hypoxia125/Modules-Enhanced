/*
    Function: meh_modules_fnc_lightningStorm_startStorm
    Start a repeating lightning storm on the server; returns a script handle (terminate to stop).
    Arguments: [area, secondsBetweenStrikes, randomness, damageRadius, lifetimeObject].
    area: [centerATL, radiusX, radiusY, direction, isRectangle, height].
    lifetimeObject is optional; the storm also stops when it dies.
*/
#include "script_component.hpp"

#define TICKRATE 0.1

params [
    ["_area", [], [[]]],
    ["_timeBetweenStrikes", 5, [0]],
    ["_strikeRandomness", 1, [0]],
    ["_areaDamage", 15, [0]],
    ["_lifetimeObject", objNull, [objNull]]
];

if (!isServer || {count _area < 6} || {!((_area#0) isEqualType [])} || {count (_area#0) < 2} ||
    {_timeBetweenStrikes < 0} || {_strikeRandomness < 0} || {_areaDamage < 0}) exitWith {scriptNull};

private _stopWithObject = !isNull _lifetimeObject;
[_area, _timeBetweenStrikes, _strikeRandomness, _areaDamage, _lifetimeObject, _stopWithObject] spawn {
    params ["_area", "_timeBetweenStrikes", "_strikeRandomness", "_areaDamage", "_lifetimeObject", "_stopWithObject"];
    private _timeTillNextStrike = _timeBetweenStrikes;
    private _totalStrikes = 0;

    while {!_stopWithObject || {alive _lifetimeObject}} do {
        sleep TICKRATE;
        if (_stopWithObject && {!alive _lifetimeObject}) exitWith {};
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

        private _randomness = random _strikeRandomness;
        if (random 1 < 0.5) then {
            _timeTillNextStrike = _timeBetweenStrikes * (1 + _randomness);
        } else {
            _timeTillNextStrike = _timeBetweenStrikes * (1 - _randomness);
        };
    };
}
