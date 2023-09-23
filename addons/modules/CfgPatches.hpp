class CfgPatches {
    class ADDON {
        name = "Modules Enhanced - Modules";
        author = "Hypoxic";
        url = "";

        requiredVersion = 2.14;
        requiredAddons[] = {
            "A3_Functions_F",
            "cba_main"
        };
        units[] = {
            "MEH_ModuleDeleteRespawnPosition",
            "MEH_ModuleFuelConsumption",
            "MEH_ModuleMoveOnCombat",
            "MEH_ModuleParadropVehicle",
            "MEH_ModuleVehicleMineJammer",
            "MEH_ModuleVehicleRearm",
            "MEH_ModuleVehicleRefuel"
        };
        weapons[] = {};

        skipWhenMissingDependencies = 1;
    };
};
