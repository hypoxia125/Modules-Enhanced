class MEH_ModuleEarthquakeDamageArea: MEH_ModuleBase {
    scope = 2;
    displayName = "Earthquake Damage Area";
    icon = "a3\data_f_argo\logos\arma3_argo_logo_small_ca.paa";
    category = "MEH_Effects";

    function = QFUNC(ModuleEarthquakeDamageArea);
    functionPriority = 1;
    isGlobal = 0;
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
        class TypeBuilding: Checkbox {
            property = QGVAR(ModuleEarthquakeDamageArea_TypeBuilding);
            displayName = "Buildings";
            tooltip = "Add buildings to the list of damage/destroyed buildings in this area.";
            defaultValue = "true";
            typeName = "BOOL";
        };

        class TypeWall: Checkbox {
            property = QGVAR(ModuleEarthquakeDamageArea_TypeWall);
            displayName = "Walls";
            tooltip = "Add walls to the list of damage/destroyed buildings in this area.\n\n**RESOURCE INTENSIVE**";
            defaultValue = "false";
            typeName = "BOOL";
        };

        class TypeTree: Checkbox {
            property = QGVAR(ModuleEarthquakeDamageArea_TypeTree);
            displayName = "Trees";
            tooltip = "Add trees to the list of damage/destroyed buildings in this area.\n\n**RESOURCE INTENSIVE**";
            defaultValue = "false";
            typeName = "BOOL";
        };

        class TypePowerlines: Checkbox {
            property = QGVAR(ModuleEarthquakeDamageArea_TypePowerlines);
            displayName = "Powerlines";
            tooltip = "Add powerlines to the list of damage/destroyed buildings in this area.";
            defaultValue = "false";
            typeName = "BOOL";
        };

        class ModuleDescription: ModuleDescription {};
    };

    class ModuleDescription: ModuleDescription {
        description[] = {
            "Defines an area for the connected Earthquake Epicenter module to damage buildings during the earthquake. Damage is directly related to the magnitude of the quake. A magnitude of 3 will result in all buildings being damaged 30% while also having 30% of those buildings be completely destroyed.",
            "",
            CSTRING(ModuleDescription_TriggerActivated_False),
            CSTRING(ModuleDescription_Repeatable_False)
        };
        position = 1;
        direction = 1;
    };
};