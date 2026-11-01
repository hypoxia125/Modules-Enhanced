/* ----------------------------------------------------------------------------
Function: meh_modules_fnc_moduleClearMapLocationNames

Author: Hypoxic

Public: False - Requires internal data

Description:
    Function that the module calls upon initialization.
---------------------------------------------------------------------------- */

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

// Variables
//------------------------------------------------------------------------------------------------
private _area = _module getVariable "ObjectArea";
_area = [getPosASL _module] + _area;
if (is3DEN) then {
    // need to do this in 3DEN due to the module area not being updated on move above
    _area = [_module] call FUNC(get3DENAreaModule);
};
private _locationTypes = _module getVariable ["LocationTypes", []];

// Code Start
//------------------------------------------------------------------------------------------------
switch _mode do {
    case "init": {
        if (is3DEN) exitWith {};

        private _locations = [_area, _locationTypes] call FUNC(clearMapLocationNames_getLocations);
        private _clearedLocations = [_locations] call FUNC(clearMapLocationNames_clearLocations);
    };

    case "registeredToWorld3DEN";
    case "attributesChanged3DEN": {
        // reset map locations
        private _clearedLocations = _module getVariable [QGVAR(ClearMapLocationNames_ClearedLocations), []];
        [_clearedLocations] call FUNC(clearMapLocationNames_restoreLocations);

        // clear new locations
        private _locations = [_area, _locationTypes] call FUNC(clearMapLocationNames_getLocations);
        private _clearedLocations = [_locations] call FUNC(clearMapLocationNames_clearLocations);

        _module setVariable [QGVAR(ClearMapLocationNames_ClearedLocations), _clearedLocations];
    };

    case "unregisteredFromWorld3DEN": {
        // reset map locations
        private _clearedLocations = _module getVariable [QGVAR(ClearMapLocationNames_ClearedLocations), []];
        [_clearedLocations] call FUNC(clearMapLocationNames_restoreLocations);
    };
};
