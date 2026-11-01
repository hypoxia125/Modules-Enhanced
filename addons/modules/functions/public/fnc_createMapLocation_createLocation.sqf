/*
    Function: meh_modules_fnc_createMapLocation_createLocation
    Create a map location. Arguments: [area, name, locationType, importance].
    area is [centerPositionASL, radiusX, radiusY, direction, isRectangle].
    Call where the location should be created; returns the created location (locationNull on invalid input).
*/
#include "script_component.hpp"

params [
    ["_area", [], [[]]],
    ["_name", "", [""]],
    ["_type", "NameLocal", [""]],
    ["_importance", 0, [0]]
];

if (count _area < 5) exitWith {locationNull};

private _location = createLocation [_type, _area#0, _area#1, _area#2];
_location setDirection (_area#3);
_location setRectangular (_area#4);
_location setText _name;
_location setImportance _importance;
_location
