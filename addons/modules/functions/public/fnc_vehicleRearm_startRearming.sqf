/*
    Function: meh_modules_fnc_vehicleRearm_startRearming
    Repeatedly rearm vehicles on the server. Returns a script handle; terminate it to stop.
    Arguments: [vehicleOrVehicles, intervalSeconds, rearmCount, runImmediately, lifetimeObject].
    lifetimeObject is optional. Ticket counts are tracked on the vehicles across restarts.
*/
#include "script_component.hpp"

params [
    ["_vehicles", [], [[], objNull]],
    ["_timeDelay", 300, [0]],
    ["_rearmCountMax", 1, [0]],
    ["_runImmediately", false, [true]],
    ["_lifetimeObject", objNull, [objNull]]
];

if (!isServer) exitWith {scriptNull};
if (_vehicles isEqualType objNull) then {_vehicles = [_vehicles]};
_vehicles = _vehicles select {!isNull _x};
if (_vehicles isEqualTo []) exitWith {scriptNull};
_timeDelay = _timeDelay max 0;
_rearmCountMax = _rearmCountMax max 1;

if (_runImmediately) then {
    {
        [_x] call FUNC(vehicleRearm_rearm);
        _x setVariable [QGVAR(VehicleRearm_RearmCount), 1];
    } forEach _vehicles;
};

private _stopWithObject = !isNull _lifetimeObject;
[_vehicles, _timeDelay, _rearmCountMax, _lifetimeObject, _stopWithObject] spawn {
    params ["_vehicles", "_timeDelay", "_rearmCountMax", "_lifetimeObject", "_stopWithObject"];

    while {(!_stopWithObject || {alive _lifetimeObject}) && {_vehicles findIf {alive _x} != -1}} do {
        sleep (_timeDelay max 0.1);
        if ((_stopWithObject && {!alive _lifetimeObject}) || {_vehicles findIf {alive _x} == -1}) exitWith {};
        if (isGamePaused) then { continue };

        {
            private _vehicle = _x;
            if !(alive _vehicle) then { continue };

            private _rearmCountCurrent = _vehicle getVariable [QGVAR(VehicleRearm_RearmCount), 0];
            if (_rearmCountCurrent >= _rearmCountMax) then { continue };

            [_vehicle] call FUNC(vehicleRearm_rearm);
            _vehicle setVariable [QGVAR(VehicleRearm_RearmCount), _rearmCountCurrent + 1];
        } forEach _vehicles;
    };
}
