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
if !(_mode in ["init", "registeredToWorld3DEN", "attributesChanged3DEN", "unregisteredFromWorld3DEN"]) exitWith {};

// Variables
//------------------------------------------------------------------------------------------------
private _pos = ASLToAGL (getPosASL _module);
private _colorRed = _module getVariable "ColorRed";
private _colorGreen = _module getVariable "ColorGreen";
private _colorBlue = _module getVariable "ColorBlue";
private _fireDamage = _module getVariable ["FireDamage", 1];
private _effectSize = _module getVariable ["EffectSize", 1];
private _particleDensity = _module getVariable ["ParticleDensity", 25];
private _particleTime = _module getVariable ["ParticleTime", 0.6];
private _particleSize = _module getVariable ["ParticleSize", 1];
private _particleSpeed = _module getVariable ["ParticleSpeed", 1];
private _particleOrientation = _module getVariable ["ParticleOrientation", 0];

if ([_fireDamage, _effectSize, _particleDensity, _particleTime, _particleSpeed] findIf {_x < 0} != -1) then {[typeOf _module] call EFUNC(Error,invalidArgs)};

private _args = [_module, _pos, _colorRed, _colorGreen, _colorBlue, _fireDamage, _effectSize, _particleDensity, _particleTime, _particleSize, _particleSpeed, _particleOrientation];

LOG("Listing Variables For Fire Effect");
{
    LOG_2("Arg %1: %2",_forEachIndex,_x);
} forEach _args;

// Functions
//------------------------------------------------------------------------------------------------
private _createFire = {
    params [
        "_module", "_pos", "_colorRed", "_colorGreen", "_colorBlue",
        "_fireDamage", "_effectSize", "_particleDensity", "_particleTime", "_particleSize",
        "_particleSpeed", "_particleOrientation"
    ];

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
};

// Code Start
//------------------------------------------------------------------------------------------------
switch _mode do {
    case "init": {
        if (is3DEN) exitWith {};

        private _emitter = _module getVariable [QGVAR(moduleEffectFire_Emitter), objNull];
        private _light = _module getVariable [QGVAR(moduleEffectFire_Light), objNull];

        [_emitter, _light] apply {deleteVehicle _x};

        (_args call _createFire) params ["_emitter", "_light"];
        _module setVariable [QGVAR(moduleEffectFire_Emitter), _emitter];
        _module setVariable [QGVAR(moduleEffectFire_Light), _light];

        // delete ingame when module is deleted
        [{
            params ["_args", "_handle"];
            _args params ["_module", "_emitter", "_light"];

            if (isNull _module) then {
                [_emitter, _light] apply {deleteVehicle _x};
                _handle call CBA_fnc_removePerFrameHandler;
            };
        }, 1, [_module, _emitter, _light]] call CBA_fnc_addPerFrameHandler;
    };

    case "registeredToWorld3DEN": {
        private _emitter = _module getVariable [QGVAR(moduleEffectFire_Emitter), objNull];
        private _light = _module getVariable [QGVAR(moduleEffectFire_Light), objNull];

        [_emitter, _light] apply {deleteVehicle _x};

        (_args call _createFire) params ["_emitter", "_light"];
        _module setVariable [QGVAR(moduleEffectFire_Emitter), _emitter];
        _module setVariable [QGVAR(moduleEffectFire_Light), _light];
    };

    case "attributesChanged3DEN": {
        private _emitter = _module getVariable [QGVAR(moduleEffectFire_Emitter), objNull];
        private _light = _module getVariable [QGVAR(moduleEffectFire_Light), objNull];

        [_emitter, _light] apply {deleteVehicle _x};

        (_args call _createFire) params ["_emitter", "_light"];
        _module setVariable [QGVAR(moduleEffectFire_Emitter), _emitter];
        _module setVariable [QGVAR(moduleEffectFire_Light), _light];
    };

    case "unregisteredFromWorld3DEN": {
        private _emitter = _module getVariable [QGVAR(moduleEffectFire_Emitter), objNull];
        private _light = _module getVariable [QGVAR(moduleEffectFire_Light), objNull];

        [_emitter, _light] apply {deleteVehicle _x};
    };

    default {};
};
