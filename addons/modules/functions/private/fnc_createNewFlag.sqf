/*
    For use with ModuleChangeFlag

    Author: Hypoxic
    Public: No
*/

#include "script_component.hpp"

params ["_originalFlag", "_flagToReplace", "_customTexture", "_retainVarName"];

private _pos = getPosASL _originalFlag;
private _dirAndUp = [vectorDir _originalFlag, vectorUp _originalFlag];
private _varName = vehicleVarName _originalFlag;

deleteVehicle _originalFlag;

private _newFlag = objNull;
if (_flagToReplace == "") then {
    // custom flag texture setup - use default white pole
    _flagToReplace = "flag_White_F";
    _newFlag = createVehicle [_flagToReplace, [0,0,0], [], 0, "CAN_COLLIDE"];
    _newFlag setPosASL _pos;
    _newFlag setVectorDirAndUp _dirAndUp;
    _newFlag setFlagTexture _customTexture;
} else {
    _newFlag = createVehicle [_flagToReplace, [0,0,0], [], 0, "CAN_COLLIDE"];
    _newFlag setPosASL _pos;
    _newFlag setVectorDirAndUp _dirAndUp;
};

if (_retainVarName) then {
    _newFlag setVehicleVarName _varName;
    missionNamespace setVariable [_varName, _newFlag, true];
};