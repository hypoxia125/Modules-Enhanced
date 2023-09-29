class MEH_ModuleTrapInventory: MEH_ModuleBase {
    scope = 2;
    displayName = CSTRING(ModuleTrapInventory_DisplayName);
    icon = "a3\ui_f_curator\data\rsccommon\rscattributeinventory\filter_6_ca.paa";
    category = "MEH";

    function = QFUNC(ModuleTrapInventory);
    functionPriority = 1;
    isGlobal = 1;
    isTriggerActivated = 0;
    isDisposable = 1;
    is3DEN = 0;

    class Attributes: AttributesBase {
        class ExplosiveType: Edit {
            property = QGVAR(ModuleTrapInventory_ExplosiveType);
            displayName = CSTRING(ModuleTrapInventory_ExplosiveType_DisplayName);
            tooltip = CSTRING(ModuleTrapInventory_ExplosiveType_Tooltip);
            defaultValue = "'GrenadeHand'";
            typeName = "STRING";
            validate = "STRING";
        };

        class ExplodeChance: Edit {
            property = QGVAR(ModuleTrapInventory_ExplodeChance);
            displayName = CSTRING(ModuleTrapInventory_ExplodeChance_DisplayName);
            tooltip = CSTRING(ModuleTrapInventory_ExplodeChance_Tooltip);
            defaultValue = 0.5;
            typeName = "NUMBER";
            validate = "NUMBER";
        };

        class CanDisable: Checkbox {
            property = QGVAR(ModuleTrapInventory_CanDisable);
            displayName = CSTRING(ModuleTrapInventory_CanDisable_DisplayName);
            tooltip = CSTRING(ModuleTrapInventory_CanDisable_Tooltip);
            defaultValue = 0;
            typeName = "BOOL";
        };

        class Persist: Checkbox {
            property = QGVAR(ModuleTrapInventory_Persist);
            displayName = CSTRING(ModuleTrapInventory_Persist_DisplayName);
            tooltip = CSTRING(ModuleTrapInventory_Persist_Tooltip);
            defaultValue = 0;
            typeName = "BOOL";
        }l

        class ModuleDescription: ModuleDescription {};
    };

    class ModuleDescription: ModuleDescription {
        description[] = {
            CSTRING(ModuleTrapInventory_ModuleDescription_Description),
            "",
            CSTRING(ModuleDescription_TriggerActivated_False),
            CSTRING(ModuleDescription_Repeatable_False)
        };
        position = 0;
        direction = 0;
        sync[] = {
            "Any",
            "Any"
        };
    };
};
