class ctrlDefault;
class ctrlDefaultText;
class ctrlListbox;
class ctrlEdit;
class ctrlButton;

class Cfg3DEN {
    class Attributes {
        class Default;
        class Title: Default {
            class Controls;
        };
        class Edit: Title {
            class Controls: Controls {
                class Title;
                class Value;
            };
        };

        class Slider: Title {
            class Controls: Controls {
                class Title;
                class Edit;
                class Value;
            };
        };

        class SliderTime: Title {
            class Controls: Controls {
                class Frame;
                class Hour;
                class Minute;
                class Second;
                class Separator;
                class Title;
                class Value;
            };
        };

        class MEH_MissionVersionReadOnly: Edit {
            class Controls: Controls {
                class Title: Title {
                    onLoad = "(_this select 0) ctrlEnable false";
                };
                class Value: Value {
                    onLoad = "(_this select 0) ctrlEnable false";
                };
            };
        };

        /*
            ----- Slider Controls -----
            -- These need to explicitly inherit the Title | Value | Edit classes from their base classes
            -- In order for them to work within the 3DEN attribute system
        */

        class MEH_ModuleSlider_Int: Slider {
            attributeLoad = "\
                _ctrlGroup = _this;\
                [_ctrlGroup controlsgroupctrl 100,_ctrlGroup controlsgroupctrl 101,'',_value] call bis_fnc_initSliderValue;\
            ";
            attributeSave = "\
                sliderPosition (_this controlsGroupCtrl 100);\
            ";
            onLoad = "\
                _ctrlGroup = _this select 0;\
                [_ctrlGroup controlsgroupctrl 100,_ctrlGroup controlsgroupctrl 101,''] call bis_fnc_initSliderValue;\
            ";

            class Controls: Controls {
                class Title: Title {};
                class Edit: Edit {};
                class Value: Value {
                    sliderRange[] = {1, 10};
                    sliderPosition = 5;
                    sliderStep = 1;
                };
            };
        };

        class MEH_ModuleSlider_Multi: Slider {
            attributeLoad = "\
                _ctrlGroup = _this;\
                [_ctrlGroup controlsgroupctrl 100,_ctrlGroup controlsgroupctrl 101,'x',_value] call bis_fnc_initSliderValue;\
            ";
            attributeSave = "\
                sliderPosition (_this controlsGroupCtrl 100);\
            ";
            onLoad = "\
                _ctrlGroup = _this select 0;\
                [_ctrlGroup controlsgroupctrl 100,_ctrlGroup controlsgroupctrl 101,'x'] call bis_fnc_initSliderValue;\
            ";

            class Controls: Controls {
                class Title: Title {};
                class Edit: Edit {};
                class Value: Value {
                    sliderRange[] = {1, 10};
                    sliderPosition = 1;
                    sliderStep = 1;
                };
            };
        };

        class MEH_ModuleSlider_Percent: Slider {
            attributeLoad = "\
                _ctrlGroup = _this;\
                [_ctrlGroup controlsgroupctrl 100,_ctrlGroup controlsgroupctrl 101,nil,_value] call bis_fnc_initSliderValue;\
            ";
            attributeSave = "\
                sliderPosition (_this controlsGroupCtrl 100);\
            ";
            onLoad = "\
                _ctrlGroup = _this select 0;\
                [_ctrlGroup controlsgroupctrl 100,_ctrlGroup controlsgroupctrl 101,nil] call bis_fnc_initSliderValue;\
            ";

            class Controls: Controls {
                class Title: Title {};
                class Edit: Edit {};
                class Value: Value {
                    sliderRange[] = {0, 1};
                    sliderPosition = 0.5;
                    sliderStep = 0.1;
                };
            };
        };

        class MEH_ModuleSlider_Time: SliderTime {
            class Controls: Controls {
                class Frame: Frame {};
                class Hour: Hour {};
                class Minute: Minute {};
                class Second: Second {};
                class Separator: Separator {};
                class Title: Title {};
                class Value: Value {
                    sliderRange[] = {0, 300};
                    sliderPosition = 0;
                    lineSize = 5;
                };
            };
        };

        class MEH_ModuleSlider_Degrees: Slider {
            attributeLoad = "\
                _ctrlGroup = _this;\
                [_ctrlGroup controlsgroupctrl 100,_ctrlGroup controlsgroupctrl 101,'*',_value] call bis_fnc_initSliderValue;\
            ";
            attributeSave = "\
                sliderPosition (_this controlsGroupCtrl 100);\
            ";
            onLoad = "\
                _ctrlGroup = _this select 0;\
                [_ctrlGroup controlsgroupctrl 100,_ctrlGroup controlsgroupctrl 101,'*'] call bis_fnc_initSliderValue;\
            ";

            class Controls: Controls {
                class Title: Title {};
                class Edit: Edit {};
                class Value: Value {
                    sliderRange[] = {0, 360};
                    sliderPosition = 90;
                    sliderStep = 1;
                };
            };
        };

        // Custom Controls For Each Module
        class MEH_ModuleLightning_StrikeTiming: MEH_ModuleSlider_Percent {
            class Controls: Controls {
                class Title: Title {};
                class Edit: Edit {};
                class Value: Value {
                    sliderRange[] = {0, 1};
                    sliderPosition = 1;
                    sliderStep = 0.01;
                };
            };
        };

        class MEH_ModuleLightning_DamageArea: MEH_ModuleSlider_Int {
            class Controls: Controls {
                class Title: Title {};
                class Edit: Edit {};
                class Value: Value {
                    sliderRange[] = {0, 100};
                    sliderPosition = 15;
                    sliderStep = 1;
                };
            };
        };

        class MEH_ModuleCreateMinefield_Density: MEH_ModuleSlider_Int {
            class Controls: Controls {
                class Title: Title {};
                class Edit: Edit {};
                class Value: Value {
                    sliderRange[] = {0.5, 30};
                    sliderPosition = 10;
                    sliderStep = 0.5;
                };
            };
        };

        class MEH_ModuleEffectFlareLauncher_LaunchDispersion: MEH_ModuleSlider_Int {
            class Controls: Controls {
                class Title: Title {};
                class Edit: Edit {};
                class Value: Value {
                    sliderRange[] = {0, 89};
                    sliderPosition = 0;
                    sliderStep = 1;
                };
            };
        };

        class MEH_ModuleEffectFlareLauncher_DeployHeight: MEH_ModuleSlider_Int {
            class Controls: Controls {
                class Title: Title {};
                class Edit: Edit {};
                class Value: Value {
                    sliderRange[] = {0, 5000};
                    sliderPosition = 250;
                    sliderStep = 25;
                };
            };
        };

        class MEH_ModuleEffectFlareLauncher_LaunchRandomness: MEH_ModuleSlider_Percent {
            class Controls: Controls {
                class Title: Title {};
                class Edit: Edit {};
                class Value: Value {
                    sliderRange[] = {0, 1};
                    sliderPosition = 0.1;
                    sliderStep = 0.01;
                };
            };
        };

        class MEH_ModuleTrapInventory_ExplodeChance: MEH_ModuleSlider_Percent {
            class Controls: Controls {
                class Title: Title {};
                class Edit: Edit {};
                class Value: Value {
                    sliderRange[] = {0, 1};
                    sliderPosition = 0.25;
                    sliderStep = 0.01;
                };
            };
        };

        class MEH_ModuleHealingArea_HealingRate: MEH_ModuleSlider_Percent {
            class Controls: Controls {
                class Title: Title {};
                class Edit: Edit {};
                class Value: Value {
                    sliderRange[] = {0, 1};
                    sliderPosition = 0.1;
                    sliderStep = 0.01;
                };
            };
        };

        class MEH_ModuleEffectFire_Colors: MEH_ModuleSlider_Int {
            class Controls: Controls {
                class Title: Title {};
                class Edit: Edit {};
                class Value: Value {
                    sliderRange[] = {0, 1};
                    sliderPosition = 0.5;
                    sliderStep = 0.01;
                };
            };
        };

        class MEH_ModuleEffectSmoke_Colors: MEH_ModuleSlider_Int {
            class Controls: Controls {
                class Title: Title {};
                class Edit: Edit {};
                class Value: Value {
                    sliderRange[] = {0, 1};
                    sliderPosition = 0.5;
                    sliderStep = 0.01;
                };
            };
        };

        class MEH_ModuleEffectFire_Orientation: MEH_ModuleSlider_Int {
            class Controls: Controls {
                class Title: Title {};
                class Edit: Edit {};
                class Value: Value {
                    sliderRange[] = {0, 359};
                    sliderPosition = 0;
                    sliderStep = 1;
                };
            };
        };

        class MEH_ModuleRearmVehicle_Delay: MEH_ModuleSlider_Time {
            class Controls: Controls {
                class Title: Title {};
                class Value: Value {
                    sliderRange[] = {60, 60*60};
                    sliderPosition = 5*60;
                    sliderStep = 60;
                };
                class Frame: Frame {};
                class Separator: Separator {};
                class Hour: Hour {};
                class Minute: Minute {};
                class Second: Second {};
            };
        };

        class MEH_ModuleEffectLightpoint_LightconeParams: MEH_ModuleSlider_Degrees {
            class Controls: Controls {
                class Title: Title {};
                class Edit: Edit {};
                class Value: Value {
                    sliderRange[] = {0, 180};
                    sliderPosition = 90;
                    sliderStep = 1;
                };
            };
        };

        class MEH_ModuleInfantrySpawner_UnitRespawnTime: MEH_ModuleSlider_Time {
            class Controls: Controls {
                class Title: Title {};
                class Value: Value {
                    sliderRange[] = {60, 60*60};
                    sliderPosition = 15*60;
                    sliderStep = 60;
                };
                class Frame: Frame {};
                class Separator: Separator {};
                class Hour: Hour {};
                class Minute: Minute {};
                class Second: Second {};
            };
        };

        class MEH_ModuleInfantrySpawner_DeactivationRadius: MEH_ModuleSlider_Int {
            class Controls: Controls {
                class Title: Title {};
                class Edit: Edit {};
                class Value: Value {
                    sliderRange[] = {0, 1000};
                    sliderPosition = 100;
                    sliderStep = 1;
                };
            };
        };

        class MEH_ModuleRepairVehicle_Delay: MEH_ModuleSlider_Time {
            class Controls: Controls {
                class Title: Title {};
                class Value: Value {
                    sliderRange[] = {0, 60*60};
                    sliderPosition = 5*60;
                    sliderStep = 1;
                };
                class Frame: Frame {};
                class Separator: Separator {};
                class Hour: Hour {};
                class Minute: Minute {};
                class Second: Second {};
            };
        };

        class MEH_ModuleVehicleRepair_Percent: MEH_ModuleSlider_Percent {
            class Controls: Controls {
                class Title: Title {};
                class Edit: Edit {};
                class Value: Value {
                    sliderRange[] = {0, 1};
                    sliderPosition = 1;
                    sliderStep = 0.01;
                };
            };
        };

        class MEH_ModuleVehicleFuelCoef_Coef: MEH_ModuleSlider_Int {
            class Controls: Controls {
                class Title: Title {};
                class Edit: Edit {};
                class Value: Value {
                    sliderRange[] = {0, 1000};
                    sliderPosition = 0;
                    sliderStep = 1;
                };
            };
        };

        class MEH_ModuleCreateRemoteTarget_Time: MEH_ModuleSlider_Time {
            class Controls: Controls {
                class Title: Title {};
                class Value: Value {
                    sliderRange[] = {60, 99*60*60};
                    sliderPosition = 15*60;
                    sliderStep = 60;
                };
                class Frame: Frame {};
                class Separator: Separator {};
                class Hour: Hour {};
                class Minute: Minute {};
                class Second: Second {};
            };
        };

        class MEH_ModuleEarthquakeEpicenter_Power: MEH_ModuleSlider_Int {
            class Controls: Controls {
                class Title: Title {};
                class Edit: Edit {};
                class Value: Value {
                    sliderRange[] = {0, 20};
                    sliderPosition = 10;
                    sliderStep = 0.1;
                };
            };
        };

        class MEH_ModuleEarthquakeEpicenter_Frequency: MEH_ModuleSlider_Int {
            class Controls: Controls {
                class Title: Title {};
                class Edit: Edit {};
                class Value: Value {
                    sliderRange[] = {0, 100};
                    sliderPosition = 10;
                    sliderStep = 0.1;
                };
            };
        };

        class MEH_ModuleEarthquakeDamageArea_DamageBuildings: MEH_ModuleSlider_Percent {
            class Controls: Controls {
                class Title: Title {};
                class Edit: Edit {};
                class Value: Value {
                    sliderRange[] = {0, 1};
                    sliderPosition = 0;
                    sliderStep = 0.1;
                };
            };
        };

        /*
            Array Input Controls
            Modified From Spearhead 1944
        */

        class MEH_ModuleInputArray: Title {
			attributeLoad="\
                {(_this controlsGroupCtrl 100) lbAdd _x} forEach _value;\
            ";
			attributeSave="\
                private _ctrlList = (_this controlsGroupCtrl 100);\
                private _valueTemp = [];\
                for '_row' from 0 to (lbSize _ctrlList - 1) do {_valueTemp append [_ctrlList lbText _row]};\
                _valueTemp;\
            ";
			h="7 * (	5 * (pixelH * pixelGrid * 	0.50)) + 4 * pixelH";
            class Controls: Controls {
				class Title: Title {};
				class Value: ctrlListbox
				{
					idc=100;
					x="48 * (pixelW * pixelGrid * 	0.50)";
					w="(	82 - 5) * (pixelW * pixelGrid * 	0.50) - 4 * pixelW";
					h="6 * (	5 * (pixelH * pixelGrid * 	0.50))";
				};
				class Input: ctrlEdit
				{
					idc=101;
					x="48 * (pixelW * pixelGrid * 	0.50)";
					y="6 * (	5 * (pixelH * pixelGrid * 	0.50)) + 4 * pixelH";
					w="(	82 - 5) * (pixelW * pixelGrid * 	0.50) - 4 * pixelW";
					h="(	5 * (pixelH * pixelGrid * 	0.50))";
				};
				class Add: ctrlButton
				{
					idc=101;
					text="+";
					tooltip="Adds an entry to the list.";
					x="(	48 + 	82 - 5) * (pixelW * pixelGrid * 	0.50) - 2 * pixelW";
					y="6 * (	5 * (pixelH * pixelGrid * 	0.50)) + 4 * pixelH";
					w="5 * (pixelW * pixelGrid * 	0.50)";
					h="(	5 * (pixelH * pixelGrid * 	0.50))";
					onButtonClick="\
                        params ['_ctrlButton'];\
                        private _ctrlGroup = ctrlParentControlsGroup _ctrlButton;\
                        private _ctrlEdit = _ctrlGroup controlsGroupCtrl 101;\
                        private _text = ctrlText _ctrlEdit;\
                        if (_text != '') then {private _array = _text splitString ', ';\
                        _array apply {(_ctrlGroup controlsGroupCtrl 100) lbAdd _x};\
                        _ctrlEdit ctrlSetText ''}\
                    ";
				};
				class Remove: Add
				{
					idc=101;
					text="-";
					tooltip="Removes an entry from the list.";
					y=0;
					onButtonClick="\
                        params ['_ctrlButton'];\
                        private _ctrlGroup = ctrlParentControlsGroup _ctrlButton;\
                        private _ctrlList = _ctrlGroup controlsGroupCtrl 100;\
                        _ctrlList lbDelete (lbCurSel _ctrlList);\
                    ";
				};
            };
        };
    };

    class EventHandlers {
        class MEH {
            // Use CBA cache in uiNamespace due to the event handlers firing before the functions are added to missionNamespace
            onMissionSave = "call (uiNamespace getVariable [""MEH_Common_fnc_3DEN_OnMissionSave"", {}])";
            onMissionLoad = "call (uiNamespace getVariable [""MEH_Common_fnc_3DEN_OnMissionLoad"", {}])";
        };
    };

    class Mission {
        class Scenario {
            class AttributeCategories {
                class MEH_VersionControl {
                    displayName = "Modules Enhanced Version Control";
                    class Attributes {
                        class MEH_MissionVersion {
                            control = "MEH_MissionVersionReadOnly";
                            defaultValue = """""";
                            displayName = "Modules Enhanced - Mission Version";
                            expression = "true";
                            property = QGVAR(MissionVersion);
                        };
                        class MEH_CurrentVersion {
                            control = "MEH_MissionVersionReadOnly";
                            defaultValue = QUOTE(QUOTE(CURRENT_VERSION));
                            displayName = "Modules Enhanced - Current Version";
                            expression = "true";
                            property = QGVAR(CurrentVersion);
                        };
                    };
                };
            };
        };
    };
};
