/*
    Function: meh_modules_fnc_vehicleRepair_startRepairing
    Repeatedly repair vehicles on the server. Returns a script handle; terminate it to stop.
    Arguments: [vehicleOrVehicles, intervalSeconds, repairCount, fractionPerTick,
                runImmediately, lifetimeObject]. lifetimeObject is optional.
    Ticket counts are tracked on the vehicles, including across restarts.
*/
#include "script_component.hpp"

params [
    ["_vehicles", [], [[], objNull]],
    ["_timeDelay", 300, [0]],
    ["_repairCountMax", 1, [0]],
    ["_repairPercent", 1, [0]],
    ["_runImmediately", false, [true]],
    ["_lifetimeObject", objNull, [objNull]]
];

if (!isServer) exitWith {scriptNull};
if (_vehicles isEqualType objNull) then {_vehicles = [_vehicles]};
_vehicles = _vehicles select {!isNull _x};
if (_vehicles isEqualTo []) exitWith {scriptNull};
_timeDelay = _timeDelay max 0;
_repairCountMax = _repairCountMax max 1;

if (_runImmediately) then {
    {
        [_x, _repairPercent] call FUNC(vehicleRepair_repair);
        _x setVariable [QGVAR(VehicleRepair_RepairCount), 1];
    } forEach _vehicles;
};

private _stopWithObject = !isNull _lifetimeObject;
[_vehicles, _timeDelay, _repairCountMax, _repairPercent, _lifetimeObject, _stopWithObject] spawn {
    params ["_vehicles", "_timeDelay", "_repairCountMax", "_repairPercent", "_lifetimeObject", "_stopWithObject"];

    while {(!_stopWithObject || {alive _lifetimeObject}) && {_vehicles findIf {alive _x} != -1}} do {
        sleep (_timeDelay max 0.1);
        if ((_stopWithObject && {!alive _lifetimeObject}) || {_vehicles findIf {alive _x} == -1}) exitWith {};
        if (isGamePaused) then { continue };

        LOG_1("ModuleVehicleRepair:: Repairing vehicles: %1",_vehicles);
        {
            private _vehicle = _x;
            if !(alive _vehicle) then { continue };

            private _repairCountCurrent = _vehicle getVariable [QGVAR(VehicleRepair_RepairCount), 0];
            if (_repairCountCurrent >= _repairCountMax) then { continue };

            [_vehicle, _repairPercent] call FUNC(vehicleRepair_repair);
            _vehicle setVariable [QGVAR(VehicleRepair_RepairCount), _repairCountCurrent + 1];
        } forEach _vehicles;
    };
}
