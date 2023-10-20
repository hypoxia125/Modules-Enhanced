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

private _endPos = createMarkerLocal [QGVAR(TeleportMenu_Marker_EndPos), _posObject];
_endPos setMarkerTypeLocal "mil_end";
_endPos setMarkerColorLocal _color;
_endPos setMarkerTextLocal LLSTRING(TeleportMenu_Marker_EndPos);

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

private _markers = [_currentPos, _endPos, _polyline];

// Set player pos
mapAnimAdd [2, 0.5, _posPlayer];
mapAnimAdd [2, 0.5, ASLToAGL (getPosASL _object)];
mapAnimAdd [2, 0.25, ASLToAGL (getPosASL _object)];
mapAnimCommit;

[{
    params ["_data", "_savedSel", "_markers"];
    _data params ["_name", "_object", "_side", "_bidirectional", "_travelTime", "_active"];

    // Close map
    openMap [false, false];
    [QGVAR(teleportMenu_ViewOnMap), [false]] call CBA_fnc_localEvent;

    // Delete markers
    _markers apply {deleteMarkerLocal _x};

    // Reopen display
    call FUNC(openTeleportMenu);

    private _lbControl = findDisplay IDD_TELEPORTMENU displayCtrl IDC_LOCLIST;
    _lbControl lbSetCurSel _savedSel;
}, [_data, _savedSel, _markers], 8] call CBA_fnc_waitAndExecute;
