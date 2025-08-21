class MEH_ModuleFadeScreen: MEH_ModuleBase {
    scope = 2;
    displayName = "Fade Screen";
    icon = "a3\data_f\flashgradient_ca.paa";
    category = "MEH_Cinematics";

    function = QFUNC(ModuleFadeScreen);
    functionPriority = 1;
    isGlobal = 1;
    isTriggerActivated = 1;
    isDisposable = 1;
    is3DEN = 1;

    class Attributes: AttributesBase {
        class InOut: Combo {
            property = QGVAR(ModuleFadeScreen_InOut);
            displayName = "In/Out";
            tooltip = "Is the module going to fade in, or fade out?";
            defaultValue = 1;
            typeName = "NUMBER";
            class Values {
                class In {
                    name = "In";
                    value = 0;
                };
                class Out {
                    name = "Out";
                    value = 1;
                };
            };
        };

        class Color: Combo {
            property = QGVAR(ModuleFadeScreen_Color);
            displayName = "Color";
            tooltip = "Color of the fade";
            defaultValue = 0;
            typeName = "NUMBER";
            class Values {
                class Black {
                    name = "Black";
                    value = 0;
                };
                class White {
                    name = "White";
                    value = 1;
                };
            };
        };

        class Duration: Edit {
            property = QGVAR(ModuleFadeScreen_Duration);
            displayName = "Fade Duration (s)";
            tooltip = "How long it takes for the screen to fade";
            defaultValue = 1;
            typeName = "NUMBER";
        };

        class ModuleDescription: ModuleDescription {};
    };

    class ModuleDescription: ModuleDescription {
        description[] = {
            "Fades the screen in and out with choice of colors.",
            "",
            CSTRING(MEH_Modules_ModuleDescription_TriggerActivated_True),
            CSTRING(ModuleDescription_Repeatable_False)
        };
        position = 0;
        direction = 0;
    };
};
