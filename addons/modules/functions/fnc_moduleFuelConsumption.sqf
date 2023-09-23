#include "script_component.hpp"

params [
    ["_module", objNull, [objNull]],
    ["_vehicles", [], [objNull, []]],
    ["_isActivated", false, [true]]
];

if (!isServer) exitWith {};
if (!_isActivated) exitWith {};

// Variables
private _tickRate = _module getVariable [QUOTE(TickRate), 1];
private _idleTime = _module getVariable [QUOTE(IdleTime), 60];
private _maxTime = _module getVariable [QUOTE(MaxTime), 20];

// Verify variables
if (_vehicles isEqualType objNull) then {_vehicles = [_vehicles]};
if (_tickRate < 1) then {_tickRate = 1};
if (_tickRate > 5) then {_tickRate = 5};
if (_idleTime < 1) then {_idleTime = 1};
if (_maxTime < 1) then {_maxTime = 1};
if (_maxTime > _idleTime) then {_maxTime = _idleTime};

[_vehicles, _tickRate, _idleTime, _maxTime] call FUNC(fuelConsumption);
