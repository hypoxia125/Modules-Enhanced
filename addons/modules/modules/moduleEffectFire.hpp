class MEH_ModuleEffectFire: MEH_ModuleBase {
    scope = 2;
    displayName = CSTRING(ModuleEffectFire_DisplayName);
    icon = "a3\ui_f\data\igui\cfg\actions\obsolete\ui_action_fire_in_flame_ca.paa";
    category = "MEH_Effects";

    function = QFUNC(ModuleEffectFire);
    functionPriority = 1;
    isGlobal = 2;
    isTriggerActivated = 1;
    isDisposable = 1;
    is3DEN = 1;

    class Attributes: AttributesBase {
        class ColorRed {
            control = "MEH_ModuleEffectFire_Colors";
            property = QGVAR(ModuleEffectFire_ColorRed);
            expression = "_this setVariable ['%s', _value, true]";
            displayName = CSTRING(ModuleEffectFire_ColorRed_DisplayName);
            tooltip = CSTRING(ModuleEffectFire_ColorRed_Tooltip);
            defaultValue = 0.5;
            typeName = "NUMBER";
        };

        class ColorGreen {
            control = "MEH_ModuleEffectFire_Colors";
            property = QGVAR(ModuleEffectFire_ColorGreen);
            expression = "_this setVariable ['%s', _value, true]";
            displayName = CSTRING(ModuleEffectFire_ColorGreen_DisplayName);
            tooltip = CSTRING(ModuleEffectFire_ColorGreen_Tooltip);
            defaultValue = 0.5;
            typeName = "NUMBER";
        };

        class ColorBlue {
            control = "MEH_ModuleEffectFire_Colors";
            property = QGVAR(ModuleEffectFire_ColorBlue);
            expression = "_this setVariable ['%s', _value, true]";
            displayName = CSTRING(ModuleEffectFire_ColorBlue_DisplayName);
            tooltip = CSTRING(ModuleEffectFire_ColorBlue_Tooltip);
            defaultValue = 0.5;
            typeName = "NUMBER";
        };

        class FireDamage: Edit {
            property = QGVAR(ModuleEffectFire_FireDamage);
            displayName = CSTRING(ModuleEffectFire_FireDamage_DisplayName);
            tooltip = CSTRING(ModuleEffectFire_FireDamage_Tooltip);
            defaultValue = 1;
            typeName = "NUMBER";
        };

        class EffectSize: Edit {
            property = QGVAR(ModuleEffectFire_EffectSize);
            displayName = CSTRING(ModuleEffectFire_EffectSize_DisplayName);
            tooltip = CSTRING(ModuleEffectFire_EffectSize_Tooltip);
            defaultValue = 1;
            typeName = "NUMBER";
        };

        class ParticleDensity: Edit {
            property = QGVAR(ModuleEffectFire_ParticleDensity);
            displayName = CSTRING(ModuleEffectFire_ParticleDensity_DisplayName);
            tooltip = CSTRING(ModuleEffectFire_ParticleDensity_Tooltip);
            defaultValue = 25;
            typeName = "NUMBER";
        };

        class ParticleTime: Edit {
            property = QGVAR(ModuleEffectFire_ParticleTime);
            displayName = CSTRING(ModuleEffectFire_ParticleTime_DisplayName);
            tooltip = CSTRING(ModuleEffectFire_ParticleTime_Tooltip);
            defaultValue = 0.6;
            typeName = "NUMBER";
        };

        class ParticleSize: Edit {
            property = QGVAR(ModuleEffectFire_ParticleSize);
            displayName = CSTRING(ModuleEffectFire_ParticleSize_DisplayName);
            tooltip = CSTRING(ModuleEffectFire_ParticleSize_Tooltip);
            defaultValue = 1;
            typeName = "NUMBER";
        };

        class ParticleSpeed: Edit {
            property = QGVAR(ModuleEffectFire_ParticleSpeed);
            displayName = CSTRING(ModuleEffectFire_ParticleSpeed_DisplayName);
            tooltip = CSTRING(ModuleEffectFire_ParticleSpeed_Tooltip);
            defaultValue = 1;
            typeName = "NUMBER";
        };

        class ParticleOrientation: Edit {
            control = "MEH_ModuleEffectFire_Orientation";
            property = QGVAR(ModuleEffectFire_ParticleOrientation);
            expression = "_this setVariable ['%s', _value, true]";
            displayName = CSTRING(ModuleEffectFire_ParticleOrientation_DisplayName);
            tooltip = CSTRING(ModuleEffectFire_ParticleOrientation_Tooltip);
            defaultValue = 0;
            typeName = "NUMBER";
        };

        class ModuleDescription: ModuleDescription {};
    };

    class ModuleDescription: ModuleDescription {
        description[] = {
            CSTRING(ModuleEffectFire_ModuleDescription_Description),
            "",
            CSTRING(ModuleDescription_TriggerActivated_Optional),
            CSTRING(ModuleDescription_TriggerActivated_Local),
            CSTRING(ModuleDescription_Repeatable_False)
        };
        position = 1;
        direction = 1;
    };
};
