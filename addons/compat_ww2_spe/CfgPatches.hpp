class CfgPatches {
    class ADDON {
        name = "Modules Enhanced - Spearhead 1944 Compatibility";
        author = "Hypoxic";
        url = "https://github.com/hypoxia125/Modules-Enhanced";
        is3DENMod = 1;

        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {
            "WW2_SPE_Core_c_Core_c",
            "meh_modules"
        };
        units[] = {};
        weapons[] = {};

        skipWhenMissingDependencies = 1;
    };
};
