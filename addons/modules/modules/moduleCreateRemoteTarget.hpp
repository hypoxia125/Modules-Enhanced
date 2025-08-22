class MEH_ModuleCreateRemoteTarget: MEH_ModuleBase {
    scope = 2;
    displayName = "Create Remote Target";
    icon = "a3\ui_f\data\igui\rsccustominfo\sensors\targets\markedtarget_ca.paa";
    category = "MEH_Misc";

    function = QFUNC(ModuleCreateRemoteTarget);
    functionPriority = 1;
    isGlobal = 0;
    isTriggerActivated = 1;
    isDisposable = 1;
    is3DEN = 1;

    class Attributes: AttributesBase {
        class Side: Combo {
            property = QGVAR(ModuleCreateRemoteTarget_Side);
            displayName = "Side";
            tooltip = "Side to share target vehicle via datalink to.";
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
                class Indepenent {
                    name = "INDEPENDENT";
                    value = 2;
                };
                class Civilian {
                    name = "CIVILIAN";
                    value = 3;
                };
            };
        };

        class Time {
            control = "MEH_ModuleCreateRemoteTarget_Time";
            property = QGVAR(ModuleCreateRemoteTarget_Time);
            expression = "_this setVariable ['%s', _value, true]";
            displayName = "Length Of Report";
            tooltip = "How long to share the target on the datalink.";
            defaultValue = 15*60;
            typeName = "NUMBER";
        };

        class ModuleDescription: ModuleDescription {};
    };

    class ModuleDescription: ModuleDescription {
        description[] = {
            "Broadcasts a synchronized object to a side's datalink. If no synchronized object is given, a logic target will be created instead.",
            "",
            CSTRING(ModuleDescription_TriggerActivated_Optional),
            CSTRING(ModuleDescription_TriggerActivated_Server),
            CSTRING(ModuleDescription_Repeatable_False)
        };
        position = 0;
        direction = 0;
    };
};
