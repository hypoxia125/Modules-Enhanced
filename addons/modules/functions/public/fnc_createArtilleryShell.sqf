#include "script_component.hpp"

params [
    ["_shell", "Sh_82mm_AMOS", [""]],
    "_posATL",
    ["_heightATL", 1000, [-1]]
];

if (isNil "_posATL") exitWith {};
_posATL set [2, _heightATL];

private _typicalSpeed = getNumber (configFile >> "CfgAmmo" >> _shell >> "typicalSpeed");
if (_typicalSpeed == -1) then { _typicalSpeed = 1000 };

private _round = createVehicle [_shell, _posATL];
_round setVelocity [0, 0, -_typicalSpeed];

_round;