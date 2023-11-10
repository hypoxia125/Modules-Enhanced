#include "script_component.hpp"

params [
    ["_minPlayers", 1, [-1]],
    ["_timeout", 60, [-1]]
];

// Initialize blanks screen
[1, LLSTRING(client_waitingForPlayers)] call FUNC(createBlankScreen);

// Mute client
[true] call FUNC(muteClient);

// Get respawn templates
private _respawnCfg = call FUNC(getRespawnConfig);
_respawnCfg params ["_respawnOnStart", "_templates"];

// Initial waitUntil for init
[{
    params ["_respawnOnStart", "_templates"];

    // Respawn and Menu
    switch true do {
        case (_respawnOnStart == 1 && "MenuPosition" in _templates): {
            // Registered player
            (!isNull player) &&
            // Player respawned
            {
                (!alive player) && {visibleMap};
            };
        };
        case (_respawnOnStart == 1): {
            // Registered player
            (!isNull player) &&
            {
                (!alive player)
            };
        };
        default {
            // Registered player
            (!isNull player) &&
            {
                (alive player)
            };
        };
    } &&
    time > 0
}, {
    player setVariable [QGVAR(playerSpawned), true, true];
    // Disable shooting
    [player, "disable"] call FUNC(playerLMB);
    player enableSimulation false;
}, [_respawnOnStart, _templates], _timeout, {
    // Timeout
}] call CBA_fnc_waitUntilAndExecute;

// Wait for server response
[{
    missionNamespace getVariable [QGVAR(syncComplete), false];
}, {
    // Wake up player
    [0, LLSTRING(client_syncComplete)] call FUNC(createBlankScreen);
    [false] call FUNC(muteClient);
    // Allow shooting
    [player, "enable"] call FUNC(playerLMB);
    player enableSimulation true;
}, [], _timeOut, {
    // Wake up player
    [0, LLSTRING(client_syncComplete)] call FUNC(createBlankScreen);
    [false] call FUNC(muteClient);
    // Allow shooting
    [player, "enable"] call FUNC(playerLMB);
    player enableSimulation true;
}] call CBA_fnc_waitUntilAndExecute;