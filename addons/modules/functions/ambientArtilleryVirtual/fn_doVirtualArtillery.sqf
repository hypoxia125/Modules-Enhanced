/* ----------------------------------------------------------------------------
Function: meh_modules_fnc_doVirtualArtillery

Author: Hypoxic

Public: True

Flags: Global Argument, Global Execution, Scheduled

Description:
    Creates an area of bombardment for virtual artillery
---------------------------------------------------------------------------- */

#include "script_component.hpp"

params [
    ["_area", [[0,0,0], 100, 100, 0, false, -1], [[]], 5],
    ["_shell", "Sh_82mm_AMOS", [""]],
    ["_salvoSize", 6, [-1]],
    ["_salvoInterval", 10, [-1]],
    ["_salvoTimeVariation", 5, [-1]],
    ["_shotInterval", 1, [-1]],
    ["_shotTimeVariation", 1, [-1]]
];

if (!canSuspend) exitWith { _this spawn FUNC(doVirtualArtillery) };

if !(_area isEqualTypeArray [[], -1, -1, -1, true, -1]) exitWith {};

for "_i" from 2 to 6 do {
    _this # _i = abs _this # _i;
};

// TODO: Create virtual HQs for use with setShotParents
// that way we can cause units to be suppressed
// Try to make the vitual HQ on sideEnemy (5) and see what happens


while {true} do {
    for "_i" from 1 to _salvoSize do {
        private _pos = [[_area]] call BIS_fnc_randomPos;
        _pos set [2, 1000];

        private _shotDelay = _shotInterval + (random [0, _shotTimeVariation / 2, _shotTimeVariation]);

        private _round = [_shell, _pos] call FUNC(createVirtualArtilleryRound);
        // TODO: _round setShotParents

        sleep _shotDelay;
    };

    private _salvoDelay = _salvoInterval + (random [0, _salvoTimeVariation / 2, _salvoTimeVariation]);
    sleep _salvoDelay;
};