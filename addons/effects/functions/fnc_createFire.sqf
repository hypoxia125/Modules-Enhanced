#include "script_component.hpp"

params ["_module", "_pos", "_colorRed", "_colorGreen", "_colorBlue", "_fireDamage", "_effectSize", "_particleDensity", "_particleTime", "_particleSize", "_particleSpeed", "_particleOrientation"];

private _particleParams = [
    ["\A3\data_f\ParticleEffects\Universal\Universal",16,10,32],
    "",
    "billboard",
    1,
    _particleTime,
    [0,0,0],
    [0,0,0.4*_particleSpeed],
    0,
    0.0565,
    0.05,
    0.03,
    [_particleSize,0],
    [
        [1*_colorRed,1*_colorGreen,1*_colorBlue,-0],
        [1*_colorRed,1*_colorGreen,1*_colorBlue,-1],
        [1*_colorRed,1*_colorGreen,1*_colorBlue,-1],
        [1*_colorRed,1*_colorGreen,1*_colorBlue,-1],
        [1*_colorRed,1*_colorGreen,1*_colorBlue,-1],
        [1*_colorRed,1*_colorGreen,1*_colorBlue,0]
    ],
    [1],
    0.01,
    0.02,
    "",
    "",
    "",
    _particleOrientation,
    false,
    -1,
    [[3,3,3,0]]
];
private _particleRandom = [
    _particleTime / 4,
    [0.15*_effectSize,0.15 *_effectSize,0],
    [0.2,0.2,0],
    0.4,
    0,
    [0,0,0,0],
    0,
    0,
    0.2
];

// Create
private _emitter = "#particlesource" createVehicleLocal _pos;

// fire
_emitter setParticleParams _particleParams;
_emitter setParticleRandom _particleRandom;
_emitter setDropInterval (1 / _particleDensity);
if (!is3DEN && {_fireDamage > 0}) then {_emitter setParticleFire [0.6*_fireDamage, 0.25*_fireDamage, 0.1]};

// light
private _lightSize = (_particleSize + _effectSize) / 2;
_light = "#lightpoint" createVehicleLocal _pos;
_light setPos [_pos select 0, _pos select 1, (_pos select 2) + 0.5];
_light setLightIntensity (50 + 400 * _lightSize);
_light setLightColor [1, 0.65, 0.4];
_light setLightAmbient [0.15, 0.05, 0];
_light setLightAttenuation [0, 0, 0, 1];
_light setLightDayLight false;

[_emitter, _light];
