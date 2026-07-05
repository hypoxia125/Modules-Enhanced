class MEH_ModuleChangeSides : MEH_ModuleBase {
    scope = 2;
    displayName = "Change Sides";
    icon = "a3\3den\data\displays\display3den\panelright\modegroups_ca.paa";
    category = "MEH_PlayerAndAI";

    function = QFUNC(ModuleChangeSides);
    functionPriority = 1;
    isGlobal = 0;
    isTriggerActivated = 1;
    isDisposable = 1;
    is3DEN = 1;

    class Attributes: AttributesBase {
        class ApplyTo: Combo {
            property = QGVAR(ModuleChangeSides_ApplyTo);
            displayName = "Apply To";
            tooltip = "Defines what units to change.";
            defaultValue = 0;
            typeName = "NUMBER";
            class Values {
                class Group {
                    name = "Groups of Synchronized Objects";
                    value = 0;
                };
                class Object {
                    name = "Synchronized Objects Only";
                    value = 1;
                };
                class Trigger {
                    name = "Objects In Synchronized Triggers";
                    value = 2;
                };
            };
        };

        class NewSide: Combo {
            property = QGVAR(ModuleChangeSides_NewSide);
            displayName = "New Side";
            tooltip = "Side to change units to.";
            defaultValue = 0;
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
                    name = "GUER";
                    value = 2;
                };
                class Civilian {
                    name = "CIV";
                    value = 3;
                };
            };
        };

        class IncludePlayers: Checkbox {
            property = QGVAR(ModuleChangeSides_IncludePlayers);
            displayName = "Include Players";
            tooltip = "Includes players in the side changing process depending on 'ApplyTo'.";
            defaultValue = "true";
            typeName = "BOOL";
        };

        class ModuleDescription: ModuleDescription {};
    };

    class ModuleDescription: ModuleDescription {
        description[] = {
            "Changes the side of the synchronized groups/units/units in trigger.",
            "All waypoints and group namespace variables will be copied over to the new group.",
            "",
            "Note: Group editor variable names do not cross over. Only units, so use the leader's editor variable name to grab the group if you need to.",
            "Note: Don't change the side of a single unit inside of a vehicle that is not in cargo. Stuff will break. Change all drivers, gunners, commanders or use 'ApplyTo Group'.",
            "",
            CSTRING(ModuleDescription_TriggerActivated_True),
            CSTRING(ModuleDescription_TriggerActivated_Server),
            CSTRING(ModuleDescription_Repeatable_False)
        };
        position = 0;
        direction = 0;
    };
};
