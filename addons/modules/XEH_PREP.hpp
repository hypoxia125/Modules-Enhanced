// Module Functions
#ifdef DISABLE_COMPILE_CACHE
    #undef PREP
    #define PREP(fncName) DFUNC(fncName) = compile preprocessFileLineNumbers QPATHTOF(functions\modules\DOUBLES(fnc,fncName).sqf)
#else
    #undef PREP
    #define PREP(fncName) [QPATHTOF(functions\modules\DOUBLES(fnc,fncName).sqf), QFUNC(fncName)] call CBA_fnc_compileFunction
#endif

PREP(moduleAmbientArtilleryVirtual);
PREP(moduleAntiTroll);
PREP(moduleChangeFlag);
PREP(moduleClearMapLocationNames);
PREP(moduleCommunicationJammer);
PREP(moduleCreateMinefield);
PREP(moduleCreateMapLocation);
PREP(moduleCreateRemoteTarget);
PREP(moduleDeleteRespawnPosition);
PREP(ModuleEarthquakeDamageArea);
PREP(moduleEarthquakeEpicenter);
PREP(moduleEffectFire);
PREP(moduleEffectFlareLauncher);
PREP(moduleEffectLightpoint);
PREP(moduleEffectSmoke);
PREP(moduleEnableDisableGunLights);
PREP(moduleFadeScreen);
PREP(moduleHealingArea);
PREP(moduleInfantrySpawner);
PREP(moduleIntroText);
PREP(moduleInventorySync);
PREP(moduleLightningStorm);
PREP(moduleMapAnimationStart);
PREP(moduleMoveOnCombat);
PREP(moduleParadropTroopTransport);
PREP(moduleMPSync);
PREP(moduleParadropVehicle);
PREP(moduleRegisterTeleporter);
PREP(moduleSpawnerWaypoint);
PREP(moduleSpeedLimiter);
PREP(moduleTrapInventory);
PREP(moduleVehicleFuelCoef);
PREP(moduleVehicleMineJammer);
PREP(moduleVehicleRearm);
PREP(moduleVehicleRefuel);
PREP(moduleVehicleRepair);
PREP(ModuleVehicleServiceStation);

// Private Functions
#ifdef DISABLE_COMPILE_CACHE
    #undef PREP
    #define PREP(fncName) DFUNC(fncName) = compile preprocessFileLineNumbers QPATHTOF(functions\private\DOUBLES(fnc,fncName).sqf)
#else
    #undef PREP
    #define PREP(fncName) [QPATHTOF(functions\private\DOUBLES(fnc,fncName).sqf), QFUNC(fncName)] call CBA_fnc_compileFunction
#endif

PREP(get3DENAreaModule);
PREP(getSynchronizedObjectsFiltered);

// Public Functions
#ifdef DISABLE_COMPILE_CACHE
    #undef PREP
    #define PREP(fncName) DFUNC(fncName) = compile preprocessFileLineNumbers QPATHTOF(functions\public\DOUBLES(fnc,fncName).sqf)
#else
    #undef PREP
    #define PREP(fncName) [QPATHTOF(functions\public\DOUBLES(fnc,fncName).sqf), QFUNC(fncName)] call CBA_fnc_compileFunction
#endif

PREP(createArtilleryShell);
PREP(createVirtualArtilleryFire);
PREP(punishPlayer);

INFO("PREP: Functions loaded successfully");
