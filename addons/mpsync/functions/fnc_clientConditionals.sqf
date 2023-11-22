/*
    fnc_clientConditionals.sqf

    Author: Hypoxic

    This is a recursive function that checks conditions in order until the end result is made. Used because of how respawn templates work.
*/

#include "script_component.hpp"

params [
    ["_mode", ""],
    "_args"
];
_args params ["_respawnOnStart", "_templates", "_timeout"];

switch _mode do {
    case "register": {
        [{
            !isNull player
        }, {
            params ["_respawnOnStart", "_templates", "_timeout"];

            INFO("Player is registered and not null");

            switch true do {
                case (_respawnOnStart == 1 && "MenuPosition" in _templates): {
                    INFO("RespawnOnStart is 1 && 'MenuPosition' is a valid template");
                    ["menuposition", _this] call FUNC(clientConditionals)
                };
                case (_respawnOnStart == 1): {
                    INFO("RespawnOnStart is 1");
                    ["respawnonstart", _this] call FUNC(clientConditionals);
                };
                default { [""] call FUNC(clientConditionals) };
            };
        }, _args, _timeout] call CBA_fnc_waitUntilAndExecute;
    };

    case "respawnonstart": {
        [{
            !alive player
        }, {
            INFO("Player has respawned");
            ["", _this] call FUNC(clientConditionals);
        }, _args, _timeout] call CBA_fnc_waitUntilAndExecute;
    };

    case "menuposition": {
        [{
            !alive player && { visibleMap };
        }, {
            INFO("Player has respawned and map is open");
            ["", _this] call FUNC(clientConditionals);
        }, _args, _timeout] call CBA_fnc_waitUntilAndExecute;
    };

    default {
        [{
            alive player;
        }, {

            INFO("All previous steps completed, disabling player");

            // Initialize blanks screen
            [1, LLSTRING(client_waitingForPlayers)] call FUNC(blankScreen);
            // Mute client
            [true] call FUNC(muteClient);

            player setVariable [QGVAR(playerSpawned), true, true];
            // Disable shooting
            [player, "disable"] call FUNC(playerLMB);
            player enableSimulation false;

        }, _args, _timeout] call CBA_fnc_waitUntilAndExecute;
    };
};
