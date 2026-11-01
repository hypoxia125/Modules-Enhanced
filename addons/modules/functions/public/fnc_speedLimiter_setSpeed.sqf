/*
    Function: meh_modules_fnc_speedLimiter_setSpeed
    Set cruise control for players and/or AI speed limit for vehicles.
    Arguments: [vehicleOrVehicles, speed, affectPlayers, affectAI]. Speed 0 removes the limit.
    Call on the server; player cruise control is broadcast to JIP clients.
*/
#include "script_component.hpp"

params [
    ["_vehicles", [], [[], objNull]],
    ["_speed", 0, [0]],
    ["_affectPlayer", true, [true]],
    ["_affectAI", true, [true]]
];

if (!isServer || {_speed < 0} || {!_affectPlayer && !_affectAI}) exitWith {};
if (_vehicles isEqualType objNull) then {_vehicles = [_vehicles]};

{
    private _vehicle = _x;
    if (!isNull _vehicle) then {
        if (_affectPlayer) then {
            [QGVAR(vehicleCruiseControl), [_vehicle, _speed], format[QGVAR(SpeedLimiter_%1), _vehicle]] call CBA_fnc_globalEventJIP;
        };
        if (_affectAI) then {
            _vehicle limitSpeed _speed;
        };
    };
} forEach _vehicles;
