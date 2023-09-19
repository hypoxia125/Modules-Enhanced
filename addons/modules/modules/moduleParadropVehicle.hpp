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
        class Expression: EditCodeMulti3 {
            property = QGVAR(ModuleParadropVehicle_Expression);
            displayName = CSTRING(ModuleParadropVehicle_Expression_DisplayName);
            tooltip = CSTRING(ModuleParadropVehicle_Expression_Tooltip);
            defaultValue = QUOTE("");
            typeName = "STRING";
        };

        class ParachuteHeight: Edit {
            property = QGVAR(ModuleParadropVehicle_ParachuteHeight);
            displayName = CSTRING(ModuleParadropVehicle_ParachuteHeight_DisplayName);
            tooltip = CSTRING(ModuleParadropVehicle_ParachuteHeight_Tooltip);
            defaultValue = 5;
            typeName = "NUMBER";
        };

        // Todo: Add edit line for classname

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