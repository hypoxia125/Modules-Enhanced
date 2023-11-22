/*
    Author: Hypoxic
    Creates ambient artillery fire at the given location, either position [x,y,z] or object position (typically module). Can be disabled by deleting
    the object, or by removing the per frame handler directing using the return.

    Arguments:
    0: Module, Object, or Position - OBJECT or POSITION
    1: Area of Effect - ARRAY in format [a, b, angle, isRectangle, z]
    2: Shell Classname - STRING
    3: Salvo Size - NUMBER
    4: Salvo Interval - NUMBER
    5: Salvo Time Variation - NUMBER
    6: Shot Interval - NUMBER
    7: Shot Time Variation - NUMBER

    ReturnValue:
    0: Handle - CBA_fnc_addPerFrameHandler Handle - NUMBER

    Example:
    [myModule, [50, 25, 180, false, -1], "Sh_82mm_AMOS", 12, 3, 3, 0.5, 1] call MEH_Modules_fnc_ambientArtilleryVirtual;

    Public: Yes
*/

#include "script_component.hpp"

params [
    ["_module", objNull, [objNull, []]],
    ["_area", [100, 100, 0, false, -1], [[]], 5],
    ["_shell", "Sh_82mm_AMOS", [""]],
    ["_salvoSize", 6, [-1]],
    ["_salvoInterval", 10, [-1]],
    ["_salvoTimeVariation", 5, [-1]],
    ["_shotInterval", 1, [-1]],
    ["_shotTimeVariation", 1, [-1]]
];

// Verify variables
if (_module isEqualType []) then {
    _module = createVehicle ["Land_HelipadEmpty_F", _module];
};
_area = [getPosATL _module] + _area;

if (
    (!isClass (configFile >> "CfgAmmo" >> _shell)) ||
    _salvoSize <= 0 ||
    _salvoInterval < 0 ||
    _salvoTimeVariation < 0 ||
    _shotInterval < 0 ||
    _shotTimeVariation < 0
) exitWith {};

// Execute
private _arguments = [_module, _area, _shell, _salvoSize, _salvoInterval, _salvoTimeVariation, _shotInterval, _shotTimeVariation];

_module setVariable [QGVAR(ambientArtillery_firing), false];

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
}, 0.5, _arguments] call CBA_fnc_addPerFrameHandler;

// Return
_handle
