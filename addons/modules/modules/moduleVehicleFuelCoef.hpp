class MEH_ModuleVehicleFuelCoef: MEH_ModuleBase {
    scope = 2;
    displayName = "Vehicle Fuel Coefficient";
    icon = "a3\ui_f\data\igui\cfg\actions\refuel_ca.paa";
    category = "MEH_Logistics";

    function = QFUNC(ModuleVehicleFuelCoef);
    functionPriority = 1;
    isGlobal = 0;
    isTriggerActivated = 1;
    isDisposable = 1;
    is3DEN = 1;

    class Attributes: AttributesBase {
        class Coef {
            control = "MEH_ModuleVehicleFuelCoef_Coef";
            expression = "_this setVariable ['%s', _value, true]";
            property = QGVAR(ModuleVehicleFuelCoef_Coef);
            displayName = "Fuel Consumption Coefficient";
            tooltip = "Values larger than 1 increase fuel consumption. Values between 0 and 1 decrease fuel consumption. 0 disables fuel consumption.";
            defaultValue = 0;
            typeName = "NUMBER";
        };

        class ModuleDescription: ModuleDescription {};
    };

    class ModuleDescription: ModuleDescription {
        description[] = {
            "Sets the fuel consumption coefficient of synchronized vehicles.",
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
