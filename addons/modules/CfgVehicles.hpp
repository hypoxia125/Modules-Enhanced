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

        class ModuleDescription;
    };
    class MEH_ModuleBase: Module_F {
        author = "Hypoxic";
        scope = 0;
        scopeCurator = 0;
        is3DEN = 0;
        isGlobal = 0;
        isTriggerActivated = 1;
        curatorCanAttach = 0;

        class ModuleDescription: ModuleDescription {
            duplicate = 0;
            duplicateEnabled = "";
            duplicateDisabled = "";
        };
    };

    #include "\z\meh\addons\modules\modules\moduleAmbientArtilleryVirtual.hpp"
    #include "\z\meh\addons\modules\modules\moduleCommunicationJammer.hpp"
    #include "\z\meh\addons\modules\modules\moduleCreateMinefield.hpp"
    #include "\z\meh\addons\modules\modules\moduleDeleteRespawnPosition.hpp"
    #include "\z\meh\addons\modules\modules\moduleEffectFire.hpp"
    #include "\z\meh\addons\modules\modules\moduleEffectLightpoint.hpp"
    #include "\z\meh\addons\modules\modules\moduleEffectSmoke.hpp"
    #include "\z\meh\addons\modules\modules\moduleEnableDisableGunLights.hpp"
    #include "\z\meh\addons\modules\modules\moduleLightningStorm.hpp"
    #include "\z\meh\addons\modules\modules\moduleMoveOnCombat.hpp"
    #include "\z\meh\addons\modules\modules\moduleMPSync.hpp"
    #include "\z\meh\addons\modules\modules\moduleParadropVehicle.hpp"
    #include "\z\meh\addons\modules\modules\moduleRegisterTeleporter.hpp"
    #include "\z\meh\addons\modules\modules\moduleSpeedLimiter.hpp"
    #include "\z\meh\addons\modules\modules\moduleTrapInventory.hpp"
    #include "\z\meh\addons\modules\modules\moduleVehicleMineJammer.hpp"
    #include "\z\meh\addons\modules\modules\moduleVehicleRearm.hpp"
    #include "\z\meh\addons\modules\modules\moduleVehicleRefuel.hpp"
};
