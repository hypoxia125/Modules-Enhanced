class MEH_ModuleRegisterTeleporter: Module_F {
    scope = 2;
    displayName = CSTRING(ModuleRegisterTeleporter_DisplayName);
    icon = "a3\ui_f\data\igui\cfg\simpletasks\types\move_ca.paa";
    category = "MEH";

    fucntion = QFUNC(ModuleRegisterTeleporter);
    functionPriority = 2;
    isGlobal = 1;
    isTriggerActivated = 1;
    isDisposable = 0;
    is3DEN = 0;

    class Attributes: AttributesBase {
        class Side: Combo {
            displayName = CSTRING(ModuleRegisterTeleporter_Side_DisplayName);
            tooltip = CSTRING(ModuleRegisterTeleporter_Side_Tooltip);
            defaultValue = 1;
            typeName = "NUMBER";
            class Values {
                class East {
                    name = CSTRING(ModuleRegisterTeleporter_Side_East);
                    value = 0;
                };
                class West {
                    name = CSTRING(ModuleRegisterTeleporter_Side_West);
                    value = 1;
                };
                class Resistance {
                    name = CSTRING(ModuleRegisterTeleporter_Side_Resistance);
                    value = 2;
                };
                class Civilian {
                    name = CSTRING(ModuleRegisterTeleporter_Side_Civilian);
                    value = 3;
                };
            };
        };

        class Way: Combo {
            displayName = CSTRING(ModuleRegisterTeleporter_Way_DisplayName);
            tooltip = CSTRING(ModuleRegisterTeleporter_Way_Tooltip);
            defaultValue = 0;
            typeName = "NUMBER";
            class Values {
                class OneWay {
                    name = CSTRING(ModuleRegisterTeleporter_Way_OneWay);
                    value = 0;
                };
                class TwoWay {
                    name = CSTRING(ModuleRegisterTeleporter_Way_TwoWay);
                    value = 1;
                };
            };
        };

        class TravelTime: Edit {
            displayName = CSTRING(ModuleRegisterTeleporter_TravelTime_DisplayName);
            tooltip = CSTRING(ModuleRegisterTeleporter_TravelTime_Tooltip);
            defaultValue = 0;
            typeName = "NUMBER";
        };
    };
};