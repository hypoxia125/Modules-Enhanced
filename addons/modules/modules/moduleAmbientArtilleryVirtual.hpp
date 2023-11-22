class MEH_ModuleAmbientArtilleryVirtual: MEH_ModuleBase {
    scope = 2;
    displayName = CSTRING(ModuleAmbientArtilleryVirtual_DisplayName);
    icon = "a3\ui_f\data\gui\cfg\communicationmenu\artillery_ca.paa";
    category = "MEH";

    function = QFUNC(ModuleAmbientArtilleryVirtual);
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
        class Shell: Edit {
            property = QGVAR(ModuleAmbientArtilleryVirtual_Shell);
            displayName = CSTRING(ModuleAmbientArtilleryVirtual_Shell_DisplayName);
            tooltip = CSTRING(ModuleAmbientArtilleryVirtual_Shell_Tooltip);
            defaultValue = "'Sh_82mm_AMOS'";
            typeName = "STRING";
            validate = "STRING";
        };

        class SalvoSize: Edit {
            property = QGVAR(ModuleAmbientArtilleryVirtual_SalvoSize);
            displayName = CSTRING(ModuleAmbientArtilleryVirtual_SalvoSize_DisplayName);
            tooltip = CSTRING(ModuleAmbientArtilleryVirtual_SalvoSize_Tooltip);
            defaultValue = 6;
            typeName = "NUMBER";
            validate = "NUMBER";
        };

        class SalvoInterval: Edit {
            property = QGVAR(ModuleAmbientArtilleryVirtual_SalvoInterval);
            displayName = CSTRING(ModuleAmbientArtilleryVirtual_SalvoInterval_DisplayName);
            tooltip = CSTRING(ModuleAmbientArtilleryVirtual_SalvoInterval_Tooltip);
            defaultValue = 10;
            typeName = "NUMBER";
            validate = "NUMBER";
        };

        class SalvoTimeVariation: Edit {
            property = QGVAR(ModuleAmbientArtilleryVirtual_SalvoTimeVariation);
            displayName = CSTRING(ModuleAmbientArtilleryVirtual_SalvoTimeVariation_DisplayName);
            tooltip = CSTRING(ModuleAmbientArtilleryVirtual_SalvoTimeVariation_Tooltip);
            defaultValue = 5;
            typeName = "NUMBER";
            validate = "NUMBER";
        };

        class ShotInterval: Edit {
            property = QGVAR(ModuleAmbientArtilleryVirtual_ShotInterval);
            displayName = CSTRING(ModuleAmbientArtilleryVirtual_ShotInterval_DisplayName);
            tooltip = CSTRING(ModuleAmbientArtilleryVirtual_ShotInterval_Tooltip);
            defaultValue = 1;
            typeName = "NUMBER";
            validate = "NUMBER";
        };

        class ShotTimeVariation: Edit {
            property = QGVAR(ModuleAmbientArtilleryVirtual_ShotTimeVariation);
            displayName = CSTRING(ModuleAmbientArtilleryVirtual_ShotTimeVariation_DisplayName);
            tooltip = CSTRING(ModuleAmbientArtilleryVirtual_ShotTimeVariation_Tooltip);
            defaultValue = 1;
            typeName = "NUMBER";
            validate = "NUMBER";
        };

        class ModuleDescription: ModuleDescription {};
    };

    class ModuleDescription: ModuleDescription {
        description[] = {
            CSTRING(ModuleAmbientArtilleryVirtual_ModuleDescription_Description),
            "",
            CSTRING(ModuleDescription_TriggerActivated_Optional),
            CSTRING(ModuleDescription_TriggerActivated_Server),
            CSTRING(ModuleDescription_Repeatable_True)
        };
        position = 1;
        direction = 1;
    };
};
