class MEH_ModuleWorldTimeScale: MEH_ModuleBase {
    scope = 2;
    displayName = "World Time Scale";
    icon = "a3\modules_f_curator\data\portraittimeacceleration_ca.paa";
    category = "MEH_Misc";

    function = QFUNC(ModuleWorldTimeScale);
    functionPriority = 1;
    isGlobal = 0;
    isTriggerActivated = 1;
    isDisposable = 1;
    is3DEN = 1;

    class Attributes: AttributesBase {
        class DayTimeScale {
            control = "MEH_ModuleWorldTimeScale_Time";
            expression = "_this setVariable ['%s', _value, true]";
            property = QGVAR(ModuleWorldTimeScale_DayTimeScale);
            displayName = "Day Duration (Real Hours)";
            tooltip = "How many REAL hours should the daytime period last?\nLower = faster day speed, Higher = slower day speed\nExample: 2 hours = 6x faster day, 24 hours = 0.5x slower day\nRange: 0.2 to 240 hours";
            defaultValue = 12;
            typeName = "NUMBER";
        };

        class NightTimeScale {
            control = "MEH_ModuleWorldTimeScale_Time";
            expression = "_this setVariable ['%s', _value, true]";
            property = QGVAR(ModuleWorldTimeScale_NightTimeScale);
            displayName = "Night Duration (Real Hours)";
            tooltip = "How many REAL hours should the nighttime period last?\nSet to 1-2 hours for fast nights on persistent servers!\nRange: 0.2 to 240 hours";
            defaultValue = 12;
            typeName = "NUMBER";
        };

        class ModuleDescription: ModuleDescription {};
    };

    class ModuleDescription: ModuleDescription {
        description[] = {
            "Allows for custom time scale based on IRL time. Use for very long/persistant missions. Can be updated mid mission by using another module connected to a trigger."
        };
        position = 0;
        direction = 0;
    };
};
