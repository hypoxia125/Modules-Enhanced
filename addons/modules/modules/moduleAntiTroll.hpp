class MEH_ModuleAntiTroll: MEH_ModuleBase {
    scope = 2;
    displayName = "Anti-Troll";
    icon = "\z\meh\addons\common\data\textures\icons\TrollFaceIcon_64x64.paa";
    category = "MEH_MultiplayerSystems";

    function = QFUNC(ModuleAntiTroll);
    functionPriority = 1;
    isGlobal = 0;
    isTriggerActivated = 0;
    isDisposable = 1;
    is3DEN = 1;

    class Attributes: AttributesBase {
        class AffectedSide: Combo {
            property = QGVAR(ModuleAntiTroll_AffectedSide);
            displayName = "Affected Side";
            tooltip = "Sets the following rules for the selected side.";
            defaultValue = 1;
            typeName = "NUMBER";
            class Values {
                class West {
                    name = "BLUFOR";
                    value = 1;
                };
                class East {
                    name = "OPFOR";
                    value = 0;
                };
                class Independent {
                    name = "Independent";
                    value = 2;
                };
                class Civilian {
                    name = "Civilian";
                    value = 3;
                };
                class All {
                    name = "All Sides";
                    value = 4;
                };
                class SyncedSides {
                    name = "Synced Sides";
                    value = 5;
                };
            };
        };

        class TeamkillThreshold: Edit {
            property = QGVAR(ModuleAntiTroll_TeamkillTreshold);
            displayName = "Teamkill Threshold";
            tooltip = "Number of teamkills needed for punishment.";
            defaultValue = "1";
            typeName = "NUMBER";
            validate = "NUMBER";
        };

        class TeamkillPunishType: Combo {
            property = QGVAR(ModuleAntiTroll_TeamkillPunishType);
            displayName = "Teamkill Punish Type";
            tooltip = "Type of punishment for teamkillers";
            defaultValue = 0;
            typeName = "NUMBER";
            class Values {
                class None {
                    name = "None";
                    value = -1;
                };
                class Kill {
                    name = "Suicide";
                    value = 0;
                };
                // class Prison {
                //     name = "Prison";
                //     value = 1;
                // };
                class Lightning {
                    name = "Lightning Bolt";
                    value = 2;
                };
                class Throw {
                    name = "Throw";
                    value = 3;
                };
                class Launch {
                    name = "Launch";
                    value = 4;
                };
            };
        };

        class TeamDamageThreshold: Edit {
            property = QGVAR(ModuleAntiTroll_TeamDamageThreshold);
            displayName = "Team Damage Threshold";
            tooltip = "Number of team hits for punishment.";
            defaultValue = "10";
            typeName = "NUMBER";
            validate = "NUMBER";
        };

        class TeamDamagePunishType: Combo {
            property = QGVAR(ModuleAntiTroll_TeamDamagePunishType);
            displayName = "Team Damage Punish Type";
            tooltip = "Type of punishment for team damage";
            defaultValue = 0;
            typeName = "NUMBER";
            class Values {
                class None {
                    name = "None";
                    value = -1;
                };
                class Kill {
                    name = "Suicide";
                    value = 0;
                };
                // class Prison {
                //     name = "Prison";
                //     value = 1;
                // };
                class Lightning {
                    name = "Lightning Bolt";
                    value = 2;
                };
                class Throw {
                    name = "Throw";
                    value = 3;
                };
                class Launch {
                    name = "Launch";
                    value = 4;
                };
            };
        };

        // class FlashbangPunishmentType: Combo {
        //     property = QGVAR(ModuleAntiTroll_FlashbangPunishmentType);
        //     displayName = "ACE: Flashbang Punishment Type";
        //     tooltip = "Type of punishment for flashbang.";
        //     defaultValue = 0;
        //     typeName = "NUMBER";
        //     class Values {
        //         class None {
        //             name = "None";
        //             value = -1;
        //         };
        //         class Kill {
        //             name = "Suicide";
        //             value = 0;
        //         };
        //         class Prison {
        //             name = "Prison";
        //             value = 1;
        //         };
        //         class Lightning {
        //             name = "Lightning Bolt";
        //             value = 2;
        //         };
        //         class Throw {
        //             name = "Throw";
        //             value = 3;
        //         };
        //         class Launch {
        //             name = "Launch";
        //             value = 4;
        //         };
        //     };
        // };

        class ModuleDescription: ModuleDescription {};
    };

    class ModuleDescription: ModuleDescription {
        description[] = {
            "Enables teamkill/teamdamage punishment",
            "",
            CSTRING(ModuleDescription_TriggerActivated_False),
            CSTRING(ModuleDescription_Repeatable_False)
        };
        position = 0;
        direction = 0;
    };
};