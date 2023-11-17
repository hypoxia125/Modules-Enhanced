class Cfg3DEN {
    class Mission {
        class Scenario {
            class AttributeCategories {
                class VersionControl {
                    class Attributes {
                        class MEH_MissionVersion {
                            property = QGVAR(MissionVersion);
                            defaultValue = "[-1,-1,-1]";
                        };
                        class MEH_CurrentVersion {
                            property = QGVAR(CurrentVersion);
                            defaultValue = QUOTE(CURRENT_VERSION);
                        };
                    };
                };
            };
        };
    };
};