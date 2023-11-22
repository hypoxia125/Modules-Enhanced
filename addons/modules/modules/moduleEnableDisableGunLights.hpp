class MEH_ModuleEnableDisableGunLights: MEH_ModuleBase {
    scope = 2;
    displayName = CSTRING(ModuleEnableDisableGunLights_DisplayName);
    icon = "a3\3den\data\displays\display3den\toolbar\flashlight_off_ca.paa";
    category = "MEH";

    function = QFUNC(ModuleEnableDisableGunLights);
    functionPriority = 1;
    isGlobal = 0;
    isTriggerActivated = 1;
    isDisposable = 1;
    is3DEN = 1;

    class Attributes: AttributesBase {
        class State: Combo {
            property = QGVAR(ModuleEnableDisableGunLights_State);
            displayName = CSTRING(ModuleEnableDisableGunLights_State_DisplayName);
            tooltip = CSTRING(ModuleEnableDisableGunLights_State_Tooltip);
            defaultValue = 0;
            typeName = "NUMBER";
            class Values {
                class Auto {
                    name = CSTRING(ModuleEnableDisableGunLights_State_Values_Auto_Name);
                    value = 0;
                };
                class AlwaysOn {
                    name = CSTRING(ModuleEnableDisableGunLights_State_Values_AlwaysOn_Name);
                    value = 1;
                };
                class AlwaysOff {
                    name = CSTRING(ModuleEnableDisableGunLights_State_Values_AlwaysOff_Name);
                    value = 2;
                };
            };
        };

        class AddAttachment: Checkbox {
            property = QGVAR(ModuleEnableDisableGunLights_AddAttachment);
            displayName = CSTRING(ModuleEnableDisableGunLights_AddAttachment_DisplayName);
            tooltip = CSTRING(ModuleEnableDisableGunLights_AddAttachment_Tooltip);
            defaultValue = "false";
            typeName = "BOOL";
        };

        class Attachment: Edit {
            property = QGVAR(ModuleEnableDisableGunLights_Attachment);
            displayName = CSTRING(ModuleEnableDisableGunLights_Attachment_DisplayName);
            tooltip = CSTRING(ModuleEnableDisableGunLights_Attachment_Tooltip);
            defaultValue = """acc_flashlight""";
            typeName = "STRING";
        };

        class ModuleDescription: ModuleDescription {};
    };

    class ModuleDescription: ModuleDescription {
        description[] = {
            CSTRING(ModuleEnableDisableGunLights_ModuleDescription_Description),
            "",
            CSTRING(ModuleDescription_TriggerActivated_Optional),
            CSTRING(ModuleDescription_TriggerActivated_Server),
            CSTRING(ModuleDescription_Repeatable_False)
        };
        position = 0;
        direction = 0;
        sync[] = {
            "AnyPerson",
            "AnyPerson"
        };
    };
};
