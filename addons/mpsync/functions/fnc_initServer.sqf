#include "script_component.hpp"

params [
    ["_minPlayers", 1, [-1]],
    ["_timeOut", 60, [-1]]
];

{{
    params ["_minPlayers", "_timeout"];

    private _players = (allUnits + allDead) select {isPlayer _x}
    // Wait for a player to join
    count _players > 0 &&

    // Wait for a player to spawn
    {
        _players findIf {
            _x getVariable [QGVAR(playerSpawned), false]
        } != -1 &&

        // Wait for enough players to spawn
        {
            { !(_x getVariable [QGVAR(playerSpawned), false]) } count _players >= _minPlayers;
        }
    }
}, {
    missionNamespace setVariable [QGVAR(syncComplete), true, true];
}, [_minPlayers, _timeout], _timeOut, {
    // Timeout
    missionNamespace setVariable [QGVAR(syncComplete), true, true];
}} call CBA_fnc_waitUntilAndExecute;