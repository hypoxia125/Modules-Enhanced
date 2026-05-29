/* ----------------------------------------------------------------------------
Function: meh_namespaces_fnc_doVirtualArtillery

Author: Hypoxic

Public: True

Flags: Global Argument, Global Execution, Scheduled

Description:
    Creates an area of bombardment for virtual artillery
---------------------------------------------------------------------------- */

#include "script_component.hpp"

params [
    ["_area", [[0,0,0], 100, 100, 0, false, -1], [[]], 5],
    ["_shell", "Sh_82mm_AMOS", [""]],
    ["_salvoSize", 6, [-1]],
    ["_salvoInterval", 10, [-1]],
    ["_salvoTimeVariation", 5, [-1]],
    ["_shotInterval", 1, [-1]],
    ["_shotTimeVariation", 1, [-1]]
];

if (!canSuspend) exitWith { _this spawn FUNC(doVirtualArtillery) };

if !(_area isEqualTypeArray [[], -1, -1, -1, true, -1]) exitWith {};

// TODO: Create virtual HQs for use with setShotParents
// that way we can cause units to be suppressed
// Try to make the vitual HQ on sideEnemy (5) and see what happens

private _state = createHashMapObject;
_state set ["area", _area];
_state set ["shell", _shell];
_state set ["salvoSize", _salvoSize];
_state set ["salvoInterval", _salvoInterval];
_state set ["salvoTimeVariation", _salvoTimeVariation];
_state set ["shotInterval", _shotInterval];
_state set ["shotTimeVariation", _shotTimeVariation];
_state set ["salvoCount", 0];
_state set ["salvoInProgress", false];
_state set ["nextShotTime", 0];
_state set ["currentSalvoSize", 0];

_state set ["fn_cancelArtillery", {
    private _frameHandler = _state getOrDefault ["frameHandler", -1];
    _frameHandler call CBA_fnc_removePerFrameHandler;
}];

private _handle = [{
    params ["_args", "_handle"];
    _args params ["_state"];

    private _currentTime = CBA_missionTime;

    // Update position if module is used and moved
    private _module = _state get "module";
    if (!isNil "_module") then {
        private _pos = getPosATL _module;
        private _area = _state get "area";
        _area set [0, _pos];
    };

    // Not currently in a salvo - start a new one
    if (!(_state get "salvoInProgress")) then {
        _state set ["currentSalvoSize", _state get "salvoSize"];
        _state set ["salvoCount", 0];
        _state set ["salvoInProgress", true];
        _state set ["nextShotTime", _currentTime]; // Fire first shot immediately
    };

    // Check if it's time to fire the next shot
    if ((_state get "salvoInProgress") && {_currentTime >= (_state get "nextShotTime")}) then {
        // Fire a shot
        private _pos = [[_state get "area"]] call BIS_fnc_randomPos;
        _pos set [2, 1000];

        private _round = [_state get "shell", _pos] call FUNC(createVirtualArtilleryRound);
        
        private _salvoCount = (_state get "salvoCount") + 1;
        _state set ["salvoCount", _salvoCount];
        
        // Check if salvo is complete
        if (_salvoCount >= (_state get "currentSalvoSize")) then {
            // Salvo complete - schedule next salvo
            private _salvoDelay = (_state get "salvoInterval") + random (_state get "salvoTimeVariation");
            _state set ["salvoInProgress", false];
            _state set ["nextShotTime", _currentTime + _salvoDelay];
        } else {
            // Schedule next shot in this salvo
            private _shotDelay = (_state get "shotInterval") + random (_state get "shotTimeVariation");
            _state set ["nextShotTime", _currentTime + _shotDelay];
        };
    };
}, 0.1, [_state]] call CBA_fnc_addPerFrameHandler;

_state set ["frameHandler", _handle];

_state