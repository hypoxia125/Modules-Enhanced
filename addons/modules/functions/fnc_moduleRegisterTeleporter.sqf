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

if (!is3DEN && {!_isActivated}) exitWith {};
if (_mode in ["dragged3DEN", "unregisteredFromWorld3DEN"]) exitWith {};

// Variables
private _name = _module getVariable [QUOTE(Name), ""];
private _sideNum = _module getVariable [QUOTE(Side), 1];
private _bidirectional = _module getVariable [QUOTE(Bidirectional), true];
private _travelTime = _module getVariable [QUOTE(TravelTime), -1];
_side = switch _sideNum do {
    case 0: {east};
    case 1: {west};
    case 2: {independent};
    case 3: {civilian};
};

// Verify variables
private _object = synchronizedObjects _module select {!(_x isKindOf "EmptyDetector" || _x isKindOf "Module_F")};
if (count _object > 1 || _travelTime < -1) exitWith {[typeOf _module] call EFUNC(Error,invalidArgs)};
_object = _object select 0;

switch _mode do {
    case "init": {
        if (is3DEN) exitWith {};
        
        INFO_1("Registering Teleporter: %1", _object);

        // Teleporter naming
        if (_name isEqualTo "") then {
            _name = FORMAT_1("Grid: %2",str mapGridPosition _object);
        };

        // Merge data with transporterData
        if (isNil QEGVAR(teleporter,teleporterData)) then {
            EGVAR(teleporter,teleporterData) = [];
        };

        EGVAR(teleporter,teleporterData) pushBackUnique [_name, _object, _side, _bidirectional, _travelTime, true];

        INFO_1("Registering Teleporter: %1 - Complete", _object);
        [QGVAR(teleporterRegistered), [_name, _object, _side, _bidirectional, _travelTime, true]] call CBA_fnc_localEvent;

        // Execute the teleporter system
        [_object] call EFUNC(teleporter,createTeleporterAction);
    };

    case "connectionChanged3DEN": {
        private _synced = get3DENConnections _module apply {_x select 1};
        private _invalid = _synced select {(_x isKindOf "Module_F")};
        if (_invalid isNotEqualTo []) then {
            [typeOf _module] call EFUNC(Error,invalidSync);

            // remove connection
            remove3DENConnection ["Sync", _invalid, _module];
        };
    };

    default {};
};
