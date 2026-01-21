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
if (!isServer) exitWith {};
if (!is3DEN && {!_isActivated}) exitWith {};
if (_mode in ["dragged3DEN", "unregisteredFromWorld3DEN"]) exitWith {};

// Variables
//------------------------------------------------------------------------------------------------
private _vehicleClass = _module getVariable [QUOTE(VehicleClass), ""];
private _createCrew = _module getVariable [QUOTE(CreateCrew), true];
private _crewSide = _module getVariable [QUOTE(CrewSide), 1];
private _paraHeight = _module getVariable [QUOTE(ParadropHeight), 200];
private _parachuteHeight = _module getVariable [QUOTE(ParachuteHeight), 150];
private _code = compile (_module getVariable [QUOTE(Expression), "true"]);

// Verify variables
if (_vehicleClass isEqualTo "") exitWith {[typeOf _module] call EFUNC(Error,invalidArgs)};
if (_paraHeight <= 0 && _paraHeight != -1) exitWith {[typeOf _module] call EFUNC(Error,invalidArgs)};
if (_parachuteHeight <= 0 && _parachuteHeight != -1) exitWith {[typeOf _module] call EFUNC(Error,invalidArgs)};

// Functions
//------------------------------------------------------------------------------------------------
private _calcDropHeight = {
    params ["_module", "_paraHeight"];

    private _pos = getPosATL _module;
    if (_paraHeight != -1) then {
        _pos set [2, 0];
        _pos = _pos vectorAdd [0, 0, _paraHeight];
    };

    // return
    _pos;
};

private _getCrewSide = {
    params ["_sideVal"];

    switch _sideVal do {
        case 0: {east};
        case 1: {west};
        case 2: {independent};
        case 3: {civilian};
        default {sideUnknown};
    };
};

private _createDrop = {
    params ["_functions", "_args"];
    _functions params ["_calcDropHeight", "_getCrewSide"];
    _args params ["_module", "_vehicleClass", "_createCrew", "_sideVal", "_pos", "_parachuteHeight", "_code"];

    private _crewSide = [_sideVal] call _getCrewSide;
    private _vehicle = createVehicle [_vehicleClass, _pos, [], 0, "NONE"];
    private _crew = grpNull;
    if (_createCrew && {_vehicleClass isKindOf "LandVehicle"}) then {
        _crew = createGroup [_crewSide, true];
        _crew createVehicleCrew _vehicle;
    };

    // Wait for parachute altitude to be reached
    [{
        params ["_vehicle", "_parachuteHeight"];

        if (isNull _vehicle) exitWith { true };

        private _pos = getPosATL _vehicle;
        _pos#2 <= _parachuteHeight;
    }, {
        params ["_vehicle"];

        if (isNull _vehicle) exitWith { true };

        private _parachute = createVehicle ["B_Parachute_02_F", getPosATL _vehicle, [], 0, "CAN_COLLIDE"];
        _parachute setVelocityModelSpace (velocityModelSpace _vehicle);
        private _attachPoint = [0,0,1];
        _vehicle attachTo [_parachute, _attachPoint];

        // Wait for vehicle to reach the ground
        [{
            params ["_vehicle", "_parachute"];

            if (isNull _vehicle) exitWith { true };

            private _pos = getPosATL _vehicle;
            _pos#2 <= 5
        }, {
            params ["_vehicle", "_parachute"];

            detach _vehicle;
            [QGVAR(ParadropVehicle_ParachuteDetached), [_vehicle, _parachute]] call CBA_fnc_globalEvent;
        }, [_vehicle, _parachute]] call CBA_fnc_waitUntilAndExecute;
    }, [_vehicle, _parachuteHeight]] call CBA_fnc_waitUntilAndExecute;

    // Call user code on vehicle
    [_vehicle, _crew] spawn _code;

    // Event
    [QGVAR(ParadropVehicle_VehicleDropped), [_vehicle]] call CBA_fnc_globalEvent;
};

private _functions = [
    _calcDropHeight,
    _getCrewSide,
    _createDrop
];

// Code Start
//------------------------------------------------------------------------------------------------
switch _mode do {
    case "init": {
        if (is3DEN) exitWith {};

        private _pos = [_module, _paraHeight] call _calcDropHeight;
        [_functions, [_module, _vehicleClass, _createCrew, _crewSide, _pos, _parachuteHeight, _code]] call _createDrop;
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
