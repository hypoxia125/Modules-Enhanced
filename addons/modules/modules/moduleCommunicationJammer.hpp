class MEH_ModuleCommunicationJammer: MEH_ModuleBase {
    scope = 2;
    displayName = "Communication Jammer";
    icon = "a3\ui_f\data\gui\rsc\rscdisplayarsenal\radio_ca.paa";
    category = "MEH_Misc";

    function = QFUNC(ModuleCommunicationJammer);
    functionPriority = 1;
    isGlobal = 2;
    isTriggerActivated = 0;
    isDisposable = 1;
    is3DEN = 1;

    canSetArea = 1;
    canSetAreaShape = 1;
    canSetAreaHeight = 1;
    class AttributeValues {
        size3[] = {100, 100, 100};
        isRectangle = 0;
    };

    class Attributes: AttributesBase {
        class JamFormula: Combo {
            property = QGVAR(ModuleCommunicationJammer_JamFormula);
            displayName = "Jam Formula";
            tooltip = "The formula used to calculate the jam amount. Based on distance of player to the jammer center/object. Normalized for max radius of the module area.";
            defaultValue = 0;
            typeName = "NUMBER";
            class Values {
                class Linear {
                    name = "Linear";
                    value = 0;
                };
                class Quadratic {
                    name = "Quadratic";
                    value = 1;
                };
                class Exponential {
                    name = "Exponential";
                    value = 2;
                };
                class Logarithmic {
                    name = "Logarithmic";
                    value = 3;
                };
                class Inverse {
                    name = "Inverse";
                    value = 4;
                };
                class Sine {
                    name = "Sine";
                    value = 5;
                };
                class Sigmoid {
                    name = "Sigmoid";
                    value = 6;
                };
            };
        };

        class K: Edit {
            property = QGVAR(ModuleCommunicationJammer_K);
            displayName = "k";
            tooltip = "Modifier of the formula.\n\nQuadratic: The steepness changes with k.\nExponential: Larger k makes the drop-off faster.\nLogarithmic: k adjust how gradual the fall-off is.\nInverse: Steeper curves for larger k.\nSine: Frequency increases with k.\nSigmoid: The S-Curve becomes steeper as k increases.";
            defaultValue = 1;
            typeName = "NUMBER";
        };

        class VisualizeRadius: Combo {
            property = QGVAR(ModuleCommunicationJammer_VisualizeRadius);
            displayName = "Visualize Radius";
            tooltip = "Shows colored spheres that indicate the strength of the jamming depending on formula selected and k value.\n\nGreen: 0-49%\nYellow: 50-74%\nRed: 75-100%";
            defaultValue = 0;
            typeName = "NUMBER";
            class Values {
                class None {
                    name = "NONE";
                    value = 0;
                };
                class Radius2D {
                    name = "2D Circumference";
                    value = 1;
                };
                class Radius3D {
                    name = "3D Area";
                    value = 2;
                };
                class Radius3DCircumference {
                    name = "3D Circumference";
                    value = 3;
                };
            };
        };

        class ModuleDescription: ModuleDescription {};
    };

    class ModuleDescription: ModuleDescription {
        description[] = {
            CSTRING(ModuleCommunicationJammer_ModuleDescription_Description),
            "",
            CSTRING(ModuleDescription_TriggerActivated_False),
            CSTRING(ModuleDescription_Repeatable_False)
        };
        position = 1;
        direction = 1;
    };
};