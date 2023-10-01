/*
    Author: Hypoxic
    Spawns and paradrops a given vehicle or crate at altitude. Additional code can be passed to the object being created.

    Arguments:
    0: Vehicle or Crate Classname - STRING
    1: Create Crew - BOOL
    2: Crew Side - SIDE
    3: Position - ARRAY in format PositionATL
    4: Parachute Height - NUMBER
    5: Code - CODE

    ReturnValue:
    0: Vehicle - OBJECT
    1: Crew - GROUP

    Example:
    [group_1, group_2, group_3, 300] call MEH_Modules_fnc_paradropVehicle;

    Public: Yes
*/

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
private _crew = grpNull;
if (_createCrew && {_vehicleClass isKindOf "LandVehicle"}) then {
    _crew = createGroup [_crewSide, true];
    _crew createVehicleCrew _vehicle;
};

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

// Return
[_vehicle, _crew];
