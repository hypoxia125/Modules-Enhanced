class MEH_ModuleParadropToopTransport: MEH_ModuleBase {
    scope = 2;
    displayName = "Create Paradrop Troop Transport";
    icon = "a3\air_f_beta\parachute_01\data\ui\map_parachute_01_ca.paa";
    category = "MEH";

    function = QFUNC(ModuleParadropTroopTransport);
    functionPriority = 1;
    isGlobal = 2;
    isTriggerActivated = 0;
    isDisposable = 1;
    is3DEN = 1;

    class Attributes: AttributesBase {
        class ChuteOpenHeight: Edit {
            property = QGVAR(ModuleParadropTroopTransport_ChuteOpenHeight);
            displayName = "Chute Open Height (AGL)";
            tooltip = "Sets what height the chute opens AGL.";
            defaultValue = "100";
            typeName = "NUMBER";
            validate = "NUMBER";
        };

        class ChuteType: Combo {
            property = QGVAR(ModuleParadropTroopTransport_ChuteType);
            displayName = "Chute Type";
            tooltip = "Sets the type of chute used in the paradrop.";
            defaultValue = 0;
            typeName = "NUMBER";
            class Values {
                class Steerable {
                    name = "Steerable Parachute";
                    value = 0;
                };
                class NonSteerable {
                    name = "Non-Steerable Parachute";
                    value = 1;
                };
            };
        };

        class ModuleDescription: ModuleDescription {};
    };

    class ModuleDescription: ModuleDescription {
        description[] = {
            "Turns an air vehicle into a paradrop vehicle. Units will be able to paradrop safely from within. Squad leaders force subordinates out on use. Use the 'Paradrop' action.",
            "",
            CSTRING(ModuleDescription_TriggerActivated_False),
            CSTRING(ModuleDescription_Repeatable_False)
        };
        position = 0;
        direction = 0;
    };
};