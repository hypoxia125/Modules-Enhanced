/*
    Function: meh_modules_fnc_clearMapLocationNames_clearLocations
    Hide map locations by changing their type to Invisible.
    Arguments: [locations] (array of Location values). Call on each client whose map should change.
    Returns: [[location, originalType], ...] for restoring the types later.
*/
#include "script_component.hpp"

params [["_locations", [], [[]]]];

private _cleared = [];
{
    private _location = createLocation [_x];
    _cleared pushBack [_location, type _location];
    _location setType "Invisible";
} forEach _locations;
_cleared
