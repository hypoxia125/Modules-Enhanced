class MEH_ModuleVehicleRepair: MEH_ModuleBase {
    scope = 2;
    displayName = "Vehicle Auto-Repair";
    icon = "a3\ui_f\data\igui\cfg\simpletasks\types\repair_ca.paa";
    category = "MEH_Logistics";

    function = QFUNC(ModuleVehicleRepair);
    functionPriority = 1;
    isGlobal = 0;
    isTriggerActivated = 1;
    isDisposable = 1;
    is3DEN = 1;

    class Attributes: AttributesBase {
        class TimeDelay {
            control = "MEH_ModuleRepairVehicle_Delay";
            expression = "_this setVariable ['%s', _value, true]";
            property = QGVAR(ModuleVehicleRepair_TimeDelay);
            displayName = "Vehicle Repair";
            tooltip = "Time between repair ticks.";
            defaultValue = 15*60;
            typeName = "NUMBER";
        };

        class RepairCount: Edit {
            property = QGVAR(ModuleVehiclRepair_RepairCount);
            displayName = "Repair Count";
            tooltip = "How many times this module will repair the vehicle.";
            defaultValue = 1;
            typeName = "NUMBER";
        };

        class Percent {
            control = "MEH_ModuleVehicleRepair_Percent";
            expression = "_this setVariable ['%s', _value, true]";
            property = QGVAR(ModuleVehicleRepair_Percent);
            displayName = "Repair Percent";
            tooltip = "Percent to add to the current HP of vehicle parts per tick.";
            defaultValue = 1;
            typeName = "NUMBER";
        };

        class RunImmediately: Checkbox {
            property = QGVAR(ModuleVehicleRepair_RunImmediately);
            displayName = "Repair Immediately When Triggered";
            tooltip = "When this module is triggered, it will immediately repair the vehicle rather than waiting for the delay. Will then continue with delay if repair count allows. You should only use this if using large time delays.";
            defaultValue = "false";
            typeName = "BOOL";

            class ModuleDescription: ModuleDescription {};
        };
    };

    class ModuleDescription: ModuleDescription {
        description[] = {
            "Repairs the vehicle at regular intervals.",
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
