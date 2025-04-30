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
if (!hasInterface) exitWith {};
if (_mode != "init") exitWith {};

// Variables
//------------------------------------------------------------------------------------------------
private _inOut = _module getVariable "InOut";
private _color = _module getVariable "Color";
private _duration = _module getVariable ["Duration", 3];

private _fade = switch (_inOut) do {
    case 0: {"IN"};
    case 1: {"OUT"};
};
private _colorFade = switch (_color) do {
    case 0: {"BLACK"};
    case 1: {"WHITE"};
};
private _type = _colorFade + " " + _fade;

// Code Start
//------------------------------------------------------------------------------------------------
if (!_isActivated) exitWith {};
if (is3DEN) exitWith {};

if (isNil QGVAR(ModuleFadeScreen_Layer)) then {
    GVAR(ModuleFadeScreen_Layer) = [QGVAR(ModuleFadeScreen_Layer)] call BIS_fnc_rscLayer;
};

QGVAR(ModuleFadeScreen_Layer) cutText ["", _type, _duration, true, true, true];