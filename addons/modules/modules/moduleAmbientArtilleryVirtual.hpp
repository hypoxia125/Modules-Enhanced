class MEH_ModuleAmbientArtilleryVirtual: MEH_ModuleBase {
    scope = 2;
    displayName = CSTRING(ModuleAmbientArtilleryVirtual_DisplayName);
    icon = "a3\ui_f\data\gui\cfg\communicationmenu\artillery_ca.paa";
    category = "MEH_Effects";

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
            defaultValue = QUOTE(AMBIENTARTILLERYVIRTUAL_SHELL);
            typeName = "STRING";
            validate = "STRING";
        };

        class TimeLength {
            control = "MEH_ModuleAmbientArtilleryVirtual_TimeLength";
            expression = "_this setVariable ['%s', _value, true]";
            property = QGVAR(ModuleAmbientArtilleryVirtual_TimeLength);
            displayName = "Length of Barrage";
            defaultValue = AMBIENTARTILLERYVIRTUAL_TIMELENGTH;
            typeName = "NUMBER";
            validate = "NUMBER";
        };

        class SalvoSize: Edit {
            property = QGVAR(ModuleAmbientArtilleryVirtual_SalvoSize);
            displayName = CSTRING(ModuleAmbientArtilleryVirtual_SalvoSize_DisplayName);
            tooltip = CSTRING(ModuleAmbientArtilleryVirtual_SalvoSize_Tooltip);
            defaultValue = AMBIENTARTILLERYVIRTUAL_SALVOSIZE;
            typeName = "NUMBER";
            validate = "NUMBER";
        };

        class SalvoInterval: Edit {
            property = QGVAR(ModuleAmbientArtilleryVirtual_SalvoInterval);
            displayName = CSTRING(ModuleAmbientArtilleryVirtual_SalvoInterval_DisplayName);
            tooltip = CSTRING(ModuleAmbientArtilleryVirtual_SalvoInterval_Tooltip);
            defaultValue = AMBIENTARTILLERYVIRTUAL_SALVOINTERVAL;
            typeName = "NUMBER";
            validate = "NUMBER";
        };

        class SalvoTimeVariation: Edit {
            property = QGVAR(ModuleAmbientArtilleryVirtual_SalvoTimeVariation);
            displayName = CSTRING(ModuleAmbientArtilleryVirtual_SalvoTimeVariation_DisplayName);
            tooltip = CSTRING(ModuleAmbientArtilleryVirtual_SalvoTimeVariation_Tooltip);
            defaultValue = AMBIENTARTILLERYVIRTUAL_SALVOTIMERVARIATION;
            typeName = "NUMBER";
            validate = "NUMBER";
        };

        class ShotInterval: Edit {
            property = QGVAR(ModuleAmbientArtilleryVirtual_ShotInterval);
            displayName = CSTRING(ModuleAmbientArtilleryVirtual_ShotInterval_DisplayName);
            tooltip = CSTRING(ModuleAmbientArtilleryVirtual_ShotInterval_Tooltip);
            defaultValue = AMBIENTARTILLERYVIRTUAL_SHOTINTERVAL;
            typeName = "NUMBER";
            validate = "NUMBER";
        };

        class ShotTimeVariation: Edit {
            property = QGVAR(ModuleAmbientArtilleryVirtual_ShotTimeVariation);
            displayName = CSTRING(ModuleAmbientArtilleryVirtual_ShotTimeVariation_DisplayName);
            tooltip = CSTRING(ModuleAmbientArtilleryVirtual_ShotTimeVariation_Tooltip);
            defaultValue = AMBIENTARTILLERYVIRTUAL_SHOTTIMEVARIATION;
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
