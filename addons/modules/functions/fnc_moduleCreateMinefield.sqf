#include "script_component.hpp"

#define MINECOUNTWARN   10000

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
if !(_mode in ["init", "registeredToWorld3DEN", "attributesChanged3DEN", "unregisteredFromWorld3DEN"]) exitWith {};

// Variables
//------------------------------------------------------------------------------------------------
private _area = _module getVariable ["ObjectArea", [50, 50, 0, false, -1]];
private _placedBy = _module getVariable ["PlacedBy", 4];
private _mineClasses = _module getVariable ["MineClasses", "['APERSMine']"];
private _mineDensity = _module getVariable ["MineDensity", 10];
private _markMap = _module getVariable ["MarkMap", 0];

if (
    !(_mineClasses isEqualTypeAll "") ||
    _mineClasses findIf { (getText (configFile >> "CfgVehicles" >> _x >> "ammo") == "") } != -1
) then {
    [typeOf _module] call EFUNC(Error,invalidArgs);
    _mode = "unregisteredFromWorld3DEN";
};

_area = [getPosASL _module] + _area;
_placedBy = switch _placedBy do {
    case 0: {west};
    case 1: {east};
    case 2: {independent};
    case 3: {civilian};
    case 4: {sideUnknown};
};
_markmap = switch _markmap do {
    case 0: {[]};
    case 1: {
        [east, west, independent, civilian] select {[_placedBy, _x] call BIS_fnc_sideIsFriendly};
    };
    case 2: {[east, west, independent, civilian]};
};

// Functions
//------------------------------------------------------------------------------------------------
private _3DENCreateMarkers = {
    _this spawn {
        params ["_module", "_mineDensity"];

        private _area = [_module] call FUNC(get3DENAreaModule);
        _area params ["_center", "_a", "_b", "_angle", "_isRectangle", "_z"];

        // Calculate total markers needed
        private ["_totalMarkers"];
        if (_isRectangle) then {
            _totalMarkers = (_mineDensity * _a * _b) / 100;
        } else {
            _totalMarkers = (_mineDensity * pi * (_a/2) * (_b/2)) / 100;
        };

        // Warn users if large amount of mines
        if (_totalMarkers > MINECOUNTWARN && isNil "_skipWarning") then {
            [
                format["You are about to simulate %1 mine markers. This can severely impact hang time. Use at own risk! Select no to skip simulation.", _totalMarkers],
                "Warning!",
                ["Yes", { missionNamespace setVariable [QGVAR(ModuleCreateMinefield_MakeMarkers), true] }],
                ["No", { missionNamespace setVariable [QGVAR(ModuleCreateMinefield_MakeMarkers), true] }],
                "a3\ui_f\data\igui\cfg\actions\obsolete\ui_action_fire_in_flame_ca.paa",
                findDisplay 313
            ] call BIS_fnc_3DENShowMessage;
        } else {
            missionNamespace setVariable [QGVAR(ModuleCreateMinefield_MakeMarkers), true]
        };

        waitUntil {!isNil {missionNamespace getVariable QGVAR(ModuleCreateMinefield_MakeMarkers)}};
        if !(missionNamespace getVariable [QGVAR(ModuleCreateMinefield_MakeMarkers), true]) exitWith {};

        // switch back to unscheduled
        isNil {
            // Create 3DEN markers
            private _markerObj = "Sign_Sphere10cm_F";
            private _createdMarkers = [];
            for "_i" from 0 to _totalMarkers - 1 do {
                private _pos = [[_area]] call BIS_fnc_randomPos;
                _pos set [2, 0];

                private _marker = createVehicle [_markerObj, _pos, [], 0, "NONE"];
                _marker setObjectTextureGlobal [0, "#(rgb,8,8,3)color(1,0,0,1)"];
                _marker setObjectScale 4;
                _createdMarkers pushBackUnique _marker;
            };

            _module setVariable [QGVAR(moduleCreateMinefield_3DEN_Markers), _createdMarkers];

            missionNamespace setVariable [QGVAR(ModuleCreateMinefield_MakeMarkers), nil];
        };
    };
};

private _3DENDeleteMarkers = {
    params ["_module"];

    private _markers = _module getVariable [QGVAR(moduleCreateMinefield_3DEN_Markers), []];
    _markers apply {deleteVehicle _x};
};

private _createMinefield = {
    params ["_area", "_placedBy", "_mineClasses", "_mineDensity", "_markMap"];
    _area params ["_center", "_a", "_b", "_angle", "_isRectangle", "_z"];

    private _totalMines = 0;
    if (_isRectangle) then {
        _totalMines = round (_mineDensity * _a * _b) / 100;
    } else {
        _totalMines = round (_mineDensity * pi * (_a/2) * (_b/2)) / 100;
    };

    private _createdMines = [];
    for "_i" from 0 to _totalMines - 1 do {
        private _pos = [[_area]] call BIS_fnc_randomPos;
        _pos set [2, 0];

        private _mine = createMine [selectRandom _mineClasses, _pos, [], 0];
        _mine setVectorUp (surfaceNormal _pos);
        _createdMines pushBackUnique _mine;
    };

    // Reveal Mines
    if (_markMap isNotEqualTo []) then {
        private _marker = createMarkerLocal [FORMAT_1("Minefield_%1",_area), _center];
        _marker setMarkerSizeLocal [_a, _b];
        _marker setMarkerDirLocal _angle;
        _marker setMarkerShapeLocal (["ELLIPSE", "RECTANGLE"] select _isRectangle);
        _marker setMarkerBrushLocal "Border";
        _marker setMarkerColorLocal "ColorRED";
        _marker setMarkerAlpha 1;

        private _marker = createMarkerLocal [FORMAT_1("MinefieldBrush_%1",_area), _center];
        _marker setMarkerSizeLocal [_a, _b];
        _marker setMarkerDirLocal _angle;
        _marker setMarkerShapeLocal (["ELLIPSE", "RECTANGLE"] select _isRectangle);
        _marker setMarkerBrushLocal "Grid";
        _marker setMarkerColorLocal "ColorRED";
        _marker setMarkerAlpha 1;

        private _marker = createMarkerLocal [FORMAT_1("MinefieldIcon_%1",_area), _center];
        _marker setMarkerShapeLocal "Icon";
        _marker setMarkerTypeLocal "mil_warning";
        _marker setMarkerColorLocal "ColorRED";
        _marker setMarkerAlpha 1;
    };

    // Broadcast Event
    [QGVAR(createMinefield_MinefieldCreated), [_area, _createdMines]] call CBA_fnc_globalEvent;
};

// Code Start
//------------------------------------------------------------------------------------------------
LOG_1("MEH_ModuleCreateMinefield: Mode: %1",_mode);
switch _mode do {
    case "init": {
        if (is3DEN) exitWith {};

        [_area, _placedBy, _mineClasses, _mineDensity, _markMap] call _createMinefield;
    };

    case "registeredToWorld3DEN": {
        [_module, _mineDensity] call _3DENCreateMarkers;
    };

    case "attributesChanged3DEN": {
        [_module] call _3DENDeleteMarkers;
        [_module, _mineDensity] call _3DENCreateMarkers;
    };

    case "unregisteredFromWorld3DEN": {
        [_module] call _3DENDeleteMarkers;
        if (!is3DEN) then { deleteVehicle _module };
    };

    default {};
};
