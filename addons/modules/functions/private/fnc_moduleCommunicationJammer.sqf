/* ----------------------------------------------------------------------------
Function: meh_modules_fnc_moduleCommunicationJammer

Author: Hypoxic

Public: False - Requires internal data

Description:
    Function that the module calls upon initialization.
---------------------------------------------------------------------------- */

#include "script_component.hpp"
#include "\a3\ui_f\hpp\defineResincl.inc"

#define TICKRATE 0.5
#define TICKRATE_NETWORK 3
#define e 2.718
#define CLAMP(value,lower,upper) lower max (value min upper)

params [["_mode", "", [""]], ["_input", [], [[]]]];
_input params [
    ["_module", objNull, [objNull]],
    ["_isActivated", false, [true]],
    ["_isCuratorPlaced", false, [true]]
];
if (_mode == "dragged3DEN") exitWith {};

private _area = _module getVariable ["ObjectArea", [100, 100, 0, false, 100]];
if (is3DEN) then {
    _area = [_module] call FUNC(get3DENAreaModule);
    _area deleteAt 0;
};
private _formula = _module getVariable ["JamFormula", 0];
private _k = _module getVariable ["k", 1];

if (_mode == "unregisteredFromWorld3DEN") exitWith {
    {deleteVehicle _x} forEach (_module getVariable [QGVAR(CommunicationJammer_3DENMarkers), []]);
    _module setVariable [QGVAR(CommunicationJammer_3DENMarkers), nil];
};
if (_mode == "attributesChanged3DEN" && {is3DEN}) exitWith {
    [_module, _area, _formula, _k, _module getVariable ["VisualizeRadius", 0]] call FUNC(communicationJammer_visualize);
};
if (_mode != "init" || {is3DEN} || {!hasInterface} || {!_isActivated}) exitWith {};

private _objects = synchronizedObjects _module select {!(_x isKindOf "EmptyDetector")};
if (count _objects > 1) exitWith {
    systemChat format ["ModuleCommunicationJammer [%1]:: Too many connected objects... disabling.", _module];
};
private _object = _objects param [0, _module];

if !(missionNamespace getVariable [QGVAR(CommunicationJammer_HandlersInitialized), false]) then {
    addMissionEventHandler ["HandleChatMessage", {
        params ["_channel", "_owner", "_from", "_text", "_person"];
        private _finalText = _text;
        if (player == _person || {!(isPlayer _person)}) then {
            _finalText = [_text, selectMax ([] call FUNC(communicationJammer_getAmounts))] call FUNC(communicationJammer_scramble);
        };
        if (player != _person) then {
            private _jam = (selectMax ([] call FUNC(communicationJammer_getAmounts))) max (_person getVariable [QGVAR(CommunicationJammer_MaxJamGlobal), 0]);
            _finalText = [_text, _jam] call FUNC(communicationJammer_scramble);
        };
        _finalText
    }];
    missionNamespace setVariable [QGVAR(CommunicationJammer_HandlersInitialized), true];
};

if (isNil {player getVariable QGVAR(CommunicationJammer_GlobalJamUpdater)}) then {
    private _networkHandle = [] spawn {
        while {true} do {
            sleep TICKRATE_NETWORK;
            if ((entities "MEH_ModuleCommunicationJammer") findIf {alive _x} == -1) exitWith {};
            player setVariable [QGVAR(CommunicationJammer_MaxJamGlobal), selectMax ([] call FUNC(communicationJammer_getAmounts)), true];
        };
        player setVariable [QGVAR(CommunicationJammer_GlobalJamUpdater), nil];
    };
    player setVariable [QGVAR(CommunicationJammer_GlobalJamUpdater), _networkHandle];
};

[_module, _object, _area, _formula, _k] spawn {
    params ["_module", "_object", "_area", "_formula", "_k"];
    private _mapCtrl = controlNull;
    private _gpsCtrl = controlNull;
    private _deadline = time + 30;
    waitUntil {
        sleep 0.1;
        _mapCtrl = (findDisplay IDD_MAIN_MAP) displayCtrl IDC_MAP;
        _gpsCtrl = ((uiNamespace getVariable ["RscCustomInfoMiniMap", displayNull]) displayCtrl 13301) controlsGroupCtrl 101;
        (!isNull _mapCtrl && {!isNull _gpsCtrl}) || {time >= _deadline} || {!alive _module}
    };
    if (time >= _deadline || {!alive _module}) exitWith {};

    private _mapHandler = _mapCtrl ctrlAddEventHandler ["Draw", {
        params ["_ctrl"];
        private _max = selectMax (player getVariable [QGVAR(CommunicationJammer_AllJamAmounts), [0]]);
        private _center = _ctrl ctrlMapScreenToWorld [0.5, 0.5];
        private _size = 640 * safeZoneWAbs;
        _ctrl drawIcon ["#(rgb,8,8,3)color(0,0,0,1)", [1,1,1,_max], _center, _size, _size, 0, "", 0];
    }];
    private _gpsHandler = _gpsCtrl ctrlAddEventHandler ["Draw", {
        params ["_ctrl"];
        private _max = selectMax (player getVariable [QGVAR(CommunicationJammer_AllJamAmounts), [0]]);
        private _center = _ctrl ctrlMapScreenToWorld (ctrlPosition _ctrl select [0,2]);
        _ctrl drawIcon ["#(rgb,8,8,3)color(0,0,0,1)", [1,1,1,_max], _center, 512, 512, 0, "", 0];
    }];

    while {true} do {
        sleep TICKRATE;
        if (isGamePaused) then {continue};
        if (!alive _module || {!alive _object}) exitWith {};

        private _areaAtObject = [getPosASL _object] + _area;
        private _jamAmount = 0;
        if (player inArea _areaAtObject) then {
            private _distance = player distance (_areaAtObject#0);
            private _radius = (_areaAtObject#1) max (_areaAtObject#2);
            private _normalized = _distance / _radius;
            switch _formula do {
                case 0: {_jamAmount = 1 - _normalized};
                case 1: {_jamAmount = 1 - (_normalized ^ _k)};
                case 2: {_jamAmount = e ^ (-_k * _normalized)};
                case 3: {_jamAmount = 1 - (log (1 + _normalized) / log (_k min 2))};
                case 4: {_jamAmount = 1 - (1 / (1 + (_normalized ^ _k)))};
                case 5: {_jamAmount = (cos (_k * pi * _normalized) + 1) / 2};
                case 6: {_jamAmount = 1 / (1 + e ^ (_k * (_normalized - 0.5)))};
            };
            _jamAmount = CLAMP(_jamAmount,0,1);
        };
        _module setVariable [QGVAR(CommunicationJammer_JamAmount), _jamAmount];
        private _amounts = [] call FUNC(communicationJammer_getAmounts);
        player setVariable [QGVAR(CommunicationJammer_AllJamAmounts), _amounts];
        private _complement = 1 - selectMax _amounts;
        player setVariable ["tf_receivingDistanceMultiplicator", _complement];
        player setVariable ["tf_sendingDistanceMultiplicator", _complement];
    };

    _mapCtrl ctrlRemoveEventHandler ["Draw", _mapHandler];
    _gpsCtrl ctrlRemoveEventHandler ["Draw", _gpsHandler];
    _module setVariable [QGVAR(CommunicationJammer_JamAmount), 0];
    player setVariable [QGVAR(CommunicationJammer_MaxJamGlobal), selectMax ([] call FUNC(communicationJammer_getAmounts)), true];
};
