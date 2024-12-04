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

        class Slider: Title {
            class Controls: Controls {
                // class Title;
                // class Edit;
                class Value;
            };
        };
        class MEH_ModuleSlider_Int: Slider {
            attributeLoad = "\
                _ctrlGroup = _this;\
                [_ctrlGroup controlsgroupctrl 100,_ctrlGroup controlsgroupctrl 101,'',_value] call bis_fnc_initSliderValue;\
            ";
            attributeSave = "\
                sliderPosition (_this controlsGroupCtrl 100);
            ";
            onLoad = "\
                _ctrlGroup = _this select 0;\
                [_ctrlGroup controlsgroupctrl 100,_ctrlGroup controlsgroupctrl 101,''] call bis_fnc_initSliderValue;\
            ";

            class Controls: Controls {
                // class Title: Title {};
                // class Edit: Edit {};
                class Value: Value {
                    sliderRange[] = {1, 10};
                    sliderPosition = 5;
                    sliderStep = 1;
                    lineSize = 0.25;
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
