class MEH_ModuleRegisterTeleporter: Module_F {
    scope = 2;
    displayName = CSTRING(ModuleRegisterTeleporter_DisplayName);
    icon = "a3\ui_f\data\igui\cfg\simpletasks\types\move_ca.paa";
    category = "MEH";

    function = QFUNC(ModuleRegisterTeleporter);
    functionPriority = 1;
    isGlobal = 2;
    isTriggerActivated = 1;
    isDisposable = 1;
    is3DEN = 1;

    class Attributes: AttributesBase {
        class Name: Edit {
            property = QGVAR(ModuleRegisterTeleporter_Name);
            displayName = CSTRING(ModuleRegisterTeleporter_Name_DisplayName);
            tooltip = CSTRING(ModuleRegisterTeleporter_Name_DisplayName);
            defaultValue = """""";
            typeName = "STRING";
            verify = "STRING";
        };

        class Side: Combo {
            property = QGVAR(ModuleRegisterTeleporter_Side);
            displayName = CSTRING(ModuleRegisterTeleporter_Side_DisplayName);
            tooltip = CSTRING(ModuleRegisterTeleporter_Side_Tooltip);
            defaultValue = 1;
            typeName = "NUMBER";
            class Values {
                class East {
                    name = CSTRING(ModuleRegisterTeleporter_Side_East);
                    value = 0;
                };
                class West {
                    name = CSTRING(ModuleRegisterTeleporter_Side_West);
                    value = 1;
                };
                class Resistance {
                    name = CSTRING(ModuleRegisterTeleporter_Side_Resistance);
                    value = 2;
                };
                class Civilian {
                    name = CSTRING(ModuleRegisterTeleporter_Side_Civilian);
                    value = 3;
                };
            };
        };

        class Bidirectional: Checkbox {
            property = QGVAR(ModuleRegisterTeleporter_Bidirectional);
            displayName = CSTRING(ModuleRegisterTeleporter_Bidirectional_DisplayName);
            tooltip = CSTRING(ModuleRegisterTeleporter_Bidirectional_Tooltip);
            defaultValue = "true";
            typeName = "BOOL";
        };

        class TravelTime: Edit {
            property = QGVAR(ModuleRegisterTeleporter_TravelTime);
            displayName = CSTRING(ModuleRegisterTeleporter_TravelTime_DisplayName);
            tooltip = CSTRING(ModuleRegisterTeleporter_TravelTime_Tooltip);
            defaultValue = -1;
            typeName = "NUMBER";
        };

        class ModuleDescription: ModuleDescription {};
    };

    class ModuleDescription: ModuleDescription {
        description[] = {
            CSTRING(ModuleRegisterTeleporter_ModuleDescription_Description),
            "",
            CSTRING(ModuleDescription_TriggerActivated_Optional),
            CSTRING(ModuleDescription_TriggerActivated_Local),
            CSTRING(ModuleDescription_Repeatable_False)
        };
        position = 0;
        direction = 0;
    };
};
