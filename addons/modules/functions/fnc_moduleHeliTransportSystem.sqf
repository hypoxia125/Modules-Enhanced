/* ----------------------------------------------------------------------------
Function: meh_modules_fnc_moduleHeliTransportSystem

Author: Hypoxic

Public: False - Requires internal data

Description:
    Handles the creation of data structures used in the heli transport system.
    Creates the needed local client systems to use the heli transport system.
---------------------------------------------------------------------------- */

#include "script_component.hpp"

// Parameters
//------------------------------------------------------------------------------------------------
params [
    ["_mode", "", [""]],
    ["_input", [], [[]]]
];
_input params [
    ["_module", objNull, [objNull]],
    ["_isActivated", false, [true]],
    ["_isCuratorPlaced", false, [true]]
];

private _invulnerableHelis = _module getVariable "InvulnerableHelis";
private _untargetableHelis = _module getVariable "UntargetableHelis";
private _invulnerablePassengers = _module getVariable "InvulnerablePassengers";
private _maxActiveHelis = _module getVariable "MaxActiveHelis";

if (isServer) then {
    if (isNil QGVAR(HeliTransportSystem_Settings)) then {
        GVAR(HeliTransportSystem_Settings) = createHashMapFromArray [
            ["invulnerableHelis", _invulnerableHelis],
            ["untargetableHelis", _untargetableHelis],
            ["invulnerablePassengers", _invulnerablePassengers],
            ["maxActiveHelis", _maxActiveHelis]
        ];

        publicVariable QGVAR(HeliTransportSystem_Settings);
    };
};