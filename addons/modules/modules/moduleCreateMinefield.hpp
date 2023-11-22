class MEH_ModuleCreateMinefield: MEH_ModuleBase {
    scope = 2;
    displayName = CSTRING(ModuleCreateMinefield_DisplayName);
    icon = "a3\ui_f\data\igui\cfg\simpletasks\types\mine_ca.paa";
    category = "MEH";

    function = QFUNC(ModuleCreateMinefield);
    functionPriority = 1;
    isGlobal = 0;
    isTriggerActivated = 0;
    isDisposable = 0;
    is3DEN = 1;

    canSetArea = 1;
    canSetAreaShape = 1;
    class AttributeValues {
        size3[] = {50, 50, -1};
        isRectangle = 0;
    };

    class Attributes: AttributesBase {
        class PlacedBy: Combo {
            property = QGVAR(ModuleCreateMinefield_PlacedBy);
            displayName = CSTRING(ModuleCreateMinefield_PlacedBy_DisplayName);
            tooltip = CSTRING(ModuleCreateMinefield_PlacedBy_Tooltip);
            defaultValue = 4;
            typeName = "NUMBER";
            class Values {
                class East {
                    name = CSTRING(ModuleCreateMinefield_PlacedBy_Values_East_Name);
                    value = 0;
                };
                class West {
                    name = CSTRING(ModuleCreateMinefield_PlacedBy_Values_West_Name);
                    value = 1;
                };
                class Independent {
                    name = CSTRING(ModuleCreateMinefield_PlacedBy_Values_Independent_Name);
                    value = 2;
                };
                class Civilian {
                    name = CSTRING(ModuleCreateMinefield_PlacedBy_Values_Civilian_Name);
                    value = 3;
                };
                class Unknown {
                    name = CSTRING(ModuleCreateMinefield_PlacedBy_Values_Unknown_Name);
                    value = 4;
                };
            };
        };

        class MineClasses: Edit {
            property = QGVAR(ModuleCreateMinefield_MineClasses);
            displayName = CSTRING(ModuleCreateMinefield_MineClasses_DisplayName);
            tooltip = CSTRING(ModuleCreateMinefield_MineClasses_Tooltip);
            defaultValue = """[""""APERSMine""""]""";
            typeName = "STRING";
            validate = "STRING";
        };

        class MineDensity: Edit {
            property = QGVAR(ModuleCreateMinefield_MineDensity);
            displayName = CSTRING(ModuleCreateMinefield_MineDensity_DisplayName);
            tooltip = CSTRING(ModuleCreateMinefield_MineDensity_Tooltip);
            defaultValue = 10;
            typeName = "NUMBER";
            validate = "NUMBER";
        };

        class MarkMap: Combo {
            property = QGVAR(ModuleCreateMinefield_MarkMap);
            displayName = CSTRING(ModuleCreateMinefield_MarkMap_DisplayName);
            tooltip = CSTRING(ModuleCreateMinefield_MarkMap_Tooltip);
            defaultValue = 0;
            typeName = "NUMBER";
            class Values {
                class None {
                    name = CSTRING(ModuleCreateMinefield_MarkMap_Values_None_Name);
                    value = 0;
                };

                class Allies {
                    name = CSTRING(ModuleCreateMinefield_MarkMap_Values_Allies_Name);
                    value = 1;
                };

                class Everyone {
                    name = CSTRING(ModuleCreateMinefield_MarkMap_Values_Everyone_Name);
                    value = 2;
                };
            };
        };

        class ModuleDescription: ModuleDescription {};
    };

    class ModuleDescription: ModuleDescription {
        description[] = {
            CSTRING(ModuleCreateMinefield_ModuleDescription_Description),
            "",
            CSTRING(ModuleDescription_TriggerActivated_False),
            CSTRING(ModuleDescription_Repeatable_False)
        };
        position = 1;
        direction = 1;
    };
};
