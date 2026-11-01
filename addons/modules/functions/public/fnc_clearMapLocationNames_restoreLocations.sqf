/*
    Function: meh_modules_fnc_clearMapLocationNames_restoreLocations
    Restore types returned by clearMapLocationNames_clearLocations.
    Arguments: [savedLocations]. Call on the same machine that cleared them.
*/
#include "script_component.hpp"

params [["_savedLocations", [], [[]]]];
{
    _x params ["_location", "_type"];
    _location setType _type;
} forEach _savedLocations;
