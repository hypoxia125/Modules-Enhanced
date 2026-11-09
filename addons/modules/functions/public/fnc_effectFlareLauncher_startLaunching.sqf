/*
    Function: meh_modules_fnc_effectFlareLauncher_startLaunching
    Repeatedly launch flares on the server. Returns a script handle; terminate to stop.
    Arguments: [originObjectOrPositionATL, flareClasses, cycleClasses, randomClass,
                minDeployHeight, maxDeployHeight, launchInterval, launchRandomness,
                launchDispersion, lifetimeObject]. lifetimeObject is optional.
*/
#include "script_component.hpp"

#define TICKRATE 0.1

params [
    ["_origin", [], [[], objNull]],
    ["_flareClasses", [], [[]]],
    ["_cycle", false, [true]],
    ["_random", false, [true]],
    ["_flareDeployHeight_Min", 100, [0]],
    ["_flareDeployHeight_Max", 250, [0]],
    ["_timeBetweenLaunches", 30, [0]],
    ["_launchRandomness", 0.1, [0]],
    ["_launchDispersion", 30, [0]],
    ["_lifetimeObject", objNull, [objNull]]
];

if (!isServer || {_flareClasses isEqualTo []} || {!(_flareClasses isEqualTypeAll "")} ||
    {_flareDeployHeight_Min < 0} || {_flareDeployHeight_Max < _flareDeployHeight_Min} ||
    {_timeBetweenLaunches < 0} || {_launchRandomness < 0} || {_launchDispersion < 0}) exitWith {scriptNull};

private _originIsObject = _origin isEqualType objNull;
if (_originIsObject && {isNull _origin}) exitWith {scriptNull};
if (!_originIsObject && {count _origin < 2}) exitWith {scriptNull};
private _stopWithObject = !isNull _lifetimeObject;

[_origin, _originIsObject, _flareClasses, _cycle, _random, _flareDeployHeight_Min, _flareDeployHeight_Max, _timeBetweenLaunches, _launchRandomness, _launchDispersion, _lifetimeObject, _stopWithObject] spawn {
    params ["_origin", "_originIsObject", "_flareClasses", "_cycle", "_random", "_flareDeployHeight_Min", "_flareDeployHeight_Max", "_timeBetweenLaunches", "_launchRandomness", "_launchDispersion", "_lifetimeObject", "_stopWithObject"];
    private _timeTillNextLaunch = _timeBetweenLaunches;
    private _flaresShot = 0;
    private _currentFlareIndex = 0;

    while {(!_stopWithObject || {alive _lifetimeObject}) && {!_originIsObject || {alive _origin}}} do {
        sleep TICKRATE;
        if ((_stopWithObject && {!alive _lifetimeObject}) || {_originIsObject && {!alive _origin}}) exitWith {};
        if (isGamePaused) then { continue };

        if (_flaresShot > 0 && _timeTillNextLaunch > 0) then {
            _timeTillNextLaunch = _timeTillNextLaunch - TICKRATE;
            continue;
        };

        private _flareClass = _flareClasses#0;
        if (_cycle) then {
            _flareClass = _flareClasses#_currentFlareIndex;
            _currentFlareIndex = (_currentFlareIndex + 1) mod count _flareClasses;
        };
        if (_random) then {_flareClass = selectRandom _flareClasses};

        private _pos = if (_originIsObject) then {getPosATL _origin} else {+_origin};
        private _round = createVehicle [_flareClass, _pos vectorAdd [0,0,1]];
        private _dir = random 360;
        private _pitch = 90 - random _launchDispersion;
        _round setDir _dir;
        [_round, _pitch, 0] call BIS_fnc_setPitchBank;
        _round setVelocityModelSpace [0, 900, 0];
        _flaresShot = _flaresShot + 1;

        [_round, _flareDeployHeight_Min, _flareDeployHeight_Max] spawn {
            params ["_round", "_min", "_max"];
            private _height = [_min, _max] call BIS_fnc_randomInt;
            private _deadline = time + 20;
            waitUntil {sleep 0.025; !alive _round || {getPosATL _round # 2 >= _height} || {time >= _deadline}};
            if (alive _round && {time < _deadline}) then {
                _round setVelocityModelSpace [0, -1, 0];
            };
        };

        private _randomness = random _launchRandomness;
        if (random 1 < 0.5) then {
            _timeTillNextLaunch = _timeBetweenLaunches * (1 + _randomness);
        } else {
            _timeTillNextLaunch = _timeBetweenLaunches * (1 - _randomness);
        };
    };
}
