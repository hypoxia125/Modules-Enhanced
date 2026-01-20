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

// Helper Functions
//------------------------------------------------------------------------------------------------
private _getFont = {
    params ["_value"];

    private _font = switch (_value) do {
        case 0: { "EtelkaMonospacePro" };
        case 1: { "EtelkaMonospaceProBold" };
        case 2: { "EtelkaNarrowMediumPro" };
        case 3: { "LucidaConsoleB" };
        case 4: { "PuristaBold" };
        case 5: { "PuristaLight" };
        case 6: { "PuristaMedium" };
        case 7: { "PuristaSemibold" };
        case 8: { "RobotoCondensed" };
        case 9: { "RobotoCondensedBold" };
        case 10: { "RobotoCondensedLight" };
        case 11: { "TahomaB" };
        default { "PuristaMedium" };
    };

    _font;
};

private _getColor = {
    params ["_value"];

    private _color = switch (_value) do {
        case 0: { "#FFFFFF" };
        case 1: { "#000000" };
        case 2: { "#0000FF" };
        case 3: { "#00CC00" };
        case 4: { "#D9D900" };
        case 5: { "#D96600" };
        case 6: { "#E60000" };
        case 7: { "#B040A7" };
        case 8: { "#004C99" };
        case 9: { "#800000" };
        case 10: { "#008000" };
        case 11: { "#660080" };
        case 12: { "#B29900" };
        default { "#FFFFFF" };
    };

    _color;
};

// Variables
//------------------------------------------------------------------------------------------------
private _title = _module getVariable ["Title", ""];
private _titleFont = [_module getVariable "TitleFont"] call _getFont;
private _titleColor = [_module getVariable "TitleFontColor"] call _getColor;
private _titleSize = _module getVariable ["TitleFontSize", 1];

private _subtitle = _module getVariable ["SubTitle", ""];
private _subtitleFont = [_module getVariable "SubtitleFont"] call _getFont;
private _subtitleColor = [_module getVariable "SubtitleFontColor"] call _getColor;
private _subtitleSize = _module getVariable ["SubtitleFontSize", 1];

private _additional = _module getVariable ["Additional", ""];
private _additionalFont = [_module getVariable "AdditionalFont"] call _getFont;
private _additionalColor = [_module getVariable "AdditionalFontColor"] call _getColor;
private _additionalSize = _module getVariable ["AdditionalFontSize", 1];

// Code Start
//------------------------------------------------------------------------------------------------
if (!_isActivated) exitWith {};
if (is3DEN) exitWith {};

private _titleFormatting = format ["<t align='right' shadow='1' size='%1' font='%2' color='%3'>%4</t><br/>", _titleSize, _titleFont, _titleColor, "%1"];
private _subtitleFormatting = format ["<t align='right' shadow='1' size='%1' font='%2' color='%3'>%4</t><br/>", _subtitleSize, _subtitleFont, _subtitleColor, "%1"];
private _additionalFormatting = format ["<t align='right' shadow='1' size='%1' font='%2' color='%3'>%4</t><br/>", _additionalSize, _additionalFont, _additionalColor, "%1"];
private _timeFormatting = format ["<t align='right' shadow='1' size='%1' font='%2' color='%3'>%4</t><br/>", 0.7, "PuristaMedium", "#FFFFFF", "%1"];

[
    [
        [_title,  _titleFormatting, 10],
        [_subtitle,  _subtitleFormatting, 10],
        [_additional,  _additionalFormatting, 10],
        [[dayTime, "HH:MM"] call BIS_fnc_timeToString, _timeFormatting, 30]
    ],
    0.5, 1
] spawn BIS_fnc_typeText;
