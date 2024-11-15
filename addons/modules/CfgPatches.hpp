class CfgPatches {
    class ADDON {
        name = "Modules Enhanced - Modules";
        author = "Hypoxic";
        url = "https://github.com/hypoxia125/Modules-Enhanced";
        is3DENMod = 1;

        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {
            "A3_Functions_F",
            "cba_main",
            "meh_main",
            "meh_common",
            "meh_effects"
        };
        units[] = {
            "MEH_ModuleAmbientArtillery",
            "MEH_ModuleAntiTroll",
            "MEH_ModuleCreateMinefield",
            "MEH_ModuleDeleteRespawnPosition",
            "MEH_ModuleEffectFire",
            "MEH_ModuleEffectLightpoint.hpp",
            "MEH_ModuleEffectSmoke",
            "MEH_ModuleEnableDisableGunLights",
            "MEH_ModuleLightningStorm",
            "MEH_ModuleMoveOnCombat",
            "MEH_ModuleMPSync",
            "MEH_ModuleParadropVehicle",
            "MEH_ModuleRegisterTeleporter",
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
