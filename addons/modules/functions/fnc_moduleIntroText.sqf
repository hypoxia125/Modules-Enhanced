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
private _title = _module getVariable ["Title", ""];
private _subtitle = _module getVariable ["SubTitle", ""];
private _additional = _module getVariable ["Additional", ""];

// Code Start
//------------------------------------------------------------------------------------------------
if (!_isActivated) exitWith {};
if (is3DEN) exitWith {};

private _titleFormatting = "<t align = 'right' shadow = '1' size = '1' font = 'PuristaBold'>%1</t><br/>";
private _subtitleFormatting = "<t align = 'right' shadow = '1' size = '0.7' font = 'PuristaMedium'>%1</t><br/>";
private _additionalFormatting = "<t align = 'right' shadow = '1' size = '0.5' font = 'PuristaLight'>%1</t><br/>";
private _timeFormatting = "<t align = 'right' shadow = '1' size = '0.5' font = 'PuristaBold'>%1</t><br/>";

[
    [
        [_title,  _titleFormatting, 10],
        [_subtitle,  _subtitleFormatting, 10],
        [_additional,  _additionalFormatting, 10],
        [[dayTime, "HH:MM"] call BIS_fnc_timeToString, _timeFormatting, 30]
    ],
    0.5, 1
] spawn BIS_fnc_typeText;