class MEH_ModuleEffectFlareLauncher: MEH_ModuleBase {
    scope = 2;
    displayName = "Effect - Flare Launcher";
    icon = "a3\modules_f_curator\data\iconflare_ca.paa";
    category = "MEH";

    function = QFUNC(ModuleEffectFlareLauncher);
    functionPriority = 1;
    isGlobal = 0;
    isTriggerActivated = 1;
    isDisposable = 0;
    is3DEN = 1;

    class Attributes: AttributesBase {
        class FlareColor: Combo {
            property = QGVAR(ModuleEffectFlareLauncher_FlareColor);
            displayName = "Flare Color";
            tooltip = "Color of the flare to be launched.";
            defaultValue = DEFAULT_FLARECOLOR;
            typeName = "NUMBER";
            class Values {
                class Green {
                    name = "Green";
                    value = 0;
                };
                class Red {
                    name = "Red";
                    value = 1;
                };
                class White {
                    name = "White";
                    value = 2;
                };
                class Yellow {
                    name = "Yellow";
                    value = 3;
                };
                class Cycle {
                    name = "Cycle";
                    value = 4;
                };
                class Random {
                    name = "Random";
                    value = 5;
                };
            };
        };

        class TimeBetweenLaunches: Edit {
            property = QGVAR(ModuleEffectFlareLauncher_TimeBetweenLaunches);
            displayName = "Time Between Launches";
            tooltip = "Time between each of the flare launches (seconds).";
            defaultValue = DEFAULT_TIMEBETWEENLAUNCHES;
            typeName = "NUMBER";
            validate = "NUMBER";
        };

        class LaunchRandomness: Edit {
            property = QGVAR(ModuleEffectFlareLauncher_LaunchRandomness);
            displayName = "Launch Randomness";
            tooltip = "Max time to add or subtract from 'Time Between Launches' (seconds). Randomly between 0 and input given.";
            defaultValue = DEFAULT_LAUNCHRANDOMNESS;
            typeName = "NUMBER";
            validate = "NUMBER";
        };

        class FlareDeployHeight: Edit {
            property = QGVAR(ModuleEffectFlareLauncher_FlareDeployHeight);
            displayName = "Flare Deploy Height";
            tooltip = "Height (ATL) that the flares deploy. Random between given inputs: [min, max]";
            defaultValue = DEFAULT_FLAREDEPLOYHEIGHT_CONFIG;
            typeName = "STRING";
            validate = "STRING";
        };

        class LaunchDispersion: Edit {
            property = QGVAR(ModuleEffectFlareLauncher_LaunchDispersion);
            displayName = "Launch Dispersion Angle";
            tooltip = "How much the shell direction can vary from a perfect 90* straight-up path. Example: Input 20* = 70* through 90* launch angle.";
            defaultValue = DEFAULT_LAUNCHDISPERSION;
            typeName = "NUMBER";
            validate = "NUMBER";
        };

        class ModuleDescription: ModuleDescription {};
    };

    class ModuleDescription: ModuleDescription {
        description[] = {
            "Launches flare rounds at user defined intervals.",
            "Arma 3 has a maximum of 64 individual dynamic lights that can be shown at once.",
            "If you go over this, glitches can occur so don't overdo it!",
            "Flares last 60 seconds (vanilla).",
            "",
            CSTRING(ModuleDescription_TriggerActivated_Optional),
            CSTRING(ModuleDescription_TriggerActivated_Server),
            CSTRING(ModuleDescription_Repeatable_True)
        };
        position = 1;
        direction = 1;
    };
};