class MEH_ModuleMapAnimationStart: MEH_ModuleBase {
    scope = 2;
    displayName = "(DEV) Map Animation: Start";
    // icon = "";
    category = "MEH_Cinematics";

    function = QFUNC(ModuleMapAnimationStart);
    functionPriority = 1;
    isGlobal = 1;
    isTriggerActivated = 1;
    isDisposable = 1;
    is3DEN = 1;

    class Attributes: AttributesBase {
        class Force: Checkbox {
            property = QGVAR(ModuleMapAnimationStart_Force);
            displayName = "Forced";
            tooltip = "Forces the viewers to enter the map and disables movement on map and menus. Can cause a permanent map lock if you don't set up the modules right. Suggested to use when you absolutely know your setup works and is reliable.";
            defaultValue = "false";
            typeName = "BOOL";
        };

        class AffectedUnits: Combo {
            property = QGVAR(ModuleMapAnimationStart_Side);
            displayName = "Affected Units";
            tooltip = "Side or synced units to apply the map animation series to.";
            defaultValue = 5;
            typeName = "NUMBER";
            class Values {
                class West {
                    name = "BLUFOR";
                    value = 0;
                };
                class East {
                    name = "OPFOR";
                    value = 1;
                };
                class Independent {
                    name = "Independent";
                    value = 2;
                };
                class Civilian {
                    name = "Civilian";
                    value = 3;
                };
                class Everyone {
                    name = "Everyone";
                    value = 4;
                };
                class SyncedUnits {
                    name = "Synced Units";
                    value = 5;
                };
            };
        };

        class FinalDelay: Edit {
            property = QGVAR(ModuleMapAnimationStart_FinalDelay);
            displayName = "Final Delay";
            tooltip = "Delay to keep map open after all animations have finished. Suggested to take 'Time Until Start' value from last animation and add your delay to that for a final value.";
            defaultValue = 3;
            typeName = "NUMBER";
        };

        class ModuleDescription: ModuleDescription {};
    };

    class ModuleDescription: ModuleDescription {
        description[] = {
            "Starts a full map animation sequence with synced Map Animation Add modules chained together.",
            "Setup: MapAnimationStart -> MapAnimationAdd -> MapAnimationAdd -> etc",
            "",
            CSTRING(ModuleDescription_TriggerActivated_True),
            CSTRING(ModuleDescription_Repeatable_False)
        };
        position = 0;
        direction = 0;
    };
};