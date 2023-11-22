class MEH_ModuleVehicleMineJammer: MEH_ModuleBase {
    scope = 2;
    displayName = CSTRING(ModuleVehicleMineJammer_DisplayName);
    icon = "a3\ui_f\data\igui\cfg\simpletasks\types\mine_ca.paa";
    category = "MEH";

    function = QFUNC(ModuleVehicleMineJammer);
    functionPriority = 1;
    isGlobal = 0;
    isTriggerActivated = 1;
    isDisposable = 1;
    is3DEN = 1;

    class Attributes: AttributesBase {
        class Radius: Edit {
            property = QGVAR(ModuleVehicleMineJammer_Radius);
            displayName = CSTRING(ModuleVehicleMineJammer_Radius_DisplayName);
            tooltip = CSTRING(ModuleVehicleMineJammer_Radius_Tooltip);
            defaultValue = 10;
            typeName = "NUMBER";
            validate = "NUMBER";
        };

        class Explode: Checkbox {
            property = QGVAR(ModuleVehicleMineJammer_Explode);
            displayName = CSTRING(ModuleVehicleMineJammer_Explode_DisplayName);
            tooltip = CSTRING(ModuleVehicleMineJammer_Explode_Tooltip);
            defaultValue = "false";
            typeName = "BOOL";
        };

        class ModuleDescription: ModuleDescription {};
    };

    class ModuleDescription: ModuleDescription {
        description[] = {
            CSTRING(ModuleVehicleMineJammer_ModuleDescription_Description),
            "",
            CSTRING(ModuleDescription_TriggerActivated_Optional),
            CSTRING(ModuleDescription_TriggerActivated_Server),
            CSTRING(ModuleDescription_Repeatable_False)
        };
        position = 0;
        direction = 0;
        sync[] = {
            "AnyVehicle",
            "AnyVehicle"
        };
    };
};
