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
if !(_mode in ["init"]) exitWith {};

// Variables
//------------------------------------------------------------------------------------------------
private _updateRate = _module getVariable "UpdateRate";
_updateRate = _updateRate / 1000;

// System
//------------------------------------------------------------------------------------------------
if (!isNil QGVAR(CapturePointSystem)) exitWith {};

GVAR(CapturePointSystem) = createHashMapObject [[
    ["#type", QGVAR(CapturePointSystem)],
    ["#str", {str _module}],
    
    ["_updateRate", _updateRate],
    ["_modules", []],

    ["#create", {
        if ((_self get "#type" select 0) == "SystemBase") exitWith {};

        _self call ["SystemStart"];
    }],

    ["Update", {
        LOG(QFUNC(moduleCapturePointSystem) + ":: Attempting to update all module objects");
        private _modules = _self get "_modules";
        LOG_1(QFUNC(moduleCapturePointSystem) + ":: Total objects: %1",count _modules);
        {
            private _module = _x;
            if (!alive _module) then {
                _self call ["Unregister", [_module]];
                continue;
            };
            
            private _moduleObject = _module getVariable QGVAR(CreateCapturePoint_ModuleObject);

            LOG_1(QFUNC(moduleCapturePointSystem) + ":: Attempting to update module object - %1",_moduleObject);
            _moduleObject call ["Update"];
        } forEach _modules;
    }],

    ["Register", {
        params ["_module"];
        if (isNil "_module") exitWith {};

        private _modules = _self get "_modules";
        private _idx = _modules find _module;
        if (_idx != -1) exitWith {};

        _modules insert [-1, [_module], true];
        _self set ["_modules", _modules];

        LOG_1(QFUNC(moduleCapturePointSystem) + ":: Module registered - %1",_module);
    }],

    ["Unregister", {
        params ["_module"];
        if (isNil "_module") exitWith {};

        private _modules = _self get "_modules";
        private _idx = _modules find _module;
        if (_idx == -1) exitWith {};

        _modules deleteAt _idx;
        _self set ["_modules", _modules];

        LOG_1(QFUNC(moduleCapturePointSystem) + ":: Module UNregistered - %1",_module);
    }],

    ["SystemStart", {
        private _handle = [{
            params ["_args", "_handle"];
            _args params ["_self"];

            if (!isMultiplayer && isGamePaused) exitWith {};

            _self call ["Update", []];
        }, _self get "_updateRate", [_self]] call CBA_fnc_addPerFrameHandler;

        LOG(QFUNC(moduleCapturePointSystem) + ":: System started...");

        _self set ["_frameSystemHandle", _handle];
    }]
]];