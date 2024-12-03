class CfgPatches {
    class ADDON {
        name = "Modules Enhanced - SOG Compatibility";
        author = "Hypoxic";
        url = "https://github.com/hypoxia125/Modules-Enhanced";
        is3DENMod = 1;

        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {
            "data_f_vietnam",
            "meh_modules"
        };
        units[] = {};
        weapons[] = {};

        skipWhenMissingDependencies = 1;
    };
};
