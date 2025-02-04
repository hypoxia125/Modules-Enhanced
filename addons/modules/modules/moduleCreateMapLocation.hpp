class MEH_ModuleCreateMapLocation: MEH_ModuleBase {
    scope = 2;
    displayName = "Create Map Location";
    // icon = "";
    category = "MEH_Misc";

    function = QFUNC(ModuleCreateMapLocation);
    functionPriority = 1;
    isGlobal = 2;
    isTriggerActivated = 0;
    isDisposable = 1;
    is3DEN = 1;

    canSetArea = 1;
    canSetAreaShape = 1;
    canSetAreaHeight = 1;
    class AttributeValues {
        size3[] = {100, 100, -1};
        isRectangle = 0;
    };

    class Attributes: AttributesBase {
        class Name: Edit {
            property = QGVAR(ModuleCreateMapLocation_Name);
            displayName = "Create Map Location";
            tooltip = "Creates a map location";
            defaultValue = "'My Location'";
            typeName = "STRING";
        };

        class Type: Combo {
            property = QGVAR(ModuleCreateMapLocation_Type);
            displayName = "Location Type";
            tooltip = "CfgLocationType selection to use for the created location.";
            defaultValue = 0;
            typeName = "NUMBER";
            class Values {
                class Area {
                    name = "Area";
                    value = 0;
                };
                class BorderCrossing {
                    name = "Border Crossing";
                    value = 1;
                };
                class CivilDefense {
                    name = "Civil Defense";
                    value = 2;
                };
                class CulturalProperty {
                    name = "Cultural Property";
                    value = 3;
                };
                class DangerousForces {
                    name = "Dangerous Forces";
                    value = 4;
                };
                class Flag {
                    name = "Flag";
                    value = 5;
                };
                class FlatArea {
                    name = "Flat Area";
                    value = 6;
                };
                class FlatAreaCity {
                    name = "Flat Area City";
                    value = 7;
                };
                class FlatAreaCitySmall {
                    name = "Flat Area City Small";
                    value = 8;
                };
                class Hill {
                    name = "Hill";
                    value = 9;
                };
                class Invisible {
                    name = "Invisible";
                    value = 10;
                };
                class Name {
                    name = "Name";
                    value = 11;
                };
                class NameCity {
                    name = "Name City";
                    value = 12;
                };
                class NameCityCapital {
                    name = "Name City Capital";
                    value = 13;
                };
                class NameLocal {
                    Name = "Name Local";
                    value = 14;
                };
                class NameMarine {
                    name = "Name Marine";
                    value = 15;
                };
                class NameVillage {
                    name = "Name Village";
                    value = 16;
                };
                class RockArea {
                    name = "Rock Area";
                    value = 17;
                };
                class SafetyZone {
                    name = "Safety Zone";
                    value = 18;
                };
                class Strategic {
                    name = "Strategic";
                    value = 19;
                };
                class StrongpointArea {
                    name = "Strongpoint Area";
                    value = 20;
                };
                class VegetationBroadleaf {
                    name = "Vegetation Broadleaf";
                    value = 21;
                };
                class VegetationFir {
                    name = "Vegetation Fir";
                    value = 22;
                };
                class VegetationPalm {
                    name = "Vegetation Palm";
                    value = 23;
                };
                class VegetationVineyard {
                    name = "Vegetation Vineyard";
                    value = 24;
                };
                class ViewPoint {
                    name = "Viewpoint";
                    value = 25;
                };
            };
        };

        class Importance: Edit {
            property = QGVAR(ModuleCreateMapLocation_Importance);
            displayName = "Importance";
            tooltip = "Sets the importance value of the location";
            defaultValue = 1;
            typeName = "NUMBER";
        };

        class ModuleDescription: ModuleDescription {};
    };

    class ModuleDescription: ModuleDescription {
        description[] = {
            "Creates a terrain based location.",
            "",
            CSTRING(ModuleDescription_TriggerActivated_False),
            CSTRING(ModuleDescription_Repeatable_False)
        };
        position = 1;
        direction = 1;
    };
};