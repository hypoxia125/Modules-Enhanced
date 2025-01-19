class MEH_ModuleVehicleRearm: MEH_ModuleBase {
    scope = 2;
    displayName = CSTRING(ModuleVehicleRearm_DisplayName);
    icon = "a3\ui_f\data\igui\cfg\simpletasks\types\rearm_ca.paa";
    category = "MEH_Logistics";

    function = QFUNC(ModuleVehicleRearm);
    functionPriority = 1;
    isGlobal = 0;
    isTriggerActivated = 1;
    isDisposable = 1;
    is3DEN = 1;

    class Attributes: AttributesBase {
        class TimeDelay {
            control = "MEH_ModuleEffectRearmVehicle_Delay";
            expression = "_this setVariable ['%s', _value, true]";
            property = QGVAR(ModuleVehicleRearm_TimeDelay);
            displayName = CSTRING(ModuleVehicleRearm_TimeDelay_DisplayName);
            tooltip = CSTRING(ModuleVehicleRearm_TimeDelay_Tooltip);
            defaultValue = 5*60;
            typeName = "NUMBER";
            validate = "NUMBER";
        };

        class RearmCount: Edit {
            property = QGVAR(ModuleVehicleRearm_RearmCount);
            displayName = "Rearm Tickets";
            tooltip = "How many times this module will rearm the vehicle.";
            defaultValue = 1;
            typeName = "NUMBER";
        };

        class RunImmediately: Checkbox {
            property = QGVAR(ModuleVehicleRearm_RunImmediately);
            displayName = "Rearm Immediately When Triggered";
            tooltip = "When this module is triggered, it will immediately rearm the vehicle rather than waiting for the delay. Will then continue with delay if rearm count allows.";
            defaultValue = "false";
            typeName = "BOOL";
        };

        class ModuleDescription: ModuleDescription {};
    };

    class ModuleDescription: ModuleDescription {
        description[] = {
            CSTRING(ModuleVehicleRearm_ModuleDescription_Description),
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
