class MEH_ModuleEffectSmoke: MEH_ModuleBase {
    scope = 2;
    displayName = CSTRING(ModuleEffectSmoke_DisplayName);
    icon = "a3\modules_f_curator\data\iconsmoke_ca.paa";
    category = "MEH";

    function = QFUNC(ModuleEffectSmoke);
    functionPriority = 1;
    isGlobal = 2;
    isTriggerActivated = 1;
    isDisposable = 1;
    is3DEN = 1;

    class Attributes: AttributesBase {
        class Class: Combo {
            property = QGVAR(ModuleEffectSmoke_Class);
            displayName = CSTRING(ModuleEffectSmoke_Class_DisplayName);
            tooltip = CSTRING(ModuleEffectSmoke_Class_Tooltip);
            defaultValue = 0;
            typeName = "NUMBER";
            class Values {
                class Default {
                    name = CSTRING(ModulesEffectSmoke_Class_Values_Default_DisplayName);
                    value = 0;
                };
                class OilSmall {
                    name = CSTRING(ModulesEffectSmoke_Class_Values_OilSmall_DisplayName);
                    value = 1;
                };
                class OilMed {
                    name = CSTRING(ModulesEffectSmoke_Class_Values_OilMed_DisplayName);
                    value = 2;
                };
                class OilLrg {
                    name = CSTRING(ModulesEffectSmoke_Class_Values_OilLrg_DisplayName);
                    value = 3;
                };
                class WoodSmall {
                    name = CSTRING(ModulesEffectSmoke_Class_Values_WoodSmall_DisplayName);
                    value = 4;
                };
                class WoodMed {
                    name = CSTRING(ModulesEffectSmoke_Class_Values_WoodMed_DisplayName);
                    value = 5;
                };
                class WoodLrg {
                    name = CSTRING(ModulesEffectSmoke_Class_Values_WoodLrg_DisplayName);
                    value = 6;
                };
            };
        };

        class ColorRed: Edit {
            property = QGVAR(ModuleEffectSmoke_ColorRed);
            displayName = CSTRING(ModuleEffectSmoke_ColorRed_DisplayName);
            tooltip = CSTRING(ModuleEffectSmoke_ColorRed_Tooltip);
            defaultValue = 0.5;
            typeName = "NUMBER";
            validate = "NUMBER";
        };

        class ColorGreen: Edit {
            property = QGVAR(ModuleEffectSmoke_ColorGreen);
            displayName = CSTRING(ModuleEffectSmoke_ColorGreen_DisplayName);
            tooltip = CSTRING(ModuleEffectSmoke_ColorGreen_Tooltip);
            defaultValue = 0.5;
            typeName = "NUMBER";
            validate = "NUMBER";
        };

        class ColorBlue: Edit {
            property = QGVAR(ModuleEffectSmoke_ColorBlue);
            displayName = CSTRING(ModuleEffectSmoke_ColorBlue_DisplayName);
            tooltip = CSTRING(ModuleEffectSmoke_ColorBlue_Tooltip);
            defaultValue = 0.5;
            typeName = "NUMBER";
            validate = "NUMBER";
        };

        class ColorAlpha: Edit {
            property = QGVAR(ModuleEffectSmoke_ColorAlpha);
            displayName = CSTRING(ModuleEffectSmoke_ColorAlpha_DisplayName);
            tooltip = CSTRING(ModuleEffectSmoke_ColorAlpha_Tooltip);
            defaultValue = 0.5;
            typeName = "NUMBER";
            validate = "NUMBER";
        };

        class EffectSize: Edit {
            property = QGVAR(ModuleEffectSmoke_EffectSize);
            displayName = CSTRING(ModuleEffectSmoke_EffectSize_DisplayName);
            tooltip = CSTRING(ModuleEffectSmoke_EffectSize_Tooltip);
            defaultValue = 1;
            typeName = "NUMBER";
            validate = "NUMBER";
        };

        class ParticleDensity: Edit {
            property = QGVAR(ModuleEffectSmoke_ParticleDensity);
            displayName = CSTRING(ModuleEffectSmoke_ParticleDensity_DisplayName);
            tooltip = CSTRING(ModuleEffectSmoke_ParticleDensity_Tooltip);
            defaultValue = 10;
            typeName = "NUMBER";
            validate = "NUMBER";
        };

        class ParticleTime: Edit {
            property = QGVAR(ModuleEffectSmoke_ParticleTime);
            displayName = CSTRING(ModuleEffectSmoke_ParticleTime_DisplayName);
            tooltip = CSTRING(ModuleEffectSmoke_ParticleTime_Tooltip);
            defaultValue = 60;
            typeName = "NUMBER";
            validate = "NUMBER";
        };

        class ParticleSize: Edit {
            property = QGVAR(ModuleEffectSmoke_ParticleSize);
            displayName = CSTRING(ModuleEffectSmoke_ParticleSize_DisplayName);
            tooltip = CSTRING(ModuleEffectSmoke_ParticleSize_Tooltip);
            defaultValue = 1;
            typeName = "NUMBER";
            validate = "NUMBER";
        };

        class EffectExpansion: Edit {
            property = QGVAR(ModuleEffectSmoke_ParticleExpansion);
            displayName = CSTRING(ModuleEffectSmoke_ParticleExpansion_DisplayName);
            tooltip = CSTRING(ModuleEffectSmoke_ParticleExpansion_Tooltip);
            defaultValue = 1;
            typeName = "NUMBER";
            validate = "NUMBER";
        };

        class ParticleSpeed: Edit {
            property = QGVAR(ModuleEffectSmoke_ParticleSpeed);
            displayName = CSTRING(ModuleEffectSmoke_ParticleSpeed_DisplayName);
            tooltip = CSTRING(ModuleEffectSmoke_ParticleSpeed_Tooltip);
            defaultValue = 1;
            typeName = "NUMBER";
            validate = "NUMBER";
        };

        class ParticleLifting: Edit {
            property = QGVAR(ModuleEffectSmoke_ParticleLifting);
            displayName = CSTRING(ModuleEffectSmoke_ParticleLifting_DisplayName);
            tooltip = CSTRING(ModuleEffectSmoke_ParticleLifting_Tooltip);
            defaultValue = 1;
            typeName = "NUMBER";
            validate = "NUMBER";
        };

        class WindEffect: Edit {
            property = QGVAR(ModuleEffectSmoke_WindEffect);
            displayName = CSTRING(ModuleEffectSmoke_WindEffect_DisplayName);
            tooltip = CSTRING(ModuleEffectSmoke_WindEffect_Tooltip);
            defaultValue = 1;
            typeName = "NUMBER";
            validate = "NUMBER";
        };

        class ModuleDescription: ModuleDescription {};
    };

    class ModuleDescription: ModuleDescription {
        description[] = {
            CSTRING(ModuleEffectSmoke_ModuleDescription_Description),
            "",
            CSTRING(ModuleDescription_TriggerActivated_Optional),
            CSTRING(ModuleDescription_TriggerActivated_Local),
            CSTRING(ModuleDescription_Repeatable_False)
        };
        position = 1;
        direction = 1;
    };
};
