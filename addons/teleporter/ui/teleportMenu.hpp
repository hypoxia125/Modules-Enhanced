#include "\z\meh\addons\common\ui\RscClasses.hpp"
#include "\z\meh\addons\common\ui\Grid.hpp"
#include "\z\meh\addons\common\ui\ControlStyles.hpp"
#include "\z\meh\addons\common\ui\ControlTypes.hpp"

class MEH_TeleportMenu {

    idd = 5165189;

    onLoad = "_this call MEH_Teleporter_fnc_teleportMenu_onLoad";

    class Controls {
        class MenuBackground: RscText
        {
            idc = 1000;
            x = QUOTE(-16.5 * GUI_GRID_W + GUI_GRID_X);
            y = QUOTE(-8.5 * GUI_GRID_H + GUI_GRID_Y);
            w = QUOTE(33 * GUI_GRID_W);
            h = QUOTE(18 * GUI_GRID_H);
            colorBackground[] = {0,0,0,0.5};
        };
        class AvailLocFrame: RscFrame
        {
            idc = 1801;
            x = QUOTE(-15.5 * GUI_GRID_W + GUI_GRID_X);
            y = QUOTE(-5 * GUI_GRID_H + GUI_GRID_Y);
            w = QUOTE(14.5 * GUI_GRID_W);
            h = QUOTE(13 * GUI_GRID_H);
        };
        class DestFrame: RscFrame
        {
            idc = 1800;
            x = QUOTE(1 * GUI_GRID_W + GUI_GRID_X);
            y = QUOTE(-5 * GUI_GRID_H + GUI_GRID_Y);
            w = QUOTE(14.5 * GUI_GRID_W);
            h = QUOTE(13 * GUI_GRID_H);
        };
        class MenuTxt: RscText
        {
            idc = 1001;
            text = CSTRING(TeleportMenu_MenuTxt);
            x = QUOTE(-16.5 * GUI_GRID_W + GUI_GRID_X);
            y = QUOTE(-9.5 * GUI_GRID_H + GUI_GRID_Y);
            w = QUOTE(33 * GUI_GRID_W);
            h = QUOTE(1 * GUI_GRID_H);
            colorBackground[] = {"(profilenamespace getvariable ['GUI_BCG_RGB_R',0.13])","(profilenamespace getvariable ['GUI_BCG_RGB_G',0.54])","(profilenamespace getvariable ['GUI_BCG_RGB_B',0.21])",1};
            style = QUOTE(ST_CENTER);
        };
        class CurrBack: RscText
        {
            idc = 1002;
            x = QUOTE(-8.5 * GUI_GRID_W + GUI_GRID_X);
            y = QUOTE(-8 * GUI_GRID_H + GUI_GRID_Y);
            w = QUOTE(17.5 * GUI_GRID_W);
            h = QUOTE(2 * GUI_GRID_H);
            colorBackground[] = {-1,-1,-1,0.5};
        };
        class CurrGridTxt: RscText
        {
            idc = 1003;
            text = CSTRING(TeleportMenu_CurrentGrid);
            x = QUOTE(-8 * GUI_GRID_W + GUI_GRID_X);
            y = QUOTE(-7.5 * GUI_GRID_H + GUI_GRID_Y);
            w = QUOTE(7.5 * GUI_GRID_W);
            h = QUOTE(1 * GUI_GRID_H);
            style = QUOTE(ST_CENTER);
        };
        class CurrGrid: RscText
        {
            idc = 1004;
            text = CSTRING(TeleportMenu_NA);
            x = QUOTE(0.5 * GUI_GRID_W + GUI_GRID_X);
            y = QUOTE(-7.5 * GUI_GRID_H + GUI_GRID_Y);
            w = QUOTE(7.5 * GUI_GRID_W);
            h = QUOTE(1 * GUI_GRID_H);
            style = QUOTE(ST_CENTER);
        };
        class AvailLocTxt: RscText
        {
            idc = 1007;
            text = CSTRING(TeleportMenu_AvailableLocations);
            x = QUOTE(-15.5 * GUI_GRID_W + GUI_GRID_X);
            y = QUOTE(-5 * GUI_GRID_H + GUI_GRID_Y);
            w = QUOTE(14.5 * GUI_GRID_W);
            h = QUOTE(1 * GUI_GRID_H);
            colorBackground[] = {"(profilenamespace getvariable ['GUI_BCG_RGB_R',0.13])","(profilenamespace getvariable ['GUI_BCG_RGB_G',0.54])","(profilenamespace getvariable ['GUI_BCG_RGB_B',0.21])",1};ackground[] = {-1,-1,-1,-1};
            style = QUOTE(ST_CENTER);
        };
        class DestInfoTxt: RscText
        {
            idc = 1008;
            text = CSTRING(TeleportMenu_DestinationInfo);
            x = QUOTE(1 * GUI_GRID_W + GUI_GRID_X);
            y = QUOTE(-5 * GUI_GRID_H + GUI_GRID_Y);
            w = QUOTE(14.5 * GUI_GRID_W);
            h = QUOTE(1 * GUI_GRID_H);
            colorBackground[] = {"(profilenamespace getvariable ['GUI_BCG_RGB_R',0.13])","(profilenamespace getvariable ['GUI_BCG_RGB_G',0.54])","(profilenamespace getvariable ['GUI_BCG_RGB_B',0.21])",1};ackground[] = {-1,-1,-1,-1};
            style = QUOTE(ST_CENTER);
        };
        class AvailLocListbox: RscListBox
        {
            idc = 1500;
            x = QUOTE(-15 * GUI_GRID_W + GUI_GRID_X);
            y = QUOTE(-3.5 * GUI_GRID_H + GUI_GRID_Y);
            w = QUOTE(13.5 * GUI_GRID_W);
            h = QUOTE(11 * GUI_GRID_H);
            colorBackground[] = {-1,-1,-1,0.5};
            onLBSelChanged = "_this call MEH_Teleporter_fnc_teleportMenu_updateInfo";
        };
        class DestBack: RscText
        {
            idc = 1009;
            x = QUOTE(1.5 * GUI_GRID_W + GUI_GRID_X);
            y = QUOTE(-3.5 * GUI_GRID_H + GUI_GRID_Y);
            w = QUOTE(13.5 * GUI_GRID_W);
            h = QUOTE(11 * GUI_GRID_H);
            colorBackground[] = {-1,-1,-1,0.5};
        };
        class DestTxt: RscText
        {
            idc = 1010;
            text = CSTRING(TeleportMenu_Destination);
            x = QUOTE(2 * GUI_GRID_W + GUI_GRID_X);
            y = QUOTE(-3 * GUI_GRID_H + GUI_GRID_Y);
            w = QUOTE(6 * GUI_GRID_W);
            h = QUOTE(2.5 * GUI_GRID_H);
            colorBackground[] = {-1,-1,-1,-1};
            style = QUOTE(ST_CENTER);
        };
        class DestGrid: RscText
        {
            idc = 1011;
            text = CSTRING(TeleportMenu_NA);
            x = QUOTE(8.5 * GUI_GRID_W + GUI_GRID_X);
            y = QUOTE(-3 * GUI_GRID_H + GUI_GRID_Y);
            w = QUOTE(6 * GUI_GRID_W);
            h = QUOTE(2.5 * GUI_GRID_H);
            colorBackground[] = {-1,-1,-1,-1};
            style = QUOTE(ST_CENTER);
        };
        class DistTxt: RscText
        {
            idc = 1012;
            text = CSTRING(TeleportMenu_Distance);
            x = QUOTE(2 * GUI_GRID_W + GUI_GRID_X);
            y = QUOTE(0 * GUI_GRID_H + GUI_GRID_Y);
            w = QUOTE(6 * GUI_GRID_W);
            h = QUOTE(2.5 * GUI_GRID_H);
            colorBackground[] = {-1,-1,-1,-1};
            style = QUOTE(ST_CENTER);
        };
        class Dist: RscText
        {
            idc = 1013;
            text = CSTRING(TeleportMenu_NA);
            x = QUOTE(8.5 * GUI_GRID_W + GUI_GRID_X);
            y = QUOTE(0 * GUI_GRID_H + GUI_GRID_Y);
            w = QUOTE(6 * GUI_GRID_W);
            h = QUOTE(2.5 * GUI_GRID_H);
            colorBackground[] = {-1,-1,-1,-1};
            style = QUOTE(ST_CENTER);
        };
        class TravelTimeTxt: RscText
        {
            idc = 1014;
            text = CSTRING(TeleportMenu_TravelTime);
            x = QUOTE(2 * GUI_GRID_W + GUI_GRID_X);
            y = QUOTE(3 * GUI_GRID_H + GUI_GRID_Y);
            w = QUOTE(6 * GUI_GRID_W);
            h = QUOTE(2.5 * GUI_GRID_H);
            colorBackground[] = {-1,-1,-1,-1};
            style = QUOTE(ST_CENTER);
        };
        class TravelTime: RscText
        {
            idc = 1015;
            text = CSTRING(TeleportMenu_NA);
            x = QUOTE(8.5 * GUI_GRID_W + GUI_GRID_X);
            y = QUOTE(3 * GUI_GRID_H + GUI_GRID_Y);
            w = QUOTE(6 * GUI_GRID_W);
            h = QUOTE(2.5 * GUI_GRID_H);
            colorBackground[] = {-1,-1,-1,-1};
            style = QUOTE(ST_CENTER);
        };
        class ViewOnMap: RscButtonMenu
        {
            idc = 1016;
            text = CSTRING(TeleportMenu_ViewOnMap);
            x = QUOTE(2.5 * GUI_GRID_W + GUI_GRID_X);
            y = QUOTE(5.5 * GUI_GRID_H + GUI_GRID_Y);
            w = QUOTE(11.5 * GUI_GRID_W);
            h = QUOTE(1 * GUI_GRID_H);
            colorBackground[] = {-1,-1,-1,-1};
            onButtonClick = "_this call MEH_Teleporter_fnc_teleportMenu_onViewMap";
            style = QUOTE(ST_CENTER);

            class Attributes
            {
                font = "RobotoCondensed";
                align = "center";
                shadow = "false";
            };
        };
        class RscButtonMenuOK_2600: RscShortcutButton
        {
            x = QUOTE(11.5 * GUI_GRID_W + GUI_GRID_X);
            y = QUOTE(9.5 * GUI_GRID_H + GUI_GRID_Y);
            w = QUOTE(5 * GUI_GRID_W);
            h = QUOTE(1.5 * GUI_GRID_H);

            text = "Confirm";
            class TextPos {
                left = QUOTE(0.5 * GUI_GRID_W);
                top = QUOTE(0.25 * GUI_GRID_H);
                right = 0;
                bottom = 0;
            };
            class ShortcutPos {
                left = QUOTE(3.75 * GUI_GRID_W);
                top = QUOTE(0.125 * GUI_GRID_H);
                w = QUOTE(1 * GUI_GRID_W);
                h = QUOTE(1 * GUI_GRID_H);
            };

            colorBackground[] = {0,0.5,0,1};
            colorBackgroundFocused[] = {0,0.5,0,1};
            colorBackground2[] = {0,1,0,1};
            textureNoShortcut = "a3\3den\data\controls\ctrlcheckbox\baseline_texturechecked_ca.paa";

            onButtonClick = QUOTE(\
                params ['_ctrl'];
                _this call MEH_Teleporter_fnc_teleportMenu_onConfirm;\
                ctrlParent _ctrl closeDisplay 1;\
            );
        };
        class RscButtonMenuCancel_2700: RscShortcutButton
        {
            x = QUOTE(-16.5 * GUI_GRID_W + GUI_GRID_X);
            y = QUOTE(9.5 * GUI_GRID_H + GUI_GRID_Y);
            w = QUOTE(5 * GUI_GRID_W);
            h = QUOTE(1.5 * GUI_GRID_H);

            text = "Cancel";
            class TextPos {
                left = QUOTE(0.5 * GUI_GRID_W);
                top = QUOTE(0.25 * GUI_GRID_H);
                right = 0;
                bottom = 0;
            };
            class ShortcutPos {
                left = QUOTE(3.75 * GUI_GRID_W);
                top = QUOTE(0.4 * GUI_GRID_H);
                w = QUOTE(0.75 * GUI_GRID_W);
                h = QUOTE(0.75 * GUI_GRID_H);
            };

            colorBackground[] = {0.5,0,0,1};
            colorBackgroundFocused[] = {0.5,0,0,1};
            colorBackground2[] = {1,0,0,1};
            textureNoShortcut = "a3\ui_f\data\gui\cfg\cursors\hc_unsel_gs.paa";

            onButtonClick = QUOTE(\
                params ['_ctrl'];
                ctrlParent _ctrl closeDisplay 2;\
            );
        };
    };
};
