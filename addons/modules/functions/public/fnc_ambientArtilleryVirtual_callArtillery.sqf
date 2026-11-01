/*
    Function: meh_modules_fnc_ambientArtilleryVirtual_callArtillery
    Fire one virtual artillery round at an ATL position. Call on the server.
    Arguments: [positionATL, ammoClass] (default ammoClass: "Sh_82mm_AMOS")
    Returns: created projectile, or objNull if invalid/not on server.
*/
#include "script_component.hpp"

params [
    ["_position", [], [[]]],
    ["_shell", "Sh_82mm_AMOS", [""]]
];

if (!isServer || {count _position < 2} || {!isClass (configFile >> "CfgAmmo" >> _shell)}) exitWith {objNull};

private _spawnPosition = +_position;
_spawnPosition set [2, 1000];
private _round = createVehicle [_shell, _spawnPosition];
_round setVelocity [0, 0, -1000];
_round
