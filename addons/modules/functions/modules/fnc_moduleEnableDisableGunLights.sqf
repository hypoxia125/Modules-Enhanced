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
if (!is3DEN && {!_isActivated}) exitWith {};
if (_mode in ["dragged3DEN", "unregisteredFromWorld3DEN"]) exitWith {};

// Variables
//------------------------------------------------------------------------------------------------
private _state = _module getVariable [QUOTE(State), 0];
private _addAttachment = _module getVariable [QUOTE(AddAttachment), false];
private _attachment = _module getVariable [QUOTE(Attachment), "acc_flashlight"];

private _units = synchronizedObjects _module select {_x isKindOf "CAManBase"};
if (!(isClass (configFile >> "CfgWeapons" >> _attachment))) exitWith {[typeOf _module] call EFUNC(Error,invalidArgs)};

// Functions
//------------------------------------------------------------------------------------------------
private _enableGunLights = {
    params ["_groups", "_state", "_addAttachment", "_attachment"];

    private _lightState = switch _state do {
        case 0: {"Auto"};
        case 1: {"ForceOn"};
        case 2: {"ForceOff"};
    };

    _groups apply {
        private _group = _x;
        private _units = units _x;

        if (_addAttachment) then {
            _units apply {
                private _unit = _x;
                [QGVAR(AddFlashlightAttachment), [_unit, _attachment], _unit] call CBA_fnc_targetEvent;
            };
        };

        [QGVAR(enableGunLightsAI), [_group, _lightState], _group] call CBA_fnc_targetEvent;

        private _players = _units select {isPlayer _x};
        _players apply {
            private _unit = _x;
            [QGVAR(enableGunLightsPlayer), [_unit, _lightState], _unit] call CBA_fnc_targetEvent;
        };
    };
};

// Code Start
//------------------------------------------------------------------------------------------------
switch _mode do {
    case "init": {
        if (is3DEN) exitWith {};

        // Get groups
        if (_units isEqualTo []) exitWith {[typeOf _module] call EFUNC(Error,requiresSync)};
        private _groups = _units apply {group _x};
        _groups = _groups arrayIntersect _groups;

        // Wait for mission to start and execute. Won't work otherwise
        private _args = [_groups, _state, _addAttachment, _attachment, _enableGunLights];
        [{
            time > 0;
        }, {
            params ["_groups", "_state", "_addAttachment", "_attachment", "_enableGunLights"];
            _this call _enableGunLights;
        }, _args] call CBA_fnc_waitUntilAndExecute;
    };

    case "connectionChanged3DEN": {
        private _synced = get3DENConnections _module apply {_x select 1};
        private _invalid = _synced select {!(_x isKindOf "CAManBase" or _x isKindOf "EmptyDetector")};
        if (_invalid isNotEqualTo []) then {
            [typeOf _module] call EFUNC(Error,invalidSync);

            // remove connection
            remove3DENConnection ["Sync", _invalid, _module];
        };
    };

    default {};
};
