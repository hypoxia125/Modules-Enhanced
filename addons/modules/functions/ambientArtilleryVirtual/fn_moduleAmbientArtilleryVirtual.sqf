/* ----------------------------------------------------------------------------
Function: meh_modules_fnc_moduleAmbientArtilleryVirtual

Author: Hypoxic

Public: False - Requires internal data

Flags: Server Only

Description:
    Function that the module calls upon initialization.
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

// Pre-Execution Checks
//------------------------------------------------------------------------------------------------
if (!isServer) exitWith {};
if !(_mode in ["init"]) exitWith {};

// Variables
//------------------------------------------------------------------------------------------------
private _area = _module getVariable ["ObjectArea", [100, 100, 0, false, -1]];
private _shell = _module getVariable ["Shell", "Sh_82mm_AMOS"];
private _salvoSize = _module getVariable ["SalvoSize", 6];
private _salvoInterval = _module getVariable ["SalvoInterval", 10];
private _salvoTimeVariation = _module getVariable ["SalvoTimeVariation", 5];
private _shotInterval = _module getVariable ["ShotInterval", 1];
private _shotTimeVariation = _module getVariable ["ShotTimeVariation", 1];

_area = [getPosATL _module] + _area;

if (!isClass (configFile >> "CfgAmmo" >> _shell)) exitWith {[typeOf _module] call EFUNC(Error,invalidArgs)};
if ([_salvoSize, _salvoInterval, _salvoTimeVariation, _shotInterval, _shotTimeVariation] findIf {_x < 0} != -1) exitWith {[typeOf _module] call EFUNC(Error,invalidArgs)};

// Code Start
//------------------------------------------------------------------------------------------------
switch _mode do {
    case "init": {
        if (is3DEN) exitWith {};

        if (_isActivated) then {
            private _handle = [
                _area, _shell, _salvoSize, _salvoInterval,
                _salvoTimeVariation, _shotInterval, _shotTimeVariation
            ] spawn FUNC(doVirtualArtillery);

            _module setVariable [QGVAR(ambientArtilleryVirtual_Handle), _handle];
        } else {
            private _handle = _module getVariable [QGVAR(ambientArtilleryVirtual_PFHandler), -1];
            terminate _handle;
        };
    };

    default {};
};
