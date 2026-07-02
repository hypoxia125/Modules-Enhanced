#include "\z\meh\addons\common\ui\RscClasses.hpp"
#include "\z\meh\addons\common\ui\Grid.hpp"
#include "\z\meh\addons\common\ui\ControlStyles.hpp"
#include "\z\meh\addons\common\ui\ControlTypes.hpp"

class MEH_TeleportMenu {
    idd = 5165189;
    onLoad = "_this call MEH_Teleporter_fnc_teleportMenu_onLoad";

    class Controls {
        class MenuBackground: RscText {
            idc = 1000;
            x = QUOTE(CENTER_X(-16.5));
            y = QUOTE(CENTER_Y(-8.5));
            w = QUOTE(GRID_W(33));
            h = QUOTE(GRID_H(18));
            colorBackground[] = {0,0,0,0.5};
        };
        
        class AvailLocFrame: RscFrame {
            idc = 1801;
            x = QUOTE(CENTER_X(-15.5));
            y = QUOTE(CENTER_Y(-5));
            w = QUOTE(GRID_W(14.5));
            h = QUOTE(GRID_H(13));
        };
        
        class DestFrame: RscFrame {
            idc = 1800;
            x = QUOTE(CENTER_X(1));
            y = QUOTE(CENTER_Y(-5));
            w = QUOTE(GRID_W(14.5));
            h = QUOTE(GRID_H(13));
        };
        
        class MenuTxt: RscText {
            idc = 1001;
            text = CSTRING(TeleportMenu_MenuTxt);
            x = QUOTE(CENTER_X(-16.5));
            y = QUOTE(CENTER_Y(-9.5));
            w = QUOTE(GRID_W(33));
            h = QUOTE(GRID_H(1));
            colorBackground[] = {"(profilenamespace getvariable ['GUI_BCG_RGB_R',0.13])","(profilenamespace getvariable ['GUI_BCG_RGB_G',0.54])","(profilenamespace getvariable ['GUI_BCG_RGB_B',0.21])",1};
            style = QUOTE(ST_CENTER);
        };
        
        class CurrBack: RscText {
            idc = 1002;
            x = QUOTE(CENTER_X(-8.5));
            y = QUOTE(CENTER_Y(-8));
            w = QUOTE(GRID_W(17.5));
            h = QUOTE(GRID_H(2));
            colorBackground[] = {-1,-1,-1,0.5};
        };
        
        class CurrGridTxt: RscText {
            idc = 1003;
            text = CSTRING(TeleportMenu_CurrentGrid);
            x = QUOTE(CENTER_X(-8));
            y = QUOTE(CENTER_Y(-7.5));
            w = QUOTE(GRID_W(7.5));
            h = QUOTE(GRID_H(1));
            style = QUOTE(ST_CENTER);
        };
        
        class CurrGrid: RscText {
            idc = 1004;
            text = CSTRING(TeleportMenu_NA);
            x = QUOTE(CENTER_X(0.5));
            y = QUOTE(CENTER_Y(-7.5));
            w = QUOTE(GRID_W(7.5));
            h = QUOTE(GRID_H(1));
            style = QUOTE(ST_CENTER);
        };
        
        class AvailLocTxt: RscText {
            idc = 1007;
            text = CSTRING(TeleportMenu_AvailableLocations);
            x = QUOTE(CENTER_X(-15.5));
            y = QUOTE(CENTER_Y(-5));
            w = QUOTE(GRID_W(14.5));
            h = QUOTE(GRID_H(1));
            colorBackground[] = {"(profilenamespace getvariable ['GUI_BCG_RGB_R',0.13])","(profilenamespace getvariable ['GUI_BCG_RGB_G',0.54])","(profilenamespace getvariable ['GUI_BCG_RGB_B',0.21])",1};
            style = QUOTE(ST_CENTER);
        };
        
        class DestInfoTxt: RscText {
            idc = 1008;
            text = CSTRING(TeleportMenu_DestinationInfo);
            x = QUOTE(CENTER_X(1));
            y = QUOTE(CENTER_Y(-5));
            w = QUOTE(GRID_W(14.5));
            h = QUOTE(GRID_H(1));
            colorBackground[] = {"(profilenamespace getvariable ['GUI_BCG_RGB_R',0.13])","(profilenamespace getvariable ['GUI_BCG_RGB_G',0.54])","(profilenamespace getvariable ['GUI_BCG_RGB_B',0.21])",1};
            style = QUOTE(ST_CENTER);
        };
        
        class AvailLocListbox: RscListBox {
            idc = 1500;
            x = QUOTE(CENTER_X(-15));
            y = QUOTE(CENTER_Y(-3.5));
            w = QUOTE(GRID_W(13.5));
            h = QUOTE(GRID_H(11));
            colorBackground[] = {-1,-1,-1,0.5};
            onLBSelChanged = "_this call MEH_Teleporter_fnc_teleportMenu_updateInfo";
        };
        
        class DestBack: RscText {
            idc = 1009;
            x = QUOTE(CENTER_X(1.5));
            y = QUOTE(CENTER_Y(-3.5));
            w = QUOTE(GRID_W(13.5));
            h = QUOTE(GRID_H(11));
            colorBackground[] = {-1,-1,-1,0.5};
        };
        
        class DestTxt: RscText {
            idc = 1010;
            text = CSTRING(TeleportMenu_Destination);
            x = QUOTE(CENTER_X(2));
            y = QUOTE(CENTER_Y(-3));
            w = QUOTE(GRID_W(6));
            h = QUOTE(GRID_H(2.5));
            colorBackground[] = {-1,-1,-1,-1};
            style = QUOTE(ST_CENTER);
        };
        
        class DestGrid: RscText {
            idc = 1011;
            text = CSTRING(TeleportMenu_NA);
            x = QUOTE(CENTER_X(8.5));
            y = QUOTE(CENTER_Y(-3));
            w = QUOTE(GRID_W(6));
            h = QUOTE(GRID_H(2.5));
            colorBackground[] = {-1,-1,-1,-1};
            style = QUOTE(ST_CENTER);
        };
        
        class DistTxt: RscText {
            idc = 1012;
            text = CSTRING(TeleportMenu_Distance);
            x = QUOTE(CENTER_X(2));
            y = QUOTE(CENTER_Y(0));
            w = QUOTE(GRID_W(6));
            h = QUOTE(GRID_H(2.5));
            colorBackground[] = {-1,-1,-1,-1};
            style = QUOTE(ST_CENTER);
        };
        
        class Dist: RscText {
            idc = 1013;
            text = CSTRING(TeleportMenu_NA);
            x = QUOTE(CENTER_X(8.5));
            y = QUOTE(CENTER_Y(0));
            w = QUOTE(GRID_W(6));
            h = QUOTE(GRID_H(2.5));
            colorBackground[] = {-1,-1,-1,-1};
            style = QUOTE(ST_CENTER);
        };
        
        class TravelTimeTxt: RscText {
            idc = 1014;
            text = CSTRING(TeleportMenu_TravelTime);
            x = QUOTE(CENTER_X(2));
            y = QUOTE(CENTER_Y(3));
            w = QUOTE(GRID_W(6));
            h = QUOTE(GRID_H(2.5));
            colorBackground[] = {-1,-1,-1,-1};
            style = QUOTE(ST_CENTER);
        };
        
        class TravelTime: RscText {
            idc = 1015;
            text = CSTRING(TeleportMenu_NA);
            x = QUOTE(CENTER_X(8.5));
            y = QUOTE(CENTER_Y(3));
            w = QUOTE(GRID_W(6));
            h = QUOTE(GRID_H(2.5));
            colorBackground[] = {-1,-1,-1,-1};
            style = QUOTE(ST_CENTER);
        };
        
        class ViewOnMap: RscButtonMenu {
            idc = 1016;
            text = CSTRING(TeleportMenu_ViewOnMap);
            x = QUOTE(CENTER_X(2.5));
            y = QUOTE(CENTER_Y(5.5));
            w = QUOTE(GRID_W(11.5));
            h = QUOTE(GRID_H(1));
            colorBackground[] = {-1,-1,-1,-1};
            onButtonClick = "_this call MEH_Teleporter_fnc_teleportMenu_onViewMap";
            style = QUOTE(ST_CENTER);

            class Attributes {
                font = "RobotoCondensed";
                align = "center";
                shadow = "false";
            };
        };
        
        class RscButtonMenuOK_2600: RscShortcutButton {
            x = QUOTE(CENTER_X(11.5));
            y = QUOTE(CENTER_Y(9.5));
            w = QUOTE(GRID_W(5));
            h = QUOTE(GRID_H(1.5));

            text = "Confirm";
            class TextPos {
                left = QUOTE(GRID_W(0.5));
                top = QUOTE(GRID_H(0.25));
                right = 0;
                bottom = 0;
            };
            class ShortcutPos {
                left = QUOTE(GRID_W(3.75));
                top = QUOTE(GRID_H(0.125));
                w = QUOTE(GRID_W(1));
                h = QUOTE(GRID_H(1));
            };

            colorBackground[] = {0,0.5,0,1};
            colorBackgroundFocused[] = {0,0.5,0,1};
            colorBackground2[] = {0,1,0,1};
            textureNoShortcut = "a3\3den\data\controls\ctrlcheckbox\baseline_texturechecked_ca.paa";

            #pragma hemtt suppress pw3_padded_arg
            onButtonClick = QUOTE(\
                params ['_ctrl'];\
                _this call MEH_Teleporter_fnc_teleportMenu_onConfirm;\
                ctrlParent _ctrl closeDisplay 1;\
            );
        };
        
        class RscButtonMenuCancel_2700: RscShortcutButton {
            x = QUOTE(CENTER_X(-16.5));
            y = QUOTE(CENTER_Y(9.5));
            w = QUOTE(GRID_W(5));
            h = QUOTE(GRID_H(1.5));

            text = "Cancel";
            class TextPos {
                left = QUOTE(GRID_W(0.5));
                top = QUOTE(GRID_H(0.25));
                right = 0;
                bottom = 0;
            };
            class ShortcutPos {
                left = QUOTE(GRID_W(3.75));
                top = QUOTE(GRID_H(0.4));
                w = QUOTE(GRID_W(0.75));
                h = QUOTE(GRID_H(0.75));
            };

            colorBackground[] = {0.5,0,0,1};
            colorBackgroundFocused[] = {0.5,0,0,1};
            colorBackground2[] = {1,0,0,1};
            textureNoShortcut = "a3\ui_f\data\gui\cfg\cursors\hc_unsel_gs.paa";

            #pragma hemtt suppress pw3_padded_arg
            onButtonClick = QUOTE(\
                params ['_ctrl'];\
                ctrlParent _ctrl closeDisplay 2;\
            );
        };
    };
};
