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
private _name = _module getVariable ["Name", format["Custom Location: %1", mapGridPosition getPosASL _module]];
private _type = _module getVariable "Type";
private _importance = _module getVariable "Importance";
private _area = _module getVariable "ObjectArea";
private _area = [getPosASL _module] + _area;
if (is3DEN) then {
    _area = [_module] call FUNC(get3DENAreaModule);
};

// Functions
//------------------------------------------------------------------------------------------------
private _getType = {
    params ["_numType"];

    switch _numType do {
        case 0: { "Area" };
        case 1: { "BorderCrossing" };
        case 2: { "CivilDefense"};
        case 3: { "CulturalProperty" };
        case 4: { "DangerousForces" };
        case 5: { "Flag" };
        case 6: { "FlatArea" };
        case 7: { "FlatAreaCity" };
        case 8: { "FlatAreaCitySmall" };
        case 9: { "Hill" };
        case 10: { "Invisible" };
        case 11: { "Name" };
        case 12: { "NameCity" };
        case 13: { "NameCityCapital" };
        case 14: { "NameLocal" };
        case 15: {"NameMarine" };
        case 16: { "NameVillage" };
        case 17: { "RockArea" };
        case 18: { "SafetyZone" };
        case 19: { "Strategic" };
        case 20: { "StrongpointArea" };
        case 21: { "VegetationBroadleaf" };
        case 22: { "VegetationFir" };
        case 23: { "VegetationPalm" };
        case 24: { "VegetationVineyard" };
        case 25: { "ViewPoint" };
    };
};

private _createLocation = {
    params ["_area", "_name", "_type", "_importance"];

    // TODO: Verify ASL works
    private _location = createLocation [_type, _area#0, _area#1, _area#2];
    _location setDirection _area#3;
    _location setRectangular _area#4;

    _location setText _name;
    _location setImportance _importance;

    // return
    _location;
};

private _deleteLocation = {
    params ["_location"];

    deleteLocation _location;
};

// Code Start
//------------------------------------------------------------------------------------------------
switch _mode do {
    case "init": {
        if (is3DEN) exitWith {};

        private _type = [_type] call _getType;
        private _location = [_area, _name, _type, _importance] call _createLocation;
        _module setVariable [QGVAR(CreateMapLocation_Location), _location];
    };

    // DOES NOT WORK WITH 3DEN. KEEPING CODE HERE INCASE IT EVER CHANGES
    // case "registeredToWorld3DEN";
    // case "attributesChanged3DEN": {
    //     // reset previous location
    //     private _location = _module getVariable QGVAR(CreateMapLocation_Location);
    //     [_location] call _deleteLocation;

    //     // build new location
    //     private _type = [_type] call _getType;
    //     private _location = [_area, _name, _type, _importance] call _createLocation;
    //     _module setVariable [QGVAR(CreateMapLocation_Location), _location];
    // };

    // case "unregisteredFromWorld3DEN": {
    //     // reset previous location
    //     private _location = _module getVariable QGVAR(CreateMapLocation_Location);
    //     [_location] call _deleteLocation;
    // };
};