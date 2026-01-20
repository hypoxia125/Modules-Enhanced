#include "script_component.hpp"

// Parameters
//------------------------------------------------------------------------------------------------
params [
    ["_mode", "", [""]],
    ["_input", [], [[]]]
];
_input params [
    ["_module", objNull, [objNull]],
    ["_isActivated", false, [true]],
    ["_isCuratorPlaced", false, [true]]
];

// Pre-Execution Checks
//------------------------------------------------------------------------------------------------
if (!is3DEN && {!_isActivated}) exitWith {};
if (_mode isEqualTo "dragged3DEN") exitWith {};

// Variables
//------------------------------------------------------------------------------------------------
private _minPlayers = _module getVariable ["MinPlayers", 1];
private _timeout = _module getVariable ["Timeout", 30];
private _variableToPass = _module getVariable ["VariableToPass", QEGVAR(MPSync,syncComplete)];

// Functions
//------------------------------------------------------------------------------------------------
if (isNil QFUNC(mpsync_blankScreen)) then {
    FUNC(mpsync_blankScreen) = compileFinal {
        params ["_state", "_text"];

        LOG_1("ModuleMPSync:: Setting blank screen state: %1",_state);

        switch _state do {
            case 0: {
                private _layer = uiNamespace getVariable QGVAR(mpsync_blankScreen);
                if (isNil "_layer") exitWith {};

                _layer cutText [_text, "BLACK IN", 3, true, true];
                uiNamespace setVariable [QGVAR(mpsync_blankScreen), nil];
            };

            case 1: {
                private _layer = uiNamespace getVariable QGVAR(mpsync_blankScreen);
                if (isNil "_layer") then {
                    _layer = QGVAR(mpsync_blankScreen) call BIS_fnc_rscLayer;
                    uiNamespace setVariable [QGVAR(mpsync_blankScreen), _layer];
                };

                _layer cutText [_text, "BLACK OUT", 1e-10, true, true];
            };
        };
    };
};

if (isNil QFUNC(mpsync_clientConditionals)) then {
    FUNC(mpsync_clientConditionals) = compileFinal {
        params [["_mode", ""], "_args"];
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
                            ["menuposition", _this] call FUNC(mpsync_clientConditionals)
                        };
                        case (_respawnOnStart == 1): {
                            INFO("RespawnOnStart is 1");
                            ["respawnonstart", _this] call FUNC(mpsync_clientConditionals);
                        };
                        default { [""] call FUNC(mpsync_clientConditionals) };
                    };
                }, _args, _timeout] call CBA_fnc_waitUntilAndExecute;
            };

            case "respawnonstart": {
                [{
                    !alive player
                }, {
                    INFO("Player has respawned");
                    ["", _this] call FUNC(mpsync_clientConditionals);
                }, _args, _timeout] call CBA_fnc_waitUntilAndExecute;
            };

            case "menuposition": {
                [{
                    !alive player && { visibleMap };
                }, {
                    INFO("Player has respawned and map is open");
                    ["", _this] call FUNC(mpsync_clientConditionals);
                }, _args, _timeout] call CBA_fnc_waitUntilAndExecute;
            };

            default {
                [{
                    alive player;
                }, {

                    INFO("All previous steps completed, disabling player");

                    // Initialize blanks screen
                    [1, "Modules Enhanced: Waiting for players..."] call FUNC(mpsync_blankScreen);
                    // Mute client
                    [true] call FUNC(mpsync_muteClient);

                    player setVariable [QGVAR(mpsync_playerSpawned), true, true];
                    // Disable shooting
                    [player, "disable"] call FUNC(mpsync_playerLMB);
                    player enableSimulation false;

                }, _args, _timeout] call CBA_fnc_waitUntilAndExecute;
            };
        };
    };
};

if (isNil QFUNC(mpsync_getRespawnConfig)) then {
    FUNC(mpsync_getRespawnConfig) = compileFinal {
        if (isServer && !hasInterface) exitWith {};

        LOG("ModuleMPSync:: Finding respawn config settings...");

        private _side = side group player;
        private _respawnOnStart = getNumber (missionConfigFile >> "respawnOnStart");
        private _templates = getArray (missionConfigFile >> "respawnTemplates");
        if (isClass (missionConfigFile >> FORMAT_1("respawnTemplates%1",_side))) then {
            _templates = getArray (missionConfigFile >> FORMAT_1("respawnTemplates%1",_side));
        };

        // Return
        [_respawnOnStart, _templates];
    };
};

if (isNil QFUNC(mpsync_init)) then {
    FUNC(mpsync_init) = compileFinal {
        params [
            ["_minPlayers", 1, [-1]],
            ["_timeout", 30, [-1]],
            ["_variableToPass", QGVAR(mpsync_syncComplete), [""]]
        ];

        LOG("ModuleMPSync:: Initializing...");

        if (!isMultiplayer) exitWith {
            systemChat format["ModuleMPSync:: Module not compatible with singleplayer. isMultiplayer=%1",isMultiplayer];
        };

        // Initialize variable
        if (isServer) then { missionNamespace setVariable [_variableToPass, false, true] };

        // Initalize Server
        [_minPlayers, _timeout, _variableToPass] call FUNC(mpsync_initServer);

        // Initialize Client
        [_minPlayers, _timeout, _variableToPass] call FUNC(mpsync_initClient);
    };
};

if (isNil QFUNC(mpsync_initClient)) then {
    FUNC(mpsync_initClient) = compileFinal {
        params ["_minPlayers", "_timeout", "_variableToPass"];

        LOG("ModuleMPSync:: Initializing client...");

        // Get respawn templates
        private _respawnCfg = call FUNC(mpsync_getRespawnConfig);
        _respawnCfg params ["_respawnOnStart", "_templates"];

        // Start client conditionals
        ["register", [_respawnOnStart, _templates, _timeout]] call FUNC(mpsync_clientConditionals);

        // Wait for server response
        [{
            params ["_timeout", "_variableToPass"];

            missionNamespace getVariable [_variableToPass, false];
        }, {
            // Wake up player
            [0, "Mission Starting..."] call FUNC(mpsync_blankScreen);
            [false] call FUNC(mpsync_muteClient);
            // Allow shooting
            [player, "enable"] call FUNC(mpsync_playerLMB);
            player enableSimulation true;
        }, [_timeOut, _variableToPass], _timeOut, {
            // Wake up player
            [0, "Mission Starting..."] call FUNC(mpsync_blankScreen);
            [false] call FUNC(mpsync_muteClient);
            // Allow shooting
            [player, "enable"] call FUNC(mpsync_playerLMB);
            player enableSimulation true;
        }] call CBA_fnc_waitUntilAndExecute;
    };
};

if (isNil QFUNC(mpsync_initServer)) then {
    FUNC(mpsync_initServer) = compileFinal {
        params ["_minPlayers","_timeout", "_variableToPass"];

        LOG("ModuleMPSync:: Initializing server...");

        [{
            params ["_minPlayers", "_timeout", "_variableToPass"];

            private _players = (allUnits + allDead) select {isPlayer _x};
            private _playersNotEmpty = _players isNotEqualTo [];
            private _aPlayerHasSpawned = _players findIf {_x getVariable [QGVAR(mpsync_layerSpawned), false]} != -1;
            private _enoughPlayersSpawned = ({ (_x getVariable [QGVAR(mpsync_playerSpawned), false]) } count _players >= _minPlayers);

            _playersNotEmpty && { _aPlayerHasSpawned && { _enoughPlayersSpawned}};

        }, {
            params ["_minPlayers", "_timeout", "_variableToPass"];

            missionNamespace setVariable [_variableToPass, true, true];
        }, [_minPlayers, _timeout, _variableToPass], _timeOut, {
            params ["_minPlayers", "_timeout", "_variableToPass"];
            // Timeout
            missionNamespace setVariable [_variableToPass, true, true];
        }] call CBA_fnc_waitUntilAndExecute;
    };
};

if (isNil QFUNC(mpsync_muteClient)) then {
    FUNC(mpsync_muteClient) = compileFinal {
        params [["_state", false, [true]]];

        LOG_1("ModuleMPSync:: Muting client state: %1",_state);

        // Set ACE hearing state
        if (isClass (configFile >> "CfgPatches" >> "ace_hearing")) then {
            ACE_Hearing_DisableVolumeUpdate = _state;
        };

        if (_state) then {
            0 fadeSound 0;
            0 fadeEnvironment 0;

            [QGVAR(mpsync_ClientMuted), [true]] call CBA_fnc_localEvent;
        } else {
            3 fadeSound 1;
            3 fadeEnvironment 1;

            [QGVAR(mpsync_ClientMuted), [false]] call CBA_fnc_localEvent;
        };
    };
};

if (isNil QFUNC(mpsync_playerLMB)) then {
    FUNC(mpsync_playerLMB) = compileFinal {
        params ["_unit", "_mode"];

        switch _mode do {
            case "disable": {
                _unit setVariable [QGVAR(mpsync_playerCurrentAmmo), _unit ammo currentWeapon _unit];
                _unit setAmmo [currentWeapon _unit, 0];
            };
            case "enable": {
                private _savedAmmo = _unit getVariable [QGVAR(mpsync_playerCurrentAmmo), 1e6];
                _unit setAmmo [currentWeapon _unit, _savedAmmo];
                _unit setVariable [QGVAR(mpsync_playerCurrentAmmo), nil];
            };
        };
    };
};

// Code Start
//------------------------------------------------------------------------------------------------
switch _mode do {
    case "init": {
        if (is3DEN) exitWith {};

        [_minPlayers, _timeout, _variableToPass] call FUNC(mpsync_init);
    };

    case "connectionChanged3DEN": {
        private _synced = get3DENConnections _module apply {_x select 1};
        private _invalid = _synced;
        if (_invalid isNotEqualTo []) then {
            [typeOf _module] call EFUNC(Error,invalidSync);

            // remove connection
            remove3DENConnection ["Sync", _invalid, _module];
        };
    };
};
