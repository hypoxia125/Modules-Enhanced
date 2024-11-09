#include "script_component.hpp"

params ["_player", "_type"];

if (isNil "_player" || {isNull _player}) exitWith {};

switch _type do {
    // suicide
    case 0: {
        _player setDamage 1;
    };
    // prison
    case 1: {

    };
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
        private _missile = createVehicle ["ammo_Missile_Cruise_01", getposATL _player vectorAdd [0,0,3], [], 0, "NONE"];
        _missile setVectorDirAndUp [[0, 0, 1], [1, 0, 0]];

        [QGVAR(setRocketAnimation), [_player]] call CBA_fnc_globalEvent;
        [QGVAR(attachPlayerToRocket), [_player, _missile], _player] call CBA_fnc_targetEvent;
        
        [{
            params ["_missile", "_player"];

            detach _player;
            [QGVAR(startRagdoll), [_player], _player] call CBA_fnc_targetEvent;
            triggerAmmo _missile;
                      
        }, [_missile, _player], 5] call CBA_fnc_waitAndExecute;
    };
};

[QGVAR(punishmentMessage), [], _player] call CBA_fnc_targetEvent;