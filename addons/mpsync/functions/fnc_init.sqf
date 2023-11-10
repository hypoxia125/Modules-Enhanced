#include "script_component.hpp"

params [
    ["_minPlayers", 1, [-1]],
    ["_timeout", 30, [-1]]
];

if (!isMultiplayer) exitWith {};

// Initalize Server
[_minPlayers, _timeout] call FUNC(initServer);

// Initialize Client
[_minPlayers, _timeout] call FUNC(initClient);