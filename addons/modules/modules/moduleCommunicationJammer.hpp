class MEH_ModuleCommunicationJammer: MEH_ModuleBase {
    scope = 2;
    displayName = CSTRING(ModuleCommunicationJammer_DisplayName);
    icon = "a3\ui_f\data\gui\rsc\rscdisplayarsenal\radio_ca.paa";
    category = "MEH";

    function = QFUNC(ModuleCommunicationJammer);
    functionPriority = 1;
    isGlobal = 2;
    isTriggerActivated = 0;
    isDisposable = 1;
    is3DEN = 1;

    canSetArea = 1;
    canSetAreaShape = 1;
    canSetAreaHeight = 1;
    class AttributeValues {
        size3[] = {100, 100, 100};
        isRectangle = 0;
    };

    class Attributes: AttributesBase {
        class ModuleDescription: ModuleDescription {};
    };

    class ModuleDescription: ModuleDescription {
        description[] = {
            CSTRING(ModuleCommunicationJammer_ModuleDescription_Description),
            "",
            CSTRING(ModuleDescription_TriggerActivated_False),
            CSTRING(ModuleDescription_Repeatable_False)
        };
        position = 1;
        direction = 1;
    };
};