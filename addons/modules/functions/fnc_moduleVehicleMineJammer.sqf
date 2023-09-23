#include "script_component.hpp"

params [
    ["_module", objNull, [objNull]],
    ["_vehicles", [], [objNull, []]],
    ["_isActivated", false, [true]]
];

if (!isServer) exitWith {};
if (!_isActivated) exitWith {};

// Variables
private _distance = _module getVariable [QUOTE(Distance), 25];
private _explode = _module getVariable [QUOTE(Explode), false];

// Verify variables
if (_vehicles isEqualType objNull) then {_vehicles = [_vehicles]};
if (_distance < 0) then {_distance = 0};

[_vehicles, _distance, _explode] call FUNC(vehicleMineJammer);
