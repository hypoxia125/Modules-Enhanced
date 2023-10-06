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

// Variables
private _pos = ASLToAGL (getPosASL _module);
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

private _particleParams = [
    ["\A3\data_f\ParticleEffects\Universal\Universal_02",8,0,40,1],
    "",
    "billboard",
    1,
    _particleTime,
    [0,0,0],
    [0,0,2*_particleSpeed],
    0,
    0.05,
    0.04*_particleLifting,
    0.05*_windEffect,
    [1 *_particleSize + 1,1.8 * _particleSize + 15],
    [
        [0.7*_colorRed,0.7*_colorGreen,0.7*_colorBlue,0.7*_colorAlpha],[0.7*_colorRed,0.7*_colorGreen,0.7*_colorBlue,0.6*_colorAlpha],[0.7*_colorRed,0.7*_colorGreen,0.7*_colorBlue,0.45*_colorAlpha],
        [0.84*_colorRed,0.84*_colorGreen,0.84*_colorBlue,0.28*_colorAlpha],[0.84*_colorRed,0.84*_colorGreen,0.84*_colorBlue,0.16*_colorAlpha],[0.84*_colorRed,0.84*_colorGreen,0.84*_colorBlue,0.09*_colorAlpha],
        [0.84*_colorRed,0.84*_colorGreen,0.84*_colorBlue,0.06*_colorAlpha],[1*_colorRed,1*_colorGreen,1*_colorBlue,0.02*_colorAlpha],[1*_colorRed,1*_colorGreen,1*_colorBlue,0*_colorAlpha]
    ],
    [1,0.55,0.35],
    0.1,
    0.08*_effectExpansion,
    "",
    "",
    ""
];
private _particleRandom = [
    _particleTime/2,
    [0.5*_effectSize,0.5*_effectSize,0.2*_effectSize],
    [0.3,0.3,0.5],
    1,
    0,
    [0,0,0,0.06],
    0,
    0
];

// Execute
if (!is3DEN && {!_isActivated}) exitWith {};

switch _mode do {
    case "init": {
        // Create emitter
        private _emitter = "#particlesource" createVehicleLocal _pos;

        // smoke
        _emitter setParticleParams _particleParams;
        _emitter setParticleRandom _particleRandom;
        _emitter setDropInterval (1 / _particleDensity);

        _module setVariable [QGVAR(moduleEffectFire_Emitter), _emitter];

        // destruction
        if (!is3DEN) then {
            [{
                params ["_args", "_handle"];
                _args params ["_module", "_emitter"];

                if (isNull _module) then {
                    deleteVehicle _emitter;
                    _handle call CBA_fnc_removePerFrameHandler;
                };
            }, 1, [_module, _emitter]] call CBA_fnc_addPerFrameHandler;
        };
    };

    case "attributesChanged3DEN": {
        private _emitter = _module getVariable [QGVAR(moduleEffectFire_Emitter), objNull];
        deleteVehicle _emitter;

        // Create emitter
        private _emitter = "#particlesource" createVehicleLocal _pos;

        // smoke
        _emitter setParticleParams _particleParams;
        _emitter setParticleRandom _particleRandom;
        _emitter setDropInterval (1 / _particleDensity);

        _module setVariable [QGVAR(moduleEffectFire_Emitter), _emitter];
    };

    case "dragged3DEN": {
        private _emitter = _module getVariable [QGVAR(moduleEffectFire_Emitter), objNull];
        deleteVehicle _emitter;

        // Create emitter
        private _emitter = "#particlesource" createVehicleLocal _pos;

        // smoke
        _emitter setParticleParams _particleParams;
        _emitter setParticleRandom _particleRandom;
        _emitter setDropInterval (1 / _particleDensity);

        _module setVariable [QGVAR(moduleEffectFire_Emitter), _emitter];
    };

    case "unregisteredFromWorld3DEN": {
        private _emitter = _module getVariable [QGVAR(moduleEffectFire_Emitter), objNull];
        deleteVehicle _emitter;
    };
};