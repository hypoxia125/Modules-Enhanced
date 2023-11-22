#include "script_component.hpp"

params ["_minPlayers", "_timeout", "_variableToPass"];

// Get respawn templates
private _respawnCfg = call FUNC(getRespawnConfig);
_respawnCfg params ["_respawnOnStart", "_templates"];

// Start client conditionals
["register", [_respawnOnStart, _templates, _timeout]] call FUNC(clientConditionals);

// Wait for server response
[{
    params ["_timeout", "_variableToPass"];

    missionNamespace getVariable [_variableToPass, false];
}, {
    // Wake up player
    [0, LLSTRING(client_syncComplete)] call FUNC(blankScreen);
    [false] call FUNC(muteClient);
    // Allow shooting
    [player, "enable"] call FUNC(playerLMB);
    player enableSimulation true;
}, [_timeOut, _variableToPass], _timeOut, {
    // Wake up player
    [0, LLSTRING(client_syncComplete)] call FUNC(blankScreen);
    [false] call FUNC(muteClient);
    // Allow shooting
    [player, "enable"] call FUNC(playerLMB);
    player enableSimulation true;
}] call CBA_fnc_waitUntilAndExecute;
