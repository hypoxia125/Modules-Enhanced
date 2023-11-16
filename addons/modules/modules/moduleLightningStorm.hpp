class MEH_ModuleLightningStorm: MEH_ModuleBase {
    scope = 2;
    displayName = CSTRING(ModuleLightningStorm_DisplayName);
    icon = "a3\modules_f_curator\data\portraitlightning_ca.paa";
    category = "MEH";

    function = QFUNC(ModuleLightningStorm);
    functionPriority = 1;
    isGlobal = 0;
    isTriggerActivated = 1;
    isDisposable = 0;
    is3DEN = 1;

    canSetArea = 1;
    canSetAreaShape = 1;
    class AttributeValues {
        size3[] = {100, 100, -1};
        isRectangle = 0;
    };

    class Attributes: AttributesBase {
        class TimeBetweenStrikes: Edit {
            property = QGVAR(ModuleLightningStorm_TimeBetweenStrikes);
            displayName = CSTRING(ModuleLightningStorm_TimeBetweenStrikes_DisplayName);
            tooltip = CSTRING(ModuleLightningStorm_TimeBetweenStrikes_Tooltip);
            defaultValue = "0.25";
            typeName = "NUMBER";
            validate = "NUMBER";
        };

        class StrikeRandomness: Edit {
            property = QGVAR(ModuleLightningStorm_StrikeRandomness);
            displayName = CSTRING(ModuleLightningStorm_StrikeRandomness_DisplayName);
            tooltip = CSTRING(ModuleLightningStorm_StrikeRandomness_Tooltip);
            defaultValue = "0.5";
            typeName = "NUMBER";
            validate = "NUMBER";
        };

        class AreaDamage: Edit {
            property = QGVAR(ModuleLightningStorm_AreaDamage);
            displayName = CSTRING(ModuleLightningStorm_AreaDamage_DisplayName);
            tooltip = CSTRING(ModuleLightningStorm_AreaDamage_Tooltip);
            defaultValue = "15";
            typeName = "NUMBER";
            validate = "NUMBER";
        };

        class ModuleDescription: ModuleDescription {};
    };

    class ModuleDescription: ModuleDescription {
        description[] = {
            CSTRING(ModuleLightningStorm_ModuleDescription_Description),
            "",
            CSTRING(ModuleDescription_TriggerActivated_Optional),
            CSTRING(ModuleDescription_TriggerActivated_Server),
            CSTRING(ModuleDescription_Repeatable_True)
        };
        position = 1;
        direction = 1;
    };
};