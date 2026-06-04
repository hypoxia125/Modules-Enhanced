class MEH_ModuleTransportSystem: MEH_ModuleBase {
    scope = 2;
    displayName = "Base Zone";
    icon = "";
    category = "MEH_HeliTransportSystem";

    function = QFUNC(ModuleHeliTransportSystem);
    functionPriority = 1;
    isGlobal = 0;
    isTriggerActivated = 0;
    isDisposable = 0;
    is3DEN = 1;

    class Attributes: AttributesBase {
        class InvulnerableHelis: Checkbox {
            property = QGVAR(ModuleHeliTransportSystem_InvulnerableHelis);
            displayName = "Invulnerable Helis";
            tooltip = "Makes Helis invulnerable";
            defaultValue = "true";
            typeName = "BOOL";
        };
        class UntargetableHelis: Checkbox {
            property = QGVAR(ModuleHeliTransportSystem_UntargetableHelis);
            displayName = "Untargetable Helis";
            tooltip = "Makes Helis untargetable by AI";
            defaultValue = "true";
            typeName = "BOOL";
        };
        class InvulnerablePassengers: Checkbox {
            property = QGVAR(ModuleHeliTransportSystem_InvulnerablePassengers);
            displayName = "Invulnerable Passengers";
            tooltip = "Makes units invulnerable in the heli while transporting and briefly after unloading.";
            defaultValue = "true";
            typeName = "BOOL";
        };
        class MaxActiveHelis: Edit {
            property = QGVAR(ModuleHeliTransportSystem_MaxActiveHelis);
            displayName = "Max Active Helis Per Side";
            tooltip = "";
            defaultValue = 4;
            typeName = "NUMBER";
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