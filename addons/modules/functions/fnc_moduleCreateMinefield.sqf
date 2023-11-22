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

if (!isServer) exitWith {};
if (_mode isEqualTo "dragged3DEN") exitWith {};

// Variables
private _area = _module getVariable [QUOTE(ObjectArea), [50, 50, 0, false, -1]];
private _placedBy = _module getVariable [QUOTE(PlacedBy), 4];
private _mineClasses = call compile (_module getVariable [QUOTE(MineClasses), "[""APERSMine""]"]);
private _mineDensity = _module getVariable [QUOTE(MineDensity), 10];
private _markMap = _module getVariable [QUOTE(MarkMap), 0];

if (
    isNil "_mineClasses" ||
    {!(_mineClasses isEqualType [])}
) then {
    [typeOf _module] call EFUNC(Error,invalidArgs);
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

// 3DEN Functions
private ["_createMarkers", "_deleteMarkers"];
if (is3DEN) then {
    _createMarkers = {
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
    };

    _deleteMarkers = {
        params ["_module"];

        private _markers = _module getVariable [QGVAR(moduleCreateMinefield_3DEN_Markers), []];
        _markers apply {deleteVehicle _x};
    };
};

// Execute
switch _mode do {
    case "init": {
        if (is3DEN) exitWith {};

        [_area, _placedBy, _mineClasses, _mineDensity, _markMap] call FUNC(createMinefield);
    };

    case "registeredToWorld3DEN": {
        [_module, _mineDensity] call _createMarkers;
    };

    case "attributesChanged3DEN": {
        [_module] call _deleteMarkers;
        [_module, _mineDensity] call _createMarkers;
    };

    case "unregisteredFromWorld3DEN": {
        [_module] call _deleteMarkers;
    };

    default {};
};
