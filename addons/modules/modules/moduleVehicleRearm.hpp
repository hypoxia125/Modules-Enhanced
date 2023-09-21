class MEH_ModuleVehicleRearm: Module_F {
    scope = 2;
    displayName = CSTRING(ModuleVehicleRearm_DisplayName);
    icon = "";
    category = "MEH";

    function = QFUNC(VehicleRearm);
    functionPriority = 1;
    isGlobal = 0;
    isTriggerActivated = 1;
    isDisposable = 1;
    is3DEN = 0;

    class Attributes: AttributesBase {
        class Repeatable: Checkbox {
            property = QGVAR(ModuleVehicleRearm_Repeatable);
            displayName = CSTRING(ModuleVehicleRearm_Repeatable_DisplayName);
            tooltip = CSTRING(ModuleVehicleRearm_Repeatable_Tooltip);
            defaultValue = 1;
            typeName = "BOOL";
        };

        class TimeDelay: Edit {
            property = QGVAR(ModuleVehicleRearm_TimeDelay);
            displayName = CSTRING(ModuleVehicleRearm_TimeDelay_DisplayName);
            tooltip = CSTRING(ModuleVehicleRearm_TimeDelay_Tooltip);
            defaultValue = 600;
            typeName = "NUMBER";
            validate = "NUMBER";
        };

        class ModuleDescription: ModuleDescription {};
    };

    class ModuleDescription: ModuleDescription {
        description = CSTRING(ModuleVehicleRearm_ModuleDescription_Description);
        position = 0;
        direction = 0;
        sync[] = {
            "AnyVehicle"
        };
    };
};