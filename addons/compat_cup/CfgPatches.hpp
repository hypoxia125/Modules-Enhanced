class CfgPatches {
    class ADDON {
        name = "Modules Enhanced - CUP Compatibility";
        author = "Hypoxic";
        url = "https://github.com/hypoxia125/Modules-Enhanced";
        is3DENMod = 1;

        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {
            "CUP_Misc_e_Config",
            "meh_modules"
        };
        units[] = {};
        weapons[] = {};

        skipWhenMissingDependencies = 1;
    };
};
