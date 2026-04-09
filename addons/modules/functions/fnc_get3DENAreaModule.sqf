/* ----------------------------------------------------------------------------
Function: meh_modules_fnc_get3DENAreaModule

Author: Hypoxic

Public: False - Requires internal data

Description:
    Gets the 3DEN area attribute of a module. Important for in-editor operations.

Parameters:
    0: Object | Module Object

Returns:
    None
---------------------------------------------------------------------------- */

#include "script_component.hpp"

params ["_module"];

private _center = ASLToAGL (getPosASL _module);
private _size = (_module get3DENAttribute "Size3") select 0;
private _dir = getDir _module;
private _isRectangle = (_module get3DENAttribute "isRectangle") select 0;

_size params [
    ["_a", 0, [-1]],
    ["_b", 0, [-1]],
    ["_z", -1, [-1]]
];

[_center, _a, _b, _dir, _isRectangle, _z];
