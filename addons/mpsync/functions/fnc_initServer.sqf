#include "script_component.hpp"

params [
    ["_minPlayers", 1, [-1]],
    ["_timeOut", 60, [-1]]
];

[{
    params ["_minPlayers", "_timeout"];

    private _players = (allUnits + allDead) select {isPlayer _x};
    private _playersNotEmpty = count _players > 0;
    private _aPlayerHasSpawned = _players findIf {_x getVariable [QGVAR(playerSpawned), false]} != -1;
    private _enoughPlayersSpawned = ({ (_x getVariable [QGVAR(playerSpawned), false]) } count _players >= _minPlayers);

    _playersNotEmpty && { _aPlayerHasSpawned && { _enoughPlayersSpawned}};
    
}, {
    missionNamespace setVariable [QGVAR(syncComplete), true, true];
}, [_minPlayers, _timeout], _timeOut, {
    // Timeout
    missionNamespace setVariable [QGVAR(syncComplete), true, true];
}] call CBA_fnc_waitUntilAndExecute;