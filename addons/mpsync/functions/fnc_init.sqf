#include "script_component.hpp"

params [
    ["_minPlayers", 1, [-1]],
    ["_timeout", 30, [-1]],
    ["_variableToPass", QGVAR(syncComplete), [""]]
];

if (!isMultiplayer) exitWith {};

// Initialize variable
if (isServer) then { missionNamespace setVariable [_variableToPass, false, true] };

// Initalize Server
[_minPlayers, _timeout, _variableToPass] call FUNC(initServer);

// Initialize Client
[_minPlayers, _timeout, _variableToPass] call FUNC(initClient);
