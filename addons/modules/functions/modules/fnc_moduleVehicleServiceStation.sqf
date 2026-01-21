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
if (is3DEN) exitWith {};
if (_mode in ["dragged3DEN", "unregisteredFromWorld3DEN"]) exitWith {};

// Variables
//------------------------------------------------------------------------------------------------
private _sideNum = _module getVariable "Side";
private _side = switch (_sideNum) do {
    case 0: { east };
    case 1: { west };
    case 2: { independent };
    case 3: { civilian };
    default { sideUnknown };
};
private _sideColor = switch (_side) do {
    case east: { "ColorEAST" };
    case west: { "ColorWEST" };
    case independent: { "ColorGUER" };
    case civilian: { "ColorCIV" };
    default { "ColorUNKNOWN" };
};
private _repair = _module getVariable "Repair";
private _repairPerTick = _module getVariable "RepairPerTick";
private _rearm = _module getVariable "Rearm";
private _rearmPerTick = _module getVariable ["RearmPerTick", 1];
private _refuel = _module getVariable "Refuel";
private _refuelPerTick = _module getVariable "RefuelPerTick";
private _tickrate = _module getVariable "TickRate";
private _area = _module getVariable "ObjectArea";
private _showMapMarker = _module getVariable "ShowMapMarker";
_area = [ASLToAGL getPosASL _module] + _area;

private _self = createHashMapObject [[
    ["module", _module],
    ["side", _side],
    ["sideColor", _sideColor],
    ["repair", _repair],
    ["repairPerTick", _repairPerTick],
    ["rearm", _rearm],
    ["rearmPerTick", _rearmPerTick],
    ["refuel", _refuel],
    ["refuelPerTick", _refuelPerTick],
    ["tickrate", _tickrate],
    ["area", _area],
    ["activated", false],
    ["showMapMarker", _showMapMarker]
]];
if (_isActivated) then {
    _module setVariable [QGVAR(ModuleVehicleServiceStation_ModuleObject), _self];
};

// Functions
//------------------------------------------------------------------------------------------------
private _startSystem = compileFinal {
    _self set ["activated", true];

    [{
        params ["_args", "_handle"];
        _args params ["_self"];

        if (isGamePaused) exitWith {};
        if !(_self get "activated") exitWith {
            _handle call CBA_fnc_removePerFrameHandler;
        };
        if (!alive (_self get "module")) exitWith {
            _handle call CBA_fnc_removePerFrameHandler;
        };

        private _vehicles = vehicles select {alive _x && _x inArea (_self get "area")};
        if (_vehicles isEqualTo []) exitWith {};

        {
            private _vehicle = _x;

            if (_self get "repair") then {
                [QGVAR(repairVehicle), [_vehicle, _self get "repairPerTick"], _vehicle] call CBA_fnc_targetEvent;
            };
            if (_self get "refuel") then {
                [QGVAR(refuelVehicle), [_vehicle, _self get "refuelPerTick"], _vehicle] call CBA_fnc_targetEvent;
            };
            if (_self get "rearm") then {
                [QGVAR(rearmVehicle), [_vehicle, _self get "rearmPerTick"], _vehicle] call CBA_fnc_targetEvent;
            };
        } forEach _vehicles;
    }, _self get "tickrate", [_self]] call CBA_fnc_addPerFrameHandler;

    // Map Markers
    _self call ["CreateMapMarker"];
};
_self set ["StartSystem", _startSystem];

private _createMapMarker = compileFinal {
    if !(_self get "showMapMarker") exitWith {};

    // area marker
    private _markerName = format[QGVAR(VehicleServiceStationArea_%1),_self get "module"];
    private _marker = createMarkerLocal [_markerName, (_self get "area") # 0];
    _marker setMarkerShapeLocal (["ELLIPSE", "RECTANGLE"] select ((_self get "area") # 4));
    _marker setMarkerBrushLocal "FDiagonal";
    _marker setMarkerSizeLocal [
        (_self get "area") # 1,
        (_self get "area") # 2
    ];
    _marker setMarkerDirLocal ((_self get "area") # 3);
    _marker setMarkerColor (_self get "sideColor");

    _self set ["areaMarker", _marker];

    // repair icon
    private _markerName = format[QGVAR(VehicleServiceStationIcon_%1),_self get "module"];
    private _marker = createMarkerLocal [_markerName, (_self get "area") # 0];
    _marker setMarkerShapeLocal "ICON";
    _marker setMarkerTypeLocal "loc_repair";
    _marker setMarkerColor (_self get "sideColor");

    _self set ["iconMarker", _marker];

    // border marker
    private _markerName = format[QGVAR(VehicleServiceStationAreaBorder_%1),_self get "module"];
    private _marker = createMarkerLocal [_markerName, (_self get "area") # 0];
    _marker setMarkerShapeLocal (["ELLIPSE", "RECTANGLE"] select ((_self get "area") # 4));
    _marker setMarkerBrushLocal "Border";
    _marker setMarkerSizeLocal [
        (_self get "area") # 1,
        (_self get "area") # 2
    ];
    _marker setMarkerDirLocal ((_self get "area") # 3);
    _marker setMarkerColor (_self get "sideColor");

    _self set ["areaBorderMarker", _marker];
    
};
_self set ["CreateMapMarker", _createMapMarker];

private _removeMapMarker = compileFinal {
    private _markers = [
        _self get "areaMarker",
        _self get "iconMarker",
        _self get "areaBorderMarker"
    ];

    {
        deleteMarker _x;
    } forEach _markers;

    _self set ["areaMarker", nil];
    _self set ["iconMarker", nil];
    _self set ["areaBorderMarker", nil];
};
_self set ["RemoveMapMarker", _removeMapMarker];

// Code Start
//------------------------------------------------------------------------------------------------
switch _mode do {
    case "init": {
        if (is3DEN) exitWith {};
        private _moduleObject = _module getVariable QGVAR(ModuleVehicleServiceStation_ModuleObject);

        if (_isActivated) then {
            _moduleObject call ["StartSystem"];
        };
        if !(_isActivated) then {
            _moduleObject set ["activated", false];
            _moduleObject call ["RemoveMapMarker"]
        };
    };
};
