#include "script_component.hpp"
params [
    ["_area", [], [[], 6]],
    ["_shell", "Sh_82mm_AMOS", [""]],
    ["_timeLength", 60, [-1]],
    ["_salvoData", [], [[]]],
    ["_shotData", [], [[]]]
];

_salvoData params [
    ["_salvoSize", 6, [-1]],
    ["_salvoInterval", 10, [-1]],
    ["_salvoTimeVariation", 5, [-1]]
];

_shotData params [
    ["_shotInterval", 1, [-1]],
    ["_shotTimeVariation", 1, [-1]]
];

if (!isServer) exitWith {};
if (!canSuspend) exitWith { _this spawn FUNC(createVirtualArtilleryFire) };

private _stopTime = time + _timeLength;

while { time < _stopTime } do {
    for "_i" from 0 to (_salvoSize - 1) do {
        private _pos = [[_area]] call BIS_fnc_randomPos;
        private _shotDelay = _shotInterval + (random [0, _shotTimeVariation / 2, _shotTimeVariation]);

        private _round = [_shell, _pos] call FUNC(createArtilleryShell);

        sleep _shotDelay;
    };

    private _salvoDelay = _salvoInterval + (random [0, _salvoTimeVariation / 2, _salvoTimeVariation]);
    sleep _salvoDelay;
};