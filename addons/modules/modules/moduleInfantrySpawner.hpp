class MEH_ModuleInfantrySpawner: MEH_ModuleBase {
    scope = 2;
    displayName = "Infantry Spawner";
    icon = "a3\ui_f_oldman\data\igui\cfg\holdactions\meet_ca.paa";
    category = "MEH_Spawners";

    function = QFUNC(ModuleInfantrySpawner);
    functionPriority = 1;
    isGlobal = 0;
    isTriggerActivated = 1;
    isDisposable = 0;
    is3DEN = 1;

    canSetArea = 1;
    canSetAreaShape = 1;
    class AttributeValues {
        size3[] = {50, 50, -1};
        isRectangle = 0;
    };

    class Attributes: AttributesBase {
        class Side: Combo {
            property = QGVAR(ModuleInfantrySpawner_Side);
            displayName = "Side";
            tooltip = "Side of the spawned units";
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
                    name = "INDEPENDENT";
                    value = 2;
                };
                class Civilian {
                    name = "CIVILIAN";
                    value = 3;
                };
            };
        };

        class Units {
            control = "MEH_ModuleInputArray";
            defaultValue = "['O_Soldier_TL_F', 'O_Soldier_GL_F', 'O_Soldier_F', 'O_soldier_AR_F']";
            displayName = "Units";
            tooltip = "Array of units available to pick from. Increase unit selection weight by adding additional of the same type.";
            expression = "_this setVariable ['%s', _value, true]";
            property = QGVAR(ModuleInfantrySpawner_Units);
            typeName = "ARRAY";
        };

        class UnitLimit: Edit {
            property = QGVAR(ModuleInfantrySpawner_UnitLimit);
            displayName = "Unit Limit";
            tooltip = "Maximum amount of units this spawner creates. Will wait to spawn more if there are alive units greater than or equal to this value.";
            defaultValue = 16;
            typeName = "NUMBER";
        };

        class UnitsPerSquad: Edit {
            property = QGVAR(ModuleInfantrySpawner_UnitsPerSquad);
            displayName = "Units Per Squad";
            tooltip = "Number of units per squad.";
            defaultValue = 8;
            typeName = "NUMBER";
        };

        class UnitRespawnTime {
            control = "MEH_ModuleInfantrySpawner_UnitRespawnTime";
            defaultValue = 15*60;
            displayName = "Unit Respawn Time";
            tooltip = "Time until module spawns units.";
            expression = "_this setVariable ['%s', _value, true]";
            typeName = "NUMBER";
            property = QGVAR(ModuleInfantrySpawner_UnitRespawnTime);
        };

        class RespawnTickets: Edit {
            property = QGVAR(ModuleInfantrySpawner_RespawnTickets);
            displayName = "Respawn Tickets";
            tooltip = "Number of respawns the module will perform before shutting down. This is a total unit amount, not a respawn instance amount.";
            defaultValue = 64;
            typeName = "NUMBER";
        };

        class DeactivationRadius {
            control = "MEH_ModuleInfantrySpawner_DeactivationRadius";
            defaultValue = 100;
            displayName = "Deactivation Radius";
            tooltip = "Radius (m) that a unit from a different side must be from the spawner center in order to deactivate the spawner.";
            expression = "_this setVariable ['%s', _value, true]";
            typeName = "NUMBER";
            property = QGVAR(ModuleInfantrySpawner_DeactivationRadius);
        };

        class WaitForFullSquad: Checkbox {
            property = QGVAR(ModuleInfantrySpawner_WaitForFullSquad);
            displayName = "Wait For Full Squad";
            tooltip = "Waits for the available unit limit to reach a point where a full squad can be spawned at once. Otherwise, it will continue to trickle in units as there are available slots.";
            defaultValue = "true";
            typeName = "BOOL";
        };

        class UnitLogic: Combo {
            property = QGVAR(ModuleInfantrySpawner_UnitLogic);
            displayName = "Unit Logic";
            tooltip = "Logic that units perform upon spawning.";
            defaultValue = 0;
            typeName = "NUMBER";
            class Values {
                class PatrolPosition {
                    name = "Patrol Position";
                    value = 0;
                };
                class Garrison {
                    name = "Garrison Units";
                    value = 1;
                };
                class UseConnectedWPModules {
                    name = "Use Connected WP Modules";
                    value = 2;
                };
                class None {
                    name = "None";
                    value = 3;
                };
            };
        };

        class Expression: Edit {
            control = "EditCodeMulti5";
            property = QGVAR(ModuleInfantrySpawner_Expression);
            displayName = "Expression";
            tooltip = "Code to execute on each group that is spawned. Passed arguments are:\n[0: Group, 1: Waypoints]";
            defaultValue = "'true'";
            typeName = "STRING";
        };

        class ModuleDescription: ModuleDescription {};
    };

    class ModuleDescription: ModuleDescription {
        description[] = {
            "Acts as an infantry spawner, constantly creating units until disabled (enemy units nearby), or upon reaching no respawn tickets.",
            "",
            CSTRING(ModuleDescription_TriggerActivated_True),
            CSTRING(ModuleDescription_Repeatable_False)
        };
        position = 1;
        direction = 1;
    };
};
