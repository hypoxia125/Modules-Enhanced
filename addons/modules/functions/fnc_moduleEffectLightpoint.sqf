#include "script_component.hpp"

params [
    ["_mode", "", [""]],
    ["_input", [], [[]]]
];
_input params [
    ["_module", objNull, [objNull]],
    ["_isActivated", false, [true]],
    ["_isCuratorPlaced", false, [true]]
];

if (!is3DEN && {!_isActivated}) exitWith {};
if (_mode isEqualTo "dragged3DEN") exitWith {};

// Variables
private _pos = ASLToAGL (getPosASL _module);
private _vector = [vectorDir _module, vectorUp _module];
private _useLightpoint = _module getVariable [QUOTE(UseLightpoint), true];
private _lightpointColor = call compile (_module getVariable [QUOTE(LightpointColor), "[1,1,1]"]);
private _lightpointAmbientColor = call compile (_module getVariable [QUOTE(LightpointAmbientColor), "[1,1,1]"]);
private _lightpointIntensity = _module getVariable [QUOTE(LightpointIntensity), 500];
private _showDaytime = _module getVariable [QUOTE(ShowDaytime), true];
private _useFlare = _module getVariable [QUOTE(UseFlare), true];
private _flareSize = _module getVariable [QUOTE(FlareSize), 0.5];
private _flareMaxDistance = _module getVariable [QUOTE(FlareMaxDistance), 250];
private _useLightcone = _module getVariable [QUOTE(UseLightcone), false];
private _lightconeColor = call compile (_module getVariable [QUOTE(LightconeColor), "[1,1,1]"]);
private _lightconeAmbientColor = call compile (_module getVariable [QUOTE(LightconeAmbientColor), "[1,1,1]"]);
private _lightconeIntensity = _module getVariable [QUOTE(LightconeIntensity), 1000];
private _lightconePars = call compile (_module getVariable [QUOTE(LightconePars), "[120,30,1]"]);

private _argsLightpoint = [_pos, _lightpointColor, _lightpointAmbientColor, _lightpointIntensity, _showDaytime, _useFlare, _flareSize, _flareMaxDistance];
private _argsLightcone = [_pos, _vector, _lightconeColor, _lightconeAmbientColor, _lightconeIntensity, _lightconePars];

// Verify variables
if ([_lightpointColor, _lightpointAmbientColor, _lightconeColor, _lightconeAmbientColor, _lightconePars] findIf {isNil {_x} || {!(_x isEqualType [])}} != -1) then {[typeOf _module] call EFUNC(Error,invalidArgs)};
if ([_lightpointColor, _lightpointAmbientColor, _lightconeColor, _lightconeAmbientColor, _lightconePars] findIf {!(_x isEqualTypeAll -1)} != -1) then {[typeOf _module] call EFUNC(Error,invalidArgs)};
if ([_lightpointIntensity, _flareSize, _flareMaxDistance, _lightconeIntensity] findIf {_x < 0} != -1) then {[typeOf _module] call EFUNC(Error,invalidArgs)};

// Functions
private _createLightpoint = {
    params ["_pos", "_color", "_ambientColor", "_intensity", "_showDaytime", "_useFlare", "_flareSize", "_flareMaxDistance"];

    private _lightpoint = "#lightpoint" createVehicle _pos;
    _lightpoint setLightColor _color;
    _lightpoint setLightAmbient _ambientColor;
    _lightpoint setLightIntensity _intensity;
    _lightpoint setLightUseFlare _useFlare;
    _lightpoint setLightFlareSize _flareSize;
    _lightpoint setLightFlareMaxDistance _flareMaxDistance;

    _lightpoint;
};

private _createLightcone = {
    params ["_pos", "_vector", "_color", "_ambientColor", "_intensity", "_pars"];

    private _lightcone = "#lightreflector" createVehicleLocal _pos;
    _lightcone setLightColor _color;
    _lightcone setLightAmbient _ambientColor;
    _lightcone setLightIntensity _intensity;
    _lightcone setLightConePars _pars;

    _lightcone setVectorDirAndUp _vector;

    _lightcone;
};

switch _mode do {
    case "init": {
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
