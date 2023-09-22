#include "script_component.hpp"

params [
    ["_vehicleClass", "", [""]],
    ["_createCrew", true, [true]],
    ["_crewSide", west, [sideUnknown]],
    ["_pos", [0,0,0], [[]], 3],
    ["_parachuteHeight", 100, [-1]],
    ["_code", {}, [{}]]
];

// Verify variables
if (_vehicleClass isEqualTo "") exitWith {};
if (_pos select 2 < 0) then {_pos set [2, 0]};
if (_parachuteHeight <= 0) then {_parachuteHeight = 0};

private _vehicle = createVehicle [_vehicleClass, _pos, [], 0, "NONE"];

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
