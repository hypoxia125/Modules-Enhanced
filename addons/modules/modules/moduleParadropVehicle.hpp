class MEH_moduleParadropVehicle: Module_F {
    scope = 2;
    displayName = CSTRING(ModuleParadropVehicle_DisplayName);
    icon = "";
    category = "MEH";

    function = QFUNC(paradropVehicle);
    functionPriority = 1;
    isGlobal = 0;
    isTriggerActivated = 1;
    isDisposable = 1;
    is3DEN = 0;

    class Attributes: AttributesBase {
        class ParadropHeight: Edit {
            property = QGVAR(ModuleParadropVehicle_ParadropHeight);
            displayName = CSTRING(ModuleParadropVehicle_ParadropHeight_DisplayName);
            tooltip = CSTRING(ModuleParadropVehicle_ParadropHeight_Tooltip);
            defaultValue = 500;
            typeName = "NUMBER";
        };

        class ParachuteHeight: Edit {
            property = QGVAR(ModuleParadropVehicle_ParachuteHeight);
            displayName = CSTRING(ModuleParadropVehicle_ParachuteHeight_DisplayName);
            tooltip = CSTRING(ModuleParadropVehicle_ParachuteHeight_Tooltip);
            defaultValue = 5;
            typeName = "NUMBER";
        };

        class Position: Combo {
            property = QGVAR(ModuleParadropVehicle_Position);
            displayName = CSTRING(ModuleParadropVehicle_Position_DisplayName);
            tooltip = CSTRING(ModuleParadropVehicle_Position_Tooltip);
            defaultValue = 0;
            typeName = "NUMBER";
            class Values {
                class VehiclePosition {
                    name = CSTRING(ModuleParadropVehicle_Position_Values_VehiclePosition_Name);
                    value = 0;
                };
                class ModulePosition {
                    name = CSTRING(ModuleParadropVehicle_Position_Values_ModulePosition_Name);
                    value = 1;
                };
            };
        };

        class Expression: EditCodeMulti3 {
            property = QGVAR(ModuleParadropVehicle_Expression);
            displayName = CSTRING(ModuleParadropVehicle_Expression_DisplayName);
            tooltip = CSTRING(ModuleParadropVehicle_Expression_Tooltip);
            defaultValue = QUOTE("");
            typeName = "STRING";
        };

        class ModuleDescription: ModuleDescription {};
    };

    class ModuleDescription: ModuleDescription {
        description = CSTRING(ModuleParadropVehicle_ModuleDescription_Description);
        position = 1;
        direction = 0;
        duplicate = 1;
        sync[] = {
            "AnyVehicle"
        };
    };
};