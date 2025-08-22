class MEH_ModuleClearMapLocationNames: MEH_ModuleBase {
    scope = 2;
    displayName = "Clear Map Location Names";
    icon = "a3\modules_f\data\iconstrategicmapimage_ca.paa";
    category = "MEH_Misc";

    function = QFUNC(ModuleClearMapLocationNames);
    functionPriority = 1;
    isGlobal = 2;
    isTriggerActivated = 0;
    isDisposable = 1;
    is3DEN = 1;

    canSetArea = 1;
    canSetAreaShape = 1;
    class AttributeValues {
        size3[] = {50, 50, -1};
        isRectangle = 0;
    };

    class Attributes: AttributesBase {
        class LocationTypes {
            control = "MEH_ModuleInputArray";
            defaultValue = "['NameCity','NameCityCapital','NameLocal','NameVillage']";
            displayName = "Location Types";
            tooltip = "CfgLocationTypes entries to change. Leave empty to change everything.";
            expression = "_this setVariable ['%s', _value, true]";
            typeName = "ARRAY";
            property = QGVAR(ModuleClearMapLocationNames_LocationTypes);
        };

        class ModuleDescription: ModuleDescription {};
    };

    class ModuleDescription: ModuleDescription {
        description[] = {
            "Removes baked-in location text on map.",
            "",
            CSTRING(ModuleDescription_TriggerActivated_False),
            CSTRING(ModuleDescription_Repeatable_False)
        };
        position = 1;
        direction = 1;
    };
};
