class MEH_ModuleEffectLightpoint: MEH_ModuleBase {
    scope = 2;
    displayName = CSTRING(ModuleEffectLightpoint_DisplayName);
    icon = "a3\modules_f_curator\data\portraitflare_ca.paa";
    category = "MEH_Effects";

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

        class LightpointColorRed {
            control = "MEH_ModuleEffectFire_Colors";
            property = QGVAR(ModuleEffectLightpoint_LightpointColorRed);
            expression = "_this setVariable ['%s', _value, true]";
            displayName = "Lightpoint Color - Red";
            tooltip = "Red value for lightpoint color.";
            defaultValue = 1;
            typeName = "NUMBER";
        };

        class LightpointColorGreen {
            control = "MEH_ModuleEffectFire_Colors";
            property = QGVAR(ModuleEffectLightpoint_LightpointColorGreen);
            expression = "_this setVariable ['%s', _value, true]";
            displayName = "Lightpoint Color - Green";
            tooltip = "Green value for lightpoint color.";
            defaultValue = 1;
            typeName = "NUMBER";
        };

        class LightpointColorBlue {
            control = "MEH_ModuleEffectFire_Colors";
            property = QGVAR(ModuleEffectLightpoint_LightpointColorBlue);
            expression = "_this setVariable ['%s', _value, true]";
            displayName = "Lightpoint Color - Blue";
            tooltip = "Blue value for lightpoint color.";
            defaultValue = 1;
            typeName = "NUMBER";
        };

        class LightpointAmbientColorRed {
            control = "MEH_ModuleEffectFire_Colors";
            property = QGVAR(ModuleEffectLightpoint_LightpointAmbientColorRed);
            expression = "_this setVariable ['%s', _value, true]";
            displayName = "Lightpoint Ambient Color - Red";
            tooltip = "Red value for ambient color.";
            defaultValue = 1;
            typeName = "NUMBER";
        };

        class LightpointAmbientColorGreen {
            control = "MEH_ModuleEffectFire_Colors";
            property = QGVAR(ModuleEffectLightpoint_LightpointAmbientColorGreen);
            expression = "_this setVariable ['%s', _value, true]";
            displayName = "Lightpoint Ambient Color - Green";
            tooltip = "Green value for ambient color.";
            defaultValue = 1;
            typeName = "NUMBER";
        };

        class LightpointAmbientColorBlue {
            control = "MEH_ModuleEffectFire_Colors";
            property = QGVAR(ModuleEffectLightpoint_LightpointAmbientColorBlue);
            expression = "_this setVariable ['%s', _value, true]";
            displayName = "Lightpoint Ambient Color - Blue";
            tooltip = "Blue value for ambient color.";
            defaultValue = 1;
            typeName = "NUMBER";
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

        class LightconeColorRed {
            control = "MEH_ModuleEffectFire_Colors";
            property = QGVAR(ModuleEffectLightpoint_LightconeColorRed);
            expression = "_this setVariable ['%s', _value, true]";
            displayName = "Lightcone Color - Red";
            tooltip = "Red value for lightcone color.";
            defaultValue = 1;
            typeName = "NUMBER";
        };

        class LightconeColorGreen {
            control = "MEH_ModuleEffectFire_Colors";
            property = QGVAR(ModuleEffectLightpoint_LightconeColorGreen);
            expression = "_this setVariable ['%s', _value, true]";
            displayName = "Lightcone Color - Green";
            tooltip = "Green value for lightcone color.";
            defaultValue = 1;
            typeName = "NUMBER";
        };

        class LightconeColorBlue {
            control = "MEH_ModuleEffectFire_Colors";
            property = QGVAR(ModuleEffectLightpoint_LightconeColorBlue);
            expression = "_this setVariable ['%s', _value, true]";
            displayName = "Lightcone Color - Blue";
            tooltip = "Blue value for lightcone color.";
            defaultValue = 1;
            typeName = "NUMBER";
        };

        class LightconeAmbientColorRed {
            control = "MEH_ModuleEffectFire_Colors";
            property = QGVAR(ModuleEffectLightpoint_LightconeAmbientColorRed);
            expression = "_this setVariable ['%s', _value, true]";
            displayName = "Lightcone Ambient Color - Red";
            tooltip = "Red value for ambient color.";
            defaultValue = 1;
            typeName = "NUMBER";
        };

        class LightconeAmbientColorGreen {
            control = "MEH_ModuleEffectFire_Colors";
            property = QGVAR(ModuleEffectLightpoint_LightconeAmbientColorGreen);
            expression = "_this setVariable ['%s', _value, true]";
            displayName = "Lightcone Ambient Color - Green";
            tooltip = "Green value for ambient color.";
            defaultValue = 1;
            typeName = "NUMBER";
        };

        class LightconeAmbientColorBlue {
            control = "MEH_ModuleEffectFire_Colors";
            property = QGVAR(ModuleEffectLightpoint_LightconeAmbientColorBlue);
            expression = "_this setVariable ['%s', _value, true]";
            displayName = "Lightcone Ambient Color - Blue";
            tooltip = "Blue value for ambient color.";
            defaultValue = 1;
            typeName = "NUMBER";
        };

        class LightconeIntensity: Edit {
            property = QGVAR(ModuleEffectLightpoint_LightconeIntensity);
            displayName = CSTRING(ModuleEffectLightpoint_LightconeIntensity_DisplayName);
            tooltip = CSTRING(ModuleEffectLightpoint_LightconeIntensity_Tooltip);
            defaultValue = 1000;
            typeName = "NUMBER";
            validate = "NUMBER";
        };

        class LightconeOuter {
            control = "MEH_ModuleEffectLightpoint_LightconeParams";
            property = QGVAR(ModuleEffectLightpoint_LightconeOuter);
            expression = "_this setVariable ['%s', _value, true]";
            displayName = "Lightcone Outer Angle";
            tooltip = "The degrees of the outer edges from the center.";
            defaultValue = 120;
            typeName = "NUMBER";
        };

        class LightconeInner {
            control = "MEH_ModuleEffectLightpoint_LightconeParams";
            property = QGVAR(ModuleEffectLightpoint_LightconeInner);
            expression = "_this setVariable ['%s', _value, true]";
            displayName = "Lightcone Inner Angle";
            tooltip = "The degrees of the inner edges from the center.";
            defaultValue = 30;
            typeName = "NUMBER";
        };

        class LightconeFade: Edit {
            property = QGVAR(ModuleEffectLightpoint_LightconeFade);
            displayName = "Lightcone Fade Coef";
            tooltip = "How much the lightcone fades per a distance.";
            defaultValue = 1;
            typeName = "NUMBER";
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
