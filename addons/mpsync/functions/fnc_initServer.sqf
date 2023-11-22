#include "script_component.hpp"

params ["_minPlayers","_timeout", "_variableToPass"];

[{
    params ["_minPlayers", "_timeout", "_variableToPass"];

    private _players = (allUnits + allDead) select {isPlayer _x};
    private _playersNotEmpty = count _players > 0;
    private _aPlayerHasSpawned = _players findIf {_x getVariable [QGVAR(playerSpawned), false]} != -1;
    private _enoughPlayersSpawned = ({ (_x getVariable [QGVAR(playerSpawned), false]) } count _players >= _minPlayers);

    _playersNotEmpty && { _aPlayerHasSpawned && { _enoughPlayersSpawned}};
    
}, {
    params ["_minPlayers", "_timeout", "_variableToPass"];

    missionNamespace setVariable [_variableToPass, true, true];
}, [_minPlayers, _timeout, _variableToPass], _timeOut, {
    params ["_minPlayers", "_timeout", "_variableToPass"];
    // Timeout
    missionNamespace setVariable [_variableToPass, true, true];
}] call CBA_fnc_waitUntilAndExecute;
