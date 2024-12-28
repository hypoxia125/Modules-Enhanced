class MEH_ModuleLightningStorm: MEH_ModuleBase {
    scope = 2;
    displayName = CSTRING(ModuleLightningStorm_DisplayName);
    icon = "a3\modules_f_curator\data\portraitlightning_ca.paa";
    category = "MEH_Effects";

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
            defaultValue = 5;
            typeName = "NUMBER";
        };

        class StrikeRandomness {
            control = "MEH_ModuleLightning_StrikeTiming";
            property = QGVAR(ModuleLightningStorm_StrikeRandomness);
            displayName = CSTRING(ModuleLightningStorm_StrikeRandomness_DisplayName);
            expression = "_this setVariable ['%s', _value, true]";
            tooltip = "Specifies the percentage of randomness applied to the base interval between strikees. The interval will vary within a range calculated as ±X% of the base interval. For example, if the base interval is 30 seconds and randomness is 20%, the strike interval will vary between 24 and 36 seconds. Use this parameter to simulate unpredictability in strike timing.";
            defaultValue = 1;
            typeName = "NUMBER";
        };

        class AreaDamage {
            control = "MEH_ModuleLightning_DamageArea";
            property = QGVAR(ModuleLightningStorm_AreaDamage);
            displayName = CSTRING(ModuleLightningStorm_AreaDamage_DisplayName);
            expression = "_this setVariable ['%s', _value, true]";
            tooltip = CSTRING(ModuleLightningStorm_AreaDamage_Tooltip);
            defaultValue = 15;
            typeName = "NUMBER";
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
