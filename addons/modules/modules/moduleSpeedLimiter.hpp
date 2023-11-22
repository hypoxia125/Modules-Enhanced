class MEH_ModuleSpeedLimiter: MEH_ModuleBase {
    scope = 2;
    displayName = CSTRING(ModuleSpeedLimiter_DisplayName);
    icon = "\z\meh\addons\modules\data\iconSpeedLimiter_ca.paa";
    category = "MEH";

    function = QFUNC(ModuleSpeedLimiter);
    functionPriority = 1;
    isGlobal = 0;
    isTriggerActivated = 1;
    isDisposable = 1;
    is3DEN = 1;

    class Attributes: AttributesBase {
        class Speed: Edit {
            property = QGVAR(ModuleSpeedLimiter_Speed);
            displayName = CSTRING(ModuleSpeedLimiter_Speed_DisplayName);
            tooltip = CSTRING(ModuleSpeedLimiter_Speed_Tooltip);
            defaultValue = 0;
            typeName = "NUMBER";
            verify = "NUMBER";
        };

        class AffectPlayer: Checkbox {
            property = QGVAR(ModuleSpeedLimiter_AffectPlayer);
            displayName = CSTRING(ModuleSpeedLimiter_AffectPlayer_DisplayName);
            tooltip = CSTRING(ModuleSpeedLimiter_AffectPlayer_Tooltip);
            defaultValue = "true";
            typeName = "BOOL";
        };

        class AffectAI: Checkbox {
            property = QGVAR(ModuleSpeedLimiter_AffectAI);
            displayName = CSTRING(ModuleSpeedLimiter_AffectAI_DisplayName);
            tooltip = CSTRING(ModuleSpeedLimiter_AffectAI_Tooltip);
            defaultValue = "true";
            typeName = "BOOL";
        };

        class ModuleDescription: ModuleDescription {};
    };

    class ModuleDescription: ModuleDescription {
        description[] = {
            CSTRING(ModuleSpeedLimiter_ModuleDescription_Description),
            "",
            CSTRING(ModuleDescription_TriggerActivated_Optional),
            CSTRING(ModuleDescription_TriggerActivated_Server),
            CSTRING(ModuleDescription_Repeatable_False)
        };
        position = 0;
        direction = 0;
        sync[] = {
            "AnyVehicle",
            "AnyVehicle"
        };
    };
};
