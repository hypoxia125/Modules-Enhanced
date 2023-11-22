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
if (!is3DEN && {!_isActivated}) exitWith {};
if (_mode in ["dragged3DEN", "unregisteredFromWorld3DEN"]) exitWith {};

// Variables
private _vehicleClass = _module getVariable [QUOTE(VehicleClass), ""];
private _createCrew = _module getVariable [QUOTE(CreateCrew), true];
private _crewSide = _module getVariable [QUOTE(CrewSide), 1];
private _paraHeight = _module getVariable [QUOTE(ParadropHeight), 200];
private _parachuteHeight = _module getVariable [QUOTE(ParachuteHeight), 150];
private _code = if (!is3DEN) then {
    compile (_module getVariable [QUOTE(Expression), "true"])
};

// Verify variables
if (_vehicleClass isEqualTo "") exitWith {[typeOf _module] call EFUNC(Error,invalidArgs)};
if (_paraHeight <= 0 && _paraHeight != -1) exitWith {[typeOf _module] call EFUNC(Error,invalidArgs)};
if (_parachuteHeight <= 0 && _parachuteHeight != -1) exitWith {[typeOf _module] call EFUNC(Error,invalidArgs)};

switch _mode do {
    case "init": {
        if (is3DEN) exitWith {};

        _crewSide = switch _crewSide do {
            case 0: {east};
            case 1: {west};
            case 2: {independent};
            case 3: {civilian};
        };

        private _pos = getPosATL _module;
        if !(_paraHeight == -1) then {
            _pos set [2, 0];
            _pos = _pos vectorAdd [0,0,_paraHeight];
        };

        [_vehicleClass, _createCrew, _crewSide, _pos, _parachuteHeight, _code] call FUNC(paradropVehicle);
    };
    
    case "connectionChanged3DEN": {
        private _synced = get3DENConnections _module apply {_x select 1};
        private _invalid = _synced select {!(_x isKindOf "EmptyDetector")};
        if (_invalid isNotEqualTo []) then {
            [typeOf _module] call EFUNC(Error,invalidSync);

            // remove connection
            remove3DENConnection ["Sync", _invalid, _module];
        };
    };
};
