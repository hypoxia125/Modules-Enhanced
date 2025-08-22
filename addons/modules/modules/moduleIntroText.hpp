class MEH_ModuleIntroText: MEH_ModuleBase {
    scope = 2;
    displayName = "Intro Text";
    icon = "a3\ui_f\data\gui\rsc\rscdisplayarcademap\icon_clear_ca.paa";
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

        class TitleFont: Combo {
            property = QGVAR(ModuleIntroText_TitleFont);
            displayName = "Title Font";
            tooltip = "Font of the first line of the cinematic.";
            defaultValue = 4;
            typeName = "NUMBER";
            class Values {
                class EtelkaMonospacePro {
                    name = "EtelkaMonospacePro";
                    value = 0;
                };
                class EtelkaMonospaceProBold {
                    name = "EtelkaMonospaceProBold";
                    value = 1;
                };
                class EtelkaNarrowMediumPro {
                    name = "EtelkaNarrowMediumPro";
                    value = 2;
                };
                class LucidaConsoleB {
                    name = "LucidaConsoleB";
                    value = 3;
                };
                class PuristaBold {
                    name = "PuristaBold";
                    value = 4;
                };
                class PuristaLight {
                    name = "PuristaLight";
                    value = 5;
                };
                class PuristaMedium {
                    name = "PuristaMedium";
                    value = 6;
                };
                class PuristaSemibold {
                    name = "PuristaSemibold";
                    value = 7;
                };
                class RobotoCondensed {
                    name = "RobotoCondensed";
                    value = 8;
                };
                class RobotoCondensedBold {
                    name = "RobotoCondensedBold";
                    value = 9;
                };
                class RobotoCondensedLight {
                    name = "RobotoCondensedLight";
                    value = 10;
                };
                class TahomaB {
                    name = "TahomaB";
                    value = 11;
                };
            };
        };

        class TitleFontSize: Edit {
            property = QGVAR(ModuleIntroText_TitleFontSize);
            displayName = "Title Font Size";
            tooltip = "Size of the first line of the cinematic.";
            defaultValue = 1;
            typeName = "NUMBER";
        };

        class TitleFontColor: Combo {
            property = QGVAR(ModuleIntroText_TitleFontColor);
            displayName = "Title Font Color";
            tooltip = "Color of the first line of the cinematic.";
            defaultValue = 0;
            typeName = "NUMBER";
            class Values {
                class White {
                    name = "White";
                    value = 0;
                };
                class Black {
                    name = "Black";
                    value = 1;
                };
                class Blue {
                    name = "Blue";
                    value = 2;
                };
                class Green {
                    name = "Green";
                    value = 3;
                };
                class Yellow {
                    name = "Yellow";
                    value = 4;
                };
                class Orange {
                    name = "Orange";
                    value = 5;
                };
                class Red {
                    name = "Red";
                    value = 6;
                };
                class Purple {
                    name = "Purple";
                    value = 7;
                };
                class Blufor {
                    name = "BLUFOR";
                    value = 8;
                };
                class Opfor {
                    name = "OPFOR";
                    value = 9;
                };
                class Independent {
                    name = "Independent";
                    value = 10;
                };
                class Civilian {
                    name = "Civilian";
                    value = 11;
                };
                class Unknown {
                    name = "Unknown";
                    value = 12;
                };
            };
        };

        class SubTitle: Edit {
            property = QGVAR(ModuleIntroText_SubTitle);
            displayName = "Subtitle";
            tooltip = "Second line in sequence";
            defaultValue = """Pyrgos Military Base""";
            typeName = "STRING";
        };

        class SubtitleFont: Combo {
            property = QGVAR(ModuleIntroText_SubtitleFont);
            displayName = "Subtitle Font";
            tooltip = "Font of the second line of the cinematic.";
            defaultValue = 6;
            typeName = "NUMBER";
            class Values {
                class EtelkaMonospacePro {
                    name = "EtelkaMonospacePro";
                    value = 0;
                };
                class EtelkaMonospaceProBold {
                    name = "EtelkaMonospaceProBold";
                    value = 1;
                };
                class EtelkaNarrowMediumPro {
                    name = "EtelkaNarrowMediumPro";
                    value = 2;
                };
                class LucidaConsoleB {
                    name = "LucidaConsoleB";
                    value = 3;
                };
                class PuristaBold {
                    name = "PuristaBold";
                    value = 4;
                };
                class PuristaLight {
                    name = "PuristaLight";
                    value = 5;
                };
                class PuristaMedium {
                    name = "PuristaMedium";
                    value = 6;
                };
                class PuristaSemibold {
                    name = "PuristaSemibold";
                    value = 7;
                };
                class RobotoCondensed {
                    name = "RobotoCondensed";
                    value = 8;
                };
                class RobotoCondensedBold {
                    name = "RobotoCondensedBold";
                    value = 9;
                };
                class RobotoCondensedLight {
                    name = "RobotoCondensedLight";
                    value = 10;
                };
                class TahomaB {
                    name = "TahomaB";
                    value = 11;
                };
            };
        };

        class SubtitleFontSize: Edit {
            property = QGVAR(ModuleIntroText_SubtitleFontSize);
            displayName = "Subtitle Font Size";
            tooltip = "Size of the second line of the cinematic.";
            defaultValue = 0.7;
            typeName = "NUMBER";
        };

        class SubtitleFontColor: Combo {
            property = QGVAR(ModuleIntroText_SubtitleFontColor);
            displayName = "Subtitle Font Color";
            tooltip = "Color of the second line of the cinematic.";
            defaultValue = 0;
            typeName = "NUMBER";
            class Values {
                class White {
                    name = "White";
                    value = 0;
                };
                class Black {
                    name = "Black";
                    value = 1;
                };
                class Blue {
                    name = "Blue";
                    value = 2;
                };
                class Green {
                    name = "Green";
                    value = 3;
                };
                class Yellow {
                    name = "Yellow";
                    value = 4;
                };
                class Orange {
                    name = "Orange";
                    value = 5;
                };
                class Red {
                    name = "Red";
                    value = 6;
                };
                class Purple {
                    name = "Purple";
                    value = 7;
                };
                class Blufor {
                    name = "BLUFOR";
                    value = 8;
                };
                class Opfor {
                    name = "OPFOR";
                    value = 9;
                };
                class Independent {
                    name = "Independent";
                    value = 10;
                };
                class Civilian {
                    name = "Civilian";
                    value = 11;
                };
                class Unknown {
                    name = "Unknown";
                    value = 12;
                };
            };
        };

        class Additional: Edit {
            property = QGVAR(ModuleIntroText_Additional);
            displayName = "Additional Line";
            tooltip = "Additional line in sequence";
            defaultValue = """2 Hours Before Operation""";
            typeName = "STRING";
        };

        class AdditionalFont: Combo {
            property = QGVAR(ModuleIntroText_AdditionalFont);
            displayName = "Additional Font";
            tooltip = "Font of the third line of the cinematic.";
            defaultValue = 6;
            typeName = "NUMBER";
            class Values {
                class EtelkaMonospacePro {
                    name = "EtelkaMonospacePro";
                    value = 0;
                };
                class EtelkaMonospaceProBold {
                    name = "EtelkaMonospaceProBold";
                    value = 1;
                };
                class EtelkaNarrowMediumPro {
                    name = "EtelkaNarrowMediumPro";
                    value = 2;
                };
                class LucidaConsoleB {
                    name = "LucidaConsoleB";
                    value = 3;
                };
                class PuristaBold {
                    name = "PuristaBold";
                    value = 4;
                };
                class PuristaLight {
                    name = "PuristaLight";
                    value = 5;
                };
                class PuristaMedium {
                    name = "PuristaMedium";
                    value = 6;
                };
                class PuristaSemibold {
                    name = "PuristaSemibold";
                    value = 7;
                };
                class RobotoCondensed {
                    name = "RobotoCondensed";
                    value = 8;
                };
                class RobotoCondensedBold {
                    name = "RobotoCondensedBold";
                    value = 9;
                };
                class RobotoCondensedLight {
                    name = "RobotoCondensedLight";
                    value = 10;
                };
                class TahomaB {
                    name = "TahomaB";
                    value = 11;
                };
            };
        };

        class AdditionalFontSize: Edit {
            property = QGVAR(ModuleIntroText_AdditionalFontSize);
            displayName = "Additional Font Size";
            tooltip = "Size of the third line of the cinematic.";
            defaultValue = 0.5;
            typeName = "NUMBER";
        };

        class AdditionalFontColor: Combo {
            property = QGVAR(ModuleIntroText_AdditionalFontColor);
            displayName = "Additional Font Color";
            tooltip = "Color of the third line of the cinematic.";
            defaultValue = 0;
            typeName = "NUMBER";
            class Values {
                class White {
                    name = "White";
                    value = 0;
                };
                class Black {
                    name = "Black";
                    value = 1;
                };
                class Blue {
                    name = "Blue";
                    value = 2;
                };
                class Green {
                    name = "Green";
                    value = 3;
                };
                class Yellow {
                    name = "Yellow";
                    value = 4;
                };
                class Orange {
                    name = "Orange";
                    value = 5;
                };
                class Red {
                    name = "Red";
                    value = 6;
                };
                class Purple {
                    name = "Purple";
                    value = 7;
                };
                class Blufor {
                    name = "BLUFOR";
                    value = 8;
                };
                class Opfor {
                    name = "OPFOR";
                    value = 9;
                };
                class Independent {
                    name = "Independent";
                    value = 10;
                };
                class Civilian {
                    name = "Civilian";
                    value = 11;
                };
                class Unknown {
                    name = "Unknown";
                    value = 12;
                };
            };
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
