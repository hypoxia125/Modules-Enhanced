class MEH_ModuleChangeFlag_ACE: MEH_ModuleBase {
    scope = 2;
    displayName = "Change Flag - ACE";
    icon = "a3\ui_f\data\igui\cfg\actions\takeflag_ca.paa";
    category = "MEH"; 

    function = QEFUNC(modules,ModuleChangeFlag);
    functionPriority = 1;
    isGlobal = 0;
    isTriggerActivated = 1;
    isDisposable = 0;
    is3DEN = 1;

    class Attributes: AttributesBase {
        class Mode: Combo {
            property = QGVAR(ModuleChangeFlag_Mode);
            displayName = "Mode";
            tooltip = "Changes if the flag should be fully replaced, or texture changed.";
            defaultValue = 0;
            typeName = "NUMBER";
            class Values {
                class TextureChange {
                    name = "Replace Flag Texture";
                    value = 0;
                };
                class Replace {
                    name = "Replace Flag Object Entirely";
                    value = 1;
                };
            };
        };

        class FlagToReplace: Combo {
            property = QGVAR(ModuleChangeFlag_FlagToReplace);
            displayName = "New Flag";
            tooltip = "Flag to replace current flag with.";
            defaultValue = 1;
            typeName = "STRING";
            class Values {
                class ACE_Black {
                    name = "ACE - Black";
                    value = "ACE_Flag_Black";
                };
                class ACE_White {
                    name = "ACE - White";
                    value = "ACE_Flag_White";
                };
                class ACE_RallyPoint_East {
                    name = "ACE - Rallypoint East";
                    value = "ACE_Rallypoint_East";
                };
                class ACE_Rallypoint_Independent {
                    name = "ACE - Rallypoint Independent";
                    value = "ACE_Rallypoint_Independent";
                };
                class ACE_Rallypoint_West {
                    name = "ACE - Rallypoint West";
                    value = "ACE_Rallypoint_West";
                };
            };
        };

        class CustomTexture: Edit {
            property = QGVAR(ModuleChangeFlag_CustomTexture);
            displayName = "Custom Texture Path";
            tooltip = "Path to custom texture.";
            defaultValue = "";
            typeName = "STRING";
        };

        class RetainVarName: Checkbox {
            property = QGVAR(ModuleChangeFlag_RetainVarName);
            displayName = "Retain Variable Name";
            tooltip = "Retains variable name upon changing flags. Keeps user variable defined in Object:Init.VariableName in flag's attributes.";
            defaultValue = "true";
            typeName = "BOOL";
        };

        class ModuleDescription: ModuleDescription {};
    };

    class ModuleDescription: ModuleDescription {
        description[] = {
            "Changes a flag texture or the flag entirely. Sync to 'FlagCarrier' based class.",
            "",
            ECSTRING(modules,ModuleDescription_TriggerActivated_True),
            ECSTRING(modules,ModuleDescription_TriggerActivated_Server),
            ECSTRING(modules,ModuleDescription_Repeatable_True)
        };
        position = 0;
        direction = 0;
    };
};