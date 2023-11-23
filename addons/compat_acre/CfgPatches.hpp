class CfgPatches {
    class ADDON {
        name = "Modules Enhanced - ACRE Compatibility";
        author = "Hypoxic";
        url = "https://github.com/hypoxia125/Modules-Enhanced";
        is3DENMod = 1;

        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {
            "A3_Functions_F",
            "cba_main",
            "meh_modules",
            "acre_main"
        };
        units[] = {};
        weapons[] = {};

        skipWhenMissingDependencies = 1;
    };
};