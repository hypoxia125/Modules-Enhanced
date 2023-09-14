class MEH_moduleMoveOnCombat: Module_F {
    scope = 2;
    displayName = CSTRING(MODULEMOVEONCOMBAT_DISPLAYNAME);
    icon = "\z\meh\addons\modules\data\iconMoveOnCombat_ca.paa"; // Todo: Add image
    category = "MEH";

    function = QFUNC(moveOnCombat);
    functionPriority = 1;
    isGlobal = 0;
    isTriggerActivated = 0;
    isDisposable = 1;
    is3DEN = 0;

    class Attributes: AttributesBase {
        class GVAR(ModuleMoveOnCombat_Delay): Edit {
            property = QGVAR(MODULEMOVEONCOMBAT_Delay);
            displayName = CSTRING(MODULEMOVEONCOMBAT_DELAY_DISPLAYNAME);
            tooltip = CSTRING(MODULEMOVEONCOMBAT_DELAY_TOOLTIP);
            defaultValue = 0;
            typeName = "NUMBER";
        };

        class ModuleDescription: ModuleDescription {};
    };

    class ModuleDescription: ModuleDescription {
        description = CSTRING(MODULEMOVEONCOMBAT_MODULEDESCRIPTION_DESCRIPTION);
        position = 0;
        direction = 0;
        duplicate = 1;
        sync[] = {
            "AnyVehicle"
        };
    };
};