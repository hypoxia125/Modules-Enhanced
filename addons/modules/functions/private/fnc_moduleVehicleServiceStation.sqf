/* ----------------------------------------------------------------------------
Function: meh_modules_fnc_moduleVehicleServiceStation

Author: Hypoxic

Public: False - Requires internal data

Description:
    Function that the module calls upon initialization.
---------------------------------------------------------------------------- */

#include "script_component.hpp"

params [
    ["_mode", "", [""]],
    ["_input", [], [[]]]
];
_input params [
    ["_module", objNull, [objNull]],
    ["_isActivated", false, [true]],
    ["_isCuratorPlaced", false, [true]]
];

if (!isServer || {is3DEN} || {_mode != "init"}) exitWith {};

private _markerNames = [
    format [QGVAR(VehicleServiceStationArea_%1), _module],
    format [QGVAR(VehicleServiceStationIcon_%1), _module],
    format [QGVAR(VehicleServiceStationAreaBorder_%1), _module]
];

if (!_isActivated) exitWith {
    terminate (_module getVariable [QGVAR(ModuleVehicleServiceStation_Handle), scriptNull]);
    _module setVariable [QGVAR(ModuleVehicleServiceStation_Handle), nil];
    {deleteMarkerLocal _x} forEach _markerNames;
};

private _previousHandle = _module getVariable [QGVAR(ModuleVehicleServiceStation_Handle), scriptNull];
if (_previousHandle isNotEqualTo scriptNull && {!scriptDone _previousHandle}) exitWith {};

private _area = [ASLToAGL getPosASL _module] + (_module getVariable "ObjectArea");
private _repair = _module getVariable "Repair";
private _repairPerTick = _module getVariable "RepairPerTick";
private _rearm = _module getVariable "Rearm";
private _refuel = _module getVariable "Refuel";
private _refuelPerTick = _module getVariable "RefuelPerTick";
private _tickrate = _module getVariable "TickRate";

private _handle = [_module, _area, _tickrate, _repair, _repairPerTick, _rearm, _refuel, _refuelPerTick] spawn {
    params ["_module", "_area", "_tickrate", "_repair", "_repairPerTick", "_rearm", "_refuel", "_refuelPerTick"];

    while {alive _module} do {
        sleep (_tickrate max 0.1);
        if (!alive _module) exitWith {};
        if (isGamePaused) then { continue };

        private _vehicles = vehicles select {alive _x && {_x inArea _area}};
        {
            private _vehicle = _x;
            if (_repair) then {
                [QGVAR(repairVehicle), [_vehicle, _repairPerTick], _vehicle] call CBA_fnc_targetEvent;
            };
            if (_refuel) then {
                [QGVAR(refuelVehicle), [_vehicle, _refuelPerTick], _vehicle] call CBA_fnc_targetEvent;
            };
            if (_rearm) then {
                [QGVAR(rearmVehicle), [_vehicle], _vehicle] call CBA_fnc_targetEvent;
            };
        } forEach _vehicles;
    };
};
_module setVariable [QGVAR(ModuleVehicleServiceStation_Handle), _handle];

if !(_module getVariable ["ShowMapMarker", false]) exitWith {};

private _sideColor = switch (_module getVariable ["Side", 1]) do {
    case 0: {"ColorEAST"};
    case 1: {"ColorWEST"};
    case 2: {"ColorGUER"};
    case 3: {"ColorCIV"};
    default {"ColorUNKNOWN"};
};

_markerNames params ["_areaName", "_iconName", "_borderName"];
private _shape = ["ELLIPSE", "RECTANGLE"] select (_area#4);
private _size = [_area#1, _area#2];

private _areaMarker = createMarkerLocal [_areaName, _area#0];
_areaMarker setMarkerShapeLocal _shape;
_areaMarker setMarkerBrushLocal "FDiagonal";
_areaMarker setMarkerSizeLocal _size;
_areaMarker setMarkerDirLocal (_area#3);
_areaMarker setMarkerColor _sideColor;

private _iconMarker = createMarkerLocal [_iconName, _area#0];
_iconMarker setMarkerShapeLocal "ICON";
_iconMarker setMarkerTypeLocal "loc_repair";
_iconMarker setMarkerColor _sideColor;

private _borderMarker = createMarkerLocal [_borderName, _area#0];
_borderMarker setMarkerShapeLocal _shape;
_borderMarker setMarkerBrushLocal "Border";
_borderMarker setMarkerSizeLocal _size;
_borderMarker setMarkerDirLocal (_area#3);
_borderMarker setMarkerColor _sideColor;
