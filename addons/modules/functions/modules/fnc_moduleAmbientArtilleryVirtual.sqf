#include "script_component.hpp"
#include "module_defaults.hpp"

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
if !(_mode in ["init", "attributesChanged3DEN"]) exitWith {};

// Variables
//------------------------------------------------------------------------------------------------
private _area = _module getVariable ["ObjectArea", [100, 100, 0, false, -1]];
private _shell = _module getVariable ["Shell", AMBIENTARTILLERYVIRTUAL_SHELL];
private _timeLength = _module getVariable ["TimeLength", AMBIENTARTILLERYVIRTUAL_TIMELENGTH];
private _salvoSize = _module getVariable ["SalvoSize", AMBIENTARTILLERYVIRTUAL_SALVOSIZE];
private _salvoInterval = _module getVariable ["SalvoInterval", AMBIENTARTILLERYVIRTUAL_SALVOINTERVAL];
private _salvoTimeVariation = _module getVariable ["SalvoTimeVariation", AMBIENTARTILLERYVIRTUAL_SALVOTIMERVARIATION];
private _shotInterval = _module getVariable ["ShotInterval", AMBIENTARTILLERYVIRTUAL_SHOTINTERVAL];
private _shotTimeVariation = _module getVariable ["ShotTimeVariation", AMBIENTARTILLERYVIRTUAL_SHOTTIMEVARIATION];

_area = [getPosATL _module] + _area;

if (!isClass (configFile >> "CfgAmmo" >> _shell)) exitWith {
    private _additionalInfo = "User defined ammo type is not a defined ammo type in CfgAmmo";
    [typeOf _module, _additionalInfo] call EFUNC(Error,invalidArgs);
};

if ([_salvoSize, _salvoInterval, _salvoTimeVariation, _shotInterval, _shotTimeVariation] findIf {_x < 0} != -1) exitWith {
    private _additionalInfo = "User defined values for salvo and shot data are negative";
    [typeOf _module, _additionalInfo] call EFUNC(Error,invalidArgs);
};

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
