#include "script_component.hpp"

params [
    ["_module", objNull, [objNull]],
    "",
    ["_isActivated", false, [true]]
];

if (!isServer) exitWith {};

// Variables
private _vehicleClass = call compile (_module getVariable [QUOTE(VehicleClass), ""]);
private _createCrew = _module getVariable [QUOTE(CreateCrew), true];
private _crewSide = _module getVariable [QUOTE(CrewSide), 1];
private _paraHeight = _module getVariable [QUOTE(ParadropHeight), 500];
private _parachuteHeight = _module getVariable [QUOTE(ParachuteHeight), 100];
private _code = compile (_module getVariable [QUOTE(Expression), "true"]);

// Verify variables
if (_vehicleClass isEqualTo "") exitWith {};
if (_paraHeight <= 0 && _paraHeight != -1) then {_paraHeight = 500};
if (_parachuteHeight <= 0) then {_parachuteHeight = 0};

_crewSide = switch _crewSide do {
    case 0: {east};
    case 1: {west};
    case 2: {independent};
    case 3: {civilian};
};

TRACE_4("Variables",_vehicleClass, _createCrew, _paraHeight, _parachuteHeight);

// Create vehicle
private _pos = getPosATL _module;
if !(_paraHeight == -1) then {
    _pos set [2, 0];
    _pos = _pos vectorAdd [0,0,_paraHeight];
};

private _vehicle = createVehicle [_vehicleClass, _pos, [], 0, "NONE"];

TRACE_2("Vehicle",_vehicle,_pos);

// Create crew
private _crew = createGroup [_crewSide, true];
if (_createCrew && {_vehicleClass isKindOf "LandVehicle"}) then {
    _crew createVehicleCrew _vehicle;
};

TRACE_1("Vehicle Crew",units _crew);

// Wait for parachute altitude
[{
    params ["_vehicle", "_parachuteHeight"];

    if (isNull _vehicle) exitWith {true};
    private _pos = getPosATL _vehicle;
    (_pos select 2 <= _parachuteHeight)
}, {
    // Create parachute
    params ["_vehicle"];

    if (isNull _vehicle) exitWith {true};
    private _parachute = createVehicle ["B_Parachute_02_F", getPosATL _vehicle, [], 0, "CAN_COLLIDE"];
    _parachute setVelocityModelSpace (velocityModelSpace _vehicle);

    private _attachPoint = [0,1,0];
    _vehicle attachTo [_parachute, _attachPoint];

    // Wait for vehicle to reach ground
    [{
        params ["_vehicle", "_parachute"];

        if (isNull _vehicle) exitWith {true};
        private _pos = getPosATL _vehicle;
        (_pos select 2 <= 5)
    }, {
        // Detach parachute
        params ["_vehicle", "_parachute"];

        detach _vehicle;
    }, [_vehicle, _parachute]] call CBA_fnc_waitUntilAndExecute;
}, [_vehicle, _parachuteHeight]] call CBA_fnc_waitUntilAndExecute;

// Call user created code on vehicle
[_vehicle, _crew] spawn _code;