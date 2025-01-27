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

// Functions
//------------------------------------------------------------------------------------------------
private _clearLocations = {
    params ["_locations"];

    private _clearedLocations = [];
    {
        private _location = createLocation [_x];
        private _type = type _location;

        LOG_1("ModuleClearMapLocationNames.ClearLocations:: Clearing location name by changing type: %1",text _location);
        _location setType "Invisible";

        _clearedLocations pushBack [_location, _type];
    } forEach _locations;

    // return locations for saving
    _clearedLocations;
};

private _resetLocations = {
    params ["_clearedLocations"];
    
    {
        _x params ["_location", "_type"];
        LOG_1("ModuleClearMapLocationNames.ResetLocations:: Resetting Location: %1",text _location);
        _location setType _type;
    } forEach _clearedLocations;
};

private _getLocations = {
    params ["_area", "_types"];
    _area params ["_center", "_a", "_b"];
    private _maxArea = _a max _b;

    private _locationsUnfiltered = nearestLocations [_center, _types, _maxArea];
    private _locations = _locationsUnfiltered select {(locationPosition _x) inArea _area};

    // return
    LOG_1("ModuleClearMapLocationNames.GetLocations:: Found locations: %1",_locations);
    _locations;
};

// Code Start
//------------------------------------------------------------------------------------------------
switch _mode do {
    case "init": {
        if (is3DEN) exitWith {};

        private _locations = [_area, _locationTypes] call _getLocations;
        private _clearedLocations = [_locations] call _clearLocations;
    };

    case "registeredToWorld3DEN";
    case "attributesChanged3DEN": {
        // reset map locations
        private _clearedLocations = _module getVariable [QGVAR(ClearMapLocationNames_ClearedLocations), []];
        [_clearedLocations] call _resetLocations;

        // clear new locations
        private _locations = [_area, _locationTypes] call _getLocations;
        private _clearedLocations = [_locations] call _clearLocations;

        _module setVariable [QGVAR(ClearMapLocationNames_ClearedLocations), _clearedLocations];
    };

    case "unregisteredFromWorld3DEN": {
        // reset map locations
        private _clearedLocations = _module getVariable [QGVAR(ClearMapLocationNames_ClearedLocations), []];
        [_clearedLocations] call _resetLocations;
    };
};