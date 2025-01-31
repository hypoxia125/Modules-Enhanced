#include "script_component.hpp"
#include "\a3\ui_f\hpp\defineResincl.inc"

#define TICKRATE                    0.5
#define TICKRATE_NETWORK            3
#define e                           2.718
#define CLAMP(var1,lower,upper)     lower max (var1 min upper)

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
if (_mode in ["dragged3DEN"]) exitWith {};

// Variables
//------------------------------------------------------------------------------------------------
private _area = _module getVariable ["ObjectArea", [100, 100, 0, false, 100]];
if (is3DEN) then {
    // need to do this in 3DEN due to the module area not being updated on move above
    _area = [_module] call FUNC(get3DENAreaModule);
    // removes the center position from the area array
    _area deleteAt 0;
};
private _jamFormula = _module getVariable ["JamFormula", 0];
private _k = _module getVariable ["k", 1];
private _visualizeRadius = _module getVariable ["VisualizeRadius", 0];

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
    ["timeSinceStart", 0],
    ["jamFormula", _jamFormula],
    ["k", _k],
    ["visualizeRadius", _visualizeRadius]
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
    private _normalizedDistance = _centerDistance / _maxRadius;

    private _jamAmount = 0;
    private _k = _self get "k";
    switch (_self get "jamFormula") do {
        case 0: {
            // Linear
            _jamAmount = 1 - _normalizedDistance;
        };

        case 1: {
            // Power Fall-Off
            // suggested k = 2
            _jamAmount = 1 - (_normalizedDistance ^ _k);
        };

        case 2: {
            // Exponential
            // suggested k = 5
            _jamAmount = (e ^ (-_k * _normalizedDistance));
        };

        case 3: {
            // Logarithmic
            // k must be >= 2
            // suggested k = 2
            _jamAmount = (1 - (log(1 + _normalizedDistance) / log(_k min 2)));
        };

        case 4: {
            // Inverse Power
            // suggested k = 2
            _jamAmount = 1 - (1 / (1 + (_normalizedDistance ^ _k)));
        };

        case 5: {
            // Sine Wave
            // suggested k = 1
            _jamAmount = (cos(_k * pi * _normalizedDistance) + 1) / 2;
        };

        case 6: {
            // Sigmoid
            // suggested k = 10
            _jamAmount = 1 / (1 + e ^ (_k * (_normalizedDistance - 0.5)));
        };
    };
    _jamAmount = CLAMP(_jamAmount,0,1);

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

// Build3DENMarkers
// -- Builds markers to show how bad the jammer is at different distances from the module
private _build3DENMarkers = compileFinal {
    // Delete previous markers
    private _module = _self get "module";
    private _previousMarkers = _module getVariable [QGVAR(CommunicationJammer_3DENMarkers), []];
    LOG_1("ModuleCommunicationJammer.Build3DENMarkers:: Deleting previous markers: %1",_previousMarkers);
    {
        deleteVehicle _x;
    } forEach _previousMarkers;

    private _visualizeRadius = _self get "visualizeRadius";
    private _markers = [];

    switch _visualizeRadius do {
        case 0: {};
        case 1: {
            {
                private _i = _x;
                private _markersTemp = _self call ["Build3DENRadius2D", [_i]];
                _markers insert [-1, _markersTemp];
            } forEach [0, 0.25, 0.5, 0.75];
        };
        case 2: {
            {
                private _i = _x;
                private _markersTemp = _self call ["Build3DENOrb", [_i]];
                _markers insert [-1, _markersTemp];
            } forEach [0, 0.5, 0.75];
        };
        case 3: {
            {
                private _i = _x;
                private _markersTemp = _self call ["Build3DENOrbOutline", [_i]];
                _markers insert [-1, _markersTemp];
            } forEach [0, 0.5, 0.75];
        };
    };

    _module setVariable [QGVAR(CommunicationJammer_3DENMarkers), _markers];
};
_moduleObject set ["Build3DENMarkers", _build3DENMarkers];

// GenerateSpherePoints
// -- Generates the points on a sphere
private _generateSpherePoints = compileFinal {
    params ["_numPoints", "_center", "_radius"];

    TRACE_3("GenerateSpherePointsInput::",_numPoints,_center,_radius);

    private _points = [];
    private _phi = (1 + sqrt(5)) / 2;

    for "_i" from 0 to (_numPoints - 1) do {
        private _z = 1 - (2 * _i) / (_numPoints - 1.0);
        private _radiusAtHeight = sqrt (1 - _z^2);
        private _theta = deg (2 * pi * _i / _phi);
        private _xx = _radiusAtHeight * cos(_theta);
        private _yy = _radiusAtHeight * sin(_theta);

        _points pushBack [
            _xx * _radius + _center#0,
            _yy * _radius + _center#1,
            _z * _radius + _center#2
        ];

        TRACE_4("Math Values::",_z,_radiusAtHeight,_theta,_phi);
    };

    // return
    _points;
};
_moduleObject set ["GenerateSpherePoints", _generateSpherePoints];

// Build3DENOrb
// -- Builds an orb for requested percent jam
private _build3DENOrb = compileFinal {
    params ["_desiredJam"];

    private _area = [_self get "position"] + (_self get "area");
    _area params ["_center", "_a", "_b"];
    private _maxRadius = _a max _b;
    private _distance = _self call ["CalculateDistanceFromJamAmount", [_desiredJam]];

    private _orbSize = CM_TO_M(100/2);
    private _scale = _distance / _orbSize;

    // private _orb = createVehicle ["Sign_Sphere25cm_F", ASLToAGL _center, [], 0, "CAN_COLLIDE"];
    private _orb = createSimpleObject ["Sign_Sphere100cm_F", _center];
    _orb setObjectScale _scale;

    private _alpha = 0.01;
    switch true do {
        case (_desiredJam >= 0.75): {
            _orb setObjectTexture [0, "#(rgb,8,8,3)color(0.5,0,0,0.03)"];
        };
        case (_desiredJam >= 0.5): {
            _orb setObjectTexture [0, "#(rgb,8,8,3)color(0.5,0.5,0,0.02)"];
        };
        case (_desiredJam >= 0): {
            _orb setObjectTexture [0, "#(rgb,8,8,3)color(0,0.5,0,0.01)"];
        };
    };

    // return
    [_orb];
};
_moduleObject set ["Build3DENOrb", _build3DENOrb];

// Build3DENOrbOutline
// -- Builds markers for the requested percent jam surrouding an orb
private _build3DENOrbOutline = compileFinal {
    params ["_desiredJam"];

    LOG_1("ModuleCommunicationJammer.Build3DENOrbOutline:: Building markers for %1 jam amount...",_desiredJam);

    private _area = [_self get "position"] + (_self get "area");
    _area params ["_center", "_a", "_b"];
    private _maxRadius = _a max _b;
    private _distance = _self call ["CalculateDistanceFromJamAmount", [_desiredJam]];
    private _orbSize = CM_TO_M(100/2);
    private _scaleFactor = 0.05;
    private _scale = _orbSize * (1 + _scaleFactor * _distance);
    private _nPoints = 500 * (1 + _scaleFactor * _distance);

    private _positions = _self call ["GenerateSpherePoints", [500, _center, _distance]];

    LOG_1("ModuleCommunicationJammer.Build3DENOrbOutline:: Positions to build orbs: %1",_positions);
    private _orbs = [];
    {
        private _position = _x;

        LOG_1("ModuleCommunicationJammer.Build3DENOrbOutline:: Building orb at position: %1",_position);

        private _orb = createSimpleObject ["Sign_Sphere100cm_F", _position];
        _orb setObjectScale _scale;
        _orbs pushBack _orb;

        switch true do {
            case (_desiredJam >= 0.75): {
                _orb setObjectTexture [0, "#(rgb,8,8,3)color(0.5,0,0,1)"];
            };
            case (_desiredJam >= 0.5): {
                _orb setObjectTexture [0, "#(rgb,8,8,3)color(0.5,0.5,0,1)"];
            };
            case (_desiredJam >= 0): {
                _orb setObjectTexture [0, "#(rgb,8,8,3)color(0,0.5,0,1)"];
            };
        };
    } forEach _positions;

    // return
    _orbs;
};
_moduleObject set ["Build3DENOrbOutline", _build3DENOrbOutline];

// Build3DENRadius2D
// -- Builds markers in the radius of the jamming area on a 2D plane
private _build3DENRadius2D = compileFinal {
    params ["_desiredJam"];

    private _area = [_self get "position"] + (_self get "area");
    _area params ["_center", "_a", "_b"];
    private _maxRadius = _a max _b;
    private _distance = _self call ["CalculateDistanceFromJamAmount", [_desiredJam]];

    private _spacing = 5;
    private _circumference = 2 * pi * _distance;
    private _numObjects = _circumference / _spacing;
    private _angleIncrement = 2 * pi / _numObjects;

    private _positions = [];
    private _orbs = [];
    for "_i" from 0 to (_numObjects - 1) do {
        private _angleRadians = _i * _angleIncrement;
        private _angleDegrees = _angleRadians * (180 / pi);
        private _xx = _distance * cos(_angleDegrees);
        private _yy = _distance * sin(_angleDegrees);
        _positions pushBack [_xx + _center#0, _yy + _center#1, _center#2];
    };
    {
        LOG_1("Position created: %1",_x);
    } forEach _positions;
    {
        private _position = _x;

        private _orb = createSimpleObject ["Sign_Sphere100cm_F", _position];
        // _orb setObjectScale _scale;
        _orbs pushBack _orb;

        switch true do {
            case (_desiredJam >= 0.75): {
                _orb setObjectTexture [0, "#(rgb,8,8,3)color(0.5,0,0,1)"];
            };
            case (_desiredJam >= 0.5): {
                _orb setObjectTexture [0, "#(rgb,8,8,3)color(0.5,0.5,0,1)"];
            };
            case (_desiredJam >= 0): {
                _orb setObjectTexture [0, "#(rgb,8,8,3)color(0,0.5,0,1)"];
            };
        };
    } forEach _positions;

    // return
    _orbs;
};
_moduleObject set ["Build3DENRadius2D", _build3DENRadius2D];

// CalculateDistanceFromJamAmount
// -- Calculates the distances from a desired jamAmount
private _calculateDistanceFromJamAmount = compileFinal {
    params ["_desiredJam"];

    _desiredJam = CLAMP(_desiredJam,0,1);

    private _k = _self get "k";

    private _area = [_self get "position"] + (_self get "area");
    private _maxRadius = (_area#1) max (_area#2);
    private _normalizedDistance = 0;

    switch (_self get "jamFormula") do {
        case 0: {
            // Linear
            _normalizedDistance = 1 - _desiredJam;
        };
        case 1: {
            // Power Fall-Off
            // Avoid k = 0
            if (_k == 0) then {
                _normalizedDistance = 1 - _desiredJam;
            } else {
                _normalizedDistance = (1 - _desiredJam) ^ (1 / _k);
            };            
        };
        case 2: {
            // Exponential
            // Avoid log(0)
            if (_desiredJam > 0) then {
                _normalizedDistance = - (log _desiredJam) / _k;
            } else {
                _normalizedDistance = _maxRadius;
            };
        };
        case 3: {
            // Logarithmic
            // Avoid _desiredJam = 1
            if (_desiredJam >= 1) then {
                _normalizedDistance = 0;
            } else {
                _normalizedDistance = (10 ^ ((log (_k max 2)) * (1 - _desiredJam))) - 1;
            };
        };
        case 4: {
            // Inverse Power
            // Avoid _desiredJam = 1
            if (_desiredJam >= 1) then {
                _normalizedDistance = 0;
            } else {
                _normalizedDistance = ((1 - _desiredJam) - 1) ^ (1 / _k);
            };
        };
        case 5: {
            // Sine Wave
            // Input to acos must be [-1,1]
            private _cosInput = (2 * _desiredJam) - 1;
            _cosInput = CLAMP(_cosInput,-1,1);
            _normalizedDistance = (acos(_cosInput)) / (_k * pi);
        };
        case 6: {
            // Sigmoid
            // _desiredJam has to be (0,1)
            if (_desiredJam == 0 || _desiredJam >= 1) then {
                _normalizedDistance = 0.5;
            } else {
                _normalizedDistance = 0.5 + (log((1 / _desiredJam) - 1)) / _k;
            };
        };
    };

    private _distance = _normalizedDistance * _maxRadius;
    LOG_1("ModuleCommunicationJammer.CalculateDistanceFromJamAmount:: Distance calculated: %1",_distance);
    _distance = CLAMP(_distance,0,_maxRadius);
    LOG_1("ModuleCommunicationJammer.CalculateDistanceFromJamAmount:: Distance calculated clamped: %1",_distance);


    // return
    _distance;
};
_moduleObject set ["CalculateDistanceFromJamAmount", _calculateDistanceFromJamAmount];

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
            _self call ["ZeroJamAmount"];
            _self call ["UpdateJamAmountGlobal"];
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

// ZeroJamAmount
// -- Zero's out the module's jam amount
private _zeroJamAmount = compileFinal {
    _self set ["jamAmount", 0];
};
_moduleObject set ["ZeroJamAmount", _zeroJamAmount];

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

        if (!_isActivated) exitWith {};
        _moduleObject call ["Init"];
    };

    case "registeredToWorld3DEN": {
    };

    case "attributesChanged3DEN": {
        if !(is3DEN) exitWith {};

        _moduleObject call ["Build3DENMarkers"];
    };

    case "connectionChanged3DEN": {
    };

    case "unregisteredFromWorld3DEN": {
        private _previousMarkers = _module getVariable [QGVAR(CommunicationJammer_3DENMarkers), []];
        LOG_1("ModuleCommunicationJammer.Build3DENMarkers:: Deleting previous markers: %1",_previousMarkers);
        {
            deleteVehicle _x;
        } forEach _previousMarkers;
    };
};