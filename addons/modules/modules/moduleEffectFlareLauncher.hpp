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
                // Blue Flares
                class Blue_60 {
                    name = "Blue (1 min)";
                    value = 0;
                };
                class Blue_180 {
                    name = "Blue (3 min)";
                    value = 1;
                };
                class Blue_300 {
                    name = "Blue (5 min)";
                    value = 2;
                };

                // Green Flares
                class Green_60 {
                    name = "Green (1 min)";
                    value = 3;
                };
                class Green_180 {
                    name = "Green (3 min)";
                    value = 4;
                };
                class Green_300 {
                    name = "Green (5 min)";
                    value = 5;
                };

                // Orange Flares
                class Orange_60 {
                    name = "Orange (1 min)";
                    value = 6;
                };
                class Orange_180 {
                    name = "Orange (3 min)";
                    value = 7;
                };
                class Orange_300 {
                    name = "Orange (5 min)";
                    value = 8;
                };

                // Purple Flares
                class Purple_60 {
                    name = "Purple (1 min)";
                    value = 9;
                };
                class Purple_180 {
                    name = "Purple (3 min)";
                    value = 10;
                };
                class Purple_300 {
                    name = "Purple (5 min)";
                    value = 11;
                };

                // Red Flares
                class Red_60 {
                    name = "Red (1 min)";
                    value = 12;
                };
                class Red_180 {
                    name = "Red (3 min)";
                    value = 13;
                };
                class Red_300 {
                    name = "Red (5 min)";
                    value = 14;
                };

                // White Flares
                class White_60 {
                    name = "White (1 min)";
                    value = 15;
                };
                class White_180 {
                    name = "White (3 min)";
                    value = 16;
                };
                class White_300 {
                    name = "White (5 min)";
                    value = 17;
                };

                // Yellow Flares
                class Yellow_60 {
                    name = "Yellow (1 min)";
                    value = 18;
                };
                class Yellow_180 {
                    name = "Yellow (3 min)";
                    value = 19;
                };
                class Yellow_300 {
                    name = "Yellow (5 min)";
                    value = 20;
                };

                // Random Flares
                class Random_60 {
                    name = "Random (1 min)";
                    value = 21;
                };
                class Random_180 {
                    name = "Random (3 min)";
                    value = 22;
                };
                class Random_300 {
                    name = "Random (5 min)";
                    value = 23;
                };

                // Cycle Flares
                class Cycle_60 {
                    name = "Cycle (1 min)";
                    value = 24;
                };
                class Cycle_180 {
                    name = "Cycle (3 min)";
                    value = 25;
                };
                class Cycle_300 {
                    name = "Cycle (5 min)";
                    value = 26;
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
            "",
            CSTRING(ModuleDescription_TriggerActivated_Optional),
            CSTRING(ModuleDescription_TriggerActivated_Server),
            CSTRING(ModuleDescription_Repeatable_True)
        };
        position = 1;
        direction = 1;
    };
};