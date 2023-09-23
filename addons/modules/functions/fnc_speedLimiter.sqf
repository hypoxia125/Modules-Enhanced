#include "script_component.hpp"

params [
    ["_vehicles", [], [[], objNull]],
    ["_speed", 0, [-1]],
    ["_affectPlayer", true, [true]],
    ["_affectAI", true, [true]]
];

// Verify variables
if (_vehicles isEqualType objNull) then {_vehicles = [_vehicles]};
if (_speed < 0) then {_speed = abs _speed};
if ((!_affectPlayer) && (!_affectAI)) exitWith {};

TRACE_4("Variables", _vehicles, _speed, _affectPlayer, _affectPlayer);

_vehicles apply {
    private _vehicle = _x;

    if (_affectPlayer) then {
        private _jip = [QGVAR(vehicleCruiseControl), [_vehicle, _speed]] call CBA_fnc_globalEventJIP;
        [_jip, _vehicle] call CBA_fnc_removeGlobalEventJIP;

        LOG_2("Limiting %1's speed to %2 for players.", _vehicle, _speed);
    };

    if (_affectAI) then {
        _vehicle limitSpeed _speed;

        LOG_2("Limiting %1's speed to %2 for AI.", _vehicle, _speed);
    };
};
