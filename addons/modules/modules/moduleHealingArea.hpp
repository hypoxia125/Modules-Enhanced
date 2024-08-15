class MEH_ModuleHealingArea: MEH_ModuleBase {
    scope = 2;
    displayName = CSTRING(ModuleHealingArea_DisplayName); // TODO: localize
    icon = "a3\ui_f\data\igui\cfg\actions\heal_ca.paa";
    category = "MEH";

    function = QFUNC(ModuleHealingArea);
    functionPriority = 1;
    isGlobal = 0;
    isTriggerActivated = 0;
    isDisposable = 1;
    is3DEN = 1;

    canSetArea = 1;
    canSetAreaShape = 1;
    class AttributeValues {
        size3[] = {20, 20, -1};
        isRectangle = 0;
    };

    class Attributes: AttributesBase {
        class Affected: Combo {
            property = QGVAR(ModuleHealingArea_Class);
            displayName = CSTRING(ModuleHealingArea_Affected_DisplayName);
            tooltip = CSTRING(ModuleHealingArea_Affected_Tooltip);
            defaultValue = 0;
            typeName = "NUMBER";
            class Values {
                class FootSoldiers {
                    name = CSTRING(ModuleHealingArea_Affected_Values_FootSoldiers_DisplayName);
                    value = 0;
                };
                // class Vehicles {
                //     name = "Vehicles" // TODO: localize
                //     value = 1;
                // };
            };
        };

        class Rate: Edit {
            property = QGVAR(ModuleHealingArea_Rate);
            displayName = CSTRING(ModuleHealingArea_Rate_DisplayName);
            tooltip = CSTRING(ModuleHealingArea_Rate_Tooltip);
            defaultValue = 0.10;
            typeName = "NUMBER";
            validate = "NUMBER";
        };

        // class ShowArea: Checkbox {
        //     property = QGVAR(ModuleHealingArea_ShowArea);
        //     displayName = "Show Area"; // TODO: localize
        //     tooltip = "Shows physical area in 3D when in game."; // TODO: localize
        //     defaultValue = "true";
        //     typeName = "BOOL";
        // };

        class ModuleDescription: ModuleDescription {};
    };

    class ModuleDescription: ModuleDescription {
        description[] = {
            CSTRING(ModuleHealingArea_ModuleDescription_Description),
            "",
            CSTRING(MEH_Modules_ModuleDescription_TriggerActivated_False),
            CSTRING(ModuleDescription_Repeatable_False)
        };
        position = 1;
        direction = 1;
    };
};