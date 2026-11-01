# Mission-maker functions

Call these after the mod's preInit; they are compiled CBA functions, **not** the `module*` callbacks. For example, `[vehicle, 0.5] call meh_modules_fnc_vehicleRefuel_refuel;` refuels a vehicle by 50%. All names below have the `meh_modules_fnc_` prefix. These functions return nothing unless noted.

| Function suffix | Arguments | Where to call |
| --- | --- | --- |
| `ambientArtilleryVirtual_callArtillery` | `[positionATL, ammoClass]` (default `"Sh_82mm_AMOS"`); returns projectile or `objNull` | Server only; spawns one shell 1000m above the position |
| `lightningStorm_strike` | `[positionATL, damageRadius]` (default 15); returns bolt or `objNull` | Server only; broadcasts visual effects |
| `createRemoteTarget_reportTarget` | `[target, side, durationSeconds]` (default 900) | Server only; broadcast to current and JIP clients |
| `vehicleRefuel_refuel` | `[vehicle, fractionToAdd]` (default 1) | Any machine; delivered to vehicle owner |
| `vehicleRearm_rearm` | `[vehicle]` | Any machine; delivered to vehicle owner |
| `vehicleRepair_repair` | `[vehicle, fractionToRepair]` (default 1) | Any machine; delivered to vehicle owner |
| `vehicleFuelCoef_setCoef` | `[vehicle, coefficient]` | Any machine; delivered to vehicle owner |
| `createMapLocation_createLocation` | `[[positionASL, radiusX, radiusY, direction, isRectangle], name, locationType, importance]`; returns location or `locationNull` | Where the location should be created |
| `clearMapLocationNames_clearLocations` | `[locations]`; returns `[[location, oldType], ...]` | Each machine whose local map should change |
| `clearMapLocationNames_restoreLocations` | `[savedLocations]` from `clearMapLocationNames_clearLocations` | Same machine as clear |
| `speedLimiter_setSpeed` | `[vehicleOrVehicles, speed, affectPlayers, affectAI]` (defaults: 0, true, true) | Server only; player cruise control is JIP-broadcast |
| `deleteRespawnPosition_delete` | `[respawnModuleOrModules]` (`ModuleRespawnPosition_F`) | Server only; deletes the respawn-position modules too |

Internal editor callbacks and helpers live in `addons/modules/functions/private/`; public functions in `addons/modules/functions/public/`. Both are registered in `addons/modules/XEH_PREP.hpp` and use the standard `meh_modules_fnc_...` global namespace.
