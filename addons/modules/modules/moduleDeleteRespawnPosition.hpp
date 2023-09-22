class MEH_moduleDeleteRespawnPosition: Module_F {
    scope = 2;
    displayName = CSTRING(ModuleDeleteRespawnPosition_DisplayName);
    icon = "a3\ui_f\data\map\diary\icons\diaryunassigntask_ca.paa"; // Todo: Add image
    category = "Multiplayer";

    function = QFUNC(ModuleDeleteRespawnPosition);
    functionPriority = 1;
    isGlobal = 0;
    isTriggerActivated = 1;
    isDisposable = 1;
    is3DEN = 0;

    class Attributes: AttributesBase {
        class ModuleDescription: ModuleDescription {};
    };

    class ModuleDescription: ModuleDescription {
        displayName = CSTRING(ModuleDeleteRespawnPosition_ModuleDescription_Description);
        position = 0;
        direction = 0;
        duplicate = 1;
        sync[] = {
            "ModuleRespawnPosition_F"
        };
    };
};