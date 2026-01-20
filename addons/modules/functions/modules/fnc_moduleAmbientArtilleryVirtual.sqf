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
private _area = _module getVariable [QUOTE(ObjectArea), [100, 100, 0, false, -1]];
private _shell = _module getVariable [QUOTE(Shell), "Sh_82mm_AMOS"];
private _timeLength = _module getVariable [QUOTE(TimeLength), 60];
private _salvoSize = _module getVariable [QUOTE(SalvoSize), 6];
private _salvoInterval = _module getVariable [QUOTE(SalvoInterval), 10];
private _salvoTimeVariation = _module getVariable [QUOTE(SalvoTimeVariation), 5];
private _shotInterval = _module getVariable [QUOTE(ShotInterval), 1];
private _shotTimeVariation = _module getVariable [QUOTE(ShotTimeVariation), 1];

if (isNull _module) then {
    _module = createVehicle ["Land_HelipadEmpty_F", _module];
};
_area = [getPosATL _module] + _area;

if (!isClass (configFile >> "CfgAmmo" >> _shell)) exitWith {[typeOf _module] call EFUNC(Error,invalidArgs)};
if ([_salvoSize, _salvoInterval, _salvoTimeVariation, _shotInterval, _shotTimeVariation] findIf {_x < 0} != -1) exitWith {[typeOf _module] call EFUNC(Error,invalidArgs)};

// Functions
//------------------------------------------------------------------------------------------------
private _stopArtillery = {
    params ["_module"];

    private _handle = _module getVariable [QGVAR(ambientArtilleryVirtual_ScriptHandler), -1];
    terminate _handle;
};

// Code Start
//------------------------------------------------------------------------------------------------
switch _mode do {
    case "init": {
        if (is3DEN) exitWith {};

        if (_isActivated) then {
            private _handle = [
                _area, _shell, _timeLength,
                [_salvoSize, _salvoInterval, _salvoTimeVariation],
                [_shotInterval, _shotTimeVariation]
            ] spawn FUNC(createVirtualArtilleryFire);

            _module setVariable [QGVAR(ambientArtilleryVirtual_ScriptHandler), _handle];
        } else {
            [_module] call _stopArtillery;
        };
    };

    default {};
};
