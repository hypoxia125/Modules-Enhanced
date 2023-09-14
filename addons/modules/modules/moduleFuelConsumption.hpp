class MEH_ModuleFuelConsumption: Module_F {
    scope = 2;
    displayName = CSTRING(ModuleFuelConsumption_DisplayName);
    icon = "a3\armor_f_decade\mbt_02\data\ui\lowfuel_ca.paa";
    category = "MEH";

    function = QFUNC(FuelConsumption);
    functionPriority = 1;
    isGlobal = 0;
    isTriggerActivated = 0;
    isDisposable = 0;
    is3DEN = 0;
    
    class Attributes: AttributesBase {
        class GVAR(ModuleFuelConsumption_MaxTime): Edit {
            property = QGVAR(ModuleFuelConsumption_MaxTime);
            displayName = CSTRING(ModuleFuelConsumption_MaxTime_DisplayName);
            tooltip = CSTRING(ModuleFuelConsumption_MaxTime_Tooltip);
            defaultValue = 20;
            typeName = "NUMBER";
        };

        class GVAR(ModuleFuelConsumption_IdleTime): Edit {
            property = QGVAR(ModuleFuelConsumption_IdleTime);
            displayName = CSTRING(ModuleFuelConsumption_IdleTime_DisplayName);
            tooltip = CSTRING(ModuleFuelConsumption_IdleTime_Tooltip);
            defaultValue = 60;
            typeName = "NUMBER";
        };

        class GVAR(ModuleFuelConsumption_TickRate): Edit {
            property = QGVAR(ModuleFuelConsumption_Rate);
            displayName = CSTRING(ModuleFuelConsumption_Rate_DisplayName);
            tooltip = CSTRING(ModuleFuelConsumption_Rate_Tooltip);
            defaultValue = 1;
            typeName = "NUMBER";
        };

        class ModuleDescription: ModuleDescription {};
    };

    class ModuleDescription: ModuleDescription {
        description = CSTRING(ModuleFuelConsumption_ModuleDescription_Description);
        position = 0;
        direction = 0;
        duplicate = 1;
    };
};