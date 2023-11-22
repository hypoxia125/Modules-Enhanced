class MEH_ModuleParadropVehicle: MEH_ModuleBase {
    scope = 2;
    displayName = CSTRING(ModuleParadropVehicle_DisplayName);
    icon = "a3\air_f_beta\parachute_01\data\ui\map_parachute_01_ca.paa";
    category = "MEH";

    function = QFUNC(ModuleParadropVehicle);
    functionPriority = 1;
    isGlobal = 0;
    isTriggerActivated = 1;
    isDisposable = 1;
    is3DEN = 1;

    class Attributes: AttributesBase {
        class VehicleClass: Edit {
            property = QGVAR(ModuleParadropVehicle_VehicleClass);
            displayName = CSTRING(ModuleParadropVehicle_VehicleClass_DisplayName);
            tooltip = CSTRING(ModuleParadropVehicle_VehicleClass_Tooltip);
            defaultValue = """B_supplyCrate_F""";
            typeName = "STRING";
            validate = "STRING";
        };

        class CreateCrew: Checkbox {
            property = QGVAR(ModuleParadropVehicle_CreateCrew);
            displayName = CSTRING(ModuleParadropVehicle_CreateCrew_DisplayName);
            tooltip = CSTRING(ModuleParadropVehicle_CreateCrew_Tooltip);
            defaultValue = "true";
            typeName = "BOOL";
        };

        class CrewSide: Combo {
            property = QGVAR(ModuleParadropVehicle_CrewSide);
            displayName = CSTRING(ModuleParadropVehicle_CrewSide_DisplayName);
            tooltip = CSTRING(ModuleParadropVehicle_CreateCrew_Tooltip);
            defaultValue = 1;
            typeName = "NUMBER";
            class Values {
                class West {
                    name = CSTRING(ModuleParadropVehicle_CreateCrew_Values_West_DisplayName);
                    value = 1;
                };
                class East {
                    name = CSTRING(ModuleParadropVehicle_CreateCrew_Values_East_DisplayName);
                    value = 0;
                };
                class Independent {
                    name = CSTRING(ModuleParadropVehicle_CreateCrew_Values_Independent_DisplayName);
                    value = 2;
                };
                class Civilian {
                    name = CSTRING(ModuleParadropVehicle_CreateCrew_Values_Civilian_DisplayName);
                    value = 3;
                };
            };
        };

        class ParadropHeight: Edit {
            property = QGVAR(ModuleParadropVehicle_ParadropHeight);
            displayName = CSTRING(ModuleParadropVehicle_ParadropHeight_DisplayName);
            tooltip = CSTRING(ModuleParadropVehicle_ParadropHeight_Tooltip);
            defaultValue = 200;
            typeName = "NUMBER";
            validate = "NUMBER";
        };

        class ParachuteHeight: Edit {
            property = QGVAR(ModuleParadropVehicle_ParachuteHeight);
            displayName = CSTRING(ModuleParadropVehicle_ParachuteHeight_DisplayName);
            tooltip = CSTRING(ModuleParadropVehicle_ParachuteHeight_Tooltip);
            defaultValue = 150;
            typeName = "NUMBER";
            validate = "NUMBER";
        };

        class Expression: Edit {
            control = QUOTE(EditMulti3);
            property = QGVAR(ModuleParadropVehicle_Expression);
            displayName = CSTRING(ModuleParadropVehicle_Expression_DisplayName);
            tooltip = CSTRING(ModuleParadropVehicle_Expression_Tooltip);
            defaultValue = """true""";
            typeName = "STRING";
            validate = "EXPRESSION";
        };

        class ModuleDescription: ModuleDescription {};
    };

    class ModuleDescription: ModuleDescription {
        description[] = {
            CSTRING(ModuleParadropVehicle_ModuleDescription_Description),
            "",
            CSTRING(ModuleDescription_TriggerActivated_True),
            CSTRING(ModuleDescription_TriggerActivated_Server),
            CSTRING(ModuleDescription_Repeatable_False)
        };
        position = 0;
        direction = 0;
    };
};
