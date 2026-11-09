/*
    Function: meh_modules_fnc_vehicleRefuel_startRefueling
    Repeatedly refuel vehicles on the server. Returns a script handle; terminate it to stop.
    Arguments: [vehicleOrVehicles, intervalSeconds, refuelCount, fractionPerTick,
                runImmediately, lifetimeObject]. lifetimeObject is optional.
    Ticket counts are tracked on the vehicles, including across restarts.
*/
#include "script_component.hpp"

params [
    ["_vehicles", [], [[], objNull]],
    ["_timeDelay", 300, [0]],
    ["_refuelCountMax", 1, [0]],
    ["_refuelPercent", 1, [0]],
    ["_runImmediately", false, [true]],
    ["_lifetimeObject", objNull, [objNull]]
];

if (!isServer) exitWith {scriptNull};
if (_vehicles isEqualType objNull) then {_vehicles = [_vehicles]};
_vehicles = _vehicles select {!isNull _x};
if (_vehicles isEqualTo []) exitWith {scriptNull};
_timeDelay = _timeDelay max 0;
_refuelCountMax = _refuelCountMax max 1;

if (_runImmediately) then {
    {
        [_x, _refuelPercent] call FUNC(vehicleRefuel_refuel);
        _x setVariable [QGVAR(VehicleRefuel_RefuelCount), 1];
    } forEach _vehicles;
};

private _stopWithObject = !isNull _lifetimeObject;
[_vehicles, _timeDelay, _refuelCountMax, _refuelPercent, _lifetimeObject, _stopWithObject] spawn {
    params ["_vehicles", "_timeDelay", "_refuelCountMax", "_refuelPercent", "_lifetimeObject", "_stopWithObject"];

    while {(!_stopWithObject || {alive _lifetimeObject}) && {_vehicles findIf {alive _x} != -1}} do {
        sleep (_timeDelay max 0.1);
        if ((_stopWithObject && {!alive _lifetimeObject}) || {_vehicles findIf {alive _x} == -1}) exitWith {};
        if (isGamePaused) then { continue };

        {
            private _vehicle = _x;
            if !(alive _vehicle) then { continue };

            private _refuelCountCurrent = _vehicle getVariable [QGVAR(VehicleRefuel_RefuelCount), 0];
            if (_refuelCountCurrent >= _refuelCountMax) then { continue };

            [_vehicle, _refuelPercent] call FUNC(vehicleRefuel_refuel);
            _vehicle setVariable [QGVAR(VehicleRefuel_RefuelCount), _refuelCountCurrent + 1];
        } forEach _vehicles;
    };
}
