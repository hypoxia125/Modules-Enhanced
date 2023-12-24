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
private _object = synchronizedObjects _module select {!(_x isKindOf "EmptyDetector" || _x isKindOf "Module_F" || _x isKindOf "CAManBase")};
if (count _object > 1) exitWith {[typeOf _module] call EFUNC(Error,invalidSync)};
if (_travelTime < -1) exitWith {[typeOf _module] call EFUNC(Error,invalidArgs)};
_object = _object select 0;

// Register
switch _mode do {
    case "init": {
        if (is3DEN) exitWith {};

        // Register if no synced object
        if (isNil "_object") then {
            // Create object
            private _flagClass = switch _side do {
                case east: {"Flag_Red_F"};
                case west: {"Flag_Blue_F"};
                case independent: {"Flag_Green_F"};
                default {"Flag_White_F"};
            };
            private _pos = getPosATL _module;
            private _flag = createVehicle [_flagClass, _pos, [], 0, "NONE"];

            _object = _flag;

            INFO_2("(%1) No object synced, creating dummy flag for use: %2",QFUNC(moduleRegisterTeleporter),_object);
        };
        
        INFO_2("(%1) Registering Teleporter: %2",QFUNC(moduleRegisterTeleporter),_object);

        // Teleporter naming
        if (_name isEqualTo "") then {
            _name = FORMAT_1("Grid: %1",str mapGridPosition _object);
        };

        // Merge data with transporterData
        if (isNil QEGVAR(teleporter,teleporterData)) then {
            EGVAR(teleporter,teleporterData) = [];
        };

        // Check if name is present in data array, if so change it
        private _i = 2;
        while {toLowerANSI _name in (EGVAR(teleporter,teleporterData) apply {toLowerANSI (_x select 0)})} do {
            _name = FORMAT_2("%1 %2",_name,_i);
            _i = _i + 1;
        };

        EGVAR(teleporter,teleporterData) pushBackUnique [_name, _object, _side, _bidirectional, _travelTime, true];

        // Global event handler for vehicle death - owner change compat
        _object addEventHandler ["Killed", {
            params ["_unit", "_killer", "_instigator", "_useEffects"];
            
            if (local _unit) then {
                ["object", _unit] call EFUNC(teleporter,deleteTeleportData);
            };
        }];
        
        INFO_2("(%1) Registering Teleporter Complete: %2",QFUNC(moduleRegisterTeleporter),_object);
        [QGVAR(teleporterRegistered), [_name, _object, _side, _bidirectional, _travelTime, true]] call CBA_fnc_localEvent;

        // Execute the teleporter system
        [_object] call EFUNC(teleporter,createTeleporterAction);
    };

    case "connectionChanged3DEN": {
        private _synced = get3DENConnections _module apply {_x select 1};
        private _invalid = _synced select {(_x isKindOf "Module_F" || _x isKindOf "CAManBase")};
        if (_invalid isNotEqualTo []) then {
            [typeOf _module] call EFUNC(Error,invalidSync);

            // remove connection
            remove3DENConnection ["Sync", _invalid, _module];
        };
    };

    default {};
};
