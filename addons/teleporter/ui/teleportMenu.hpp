#include "RscClasses.hpp"
#include "Grid.hpp"
#include "ControlStyles.hpp"
#include "ControlTypes.hpp"

class MEH_TeleportMenu {

    idd = 6969;

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
            text = "Modules Enhanced - Teleporter Menu"; //--- ToDo: Localize;
            x = QUOTE(-16.5 * GUI_GRID_W + GUI_GRID_X);
            y = QUOTE(-11.08 * GUI_GRID_H + GUI_GRID_Y);
            w = QUOTE(33 * GUI_GRID_W);
            h = QUOTE(2.5 * GUI_GRID_H);
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
            colorBackground[] = {-1,-1,-1,1};
        };
        class CurrGridTxt: RscText
        {
            idc = 1003;
            text = "Current Grid:"; //--- ToDo: Localize;
            x = QUOTE(-8 * GUI_GRID_W + GUI_GRID_X);
            y = QUOTE(-7.5 * GUI_GRID_H + GUI_GRID_Y);
            w = QUOTE(7.5 * GUI_GRID_W);
            h = QUOTE(1 * GUI_GRID_H);
            style = QUOTE(ST_CENTER);
        };
        class CurrGrid: RscText
        {
            idc = 1004;
            text = """173637"""; //--- ToDo: Localize;
            x = QUOTE(0.5 * GUI_GRID_W + GUI_GRID_X);
            y = QUOTE(-7.5 * GUI_GRID_H + GUI_GRID_Y);
            w = QUOTE(7.5 * GUI_GRID_W);
            h = QUOTE(1 * GUI_GRID_H);
            style = QUOTE(ST_CENTER);
        };
        class AvailLocTxt: RscText
        {
            idc = 1007;
            text = "Available Locations"; //--- ToDo: Localize;
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
            text = "Destination Info"; //--- ToDo: Localize;
            x = QUOTE(1 * GUI_GRID_W + GUI_GRID_X);
            y = QUOTE(-5 * GUI_GRID_H + GUI_GRID_Y);
            w = QUOTE(14.5 * GUI_GRID_W);
            h = QUOTE(1 * GUI_GRID_H);
            colorBackground[] = {"(profilenamespace getvariable ['GUI_BCG_RGB_R',0.13])","(profilenamespace getvariable ['GUI_BCG_RGB_G',0.54])","(profilenamespace getvariable ['GUI_BCG_RGB_B',0.21])",1};ackground[] = {-1,-1,-1,-1};
            style = QUOTE(ST_CENTER);
        };
        class AvailLocListbox: RscListbox
        {
            idc = 1500;
            x = QUOTE(-15 * GUI_GRID_W + GUI_GRID_X);
            y = QUOTE(-3.5 * GUI_GRID_H + GUI_GRID_Y);
            w = QUOTE(13.5 * GUI_GRID_W);
            h = QUOTE(11 * GUI_GRID_H);
            colorBackground[] = {-1,-1,-1,1};
        };
        class DestBack: RscText
        {
            idc = 1009;
            x = QUOTE(1.5 * GUI_GRID_W + GUI_GRID_X);
            y = QUOTE(-3.5 * GUI_GRID_H + GUI_GRID_Y);
            w = QUOTE(13.5 * GUI_GRID_W);
            h = QUOTE(11 * GUI_GRID_H);
            colorBackground[] = {-1,-1,-1,1};
        };
        class DestTxt: RscText
        {
            idc = 1010;
            text = "Grid Location:"; //--- ToDo: Localize;
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
            text = """183474"""; //--- ToDo: Localize;
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
            text = "Travel Distance"; //--- ToDo: Localize;
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
            text = "1837 Meters"; //--- ToDo: Localize;
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
            text = "Travel Time:"; //--- ToDo: Localize;
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
            text = "23 Seconds"; //--- ToDo: Localize;
            x = QUOTE(8.5 * GUI_GRID_W + GUI_GRID_X);
            y = QUOTE(3 * GUI_GRID_H + GUI_GRID_Y);
            w = QUOTE(6 * GUI_GRID_W);
            h = QUOTE(2.5 * GUI_GRID_H);
            colorBackground[] = {-1,-1,-1,-1};
            style = QUOTE(ST_CENTER);
        };
        class ViewOnMap: RscButton
        {
            idc = 1016;
            text = "View On Map"; //--- ToDo: Localize;
            x = QUOTE(6 * GUI_GRID_W + GUI_GRID_X);
            y = QUOTE(6 * GUI_GRID_H + GUI_GRID_Y);
            w = QUOTE(5 * GUI_GRID_W);
            h = QUOTE(1 * GUI_GRID_H);
            colorBackground[] = {-1,-1,-1,-1};
            style = QUOTE(ST_CENTER);
        };
        class RscButtonMenuOK_2600: RscButtonMenuOK
        {
            x = QUOTE(11.5 * GUI_GRID_W + GUI_GRID_X);
            y = QUOTE(9.5 * GUI_GRID_H + GUI_GRID_Y);
            w = QUOTE(5 * GUI_GRID_W);
            h = QUOTE(1.5 * GUI_GRID_H);
            colorBackground[] = {0,0,0,1};
        };
        class RscButtonMenuCancel_2700: RscButtonMenuCancel
        {
            x = QUOTE(-16.5 * GUI_GRID_W + GUI_GRID_X);
            y = QUOTE(9.5 * GUI_GRID_H + GUI_GRID_Y);
            w = QUOTE(5 * GUI_GRID_W);
            h = QUOTE(1.5 * GUI_GRID_H);
            colorBackground[] = {0,0,0,1};
        };
    };
};
