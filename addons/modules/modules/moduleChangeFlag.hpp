class MEH_ModuleChangeFlag: MEH_ModuleBase {
    scope = 2;
    displayName = "Change Flag";
    icon = "a3\ui_f\data\igui\cfg\actions\takeflag_ca.paa";
    category = "MEH";

    function = QFUNC(ModuleChangeFlag);
    functionPriority = 1;
    isGlobal = 0;
    isTriggerActivated = 1;
    isDisposable = 0;
    is3DEN = 1;

    class Attributes: AttributesBase {
        class Mode: Combo {
            property = QGVAR(ModuleChangeFlag_Mode);
            displayName = "Mode";
            tooltip = "Changes if the flag should be fully replaced, or texture changed.";
            defaultValue = 0;
            typeName = "NUMBER";
            class Values {
                class TextureChange {
                    name = "Replace Flag Texture";
                    value = 0;
                };
                class Replace {
                    name = "Replace Flag Object Entirely";
                    value = 1;
                };
            };
        };

        class FlagToReplace: Combo {
            property = QGVAR(ModuleChangeFlag_FlagToReplace);
            displayName = "New Flag";
            tooltip = "Flag to replace current flag with.";
            defaultValue = "Flag_MEH_F";
            typeName = "STRING";
            class Values {
                class Custom {
                    name = "Custom Flag (Fill Below)";
                    value = "";
                };
                class AAF {
                    name = "AAF";
                    value = "Flag_AAF_F";
                };
                class Altis_Colonial {
                    name = "Altis Colonial";
                    value = "Flag_AltisColonial_F";
                };
                class Altis {
                    name = "Altis";
                    value = "Flag_Altis_F";
                };
                class ARMEX {
                    name = "ARMEX";
                    value = "Flag_ARMEX_F";
                };
                class BI {
                    name = "Bohemia Interactive";
                    value = "Flag_BI_F";
                };
                class Blue {
                    name = "Blue";
                    value = "Flag_Blue_F";
                };
                class BlueKing {
                    name = "Blue King";
                    value = "Flag_Blueking_F";
                };
                class BlueKing_Inverted {
                    name = "Blue King - Inverted";
                    value = "Flag_Blueking_inverted_F";
                };
                class Burstkoke {
                    name = "Burstkoke";
                    value = "Flag_Burstkoke_F";
                };
                class Burstkoke_Inverted {
                    name = "Burstkoke - Inverted";
                    value = "Flag_Burstkoke_inverted_F";
                };
                class Checkered {
                    name = "Checkered";
                    value = "FlagChecked_F";
                };
                class CSAT {
                    name = "CSAT";
                    value = "Flag_CSAT_F";
                };
                class CTRG {
                    name = "CTRG";
                    value = "Flag_CTRG_F";
                };
                class FD_Blue {
                    name = "FD - Blue";
                    value = "Flag_FD_Blue_F";
                };
                class FD_Green {
                    name = "FD - Green";
                    value = "Flag_FD_Green_F";
                };
                class FD_Orange {
                    name = "FD - Orange";
                    value = "Flag_FD_Orange_F";
                };
                class FD_Purple {
                    name = "FD - Purple";
                    value = "Flag_FD_Purple_F";
                };
                class FD_Red {
                    name = "FD - Red";
                    value = "Flag_FD_Red_F";
                };
                class FIA {
                    name = "FIA";
                    value = "Flag_FIA_F";
                };
                class Fuel {
                    name = "Fuel";
                    value = "Flag_Fuel_F";
                };
                class Fuel_Inverted {
                    name = "Fuel - Inverted";
                    value = "Flag_Fuel_inverted_F";
                };
                class Gendarmerie {
                    name = "Gendarmerie";
                    value = "Flag_Gendarmerie_F";
                };
                class Green {
                    name = "Green";
                    value = "Flag_Green_F";
                };
                class HorizonIslands {
                    name = "Horizon Islands";
                    value = "Flag_HorizonIslands_F";
                };
                class IDAP {
                    name = "IDAP";
                    value = "Flag_IDAP_F";
                };
                class ION {
                    name = "ION";
                    value = "Flag_ION_F";
                };
                class Larkin {
                    name = "Larkin";
                    value = "Flag_Larkin_F";
                };
                class LDF {
                    name = "LDF";
                    value = "Flag_EAF_F";
                };
                class Livonia {
                    name = "Livonia";
                    value = "Flag_Enoch_F";
                };
                class NATO {
                    name = "NATO";
                    value = "Flag_NATO_F";
                };
                class POW_MIA {
                    name = "POW/MIA";
                    value = "Flag_POWMIA_F";
                };
                class Quontrol {
                    name = "Quontrol";
                    value = "Flag_Quontrol_F";
                };
                class RedCrystal {
                    name = "Red Crystal";
                    value = "Flag_RedCrystal_F";
                };
                class Red {
                    name = "Red";
                    value = "Flag_Red_F";
                };
                class RedBurger {
                    name = "Redburger";
                    value = "Flag_Redburger_F";
                };
                class Redstone {
                    name = "Redstone";
                    value = "Flag_Redstone_F";
                };
                class Suatmm {
                    name = "Suatmm";
                    value = "Flag_Suatmm_F";
                };
                class Syndikat {
                    name = "Syndikat";
                    value = "Flag_Syndikat_F";
                };
                class UK {
                    name = "UK";
                    value = "Flag_UK_F";
                };
                class UNO {
                    name = "UNO";
                    value = "Flag_UNO_F";
                };
                class USA {
                    name = "USA";
                    value = "Flag_US_F";
                };
                class Viper {
                    name = "Viper";
                    value = "Flag_Viper_F";
                };
                class Vrana {
                    name = "Vrana";
                    value = "Flag_Vrana_F";
                };
                class White {
                    name = "White";
                    value = "Flag_White_F";
                };
                class MEH {
                    name = "MEH - Modules Enhanced";
                    value = "Flag_MEH_F";
                };
                class MEH_Inverted {
                    name = "MEH - Modules Enhanced (Inverted)";
                    value = "Flag_MEH_Inverted_F";
                };
            };
        };

        class CustomTexture: Edit {
            property = QGVAR(ModuleChangeFlag_CustomTexture);
            displayName = "Custom Texture Path";
            tooltip = "Path to custom texture.";
            defaultValue = "'\z\meh\addons\common\data\textures\flags\flag_MEH_co.paa'";
            typeName = "STRING";
        };

        class RetainVarName: Checkbox {
            property = QGVAR(ModuleChangeFlag_RetainVarName);
            displayName = "Retain Variable Name";
            tooltip = "Retains variable name upon changing flags. Keeps user variable defined in Object:Init.VariableName in flag's attributes.";
            defaultValue = "true";
            typeName = "BOOL";
        };

        class ModuleDescription: ModuleDescription {};
    };

    class ModuleDescription: ModuleDescription {
        description[] = {
            "Changes a flag texture or the flag entirely. Sync to 'FlagCarrier' based class.",
            "",
            CSTRING(ModuleDescription_TriggerActivated_True),
            CSTRING(ModuleDescription_TriggerActivated_Server),
            CSTRING(ModuleDescription_Repeatable_True)
        };
        position = 0;
        direction = 0;
    };
};