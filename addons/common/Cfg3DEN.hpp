class Cfg3DEN {
    class Attributes {
        class Title;
        class Edit: Title {
            class Controls {
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
