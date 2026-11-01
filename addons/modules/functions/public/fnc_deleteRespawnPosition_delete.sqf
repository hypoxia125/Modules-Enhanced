/*
    Function: meh_modules_fnc_deleteRespawnPosition_delete
    Remove respawn positions created by ModuleRespawnPosition_F and delete those modules.
    Arguments: [respawnModuleOrModules]. Call on the server; returns nothing.
*/
#include "script_component.hpp"

params [["_modules", [], [[], objNull]]];
if (!isServer) exitWith {};
if (_modules isEqualType objNull) then {_modules = [_modules]};

{
    private _module = _x;
    if (_module isKindOf "ModuleRespawnPosition_F") then {
        private _respawn = (_module getVariable [QUOTE(respawn), []]) param [0, [], [[], ""]];
        if (_respawn isEqualType [] && {count _respawn == 2}) then {
            _respawn call BIS_fnc_removeRespawnPosition;
            deleteVehicle _module;
        };
    };
} forEach _modules;
