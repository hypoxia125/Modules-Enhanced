class MEH_ModuleInventorySync : MEH_ModuleBase {
    scope = 2;
    displayName = "Inventory Sync";
    icon = "a3\ui_f\data\map\vehicleicons\iconcrateammo_ca.paa";
    category = "MEH_Logistics";
    
    function = QFUNC(ModuleInventorySync);
    functionPriority = 1;
    isGlobal = 0;
    isTriggerActivated = 0;
    isDisposable = 1;
    is3DEN = 1;

    class Attributes : AttributesBase {
        class Identifier : Edit {
            property = QGVAR(ModuleInventorySync_Identifier);
            displayName = "Unique Identifier";
            tooltip = "Unique identifier for this inventory. Will sync with other inventories that share the same identifier.";
            defaultValue = """myIdentifier""";
            typeName = "STRING";
        };

        class ClearIdentifier : Checkbox {
            property = QGVAR(ModuleInventorySync_ClearIdentifier);
            displayName = "Clear Identifier";
            tooltip = "Clears all data in the above identifier upon mission start.";
            defaultValue = "false";
            typeName = "BOOL";
        };

        class SaveLocation : Combo {
            property = QGVAR(ModuleInventorySync_SaveLocation);
            displayName = "Save Location";
            tooltip = "In what namespace do we save this data?";
            defaultValue = 0;
            class Values {
                class Server {
                    name = "Server";
                    value = 0;
                };
                class AllClients {
                    name = "Server + All Clients (Experimental)";
                    value = 1;
                };
            };
        };

        class RefreshRate: Edit {
            defaultValue = 0.5;
            displayName = "Tick Rate For Inventory Sync";
            tooltip = "Delay between Inventory Sync. Lower numbers update faster at a cost of performance.";
            typeName = "NUMBER";
            property = QGVAR(ModuleInventorySync_RefreshRate);
        };

        class ModuleDescription: ModuleDescription {};
    };

    class ModuleDescription: ModuleDescription {
        description[] = {
            "Syncs crates together allowing items that are added/removed to be reflected in other crates.",
            "",
            CSTRING(ModuleDescription_TriggerActivated_False),
            CSTRING(ModuleDescription_Repeatable_False)
        };
        position = 0;
        direction = 0;
    };
};
