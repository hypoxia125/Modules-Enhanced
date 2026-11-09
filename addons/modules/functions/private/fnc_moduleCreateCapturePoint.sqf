#include "script_component.hpp"

params [["_mode", "", [""]], ["_input", [], [[]]]];
_input params [
    ["_module", objNull, [objNull]],
    ["_isActivated", false, [true]],
    ["_isCuratorPlaced", false, [true]]
];
if (_mode != "init") exitWith {};

if (hasInterface && {!(missionNamespace getVariable [QGVAR(CapturePoint_EventInit), false])}) then {
    [QGVAR(CapturePoint_ProgressTick), {
        params ["_module", "_area", "_markerLetter", "_owner", "_data"];
        private _inValidArea = false;
        {
            if (player inArea _x) exitWith {_inValidArea = true};
        } forEach (missionNamespace getVariable [QGVAR(CapturePointSystem_AllAreas), []]);

        if (!_inValidArea) exitWith {
            if !(isNil QGVAR(CapturePoint_HUDLayer)) then {
                GVAR(CapturePoint_HUDLayer) cutFadeOut 1;
                GVAR(CapturePoint_HUDLayer) = nil;
            };
        };
        if !(player inArea _area) exitWith {};

        private _display = uiNamespace getVariable [QGVAR(CapturePointHUD), displayNull];
        if (isNull _display && {missionNamespace getVariable [QGVAR(CapturePointSystemShowUI), false]}) then {
            GVAR(CapturePoint_HUDLayer) = QGVAR(CapturePoint_HUDLayer) call BIS_fnc_rscLayer;
            GVAR(CapturePoint_HUDLayer) cutRsc ["MEH_Modules_CapturePointHUD", "PLAIN", 1, true];
            [_markerLetter, _owner] spawn {
                params ["_markerLetter", "_owner"];
                private _display = uiNamespace getVariable [QGVAR(CapturePointHUD), displayNull];
                waitUntil {!isNull _display};
                private _title = _display displayCtrl 900;
                _title ctrlSetText format ["Capture Point: %1", _markerLetter];
                private _color = switch _owner do {
                    case east: {[0.5,0,0,1]};
                    case west: {[0,0.3,0.6,1]};
                    case independent: {[0,0.5,0,1]};
                    case civilian: {[0.4,0,0.5,1]};
                    default {[0,0,0,1]};
                };
                _title ctrlSetBackgroundColor _color;
            };
        };

        {
            _x params ["_side", "_percent"];
            private _controls = switch _side do {
                case west: {[100, 102]};
                case east: {[200, 202]};
                case independent: {[300, 302]};
                case civilian: {[400, 402]};
                default {[]};
            };
            if (_controls isNotEqualTo []) then {
                (_display displayCtrl (_controls#0)) progressSetPosition _percent;
                (_display displayCtrl (_controls#1)) ctrlSetText format ["%1%%", _percent * 100];
            };
        } forEach _data;

        private _color = switch _owner do {
            case east: {[0.5,0,0,1]};
            case west: {[0,0.3,0.6,1]};
            case independent: {[0,0.5,0,1]};
            case civilian: {[0.4,0,0.5,1]};
            default {[0,0,0,1]};
        };
        (_display displayCtrl 900) ctrlSetBackgroundColor _color;
    }] call CBA_fnc_addEventHandler;
    missionNamespace setVariable [QGVAR(CapturePoint_EventInit), true];
};

private _area = [getPosASL _module] + (_module getVariable "ObjectArea");
if (isNil QGVAR(CapturePointSystem_AllAreas)) then {GVAR(CapturePointSystem_AllAreas) = []};
GVAR(CapturePointSystem_AllAreas) pushBackUnique _area;
if (!isServer) exitWith {};

private _timeOut = 10;
while {_timeOut > 0 && {isNil QGVAR(CapturePointSystemModules)}} do {
    _timeOut = _timeOut - 1;
    sleep 1;
};
if (isNil QGVAR(CapturePointSystemModules)) exitWith {
    ERROR("MEH_Modules_fnc_moduleCreateCapturePoint:: CapturePointSystem not found after waiting 10 seconds!");
};

if (!_isActivated) exitWith {
    GVAR(CapturePointSystemModules) = GVAR(CapturePointSystemModules) - [_module];
    {
        deleteMarker _x;
    } forEach (_module getVariable [QGVAR(CapturePoint_Markers), []]);
    _module setVariable [QGVAR(CapturePoint_Markers), nil];
};
if (_module in GVAR(CapturePointSystemModules)) exitWith {};

private _owner = switch (_module getVariable "OwnerOnStart") do {
    case 0: {east};
    case 1: {west};
    case 2: {independent};
    case 3: {civilian};
    default {sideUnknown};
};
private _progress = createHashMapFromArray [
    [east, 0], [west, 0], [independent, 0], [civilian, 0]
];
if (_owner != sideUnknown) then {_progress set [_owner, 1]};
_module setVariable [QGVAR(CapturePoint_Area), _area];
_module setVariable [QGVAR(CapturePoint_Owner), _owner];
_module setVariable [QGVAR(CapturePoint_Progress), _progress];

_area params ["_position", "_a", "_b", "_angle", "_isRectangle"];
private _shape = ["ELLIPSE", "RECTANGLE"] select _isRectangle;
private _markers = [];
{
    _x params ["_suffix", "_brush"];
    private _marker = createMarker [format [QGVAR(CapturePoint_%1_%2), _module, _suffix], _position];
    if (_suffix == "Letter") then {
        _marker setMarkerShapeLocal "Icon";
        _marker setMarkerTypeLocal format ["loc_Letter%1", _module getVariable "CapturePointLetter"];
    } else {
        _marker setMarkerBrushLocal _brush;
        _marker setMarkerShapeLocal _shape;
        _marker setMarkerSizeLocal [_a, _b];
    };
    _markers pushBack _marker;
} forEach [["Inner", "FDiagonal"], ["Outer", "Border"], ["Letter", ""]];
private _color = switch _owner do {
    case east: {"ColorEast"};
    case west: {"ColorWest"};
    case independent: {"ColorIndependent"};
    case civilian: {"ColorCivilian"};
    default {"ColorBlack"};
};
{_x setMarkerColor _color} forEach _markers;
_module setVariable [QGVAR(CapturePoint_Markers), _markers];
GVAR(CapturePointSystemModules) pushBackUnique _module;
