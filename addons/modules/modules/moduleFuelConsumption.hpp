class MEH_ModuleFuelConsumption: MEH_ModuleBase {
    scope = 2;
    displayName = CSTRING(ModuleFuelConsumption_DisplayName);
    icon = "a3\armor_f_decade\mbt_02\data\ui\lowfuel_ca.paa";
    category = "MEH";

    function = QFUNC(ModuleFuelConsumption);
    functionPriority = 1;
    isGlobal = 0;
    isTriggerActivated = 0;
    isDisposable = 1;
    is3DEN = 0;
    
    class Attributes: AttributesBase {
        class MaxTime: Edit {
            property = QGVAR(ModuleFuelConsumption_MaxTime);
            displayName = CSTRING(ModuleFuelConsumption_MaxTime_DisplayName);
            tooltip = CSTRING(ModuleFuelConsumption_MaxTime_Tooltip);
            defaultValue = 20;
            typeName = "NUMBER";
        };

        class IdleTime: Edit {
            property = QGVAR(ModuleFuelConsumption_IdleTime);
            displayName = CSTRING(ModuleFuelConsumption_IdleTime_DisplayName);
            tooltip = CSTRING(ModuleFuelConsumption_IdleTime_Tooltip);
            defaultValue = 60;
            typeName = "NUMBER";
        };

        class TickRate: Edit {
            property = QGVAR(ModuleFuelConsumption_Rate);
            displayName = CSTRING(ModuleFuelConsumption_Rate_DisplayName);
            tooltip = CSTRING(ModuleFuelConsumption_Rate_Tooltip);
            defaultValue = 1;
            typeName = "NUMBER";
        };

        class ModuleDescription: ModuleDescription {};
    };

    class ModuleDescription: ModuleDescription {
        description[] = {
            CSTRING(ModuleFuelConsumption_ModuleDescription_Description),
            "",
            CSTRING(ModuleDescription_TriggerActivated_False),
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