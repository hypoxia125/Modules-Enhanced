/* ----------------------------------------------------------------------------
Function: meh_modules_fnc_createVirtualArtilleryRound

Author: Hypoxic

Public: True

Flags: Global Argument, Global Execution

Description:
    Creates an area of bombardment for virtual artillery
---------------------------------------------------------------------------- */

#include "script_component.hpp"

params ["_shell", "_pos", "_customVelocity"];

private _round = createVehicle [_shell, _pos];

if (!isNil "_customVelocity") then {
    _round setVelocity (_customVelocity min -_customVelocity);
} else {
    private _velocity = getNumber (configFile >> "CfgAmmo" >> _shell >> "speed");
    if (_velocity == 0) then { _velocity = -1000 };
    _round setVelocity (_velocity min -_velocity);
};

_round
