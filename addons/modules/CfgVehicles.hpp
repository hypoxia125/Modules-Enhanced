class CfgVehicles {
    class Logic;
    class Module_F: Logic {
        class AttributesBase
        {
            class Default;
            class Edit;
            class EditCodeMulti5;
            class EditMulti3;
            class EditMulti5;
            class Combo;
            class Checkbox;
            class CheckboxNumber;
            class ModuleDescription;
            class Units;
        };

        class ModuleDescription {
            class AnyBrain;
        };
    };

    #include "\z\meh\addons\modules\modules\moduleDeleteRespawnPosition.hpp"
    #include "\z\meh\addons\modules\modules\moduleFuelConsumption.hpp"
    #include "\z\meh\addons\modules\modules\moduleMoveOnCombat.hpp"
    #include "\z\meh\addons\modules\modules\moduleParadropVehicle.hpp"
};