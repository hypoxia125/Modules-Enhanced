/*
    For use with ModuleChangeFlag

    Author: Hypoxic
    Public: No
*/

#include "script_component.hpp"

params ["_originalFlag", "_flagToReplace", "_customTexture"];

private _filePath = "";
if (_flagToReplace == "") then {
    // custom flag texture
    _filePath = _customTexture;
} else {
    private _textureString = getText (configFile >> "CfgVehicles" >> _flagToReplace >> "EventHandlers" >> "init");
    private _parts = _textureString splitString "'";
    _filePath = _parts#1;
};

_originalFlag setFlagTexture _filePath;