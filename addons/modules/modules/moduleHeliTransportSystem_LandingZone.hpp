class MEH_ModuleTransportSystem_LZ: MEH_ModuleBase {
    scope = 2;
    displayName = "Landing Zone";
    icon = "";
    category = "MEH_HeliTransportSystem";

    function = QFUNC(ModuleHeliTransportSystem_LZ);
    functionPriority = 1;
    isGlobal = 0;
    isTriggerActivated = 1;
    isDisposable = 0;
    is3DEN = 1;

    class Attributes: AttributesBase {
        class DisplayName: Edit {
            property = QGVAR(ModuleHeliTransportSystem_LZ_DisplayName);
            displayName = "Display Name";
            tooltip = "Display name for UI";
            defaultValue = """Undefined Landing Zone""";
            typeName = "STRING";
            validate = "STRING";
        };
        class SideEast: Checkbox {
            property = QGVAR(ModuleHeliTransportSystem_LZ_SideEast);
            displayName = "OPFOR Can Use";
            tooltip = "OPFOR can use this landing zone";
            defaultValue = "true";
            typeName = "BOOL";
        };
        class SideWest: Checkbox {
            property = QGVAR(ModuleHeliTransportSystem_LZ_SideWest);
            displayName = "BLUFOR Can Use";
            tooltip = "BLUFOR can use this landing zone";
            defaultValue = "true";
            typeName = "BOOL";
        };
        class SideIndependent: Checkbox {
            property = QGVAR(ModuleHeliTransportSystem_LZ_SideIndependent);
            displayName = "GUER Can Use";
            tooltip = "GUER can use this landing zone";
            defaultValue = "true";
            typeName = "BOOL";
        };
        class SideCivilian: Checkbox {
            property = QGVAR(ModuleHeliTransportSystem_LZ_SideCivilian);
            displayName = "CIV Can Use";
            tooltip = "CIV can use this landing zone";
            defaultValue = "true";
            typeName = "BOOL";
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