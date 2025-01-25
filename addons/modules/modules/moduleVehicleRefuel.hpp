class MEH_ModuleVehicleRefuel: MEH_ModuleBase {
    scope = 2;
    displayName = CSTRING(ModuleVehicleRefuel_DisplayName);
    icon = "a3\ui_f\data\igui\cfg\simpletasks\types\refuel_ca.paa";
    category = "MEH_Logistics";

    function = QFUNC(ModuleVehicleRefuel);
    functionPriority = 1;
    isGlobal = 0;
    isTriggerActivated = 1;
    isDisposable = 1;
    is3DEN = 1;

    class Attributes: AttributesBase {
        class TimeDelay {
            control = "MEH_ModuleRearmVehicle_Delay";
            expression = "_this setVariable ['%s', _value, true]";
            property = QGVAR(ModuleVehicleRefuel_TimeDelay);
            displayName = CSTRING(ModuleVehicleRefuel_TimeDelay_DisplayName);
            tooltip = CSTRING(ModuleVehicleRefuel_TimeDelay_Tooltip);
            defaultValue = 5*60;
            typeName = "NUMBER";
            validate = "NUMBER";
        };

        class RefuelCount: Edit {
            property = QGVAR(ModuleVehicleRefuel_RefuelCount);
            displayName = "Refuel Tickets";
            tooltip = "How many times this module will refuel the vehicle.";
            defaultValue = 1;
            typeName = "NUMBER";
        };

        class RunImmediately: Checkbox {
            property = QGVAR(ModuleVehicleRefuel_RunImmediately);
            displayName = "Refuel Immediately When Triggered";
            tooltip = "When this module is triggered, it will immediately refuel the vehicle rather than waiting for the delay. Will then continue with delay if refuel count allows.";
            defaultValue = "false";
            typeName = "BOOL";
        };

        class ModuleDescription: ModuleDescription {};
    };

    class ModuleDescription: ModuleDescription {
        description[] = {
            CSTRING(ModuleVehicleRefuel_ModuleDescription_Description),
            "",
            CSTRING(ModuleDescription_TriggerActivated_Optional),
            CSTRING(ModuleDescription_TriggerActivated_Server),
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
