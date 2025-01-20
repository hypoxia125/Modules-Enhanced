#include "script_component.hpp"
#include "\a3\ui_f\hpp\defineResincl.inc"

#define TICKRATE            0.5
#define TICKRATE_NETWORK    3

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
if (_mode in ["dragged3DEN", "unregisteredFromWorld3DEN"]) exitWith {};

// Variables
//------------------------------------------------------------------------------------------------
private _area = _module getVariable ["ObjectArea", [100, 100, 0, false, 100]];

private _mapCtrl = (findDisplay IDD_MAIN_MAP) displayCtrl IDC_MAP;
private _gpsCtrl = ((uiNamespace getVariable ["RscCustomInfoMiniMap", displayNull]) displayCtrl 13301) controlsGroupCtrl 101;
private _scrambleCharacters = [];
for "_i" from 65 to 90 do {
    _scrambleCharacters pushBack toString [_i];
};
for "_i" from 97 to 122 do {
    _scrambleCharacters pushBack toString [_i];
};
for "_i" from 48 to 57 do {
    _scrambleCharacters pushBack toString [_i];
};

private _moduleObject = createHashMapObject [[
    ["#type", "ModuleCommunicationJammer"],
    ["module", _module],
    ["object", objNull],
    ["position", getPosASL _module],
    ["area", _area],
    ["connectedObject", objNull],
    ["mapCtrl", _mapCtrl],
    ["mapCtrlHandler", -1],
    ["gpsCtrlHandler", -1],
    ["gpsCtrl", _gpsCtrl],
    ["scrambleCharacters", _scrambleCharacters],
    ["jamAmount", 0],
    ["timeSinceStart", 0]
]];
_module setVariable [QGVAR(CommunicationJammer_ModuleObject), _moduleObject];

// Functions
//------------------------------------------------------------------------------------------------

// EnableDisableVoiceChannel
// -- Enables or disables voice channels
private _enableDisableVoiceChannel = compileFinal {
    params ["_mode"];

    LOG_1("ModuleCommunicationJammer:: Updating voice state: %1",_mode);

    switch toLowerANSI _mode do {
        case "enable": {
            for "_i" from 0 to 15 do {
                _i enableChannel [true, true];
            };
        };
        case "disable": {
            for "_i" from 0 to 15 do {
                _i enableChannel [true, false];
            };
        };
    };
};
_moduleObject set ["EnableDisableVoiceChannel", _enableDisableVoiceChannel];

// ScrambleTextCharacters
// -- Scrambles the given string to random characters depending on jam amount
private _scrambleTextCharacters = compileFinal {
    params ["_text", "_jamAmount"];

    LOG_1("ModuleCommunicationJammer:: Original Message: %1",_text);

    private _characters = _self get "scrambleCharacters";

    // Convert text to array of strings
    _text = _text splitString "";

    // Modify strings
    private _countChars = count _text;
    private _numBlocked = linearConversion [0, 1, _jamAmount, 0, _countChars, true];

    private _unusedMessageIndexes = [];
    if (_numBlocked > 0) then {
        for "_i" from 1 to _numBlocked do {
            private _randomIndex = round random count _text;

            if (
                (_randomIndex in _unusedMessageIndexes) ||
                (_text select _randomIndex isEqualTo " ")
            ) then {
                continue;
            };

            _text set [_randomIndex, selectRandom _characters];
            _unusedMessageIndexes pushBack _randomIndex;
        };
    };

    // Combine
    _text = _text joinString "";

    LOG_2("%1:: Scrambled Message: %2",QFUNC(scrambleTextCharacters),_text);

    // Return
    _text;
};
_moduleObject set ["ScrambleTextCharacters", _scrambleTextCharacters];

// UpdatePosition
// -- Updates the position and area arrays to wherever the module or object is
private _updatePosition = compileFinal {
    private _object = _self get "object";
    private _position = getPosASL _object;

    _self set ["position", _position];

    // LOG_1("ModuleCommunicationJammer:: Updated jammer position: %1",_position);
};
_moduleObject set ["UpdatePosition", _updatePosition];

// UpdateJamAmount
// -- Updates the jam amount for other use
private _updateJamAmount = compileFinal {

    private _area = [_self get "position"] + (_self get "area");
    if !(player inArea _area) exitWith {
        _self set ["jamAmount", 0];
    };

    private _centerDistance = player distance (_area#0);
    private _maxRadius = (_area#1) max (_area#2);

    private _jamAmount = linearConversion [_maxRadius, 0, _centerDistance, 0, 1, true] min 1;

    _self set ["jamAmount", _jamAmount];
    // LOG_1("ModuleCommunicationJammer:: Updated jam amount: %1", _jamAmount);
};
_moduleObject set ["UpdateJamAmount", _updateJamAmount];

// UpdateJamAmountGlobal
// -- Broadcasts the global max jam amount to the player's namespace to other clients
private _updateJamAmountGlobal = compileFinal {
    private _allJamAmounts = _self call ["GetAllJamAmounts"];
    private _maxJam = selectMax _allJamAmounts;

    player setVariable [QGVAR(CommunicationJammer_MaxJamGlobal), _maxJam, true];
};
_moduleObject set ["UpdateJamAmountGlobal", _updateJamAmountGlobal];

// GetAllJamAmounts
// -- Finds all jammer modules and gets their jam amount. Returns an array of all jam amounts.
private _getAllJamAmounts = compileFinal {
    // LOG("ModuleCommunicationJammer:: Grabbing all jamming amounts...");

    private _allJammerModules = entities "MEH_ModuleCommunicationJammer";
    private _jamAmounts = [];

    {
        private _moduleObject = _x getVariable [QGVAR(CommunicationJammer_ModuleObject), createHashMap];
        private _jamAmount = _moduleObject getOrDefault ["jamAmount", 0];
        _jamAmounts pushBack _jamAmount;
    } forEach _allJammerModules;

    // return
    // LOG_1("ModuleCommunicationJammer:: All jam amounts: %1", _jamAmounts);
    _jamAmounts;
};
_moduleObject set ["GetAllJamAmounts", _getAllJamAmounts];

// UpdateAllJamAmounts_Player
// -- Updates all jam amounts to the player's namespace for GUI event handlers
private _updateAllJamAmounts_Player = compileFinal {
    private _allJamAmounts = _self call ["GetAllJamAmounts"];
    
    player setVariable [QGVAR(CommunicationJammer_AllJamAmounts), _allJamAmounts];
};
_moduleObject set ["UpdateAllJamAmounts_Player", _updateAllJamAmounts_Player];

// Update TFAR Interference
// -- Updates the TFAR interference depending on how deep a player is
private _updateTFARInterference = compileFinal {
    private _allJamAmounts = _self call ["GetAllJamAmounts"];
    private _maxJam = selectMax _allJamAmounts;

    player setVariable ["tf_receivingDistanceMultiplicator", _maxJam];
    player setVariable ["tf_sendingDistanceMultiplicator", _maxJam];
};
_moduleObject set ["UpdateTFARInterference", _updateTFARInterference];

// Init
// -- Starts the communcation jammer system
private _init = compileFinal {
    LOG("ModuleCommunicationJammer:: Initializing...");

    // Map Icon Handler
    private _mapCtrl = _self get "mapCtrl";
    private _mapCtrlHandler = _mapCtrl ctrlAddEventHandler ["Draw", {
        params ["_mapCtrl"];

        private _allJamAmounts = player getVariable [QGVAR(CommunicationJammer_AllJamAmounts), [0]];

        // UI Stuff
        private _mapCenter = _mapCtrl ctrlMapScreenToWorld [0.5, 0.5];
        private _screenSize = 640 * safeZoneWAbs;

        private _maxAmount = selectMax _allJamAmounts;

        // Texture + Icon
        private _texture = "#(rgb,8,8,3)color(0,0,0,1)";
        _mapCtrl drawIcon [_texture, [1,1,1,_maxAmount], _mapCenter, _screenSize, _screenSize, 0, "", 0];
    }];
    _self set ["mapCtrlHandler", _mapCtrlHandler];

    // GPS Icon
    private _gpsCtrl = _self get "gpsCtrl";
    private _gpsCtrlHandler = _gpsCtrl ctrlAddEventHandler ["Draw", {
        params ["_ctrl"];

        private _allJamAmounts = player getVariable [QGVAR(CommunicationJammer_AllJamAmounts), [0]];

        // UI stuff
        private _center = _ctrl ctrlMapScreenToWorld (ctrlPosition _ctrl select [0,2]);
        private _size = 512;

        private _maxAmount = selectMax _allJamAmounts;

        // Texture + Icon
        private _texture = "#(rgb,8,8,3)color(0,0,0,1)";
        _ctrl drawIcon [_texture, [1,1,1,_maxAmount], _center, _size, _size, 0, "", 0];
    }];
    _self set ["gpsCtrlHandler", _gpsCtrlHandler];

    // Handle Chat Messages
    addMissionEventHandler ["HandleChatMessage", {
        params ["_channel", "_owner", "_from", "_text", "_person", "_name", "_strID", "_forcedDisplay", "_isPlayerMessage", "_sentenceType", "_chatMessageType"];
        _thisArgs params ["_self"];

        private _finalText = _text;
        // Self sent message or received from AI
        if (player == _person || !(isPlayer _person)) then {
            private _jamAmounts = _self call ["GetAllJamAmounts"];
            private _maxAmount = selectMax _jamAmounts;

            // return
            _finalText = _self call ["ScrambleTextCharacters", [_text, _maxAmount]];
        };

        // Received message
        if (player != _person) then {
            private _jamAmountsPlayer = _self call ["GetAllJamAmounts"];
            private _maxAmountPlayer = selectMax _jamAmountsPlayer;

            private _unitJam = _person getVariable [QGVAR(CommunicationJammer_MaxJamGlobal), 0];

            // select the stronger of the two jams
            private _jam = _maxAmountPlayer max _unitJam;

            _finalText = _self call ["ScrambleTextCharacters", [_text, _jam]];
        };

        _finalText;
    }, [_self]];

    // Handle updating jam amount globally in player namespace
    private _handle = player getVariable QGVAR(CommunicationJammer_GlobalJamUpdater);
    if (isNil "_handle") then {
        LOG("ModuleCommunicationJammer:: Starting global jam updater for player");
        _handle = [{
            params ["_args", "_handle"];
            _args params ["_self"];

            private _allJammerModules = entities "MEH_ModuleCommunicationJammer";
            if (_allJammerModules findIf {alive _x} == -1) exitWith {_handle call CBA_fnc_removePerFrameHandler};

            // Update jam amount globally, at a longer interval
            LOG_1("ModuleCommunicationJammer:: Updating jam amount globally: frameNo: %1",diag_frameNo);
            _self call ["UpdateJamAmountGlobal"];
        }, TICKRATE_NETWORK, [_self]] call CBA_fnc_addPerFrameHandler;
        player setVariable [QGVAR(CommunicationJammer_GlobalJamUpdater), _handle];
    };

    // System Logic
    [{
        params ["_args", "_handle"];
        _args params ["_self"];

        // Early exits + destruction of handlers
        if (isGamePaused) exitWith {};
        if (
            !alive (_self get "module") ||
            {!alive (_self get "object")}
        ) exitWith {
            LOG("Module Or Object Deleted - Destroying handlers...");
            _handle call CBA_fnc_removePerFrameHandler;
            (_self get "mapCtrl") ctrlRemoveEventHandler ["Draw", _self get "mapCtrlHandler"];
            (_self get "gpsCtrl") ctrlRemoveEventHandler ["Draw", _self get "gpsCtrlHandler"];
        };

        // Update position
        _self call ["UpdatePosition"];

        // Update global jam amounts
        _self call ["UpdateAllJamAmounts_Player"];

        // Update jam amount for this module
        _self call ["UpdateJamAmount"];

        // Update TFAR Jam Amounts
        _self call ["UpdateTFARInterference"];
    }, TICKRATE, [_self]] call CBA_fnc_addPerFrameHandler;
};
_moduleObject set ["Init", _init];

// Code Start
//------------------------------------------------------------------------------------------------
switch _mode do {
    case "init": {
        if (is3DEN) exitWith {};
        if (!hasInterface) exitWith {};

        private _objects = synchronizedObjects _module select {!(_x isKindOf "EmptyDetector")};
        if (count _objects > 1) exitWith {
            systemChat format["ModuleCommunicationJammer [%1]:: Too many connected objects... disabling.",_module];
        };
        private _object = _objects#0;

        // Use module if object doesn't exist
        if (isNil "_object") then {_object = _module};
        _moduleObject set ["object", _object];

        _moduleObject call ["Init"];
    };

    case "registeredToWorld3DEN": {
    };

    case "attributesChanged3DEN": {
    };

    case "connectionChanged3DEN": {
    };
};