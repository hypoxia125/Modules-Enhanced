#include "script_component.hpp"

params ["_control"];

private _lbControl = findDisplay IDD_TELEPORTMENU displayCtrl IDC_LOCLIST;
private _nameSel = _lbControl lbText (lbCurSel _lbControl);
private _data = ["name", _nameSel] call FUNC(getTeleporterData);

_data params ["_name", "_object", "_side", "_bidirectional", "_travelTime", "_active"];
if (isNil "_data") exitWith {};

private _posPlayer = ASLToAGL (getPosASL player);
private _posObject = ASLToAGL (getPosASL _object);

// Close display
private _savedSel = lbCurSel _lbControl;
(findDisplay IDD_TELEPORTMENU) closeDisplay 2;

// Open map
openMap [true, true];
[QGVAR(teleportMenu_ViewOnMap), [true]] call CBA_fnc_localEvent;

// Create markers
private _markers = [];
private _color = switch side group player do {
    case east: {"ColorOpfor"};
    case west: {"ColorBlufor"};
    case resistance: {"ColorIndependent"};
    case civilian: {"ColorCivilian"};
    default {"ColorBlack"};
};
private _currentPos = createMarkerLocal [QGVAR(TeleportMenu_Marker_CurrentPos), _posPlayer];
_currentPos setMarkerTypeLocal "mil_start";
_currentPos setMarkerColorLocal _color;
_currentPos setMarkerTextLocal LLSTRING(TeleportMenu_Marker_CurrentPos);
_markers pushBack _currentPos;

private _endPos = createMarkerLocal [QGVAR(TeleportMenu_Marker_EndPos), _posObject];
_endPos setMarkerTypeLocal "mil_end";
_endPos setMarkerColorLocal _color;
_endPos setMarkerTextLocal LLSTRING(TeleportMenu_Marker_EndPos);
_markers pushBack _endPos;

// Move end pos with object if it is a vehicle
private _handle = scriptNull;
if (_object isKindOf "AllVehicles") then {
    _handle = [_object, _endPos] spawn {
        params ["_object", "_endPos"];
        while {true} do {
            sleep 0.25;
            if (isNull _object) exitWith {};
            _endPos setMarkerPosLocal _object;
        };
    };
};

if (!(_object isKindOf "AllVehicles")) then {
    private _polylineArray = [
        _posPlayer select 0,
        _posPlayer select 1,
        _posObject select 0,
        _posObject select 1
    ];
    private _polyline = createMarkerLocal [QGVAR(marker_polyline), _posObject];
    _polyline setMarkerShapeLocal "polyline";
    _polyline setMarkerPolylineLocal _polylineArray;
    _polyline setMarkerColorLocal _color;
    _markers pushBack _polyline;
};

// Set player pos
mapAnimAdd [2, 0.5, player];
mapAnimAdd [2, 0.5, _object];
mapAnimAdd [2, 0.25, _object];
mapAnimCommit;

[_data, _savedSel, _markers, _handle] spawn {
    params ["_data", "_savedSel", "_markers", "_handle"];
    _data params ["_name", "_object", "_side", "_bidirectional", "_travelTime", "_active"];
    sleep 8;

    // Close map
    openMap [false, false];
    [QGVAR(teleportMenu_ViewOnMap), [false]] call CBA_fnc_localEvent;

    // If vehicle, stop per frame handler
    terminate _handle;

    // Delete markers
    _markers apply {deleteMarkerLocal _x};

    // Reopen display
    call FUNC(openTeleportMenu);

    private _lbControl = findDisplay IDD_TELEPORTMENU displayCtrl IDC_LOCLIST;
    _lbControl lbSetCurSel _savedSel;
};
