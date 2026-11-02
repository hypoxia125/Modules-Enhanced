/*
    Function: meh_modules_fnc_antiTroll_punish
    Apply an Anti-Troll punishment to a unit. Call on the server.
    Arguments: [unit, punishmentType] (0: kill, 1: prison [not implemented],
                2: lightning, 3: throw, 4: launch).
*/
#include "script_component.hpp"

params [
    ["_player", objNull, [objNull]],
    ["_type", -1, [0]]
];

if (!isServer || {isNull _player} || {!(_type in [0, 1, 2, 3, 4])}) exitWith {};

switch _type do {
    // suicide
    case 0: {
        _player setDamage 1;
    };
    // prison (not implemented)
    case 1: {};
    // lightning
    case 2: {
        private _bolt = createVehicle ["MEH_LightningBolt", [100,100,100], [], 0, "CAN_COLLIDE"];
        private _pos = getPosATL _player;
        _bolt setPosATL _pos;
        _bolt setDamage 1;

        [QEGVAR(effects,lightningStrike_Local), [getPosATL _player, random 360, selectRandom ["Lightning1_F", "Lightning2_F"]]] call CBA_fnc_globalEvent;
        _player setDamage 1;
    };
    // throw
    case 3: {
        [QGVAR(throwUnit), [_player, 100], _player] call CBA_fnc_targetEvent;
    };
    // launch
    case 4: {
        private _missile = createVehicle ["ammo_Missile_Cruise_01", getPosATL _player vectorAdd [0,0,3], [], 0, "NONE"];
        _missile setVectorDirAndUp [[0, 0, 1], [1, 0, 0]];

        [QGVAR(setRocketAnimation), [_player]] call CBA_fnc_globalEvent;
        [QGVAR(attachPlayerToRocket), [_player, _missile], _player] call CBA_fnc_targetEvent;

        [_missile, _player] spawn {
            params ["_missile", "_player"];
            sleep 5;
            detach _player;
            [QGVAR(startRagdoll), [_player], _player] call CBA_fnc_targetEvent;
            triggerAmmo _missile;
        };
    };
};

[QGVAR(punishmentMessage), [], _player] call CBA_fnc_targetEvent;
