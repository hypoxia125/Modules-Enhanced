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
if (!is3DEN && {!_isActivated}) exitWith {};
if (_mode isEqualTo "dragged3DEN") exitWith {};

// Variables
//------------------------------------------------------------------------------------------------
private _pos = ASLToAGL (getPosASL _module);
private _vector = [vectorDir _module, vectorUp _module];

private _useLightpoint = _module getVariable "UseLightpoint";
private _lightpointColorRed = _module getVariable "LightpointColorRed";
private _lightpointColorGreen = _module getVariable "LightpointColorGreen";
private _lightpointColorBlue = _module getVariable "LightpointColorBlue";
private _lightpointAmbientColorRed = _module getVariable "LightpointAmbientColorRed";
private _lightpointAmbientColorGreen = _module getVariable "LightpointAmbientColorGreen";
private _lightpointAmbientColorBlue = _module getVariable "LightpointAmbientColorBlue";
private _lightpointIntensity = _module getVariable ["LightpointIntensity", 500];
private _showDaytime = _module getVariable "ShowDaytime";
private _useFlare = _module getVariable "UseFlare";
private _flareSize = _module getVariable ["FlareSize", 0.5];
private _flareMaxDistance = _module getVariable ["FlareMaxDistance", 250];

private _useLightcone = _module getVariable "UseLightcone";
private _lightconeColorRed = _module getVariable "LightconeColorRed";
private _lightconeColorGreen = _module getVariable "LightconeColorGreen";
private _lightconeColorBlue = _module getVariable "LightconeColorBlue";
private _lightconeAmbientColorRed = _module getVariable "LightconeAmbientColorRed";
private _lightconeAmbientColorGreen = _module getVariable "LightconeAmbientColorGreen";
private _lightconeAmbientColorBlue = _module getVariable "LightconeAmbientColorBlue";
private _lightconeIntensity = _module getVariable ["LightconeIntensity", 1000];

private _lightconeOuter = _module getVariable "LightconeOuter";
private _lightconeInner = _module getVariable "LightconeInner";
private _lightconeFade = _module getVariable ["LightconeFade", 1];

private _argsLightpoint =   [_pos, _lightpointColorRed, _lightpointColorGreen, _lightpointColorBlue,
                            _lightpointAmbientColorRed, _lightpointAmbientColorGreen, _lightpointAmbientColorBlue,
                            _lightpointIntensity, _showDaytime, _useFlare, _flareSize, _flareMaxDistance];

private _argsLightcone =    [_pos, _vector, _lightconeColorRed, _lightconeColorGreen, _lightconeColorBlue,
                            _lightconeAmbientColorRed, _lightconeAmbientColorGreen, _lightconeAmbientColorBlue,
                            _lightconeIntensity, _lightconeOuter, _lightconeInner, _lightconeFade];

#ifdef DEBUG_MODE_FULL
{
    LOG_2("Lightpoint Arg:: %2: %1",_x,_forEachIndex)
} forEach _argsLightpoint;

{
    LOG_2("Lightcone Arg:: %2: %1",_x,_forEachIndex)
} forEach _argsLightcone;
#endif

// Functions
//------------------------------------------------------------------------------------------------
private _createLightpoint = {
    params ["_pos", "_lightpointColorRed", "_lightpointColorGreen", "_lightpointColorBlue",
            "_lightpointAmbientColorRed", "_lightpointAmbientColorGreen", "_lightpointAmbientColorBlue",
            "_lightpointIntensity", "_showDaytime", "_useFlare", "_flareSize", "_flareMaxDistance"];

    private _lightpoint = "#lightpoint" createVehicleLocal _pos;
    _lightpoint setLightColor [_lightpointColorRed, _lightpointColorGreen, _lightpointColorBlue];
    _lightpoint setLightAmbient [_lightpointAmbientColorRed, _lightpointAmbientColorGreen, _lightpointAmbientColorBlue];
    _lightpoint setLightIntensity _lightpointIntensity;
    _lightpoint setLightDayLight _showDaytime;
    _lightpoint setLightUseFlare _useFlare;
    _lightpoint setLightFlareSize _flareSize;
    _lightpoint setLightFlareMaxDistance _flareMaxDistance;

    _lightpoint;
};

private _createLightcone = {
    params ["_pos", "_vector", "_lightconeColorRed", "_lightconeColorGreen", "_lightconeColorBlue",
            "_lightconeAmbientColorRed", "_lightconeAmbientColorGreen", "_lightconeAmbientColorBlue",
            "_lightconeIntensity", "_lightconeOuter", "_lightconeInner", "_lightconeFade"];

    private _lightcone = "#lightreflector" createVehicleLocal _pos;
    _lightcone setLightColor [_lightconeColorRed, _lightconeColorGreen, _lightconeColorBlue];
    _lightcone setLightAmbient [_lightconeAmbientColorRed, _lightconeAmbientColorGreen, _lightconeAmbientColorBlue];
    _lightcone setLightIntensity _lightconeIntensity;
    _lightcone setLightConePars [_lightconeOuter, _lightconeInner, _lightconeFade];

    _lightcone setVectorDirAndUp _vector;

    _lightcone;
};

// Code Start
//------------------------------------------------------------------------------------------------
switch _mode do {
    case "init": {
        if (is3DEN) exitWith {};

        // Create lightpoint
        private _lightpoint = objNull;
        if (_useLightpoint) then {
            _lightpoint = _argsLightpoint call _createLightpoint;
            _module setVariable [QGVAR(moduleEffectLightpoint_Lightpoint), _lightpoint];
        };

        // Create lightcone
        private _lightcone = objNull;
        if (_useLightcone) then {
            _lightcone = _argsLightcone call _createLightcone;
            _module setVariable [QGVAR(moduleEffectLightpoint_lightcone), _lightcone];
        };

        // Destruction
        if (!is3DEN) then {
            [{
                params ["_args", "_handle"];
                _args params ["_module", "_lightpoint", "_lightcone"];

                if (isNull _module) then {
                    deleteVehicle _lightpoint;
                    _handle call CBA_fnc_removePerFrameHandler;
                };
            }, 0, [_module, _lightpoint, _lightcone]] call CBA_fnc_addPerFrameHandler;
        };
    };

    case "registeredToWorld3DEN": {
        // Create lightpoint
        private _lightpoint = objNull;
        if (_useLightpoint) then {
            _lightpoint = _argsLightpoint call _createLightpoint;
            _module setVariable [QGVAR(moduleEffectLightpoint_Lightpoint), _lightpoint];
        };

        // Create lightcone
        private _lightcone = objNull;
        if (_useLightcone) then {
            _lightcone = _argsLightcone call _createLightcone;
            _module setVariable [QGVAR(moduleEffectLightpoint_lightcone), _lightcone];
        };
    };

    case "attributesChanged3DEN": {
        private _lightpoint = _module getVariable [QGVAR(moduleEffectLightpoint_Lightpoint), objNull];
        private _lightcone = _module getVariable [QGVAR(moduleEffectLightpoint_Lightcone), objNull];

        [_lightpoint, _lightcone] apply {deleteVehicle _x};

        // Create lightpoint
        private _lightpoint = objNull;
        if (_useLightpoint) then {
            _lightpoint = _argsLightpoint call _createLightpoint;
            _module setVariable [QGVAR(moduleEffectLightpoint_Lightpoint), _lightpoint];
        };

        // Create lightcone
        private _lightcone = objNull;
        if (_useLightcone) then {
            _lightcone = _argsLightcone call _createLightcone;
            _module setVariable [QGVAR(moduleEffectLightpoint_lightcone), _lightcone];
        };
    };

    case "unregisteredFromWorld3DEN": {
        private _lightpoint = _module getVariable [QGVAR(moduleEffectLightpoint_Lightpoint), objNull];
        private _lightcone = _module getVariable [QGVAR(moduleEffectLightpoint_Lightcone), objNull];

        [_lightpoint, _lightcone] apply {deleteVehicle _x};
    };
};
