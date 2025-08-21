class MEH_ModuleVehicleServiceStation: MEH_ModuleBase {
    scope = 2;
    displayName = "Vehicle Service Station";
    icon = "a3\ui_f\data\igui\cfg\simpletasks\types\repair_ca.paa";
    category = "MEH_Logistics";

    function = QFUNC(ModuleVehicleServiceStation);
    functionPriority = 1;
    isGlobal = 0;
    isTriggerActivated = 1;
    isDisposable = 0;
    is3DEN = 1;

    canSetArea = 1;
    canSetAreaShape = 1;
    canSetAreaHeight = 1;
    class AttributeValues {
        size3[] = {50, 50, -1};
        isRectangle = 0;
    };

    class Attributes: AttributesBase {
        class Side: Combo {
            property = QGVAR(ModuleVehicleServiceStation_Side);
            displayName = "Side";
            tooltip = "Side that Vehicle Service Station belongs to.";
            defaultValue = 1;
            typeName = "NUMBER";
            class Values {
                class East {
                    name = "OPFOR";
                    value = 0;
                };
                class West {
                    name = "BLUFOR";
                    value = 1;
                };
                class Independent {
                    name = "INDEPENDENT";
                    value = 2;
                };
                class Civilian {
                    name = "CIVILIAN";
                    value = 3;
                };
            };
        };

        // Rearm
        class Rearm: Checkbox {
            property = QGVAR(ModuleVehicleServiceStation_Rearm);
            displayName = "Rearm";
            tooltip = "Enable vehicle rearming. Rearms fully per tick.";
            defaultValue = "true";
            typeName = "BOOL";
        };
        // class RearmPerTick {
        //     control = "MEH_ModuleVehicleServiceStation_RearmPerTick";
        //     property = QGVAR(ModuleVehicleServiceStation_RearmPerTick);
        //     displayName = "Rearm Per Tick";
        //     expression = "_this setVariable ['%s', _value, true]";
        //     tooltip = "Percent of vehicle to rearm per tick. This is locked at 100%. Uneditable.";
        //     defaultValue = 1;
        //     typeName = "NUMBER";
        // };

        // Repair
        class Repair: Checkbox {
            property = QGVAR(ModuleVehicleServiceStation_Repair);
            displayName = "Repair";
            tooltip = "Enable vehicle repairing";
            defaultValue = "true";
            typeName = "BOOL";
        };
        class RepairPerTick {
            control = "MEH_ModuleVehicleServiceStation_RepairPerTick";
            property = QGVAR(ModuleVehicleServiceStation_RepairPerTick);
            displayName = "Repair Per Tick";
            expression = "_this setVariable ['%s', _value, true]";
            tooltip = "Percent of vehicle to repair per tick.";
            defaultValue = 1;
            typeName = "NUMBER";
        };

        // Refuel
        class Refuel: Checkbox {
            property = QGVAR(ModuleVehicleServiceStation_Refuel);
            displayName = "Refuel";
            tooltip = "Enable vehicle refueling";
            defaultValue = "true";
            typeName = "BOOL";
        };
        class RefuelPerTick {
            control = "MEH_ModuleVehicleServiceStation_RefuelPerTick";
            property = QGVAR(ModuleVehicleServiceStation_RefuelPerTick);
            displayName = "Refuel Per Tick";
            expression = "_this setVariable ['%s', _value, true]";
            tooltip = "Percent of vehicle to refuel per tick.";
            defaultValue = 1;
            typeName = "NUMBER";
        };

        class Tickrate {
            control = "MEH_ModuleVehicleServiceStation_Tickrate";
            property = QGVAR(ModuleVehicleServiceStation_Tickrate);
            displayName = "Tick Rate";
            tooltip = "Time (s) between each tick.";
            expression = "_this setVariable ['%s', _value, true]";
            defaultValue = 1;
            typeName = "NUMBER";
        };

        class ShowMapMarker: Checkbox {
            property = QGVAR(ModuleVehicleServiceStation_ShowMapMarker);
            displayName = "Show Global Map Marker";
            tooltip = "Show map marker on map for faction, or all factions.";
            defaultValue = "false";
            typeName = "BOOL";
        };

        class ModuleDescription: ModuleDescription {};
    };

    class ModuleDescription: ModuleDescription {
        description[] = {
            "Creates an area that can repair, rearm, and/or refuel vehicles within. Can be toggled with repeatable trigger.",
            "",
            CSTRING(ModuleDescription_TriggerActivated_Optional),
            CSTRING(ModuleDescription_TriggerActivated_Server),
            CSTRING(ModuleDescription_Repeatable_True)
        };
        position = 1;
        direction = 1;
    };
};
