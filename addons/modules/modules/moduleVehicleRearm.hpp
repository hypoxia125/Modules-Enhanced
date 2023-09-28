class MEH_ModuleVehicleRearm: Module_F {
    scope = 2;
    displayName = CSTRING(ModuleVehicleRearm_DisplayName);
    icon = "a3\ui_f\data\igui\cfg\simpletasks\types\rearm_ca.paa";
    category = "MEH";

    function = QFUNC(ModuleVehicleRearm);
    functionPriority = 1;
    isGlobal = 0;
    isTriggerActivated = 1;
    isDisposable = 1;
    is3DEN = 0;

    class Attributes: AttributesBase {
        class TimeDelay: Edit {
            property = QGVAR(ModuleVehicleRearm_TimeDelay);
            displayName = CSTRING(ModuleVehicleRearm_TimeDelay_DisplayName);
            tooltip = CSTRING(ModuleVehicleRearm_TimeDelay_Tooltip);
            defaultValue = 0;
            typeName = "NUMBER";
            validate = "NUMBER";
        };

        class ModuleDescription: ModuleDescription {};
    };

    class ModuleDescription: ModuleDescription {
        description = CSTRING(ModuleVehicleRearm_ModuleDescription_Description);
        position = 0;
        direction = 0;
        sync[] = {
            "AnyVehicle"
        };
    };
};