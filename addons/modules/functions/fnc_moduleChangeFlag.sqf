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
if (!isServer) exitWith {};
if !(_mode in ["init", "connectionChanged3DEN"]) exitWith {};

// Variables
//------------------------------------------------------------------------------------------------
private _moduleMode = _module getVariable "Mode";
private _flagToReplace = _module getVariable ["FlagToReplace", ""];
private _customTexture = _module getVariable "CustomTexture";
private _retainVarName = _module getVariable "RetainVarName";

// Functions
//------------------------------------------------------------------------------------------------
private _getConnectedFlag = {
    params ["_module"];

    private _synced = synchronizedObjects _module;
    private _flag = _synced select {_x isKindOf "FlagCarrier"};
    
    _flag#0;
};

private _createNewFlag = {
    params ["_originalFlag", "_flagToReplace", "_customTexture", "_retainVarName"];

    private _pos = getPosASL _originalFlag;
    private _dirAndUp = [vectorDir _originalFlag, vectorUp _originalFlag];
    private _varName = vehicleVarName _originalFlag;

    deleteVehicle _originalFlag;

    private _newFlag = objNull;
    if (_flagToReplace == "") then {
        // custom flag texture setup - use default white pole
        _flagToReplace = "flag_White_F";
        _newFlag = createVehicle [_flagToReplace, [0,0,0], [], 0, "CAN_COLLIDE"];
        _newFlag setPosASL _pos;
        _newFlag setVectorDirAndUp _dirAndUp;
        _newFlag setFlagTexture _customTexture;
    } else {
        _newFlag = createVehicle [_flagToReplace, [0,0,0], [], 0, "CAN_COLLIDE"];
        _newFlag setPosASL _pos;
        _newFlag setVectorDirAndUp _dirAndUp;
    };

    if (_retainVarName) then {
        _newFlag setVehicleVarName _varName;
        missionNamespace setVariable [_varName, _newFlag, true];
    };
};

private _replaceFlagTexture = {
    params ["_originalFlag", "_flagToReplace", "_customTexture"];

    private _filePath = "";
    if (_flagToReplace == "") then {
        // custom flag texture
        _filePath = _customTexture;
    } else {
        private _textureString = getText (configFile >> "CfgVehicles" >> _flagToReplace >> "EventHandlers" >> "init");
        private _parts = _textureString splitString "'";
        _filePath = _parts#1;
    };

    _originalFlag setFlagTexture _filePath;
};

// Code Start
//------------------------------------------------------------------------------------------------
switch _mode do {
    case "init": {
        if (is3DEN) exitWith {};

        private _originalFlag = [_module] call _getConnectedFlag;

        if (_moduleMode == 0) then {
            [_originalFlag, _flagToReplace, _customTexture] call _replaceFlagTexture;
        } else {
            [_originalFlag, _flagToReplace, _customTexture, _retainVarName] call _createNewFlag;
        };
    };

    case "connectionChanged3DEN": {
        private _synced = get3DENConnections _module apply {_x select 1};
        private _invalid = _synced select {
            !(_x isKindOf "EmptyDetector") &&
            !(_x isKindOf "FlagCarrier")
        };
        if (_invalid isNotEqualTo []) then {
            [typeOf _module] call EFUNC(Error,invalidSync);

            // remove connection
            remove3DENConnection ["Sync", _invalid, _module];
        };
    };
};