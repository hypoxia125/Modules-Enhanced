class MEH_ModuleVehicleRefuel: Module_F {
    scope = 2;
    displayName = CSTRING(ModuleVehicleRefuel_DisplayName);
    icon = "a3\ui_f\data\igui\cfg\simpletasks\types\refuel_ca.paa";
    category = "MEH";

    function = QFUNC(VehicleRefuel);
    functionPriority = 1;
    isGlobal = 0;
    isTriggerActivated = 1;
    isDisposable = 1;
    is3DEN = 0;

    class Attributes: AttributesBase {
        class Repeatable: Checkbox {
            property = QGVAR(ModuleVehicleRefuel_Repeatable);
            displayName = CSTRING(ModuleVehicleRefuel_Repeatable_DisplayName);
            tooltip = CSTRING(ModuleVehicleRefuel_Repeatable_Tooltip);
            defaultValue = 1;
            typeName = "BOOL";
        };

        class TimeDelay: Edit {
            property = QGVAR(ModuleVehicleRefuel_TimeDelay);
            displayName = CSTRING(ModuleVehicleRefuel_TimeDelay_DisplayName);
            tooltip = CSTRING(ModuleVehicleRefuel_TimeDelay_Tooltip);
            defaultValue = 600;
            typeName = "NUMBER";
            validate = "NUMBER";
        };

        class ModuleDescription: ModuleDescription {};
    };

    class ModuleDescription: ModuleDescription {
        description = CSTRING(ModuleVehicleRefuel_ModuleDescription_Description);
        position = 0;
        direction = 0;
        sync[] = {
            "AnyVehicle"
        };
    };
};