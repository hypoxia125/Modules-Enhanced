class MEH_ModuleEffectLightpoint: MEH_ModuleBase {
    scope = 2;
    displayName = CSTRING(ModuleEffectLightpoint_DisplayName);
    icon = "a3\modules_f_curator\data\portraitflare_ca.paa";
    category = "MEH";

    function = QFUNC(ModuleEffectLightpoint);
    functionPriority = 1;
    isGlobal = 2;
    isTriggerActivated = 1;
    isDisposable = 1;
    is3DEN = 1;

    class Attributes: AttributesBase {
        class UseLightpoint: Checkbox {
            property = QGVAR(ModuleEffectLightpoint_UseLightpoint);
            displayName = CSTRING(ModuleEffectLightpoint_UseLightpoint_DisplayName);
            tooltip = CSTRING(ModuleEffectLightpoint_UseLightpoint_Tooltip);
            defaultValue = "true";
            typeName = "BOOL";
        };

        class LightpointColor: Edit {
            property = QGVAR(ModuleEffectLightpoint_LightpointColor);
            displayName = CSTRING(ModuleEffectLightpoint_LightpointColor_DisplayName);
            tooltip = CSTRING(ModuleEffectLightpoint_LightpointColor_Tooltip);
            defaultValue = "'[1,1,1]'";
            typeName = "STRING";
            validate = "STRING";
        };

        class LightpointAmbientColor: Edit {
            property = QGVAR(ModuleEffectLightpoint_LightpointAmbientColor);
            displayName = CSTRING(ModuleEffectLightpoint_LightpointAmbientColor_DisplayName);
            tooltip = CSTRING(ModuleEffectLightpoint_LightpointAmbientColor_Tooltip);
            defaultValue = "'[1,1,1]'";
            typeName = "STRING";
            validate = "STRING";
        };

        class LightpointIntensity: Edit {
            property = QGVAR(ModuleEffectLightpoint_LightpointIntensity);
            displayName = CSTRING(ModuleEffectLightpoint_LightpointIntensity_DisplayName);
            tooltip = CSTRING(ModuleEffectLightpoint_LightpointIntensity_Tooltip);
            defaultValue = 500;
            typeName = "NUMBER";
            validate = "NUMBER";
        };

        class ShowDaytime: Checkbox {
            property = QGVAR(ModuleEffectLightpoint_ShowDaytime);
            displayName = CSTRING(ModuleEffectLightpoint_ShowDaytime_DisplayName);
            tooltip = CSTRING(ModuleEffectLightpoint_ShowDaytime_Tooltip);
            defaultValue = "true";
            typeName = "BOOL";
        };

        class UseFlare: Checkbox {
            property = QGVAR(ModuleEffectLightpoint_UseFlare);
            displayName = CSTRING(ModuleEffectLightpoint_UseFlare_DisplayName);
            tooltip = CSTRING(ModuleEffectLightpoint_UseFlare_Tooltip);
            defaultValue = "true";
            typeName = "BOOL";
        };

        class FlareSize: Edit {
            property = QGVAR(ModuleEffectLightpoint_FlareSize);
            displayName = CSTRING(ModuleEffectLightpoint_FlareSize_DisplayName);
            tooltip = CSTRING(ModuleEffectLightpoint_FlareSize_Tooltip);
            defaultValue = 0.5;
            typeName = "NUMBER";
            validate = "NUMBER";
        };

        class FlareMaxDistance: Edit {
            property = QGVAR(ModuleEffectLightpoint_FlareMaxDistance);
            displayName = CSTRING(ModuleEffectLightpoint_FlareMaxDistance_DisplayName);
            tooltip = CSTRING(ModuleEffectLightpoint_FlareMaxDistance_Tooltip);
            defaultValue = 250;
            typeName = "NUMBER";
            validate = "NUMBER";
        };

        class UseLightcone: Checkbox {
            property = QGVAR(ModuleEffectLightpoint_UseLightcone);
            displayName = CSTRING(ModuleEffectLightpoint_UseLightcone_DisplayName);
            tooltip = CSTRING(ModuleEffectLightpoint_UseLightcone_Tooltip);
            defaultValue = "false";
            typeName = "BOOL";
        };

        class LightconeColor: Edit {
            property = QGVAR(ModuleEffectLightpoint_LightconeColor);
            displayName = CSTRING(ModuleEffectLightpoint_LightconeColor_DisplayName);
            tooltip = CSTRING(ModuleEffectLightpoint_LightconeColor_Tooltip);
            defaultValue = "'[1,1,1]'";
            typeName = "STRING";
            validate = "STRING";
        };

        class LightconeAmbientColor: Edit {
            property = QGVAR(ModuleEffectLightpoint_LightconeAmbientColor);
            displayName = CSTRING(ModuleEffectLightpoint_LightconeAmbientColor_DisplayName);
            tooltip = CSTRING(ModuleEffectLightpoint_LightconeAmbientColor_Tooltip);
            defaultValue = "'[1,1,1]'";
            typeName = "STRING";
            validate = "STRING";
        };

        class LightconeIntensity: Edit {
            property = QGVAR(ModuleEffectLightpoint_LightconeIntensity);
            displayName = CSTRING(ModuleEffectLightpoint_LightconeIntensity_DisplayName);
            tooltip = CSTRING(ModuleEffectLightpoint_LightconeIntensity_Tooltip);
            defaultValue = 1000;
            typeName = "NUMBER";
            validate = "NUMBER";
        };

        class LightconePars: Edit {
            property = QGVAR(ModuleEffectLightpoint_LightconePars);
            displayName = CSTRING(ModuleEffectLightpoint_LightconePars_DisplayName);
            tooltip = CSTRING(ModuleEffectLightpoint_LightconePars_Tooltip);
            defaultValue = "'[120,30,1]'";
            typeName = "STRING";
            validate = "STRING";
        };

        class ModuleDescription: ModuleDescription {};
    };
    
    class ModuleDescription: ModuleDescription {
        description[] = {
            CSTRING(ModuleEffectLightpoint_ModuleDescription_Description),
            "",
            CSTRING(ModuleDescription_TriggerActivated_Optional),
            CSTRING(ModuleDescription_TriggerActivated_Local),
            CSTRING(ModuleDescription_Repeatable_False)
        };
        position = 1;
        direction = 1;
    };
};
