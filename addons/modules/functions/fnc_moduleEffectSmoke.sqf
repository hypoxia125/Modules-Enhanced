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
private _class = _module getVariable [QUOTE(Class), 0];
private _colorRed = _module getVariable [QUOTE(ColorRed), 0.5];
private _colorGreen = _module getVariable [QUOTE(ColorGreen), 0.5];
private _colorBlue = _module getVariable [QUOTE(ColorBlue), 0.5];
private _colorAlpha = _module getVariable [QUOTE(ColorAlpha), 0.5];
private _effectSize = _module getVariable [QUOTE(EffectSize), 1];
private _particleDensity = _module getVariable [QUOTE(ParticleDensity), 25];
private _particleTime = _module getVariable [QUOTE(ParticleTime), 0.6];
private _particleSize = _module getVariable [QUOTE(ParticleSize), 1];
private _effectExpansion = _module getVariable [QUOTE(EffectExpansion), 1];
private _particleSpeed = _module getVariable [QUOTE(ParticleSpeed), 1];
private _particleLifting = _module getVariable [QUOTE(ParticleLifting), 1];
private _windEffect = _module getVariable [QUOTE(WindEffect), 1];

// Verify variables
if (_colorRed > 1) then {_colorRed = 1};
if (_colorRed < 0) then {_colorRed = 0};
if (_colorGreen > 1) then {_colorGreen = 1};
if (_colorGreen < 0) then {_colorGreen = 0};
if (_colorBlue > 1) then {_colorBlue = 1};
if (_colorBlue < 0) then {_colorBlue = 0};
if (_colorAlpha > 1) then {_colorAlpha = 1};
if (_colorAlpha < 0) then {_colorAlpha = 0};
if ([_effectSize, _particleDensity, _particleTime, _particleSize, _effectExpansion, _particleSpeed, _particleLifting, _windEffect] findIf {_x < 0} != -1) then {[typeOf _module] call EFUNC(Error,invalidArgs)};

private _args = [_module, _pos, _colorRed, _colorBlue, _colorAlpha, _effectSize, _particleDensity, _particleTime, _particleSize, _effectExpansion, _particleSpeed, _particleLifting, _windEffect, _class];

// Execute
switch _mode do {
    case "init": {
        if (is3DEN) exitWith {};

        private _emitter = _module getVariable [QGVAR(moduleEffectFire_Emitter), objNull];
        deleteVehicle _emitter;

        private _emitter = _args call EFUNC(Effects,createSmoke);
        _module setVariable [QGVAR(moduleEffectFire_Emitter), _emitter];

        [{
            params ["_args", "_handle"];
            _args params ["_module", "_emitter"];

            if (isNull _module) then {
                deleteVehicle _emitter;
                _handle call CBA_fnc_removePerFrameHandler;
            };
        }, 1, [_module, _emitter]] call CBA_fnc_addPerFrameHandler;
    };

    case "registeredToWorld3DEN": {
        private _emitter = _module getVariable [QGVAR(moduleEffectFire_Emitter), objNull];
        deleteVehicle _emitter;

        private _emitter = _args call EFUNC(Effects,createSmoke);
        _module setVariable [QGVAR(moduleEffectFire_Emitter), _emitter];
    };

    case "attributesChanged3DEN": {
        private _emitter = _module getVariable [QGVAR(moduleEffectFire_Emitter), objNull];
        deleteVehicle _emitter;

        private _emitter = _args call EFUNC(Effects,createSmoke);
        _module setVariable [QGVAR(moduleEffectFire_Emitter), _emitter];
    };

    case "unregisteredFromWorld3DEN": {
        private _emitter = _module getVariable [QGVAR(moduleEffectFire_Emitter), objNull];
        deleteVehicle _emitter;
    };

    default {};
};
