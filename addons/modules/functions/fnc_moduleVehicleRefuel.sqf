#include "script_component.hpp"

params [
    ["_module", objNull, [objNull]],
    ["_vehicles", [], [objNull, []]],
    ["_isActivated", false, [true]]
];

if (!isServer) exitWith {};

// Variables
private _repeatable = _module getVariable [QUOTE(Repeatable), true];
private _timeDelay = _module getVariable [QUOTE(TimeDelay), 600];

// Validate variables
if (_vehicles isEqualType objNull) then {_vehicles = [_vehicles]};
if (_timeDelay < 0) then {_timeDelay = 0};

[_vehicles, _repeatable, _timeDelay] call FUNC(vehicleRefuel);
