class MEH_ModuleTransportSystem_BaseSpawn: MEH_ModuleBase {
    scope = 2;
    displayName = "Base Zone";
    icon = "";
    category = "MEH_HeliTransportSystem";

    function = QFUNC(ModuleHeliTransportSystem_BaseSpawn);
    functionPriority = 1;
    isGlobal = 0;
    isTriggerActivated = 0;
    isDisposable = 0;
    is3DEN = 1;

    class Attributes: AttributesBase {
        class Owner: Combo {
            property = QGVAR(ModuleHeliTransportSystem_BaseSpawn_Owner);
            displayName = "Owner";
            tooltip = "Which side owns this base spawn";
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
                    name = "GUER";
                    value = 2;
                };
                class Civilian {
                    name = "CIV";
                    value = 3;
                };
            };
        };
        class HeliType: Edit {
            property = QGVAR(ModuleHeliTransportSystem_BaseSpawn_HeliType);
            displayName = "Heli Type";
            tooltip = "Classname of heli to spawn";
            defaultValue = """HeliClassHere""";
            typeName = "STRING";
            validate = "STRING";
        };
        class SpawnDirection: Edit {
            property = QGVAR(ModuleHeliTransportSystem_BaseSpawn_SpawnDirection);
            displayName = "Spawn Direction (World)";
            tooltip = "World Coordinate Spawn Direction for Heli\nN: 0, E: 90, S: 180, W: 270";
            defaultValue = "NUMBER";
            typeName = "NUMBER";
            validate = "NUMBER";
        };

        class ModuleDescription: ModuleDescription {};
    };

    class ModuleDescription: ModuleDescription {
        description[] = {
            ""
        };
        position = 1;
        direction = 0;
    };
};