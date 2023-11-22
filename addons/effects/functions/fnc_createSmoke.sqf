#include "script_component.hpp"

params ["_module", "_pos", "_colorRed", "_colorBlue", "_colorAlpha", "_effectSize", "_particleDensity", "_particleTime", "_particleSize", "_effectExpansion", "_particleSpeed", "_particleLifting", "_windEffect"];

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

// Create emitter
private _emitter = "#particlesource" createVehicleLocal _pos;

// smoke
_emitter setParticleParams _particleParams;
_emitter setParticleRandom _particleRandom;
_emitter setDropInterval (1 / _particleDensity);

_emitter;
