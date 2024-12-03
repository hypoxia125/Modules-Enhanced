class CfgVehicles {
    class FlagCarrier;
    class Flag_MEH_F: FlagCarrier {
        author = "Hypoxic";
        displayName = "Flag (Modules Enhanced)";
        editorPreview = "\z\meh\addons\common\data\textures\flags\flag_MEH_co.paa";
        class EventHandlers {
            init = "(_this select 0) setFlagTexture '\z\meh\addons\common\data\textures\flags\flag_MEH_co.paa'";
        };
        scope = 2;
        scopeCurator = 2;
    };

    class Flag_MEH_Inverted_F: Flag_MEH_F {
        displayName = "Flag (Modules Enhanced - Inverted)";
        editorPreview = "\z\meh\addons\common\data\textures\flags\flag_MEH_Inverted_co.paa";
        class EventHandlers {
            init = "(_this select 0) setFlagTexture '\z\meh\addons\common\data\textures\flags\flag_MEH_Inverted_co.paa'";
        };
    };

    class Banner_01_base_F;
    class Banner_MEH_F: Banner_01_base_F {
        author = "Hypoxic";
        displayName = "Banner (Modules Enhanced)";
        editorPreview = "\z\meh\addons\common\data\textures\flags\flag_MEH_co.paa";
        hiddenSelectionsTextures[] = {"\z\meh\addons\common\data\textures\flags\flag_MEH_co.paa"};
        scope = 2;
        scopeCurator = 2;
    };

    class Banner_MEH_Inverted_F: Banner_MEH_F {
        displayName = "Banner (Modules Enhanced - Inverted)";
        editorPreview = "\z\meh\addons\common\data\textures\flags\flag_MEH_Inverted_co.paa";
        hiddenSelectionsTextures[] = {"\z\meh\addons\common\data\textures\flags\flag_MEH_Inverted_co.paa"};
    };
};