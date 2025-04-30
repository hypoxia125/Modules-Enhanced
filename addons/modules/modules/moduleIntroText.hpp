class MEH_ModuleIntroText: MEH_ModuleBase {
    scope = 2;
    displayName = "Intro Text";
    icon = "DBUG\pictures\text.paa";
    category = "MEH_Cinematics";

    function = QFUNC(ModuleIntroText);
    functionPriority = 1;
    isGlobal = 1;
    isTriggerActivated = 1;
    isDisposable = 1;
    is3DEN = 1;

    class Attributes: AttributesBase {
        class Title: Edit {
            property = QGVAR(ModuleIntroText_Title);
            displayName = "Title";
            tooltip = "First line in sequence";
            defaultValue = """Altis""";
            typeName = "STRING";
        };

        class SubTitle: Edit {
            property = QGVAR(ModuleIntroText_SubTitle);
            displayName = "Subtitle";
            tooltip = "Second line in sequence";
            defaultValue = """Pyrgos Military Base""";
            typeName = "STRING";
        };

        class Additional: Edit {
            property = QGVAR(ModuleIntroText_Additional);
            displayName = "Additional Line";
            tooltip = "Additional line in sequence";
            defaultValue = """2 Hours Before Operation""";
            typeName = "STRING";
        };

        class ModuleDescription: ModuleDescription {};
    };

    class ModuleDescription: ModuleDescription {
        description[] = {
            "Creates an intro typing text at bottom right of screen. Title, subtitle, and current time.",
            "",
            CSTRING(MEH_Modules_ModuleDescription_TriggerActivated_True),
            CSTRING(ModuleDescription_Repeatable_False)
        };
        position = 0;
        direction = 0;
    };
};