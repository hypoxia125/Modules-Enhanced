/*
    Function: meh_modules_fnc_ambientArtilleryVirtual_startArtillery
    Repeatedly fire virtual artillery salvos in an ATL area. Call on the server.
    Arguments: [area, ammoClass, salvoSize, salvoInterval, salvoVariation,
                shotInterval, shotVariation, lifetimeObject]
    area: [centerATL, radiusX, radiusY, direction, isRectangle, height].
    lifetimeObject is optional; firing stops when it is no longer alive.
    Returns: script handle (terminate to stop), or scriptNull for invalid input/not on server.
*/
#include "script_component.hpp"

params [
    ["_area", [], [[]]],
    ["_shell", "Sh_82mm_AMOS", [""]],
    ["_salvoSize", 6, [0]],
    ["_salvoInterval", 10, [0]],
    ["_salvoTimeVariation", 5, [0]],
    ["_shotInterval", 1, [0]],
    ["_shotTimeVariation", 1, [0]],
    ["_lifetimeObject", objNull, [objNull]]
];

if (!isServer || {count _area < 6} || {!((_area#0) isEqualType [])} || {count (_area#0) < 2} ||
    {!isClass (configFile >> "CfgAmmo" >> _shell)} || {_salvoSize < 1} ||
    {[_salvoInterval, _salvoTimeVariation, _shotInterval, _shotTimeVariation] findIf {_x < 0} != -1}) exitWith {scriptNull};

private _stopWithObject = !isNull _lifetimeObject;
[_area, _shell, _salvoSize, _salvoInterval, _salvoTimeVariation, _shotInterval, _shotTimeVariation, _lifetimeObject, _stopWithObject] spawn {
    params ["_area", "_shell", "_salvoSize", "_salvoInterval", "_salvoTimeVariation", "_shotInterval", "_shotTimeVariation", "_lifetimeObject", "_stopWithObject"];
    sleep 0.5;

    while {!_stopWithObject || {alive _lifetimeObject}} do {
        for "_i" from 1 to _salvoSize do {
            private _shotDelay = _shotInterval + random [0, _shotTimeVariation / 2, _shotTimeVariation];
            sleep (_shotDelay max 0.01);
            if (_stopWithObject && {!alive _lifetimeObject}) exitWith {};

            private _pos = [[_area]] call BIS_fnc_randomPos;
            [_pos, _shell] call FUNC(ambientArtilleryVirtual_callArtillery);
        };

        if (_stopWithObject && {!alive _lifetimeObject}) exitWith {};
        private _salvoDelay = _salvoInterval + random [0, _salvoTimeVariation / 2, _salvoTimeVariation];
        sleep (_salvoDelay max 0.01);
    };
}
