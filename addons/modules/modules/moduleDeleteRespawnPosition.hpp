class MEH_ModuleDeleteRespawnPosition: MEH_ModuleBase {
    scope = 2;
    displayName = CSTRING(ModuleDeleteRespawnPosition_DisplayName);
    icon = "a3\ui_f\data\igui\cfg\actions\obsolete\ui_action_cancel_ca.paa";
    category = "MEH_MultiplayerSystems";

    function = QFUNC(ModuleDeleteRespawnPosition);
    functionPriority = 1;
    isGlobal = 0;
    isTriggerActivated = 1;
    isDisposable = 1;
    is3DEN = 1;

    class Attributes: AttributesBase {
        class ModuleDescription: ModuleDescription {};
    };

    class ModuleDescription: ModuleDescription {
        description[] = {
            CSTRING(ModuleDeleteRespawnPosition_ModuleDescription_Description),
            "",
            CSTRING(ModuleDescription_TriggerActivated_True),
            CSTRING(ModuleDescription_TriggerActivated_Server),
            CSTRING(ModuleDescription_Repeatable_False)
        };
        sync[] = {
            "ModuleRespawnPosition_F",
            "ModuleRespawnPosition_F"
        };

        class ModuleRespawnPosition_F {
            position = 0;
            direction = 0;
            duplicate = 1;
        };
    };
};
