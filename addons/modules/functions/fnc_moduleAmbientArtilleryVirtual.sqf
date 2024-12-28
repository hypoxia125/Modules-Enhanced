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
if (!isServer) exitWith {};
if !(_mode in ["init"]) exitWith {};

// Variables
//------------------------------------------------------------------------------------------------
private _area = _module getVariable [QUOTE(ObjectArea), [100, 100, 0, false, -1]];
private _shell = _module getVariable [QUOTE(Shell), "Sh_82mm_AMOS"];
private _salvoSize = _module getVariable [QUOTE(SalvoSize), 6];
private _salvoInterval = _module getVariable [QUOTE(SalvoInterval), 10];
private _salvoTimeVariation = _module getVariable [QUOTE(SalvoTimeVariation), 5];
private _shotInterval = _module getVariable [QUOTE(ShotInterval), 1];
private _shotTimeVariation = _module getVariable [QUOTE(ShotTimeVariation), 1];

if (isNull _module) then {
    _module = createVehicle ["Land_HelipadEmpty_F", _module];
};
_area = [getPosATL _module] + _area;

if (!isClass (configFile >> "CfgAmmo" >> _shell)) exitWith {[typeOf _module] call EFUNC(Error,invalidArgs)};
if ([_salvoSize, _salvoInterval, _salvoTimeVariation, _shotInterval, _shotTimeVariation] findIf {_x < 0} != -1) exitWith {[typeOf _module] call EFUNC(Error,invalidArgs)};

// Functions
//------------------------------------------------------------------------------------------------
private _startArtillery = {
    params ["_module", "_area", "_shell", "_salvoSize", "_salvoInterval", "_salvoTimeVariation", "_shotInterval", "_shotTimeVariation"];

    private _handle = [{
        params ["_args", "_handle"];
        _args params ["_module", "_area", "_shell", "_salvoSize", "_salvoInterval", "_salvoTimeVariation", "_shotInterval", "_shotTimeVariation"];

        // Exit code if module is dead or currently firing
        if (!alive _module) exitWith {_handle call CBA_fnc_removePerFrameHandler};
        private _isFiring = _module getVariable [QGVAR(ambientArtillery_firing), false];
        if (_isFiring) exitWith {};

        // Salvos firing
        _module setVariable [QGVAR(ambientArtillery_firing), true];

        for "_i" from 1 to _salvoSize do {
            private _pos = [[_area]] call BIS_fnc_randomPos;
            _pos set [2, 1000];

            private _shotDelay = _shotInterval + (random [0, _shotTimeVariation / 2, _shotTimeVariation]);

            [{
                params ["_module", "_shell", "_salvoSize", "_salvoInterval", "_salvoTimeVariation", "_pos", "_index"];

                private _round = createVehicle [_shell, _pos];
                _round setVelocity [0, 0, -1000];

                // Exit after last shot in salvo
                private _lastRound = _index == _salvoSize;
                if (_lastRound) then {
                    private _salvoDelay = _salvoInterval + (random [0, _salvoTimeVariation / 2, _salvoTimeVariation]);

                    // Set module to not firing to trigger the next salvo
                    [{
                        params ["_module"];

                        _module setVariable [QGVAR(ambientArtillery_firing), false];

                    }, [_module], _salvoDelay] call CBA_fnc_waitAndExecute;
                };
            }, [_module, _shell, _salvoSize, _salvoInterval, _salvoTimeVariation, _pos, _i], _shotDelay * _i] call CBA_fnc_waitAndExecute;
        };
    }, 0.5, [_module, _area, _shell, _salvoSize, _salvoInterval, _salvoTimeVariation, _shotInterval, _shotTimeVariation]] call CBA_fnc_addPerFrameHandler;

    // return
    _handle
};

private _stopArtillery = {
    params ["_module"];

    private _handle = _module getVariable [QGVAR(ambientArtilleryVirtual_PFHandler), -1];
    _handle call CBA_fnc_removePerFrameHandler;
};

// Code Start
//------------------------------------------------------------------------------------------------
switch _mode do {
    case "init": {
        if (is3DEN) exitWith {};

        if (_isActivated) then {
            private _handle = [
                _module, _area, _shell, _salvoSize, _salvoInterval,
                _salvoTimeVariation, _shotInterval, _shotTimeVariation
            ] call _startArtillery;

            _module setVariable [QGVAR(ambientArtilleryVirtual_Handle), _handle];
        } else {
            [_module] call _stopArtillery;
        };
    };

    default {};
};
