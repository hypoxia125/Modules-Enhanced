#include "script_component.hpp"

params [["_mode", "", [""]], ["_input", [], [[]]]];
_input params [["_module", objNull, [objNull]]];
if (_mode != "init") exitWith {};

if !(missionNamespace getVariable [QGVAR(CapturePointSystemDebug), false]) then {
    if (_module getVariable ["Debug", false]) then {
        [QGVAR(CapturePoint_OwnerChanged), {
            params ["_module", "_currentOwner", "_newOwner", "_pointLetter"];
            systemChat format ["Point: %1 - Ownership changed: %2", _pointLetter, _newOwner];
        }] call CBA_fnc_addEventHandler;
        missionNamespace setVariable [QGVAR(CapturePointSystemDebug), true];
    };
};

if (!isServer || {!isNil QGVAR(CapturePointSystemModules)}) exitWith {};

GVAR(CapturePointSystemModules) = [];
GVAR(CapturePointSystemUpdateRate) = ((_module getVariable "UpdateRate") max 1000) / 1000;
GVAR(CapturePointSystemShowUI) = _module getVariable "ShowUI";
publicVariable QGVAR(CapturePointSystemShowUI);

GVAR(CapturePointSystemHandle) = [{
    params ["_args"];
    _args params ["_updateRate", "_elapsed"];

    if (!isMultiplayer && {isGamePaused}) exitWith {};
    _elapsed = _elapsed + diag_deltaTime;
    if (_elapsed < _updateRate) exitWith {
        _args set [1, _elapsed];
    };
    _args set [1, 0];

    {
        if (!alive _x) then {
            GVAR(CapturePointSystemModules) deleteAt (GVAR(CapturePointSystemModules) find _x);
        } else {
            [_x, _elapsed] call FUNC(capturePoint_update);
        };
    } forEach (+GVAR(CapturePointSystemModules));
}, 0, [GVAR(CapturePointSystemUpdateRate), 0]] call CBA_fnc_addPerFrameHandler;
LOG(QFUNC(moduleCapturePointSystem) + ":: System started...");
