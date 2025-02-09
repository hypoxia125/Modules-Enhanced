class MEH_ModuleEarthquakeEpicenter: MEH_ModuleBase {
    scope = 2;
    displayName = "Earthquake Epicenter";
    icon = "a3\data_f_argo\logos\arma3_argo_logo_small_ca.paa";
    category = "MEH_Effects";

    function = QFUNC(ModuleEarthquakeEpicenter);
    functionPriority = 1;
    isGlobal = 1;
    isTriggerActivated = 1;
    isDisposable = 1;
    is3DEN = 1;

    class Attributes: AttributesBase {
        class Magnitude: Combo {
            property = QGVAR(ModuleEarthquakeEpicenter_Magnitude);
            displayName = "Magnitude";
            tooltip = "Richter Scale Magnitude\nLogarithmic Scale: 1-10";
            defaultValue = 5;
            typeName = "NUMBER";
            class Values {
                class Scale_1 {
                    name = "1: Micro";
                    value = 1;
                };
                class Scale_2 {
                    name = "2: Minor";
                    value = 2;
                };
                class Scale_3 {
                    name = "3: Minor";
                    value = 3;
                };
                class Scale_4 {
                    name = "4: Light";
                    value = 4;
                };
                class Scale_5 {
                    name = "5: Moderate";
                    value = 5;
                };
                class Scale_6 {
                    name = "6: Strong";
                    value = 6;
                };
                class Scale_7 {
                    name = "7: Major";
                    value = 7;
                };
                class Scale_8 {
                    name = "8: Great";
                    value = 8;
                };
                class Scale_9 {
                    name = "9: Great";
                    value = 9;
                };
                class Scale_10 {
                    name = "10: Great";
                    value = 10;
                };
            };
        };

        class ModuleDescription: ModuleDescription {};
    };

    class ModuleDescription: ModuleDescription {
        description[] = {
            "Defines an area for the connected Earthquake Epicenter module to damage buildings during the earthquake. Magnitude is based on the Richter Scale and will effect the camera shake power and frequency as well as duration of the quake.",
            "",
            CSTRING(ModuleDescription_TriggerActivated_True),
            CSTRING(ModuleDescription_TriggerActivated_Server),
            CSTRING(ModuleDescription_Repeatable_False)
        };
        position = 1;
        direction = 0;
    };
};