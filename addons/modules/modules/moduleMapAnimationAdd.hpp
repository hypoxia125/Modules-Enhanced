class MEH_ModuleMapAnimationAdd: MEH_ModuleBase {
    scope = 2;
    displayName = "(DEV) Map Animation: Add";
    // icon = "";
    category = "MEH_Cinematics";

    // function = QFUNC(ModuleMapAnimationAdd);
    functionPriority = 1;
    isGlobal = 1;
    isTriggerActivated = 1;
    isDisposable = 1;
    is3DEN = 1;

    class Attributes: AttributesBase {
        class Time: Edit {
            property = QGVAR(ModuleMapAnimationAdd_Time);
            displayName = "Animation Time";
            tooltip = "Time it takes to complete animation.";
            defaultValue = 3;
            typeName = "NUMBER";
        };

        class Zoom {
            control = "MEH_ModuleMapAnimationAdd_Zoom";
            property = QGVAR(ModuleMapAnimationAdd_Zoom);
            displayName = "Zoom";
            expression = "_this setVariable ['%s', _value, true]";
            tooltip = "Zoom of the map. Higher number means more zoomed out.";
            defaultValue = 0.25;
            typeName = "NUMBER";
        };

        class TimeUntilStart: Edit {
            property = QGVAR(ModuleMapAnimationAdd_TimeUntilStart);
            displayName = "Animation Start Delay Time";
            tooltip = "The elapsed time from when the previous Map Animation Add module begins running until this particular animation is triggered.";
            defaultValue = 5;
            typeName = "NUMBER";
        };

        class Expression: Edit {
            control = "EditCodeMulti5";
            property = QGVAR(ModuleMapAnimationAdd_Expression);
            displayName = "Expression";
            tooltip = "Code to execute when this animation starts.";
            defaultValue = """true""";
            typeName = "STRING";
            validate = "EXPRESSION";
        };

        class ModuleDescription: ModuleDescription {};
    };

    class ModuleDescription: ModuleDescription {
        description[] = {
            "Adds an animation to a chain of animations, starting with Map Animation Start.",
            "Setup: MapAnimationStart -> MapAnimationAdd -> MapAnimationAdd -> etc",
            "",
            CSTRING(ModuleDescription_TriggerActivated_False),
            CSTRING(ModuleDescription_Repeatable_False)
        };
        position = 1;
        direction = 0;
    };
};
