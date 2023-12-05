#include "script_component.hpp"

params ["_module", "_pos", "_colorRed", "_colorBlue", "_colorAlpha", "_effectSize", "_particleDensity", "_particleTime", "_particleSize", "_effectExpansion", "_particleSpeed", "_particleLifting", "_windEffect", "_class"];

private ["_particleCircle", "_particleRandom", "_particleParams", "_particleDropInterval"];
switch _class do {
    default {
        // Default Arma 3 Smoke Particle
        _particleCircle = [0, [0,0,0]];
        _particleRandom = [_particleTime/2, [0.5*_effectSize,0.5*_effectSize,0.2*_effectSize], [0.3,0.3,0.5], 1, 0, [0,0,0,0.06], 0, 0];
        _particleParams = [["\A3\data_f\ParticleEffects\Universal\Universal_02",8,0,40,1], "", "billboard", 1, _particleTime, [0,0,0], [0,0,2*_particleSpeed], 0, 0.05, 0.04*_particleLifting, 0.05*_windEffect, [1 *_particleSize + 1,1.8 * _particleSize + 15], [[0.7*_colorRed,0.7*_colorGreen,0.7*_colorBlue,0.7*_colorAlpha],[0.7*_colorRed,0.7*_colorGreen,0.7*_colorBlue,0.6*_colorAlpha],[0.7*_colorRed,0.7*_colorGreen,0.7*_colorBlue,0.45*_colorAlpha], [0.84*_colorRed,0.84*_colorGreen,0.84*_colorBlue,0.28*_colorAlpha],[0.84*_colorRed,0.84*_colorGreen,0.84*_colorBlue,0.16*_colorAlpha],[0.84*_colorRed,0.84*_colorGreen,0.84*_colorBlue,0.09*_colorAlpha], [0.84*_colorRed,0.84*_colorGreen,0.84*_colorBlue,0.06*_colorAlpha],[1*_colorRed,1*_colorGreen,1*_colorBlue,0.02*_colorAlpha],[1*_colorRed,1*_colorGreen,1*_colorBlue,0*_colorAlpha]], [1,0.55,0.35], 0.1, 0.08*_effectExpansion, "", "", ""];
        _particleDropInterval = 1 / _particleDensity;
    };
    case 1: {
        // Oily Smoke - Modified From Zeus Enhanced
        _particleCircle = [0, [0, 0, 0]];
        _particleRandom = [_particleTime/2, [0.25*_effectSize, 0.25*_effectSize, 0*_effectSize], [0.2, 0.2, 0], 0, 0.25, [0, 0, 0, 0.1], 0, 0];
        _particleParams = [["\A3\data_f\ParticleEffects\Universal\Universal_02", 8, 1, 8], "", "Billboard", 1, _particleTime, [0, 0, 0], [0, 0, 1.5*_particleSpeed], 0, 10, 7.9*_particleLifting, 0.066*_windEffect, [1*_particleSize, 3* _particleSize, 6], [[0.1*_colorRed, 0.1*_colorGreen, 0.1*_colorBlue, 1*_colorAlpha], [0.25*_colorRed, 0.25*_colorGreen, 0.25*_colorBlue, 0.5*_colorAlpha], [0.5*_colorRed, 0.5*_colorGreen, 0.5*_colorBlue, 0*_colorAlpha]], [0.125], 1, 0.08*_effectExpansion, "", "", ""];        
        _particleDropInterval = 1 / _particleDensity;
    };
    case 2: {
        // Med Oily Smoke - Modified From Zeus Enhanced
        _particleCircle = [0, [0, 0, 0]];
        _particleRandom = [_particleTime/2, [0.25*_effectSize, 0.25*_effectSize, 0*_effectSize], [0.2, 0.2, 0], 0, 0.25, [0, 0, 0, 0.1], 0, 0];
        _particleParams = [["\A3\data_f\ParticleEffects\Universal\Universal_02", 8, 1, 8], "", "Billboard", 1, _particleTime, [0, 0, 0], [0, 0, 2.5*_particleSpeed], 0, 10, 7.9*_particleLifting, 0.066*_windEffect, [2*_particleSize, 6* _particleSize, 12], [[0.1*_colorRed, 0.1*_colorGreen, 0.1*_colorBlue, 1*_colorAlpha], [0.25*_colorRed, 0.25*_colorGreen, 0.25*_colorBlue, 0.5*_colorAlpha], [0.5*_colorRed, 0.5*_colorGreen, 0.5*_colorBlue, 0*_colorAlpha]], [0.125], 1, 0.08*_effectExpansion, "", "", ""];
        _particleDropInterval = 1 / _particleDensity;
    };
    case 3: {
        // Large Oily Smoke - Modified From Zeus Enhanced
        _particleCircle = [0, [0, 0, 0]];
        _particleRandom = [_particleTime/2, [0.5*_effectSize, 0.5*_effectSize, 0*_effectSize], [0.2, 0.2, 0], 0, 0.25, [0, 0, 0, 0.1], 0, 0];
        _particleParams = [["\A3\data_f\ParticleEffects\Universal\Universal_02", 8, 1, 6], "", "Billboard", 1, _particleTime, [0, 0, 0], [0, 0, 4.5*_particleSpeed], 0, 10, 7.9*_particleLifting, 0.5*_windEffect, [4*_particleSize, 12* _particleSize, 20], [[0.1*_colorRed, 0.1*_colorGreen, 0.1*_colorBlue, 0.8*_colorAlpha], [0.25*_colorRed, 0.25*_colorGreen, 0.25*_colorBlue, 0.5*_colorAlpha], [0.5*_colorRed, 0.5*_colorGreen, 0.5*_colorBlue, 0*_colorAlpha]], [0.125], 1, 0.08*_effectExpansion, "", "", ""];
        _particleDropInterval = 1 / _particleDensity;
    };
    case 4: {
        // Small Wood Smoke - Modified From Zeus Enhanced
        _particleCircle = [0, [0, 0, 0]];
        _particleRandom = [_particleTime/2, [0.25*_effectSize, 0.25*_effectSize, 0*_effectSize], [0.2, 0.2, 0], 0, 0.25, [0, 0, 0, 0.1], 0, 0];
        _particleParams = [["\A3\data_f\ParticleEffects\Universal\Universal_02", 8, 3, 1], "", "Billboard", 1, _particleTime, [0, 0, 0], [0, 0, 1.5*_particleSpeed], 0, 10, 7.9*_particleLifting, 0.066*_windEffect, [1*_particleSize, 3* _particleSize, 6], [[0.5*_colorRed, 0.5*_colorGreen, 0.5*_colorBlue, 0.15*_colorAlpha], [0.75*_colorRed, 0.75*_colorGreen, 0.75*_colorBlue, 0.075*_colorAlpha], [1*_colorRed, 1*_colorGreen, 1*_colorBlue, 0*_colorAlpha]], [0.125], 1, 0.08*_effectExpansion, "", "", ""];
        _particleDropInterval = 1 / _particleDensity;
    };
    case 5: {
        // Medium Wood Smoke - Modified From Zeus Enhanced
        _particleCircle = [0, [0, 0, 0]];
        _particleRandom = [_particleTime/2, [0.25*_effectSize, 0.25*_effectSize, 0*_effectSize], [0.2, 0.2, 0], 0, 0.25, [0, 0, 0, 0.1], 0, 0];
        _particleParams = [["\A3\data_f\ParticleEffects\Universal\Universal_02", 8, 3, 1], "", "Billboard", 1, _particleTime, [0, 0, 0], [0, 0, 2.5*_particleSpeed], 0, 10, 7.9*_particleLifting, 0.066*_windEffect, [2*_particleSize, 6* _particleSize, 12], [[0.5*_colorRed, 0.5*_colorGreen, 0.5*_colorBlue, 0.3*_colorAlpha], [0.75*_colorRed, 0.75*_colorGreen, 0.75*_colorBlue, 0.15*_colorAlpha], [1*_colorRed, 1*_colorGreen, 1*_colorBlue, 0*_colorAlpha]], [0.125], 1, 0.08*_effectExpansion, "", "", ""];
        _particleDropInterval = 0.1;
    };
    case 6: {
        // Large Wood Smoke - Modified From Zeus Enhanced
        _particleCircle = [0, [0, 0, 0]];
        _particleRandom = [_particleTime/2, [0.5*_effectSize, 0.5*_effectSize, 0*_effectSize], [0.2, 0.2, 0], 0, 0.25, [0, 0, 0, 0.1], 0, 0];
        _particleParams = [["\A3\data_f\ParticleEffects\Universal\Universal_02", 8, 3, 1], "", "Billboard", 1, _particleTime, [0, 0, 0], [0, 0, 4.5*_particleSpeed], 0, 10, 7.9*_particleLifting, 0.5*_windEffect, [4*_particleSize, 12* _particleSize, 20], [[0.5*_colorRed, 0.5*_colorGreen, 0.5*_colorBlue, 0.5*_colorAlpha], [0.75*_colorRed, 0.75*_colorGreen, 0.75*_colorBlue, 0.25*_colorAlpha], [1*_colorRed, 1*_colorGreen, 1*_colorBlue, 0*_colorAlpha]], [0.125], 1, 0.08*_effectExpansion, "", "", ""];
        _particleDropInterval = 1 / _particleDensity;
    };
};

// Create emitter
private _emitter = "#particlesource" createVehicleLocal _pos;

// smoke
_emitter setParticleParams _particleParams;
_emitter setParticleRandom _particleRandom;
_emitter setDropInterval _particleDropInterval;
_emitter setParticleCircle _particleCircle;

_emitter;
