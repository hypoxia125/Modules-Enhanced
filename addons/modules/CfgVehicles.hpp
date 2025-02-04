class CfgVehicles {
    class Logic;
    class Module_F: Logic {
        class AttributesBase;
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

        class AttributesBase: AttributesBase {
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

        class ModuleDescription: ModuleDescription {
            duplicate = 0;
            duplicateEnabled = "";
            duplicateDisabled = "";
        };
    };

    #include "\z\meh\addons\modules\moduleDefaults.inc"
    #include "\z\meh\addons\modules\modules\moduleAmbientArtilleryVirtual.hpp"
    #include "\z\meh\addons\modules\modules\moduleAntiTroll.hpp"
    #include "\z\meh\addons\modules\modules\moduleChangeFlag.hpp"
    #include "\z\meh\addons\modules\modules\moduleClearMapLocationNames.hpp"
    #include "\z\meh\addons\modules\modules\moduleCommunicationJammer.hpp"
    #include "\z\meh\addons\modules\modules\moduleCreateMapLocation.hpp"
    #include "\z\meh\addons\modules\modules\moduleCreateMinefield.hpp"
    #include "\z\meh\addons\modules\modules\moduleCreateRemoteTarget.hpp"
    #include "\z\meh\addons\modules\modules\moduleDeleteRespawnPosition.hpp"
    #include "\z\meh\addons\modules\modules\moduleEffectFire.hpp"
    #include "\z\meh\addons\modules\modules\moduleEffectFlareLauncher.hpp"
    #include "\z\meh\addons\modules\modules\moduleEffectLightpoint.hpp"
    #include "\z\meh\addons\modules\modules\moduleEffectSmoke.hpp"
    #include "\z\meh\addons\modules\modules\moduleEnableDisableGunLights.hpp"
    #include "\z\meh\addons\modules\modules\moduleHealingArea.hpp"
    #include "\z\meh\addons\modules\modules\moduleInfantrySpawner.hpp"
    #include "\z\meh\addons\modules\modules\moduleLightningStorm.hpp"
    #include "\z\meh\addons\modules\modules\moduleMoveOnCombat.hpp"
    #include "\z\meh\addons\modules\modules\moduleParadropTroopTransport.hpp"
    #include "\z\meh\addons\modules\modules\moduleMPSync.hpp"
    #include "\z\meh\addons\modules\modules\moduleParadropVehicle.hpp"
    #include "\z\meh\addons\modules\modules\moduleRegisterTeleporter.hpp"
    #include "\z\meh\addons\modules\modules\moduleSpawnerWP.hpp"
    #include "\z\meh\addons\modules\modules\moduleSpeedLimiter.hpp"
    #include "\z\meh\addons\modules\modules\moduleTrapInventory.hpp"
    #include "\z\meh\addons\modules\modules\moduleVehicleFuelCoef.hpp"
    #include "\z\meh\addons\modules\modules\moduleVehicleMineJammer.hpp"
    #include "\z\meh\addons\modules\modules\moduleVehicleRearm.hpp"
    #include "\z\meh\addons\modules\modules\moduleVehicleRefuel.hpp"
    #include "\z\meh\addons\modules\modules\moduleVehicleRepair.hpp"
};
