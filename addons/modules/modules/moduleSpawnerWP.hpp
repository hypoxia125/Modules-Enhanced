class MEH_ModuleSpawnerWaypoint: MEH_ModuleBase {
    scope = 2;
    displayName = "Spawner Waypoint";
    icon = "a3\ui_f\data\igui\cfg\simpletasks\types\move_ca.paa";
    category = "MEH_Spawners";

    function = QFUNC(ModuleSpawnerWaypoint);
    functionPriority = 1;
    isGlobal = 0;
    isTriggerActivated = 0;
    isDisposable = 0;
    is3DEN = 1;

    class Attributes: AttributesBase {
        class WaypointType: Combo {
            property = QGVAR(ModuleSpawnerWaypoint_WaypointType);
            displayName = "Waypoint Type";
            tooltip = "Type of waypoint to create for spawner group.";
            defaultValue = 0;
            typeName = "NUMBER";
            class Values {
                class Move {
                    name = "MOVE";
                    value = 0;
                };
                class SAD {
                    name = "SEEK AND DESTROY";
                    value = 1;
                };
                class Sentry {
                    name = "SENTRY";
                    value = 2;
                };
            };
        };

        class WaypointIndex: Edit {
            property = QGVAR(ModuleSpawnerWaypoint_WaypointIndex);
            displayName = "Waypoint Index";
            tooltip = "The waypoint's position in the list of waypoints. If the same number is assigned to multiple modules, one of those modules is randomly selected.";
            defaultValue = 0;
            typeName = "NUMBER";
        };

        class ModuleDescription: ModuleDescription {};
    };

    class ModuleDescription: ModuleDescription {
        description[] = {
            "Acts as a waypoint position for a connected spawner.",
            "",
            CSTRING(ModuleDescription_TriggerActivated_False),
            CSTRING(ModuleDescription_Repeatable_False)
        };
        position = 1;
        direction = 1;
    };
};
