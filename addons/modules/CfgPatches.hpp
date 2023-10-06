class CfgPatches {
    class ADDON {
        name = "Modules Enhanced - Modules";
        author = "Hypoxic";
        url = "https://github.com/hypoxia125/Modules-Enhanced";
        is3DENMod = 1;

        requiredVersion = 2.14;
        requiredAddons[] = {
            "A3_Functions_F",
            "cba_main"
        };
        units[] = {
            "MEH_moduleAmbientArtillery",
            "MEH_ModuleDeleteRespawnPosition",
            "MEH_ModuleEffectFire",
            "MEH_ModuleEffectSmoke",
            "MEH_ModuleEnableDisableGunLights",
            "MEH_ModuleMoveOnCombat",
            "MEH_ModuleParadropVehicle",
            "MEH_ModuleSpeedLimiter",
            "MEH_ModuleTrapInventory",
            "MEH_ModuleVehicleMineJammer",
            "MEH_ModuleVehicleRearm",
            "MEH_ModuleVehicleRefuel"
        };
        weapons[] = {};

        skipWhenMissingDependencies = 1;
    };
};
