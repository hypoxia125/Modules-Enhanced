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

// Code Start
//------------------------------------------------------------------------------------------------
switch _mode do {
    case "init": {
        if (is3DEN) exitWith {};

        private _originalFlags = [_module] call FUNC(getConnectedFlags);

        if (_moduleMode == 0) then {
            {
                [_x, _flagToReplace, _customTexture] call FUNC(replaceFlagTexture);
            } forEach _originalFlags;
        } else {
            {
                [_x, _flagToReplace, _customTexture, _retainVarName] call FUNC(createNewFlag);
            } forEach _originalFlags;
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
