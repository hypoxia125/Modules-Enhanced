class MEH_Modules_CapturePointHUD {
    idd = 738562109;
    duration = 1e11;


    onLoad = "uiNamespace setVariable ['MEH_Modules_CapturePointHUD', _this#0]";
    onUnload = "uiNamespace setVariable ['MEH_Modules_CapturePointHUD', nil]";

    class Controls {
        class Main: RscControlsGroup {
            idc = 1000;

            x = QUOTE(CENTER_X(MAX_LEFT));
            y = QUOTE(VCENTER(15));
            w = QUOTE(GRID_W(TOTAL_WIDTH));
            h = QUOTE(GRID_H(PROGRESS_BARS_TOTAL_HEIGHT(4)));
            colorBackground[] = COLOR_BG;
            
            class controls {
                // ================================
                // Title
                // ================================
                class Title: RscText {
                    idc = 900;
                    x = QUOTE(0);
                    y = QUOTE(0);
                    w = QUOTE(GRID_W(TOTAL_WIDTH));
                    h = QUOTE(GRID_H(TITLE_HEIGHT));
                    text = "";
                    colorText[] = COLOR_TITLE_TEXT;
                    colorBackground[] = {0,0,0,1};
                    style = TEXT_STYLE_CENTER;
                    sizeEx = TEXT_SIZE_MEDIUM;
                    font = FONT_BOLD;
                };

                // ================================
                // BLUFOR
                // ================================
                class Blufor: RscProgress {
                    idc = 100;
                    onLoad = PROGRESS_ONLOAD;
                    x = QUOTE(GRID_W(LABEL_WIDTH));
                    y = QUOTE(GRID_H(PROGRESS_Y(0)));
                    w = QUOTE(GRID_W(BAR_WIDTH));
                    h = QUOTE(GRID_H(PROGRESS_BAR_HEIGHT));
                    colorBar[] = COLOR_BLUFOR;
                };

                class BluforTextLeft: RscText {
                    idc = 101;
                    x = QUOTE(0);
                    y = QUOTE(GRID_H(PROGRESS_Y(0)));
                    w = QUOTE(GRID_W(LABEL_WIDTH));
                    h = QUOTE(GRID_H(PROGRESS_BAR_HEIGHT));
                    text = "BLUFOR";
                    colorText[] = COLOR_BLUFOR;
                    style = TEXT_STYLE_RIGHT;
                    sizeEx = TEXT_SIZE_SMALL;
                    font = FONT_BOLD;
                };

                class BluforTextRight: RscText {
                    idc = 102;
                    x = QUOTE(GRID_W(LABEL_WIDTH + BAR_WIDTH));
                    y = QUOTE(GRID_H(PROGRESS_Y(0)));
                    w = QUOTE(GRID_W(LABEL_WIDTH));
                    h = QUOTE(GRID_H(PROGRESS_BAR_HEIGHT));
                    text = "0%";
                    colorText[] = COLOR_PROGRESS_TEXT;
                    style = TEXT_STYLE_LEFT;
                    sizeEx = TEXT_SIZE_SMALL;
                    font = FONT_BOLD;
                };

                // ================================
                // OPFOR
                // ================================
                class Opfor: RscProgress {
                    idc = 200;
                    onLoad = PROGRESS_ONLOAD;
                    x = QUOTE(GRID_W(LABEL_WIDTH));
                    y = QUOTE(GRID_H(PROGRESS_Y(1)));
                    w = QUOTE(GRID_W(BAR_WIDTH));
                    h = QUOTE(GRID_H(PROGRESS_BAR_HEIGHT));
                    colorBar[] = COLOR_OPFOR;
                };

                class OpforTextLeft: RscText {
                    idc = 201;
                    x = QUOTE(0);
                    y = QUOTE(GRID_H(PROGRESS_Y(1)));
                    w = QUOTE(GRID_W(LABEL_WIDTH));
                    h = QUOTE(GRID_H(PROGRESS_BAR_HEIGHT));
                    text = "OPFOR";
                    colorText[] = COLOR_OPFOR;
                    style = TEXT_STYLE_RIGHT;
                    sizeEx = TEXT_SIZE_SMALL;
                    font = FONT_BOLD;
                };

                class OpforTextRight: RscText {
                    idc = 202;
                    x = QUOTE(GRID_W(LABEL_WIDTH + BAR_WIDTH));
                    y = QUOTE(GRID_H(PROGRESS_Y(1)));
                    w = QUOTE(GRID_W(LABEL_WIDTH));
                    h = QUOTE(GRID_H(PROGRESS_BAR_HEIGHT));
                    text = "0%";
                    colorText[] = COLOR_PROGRESS_TEXT;
                    style = TEXT_STYLE_LEFT;
                    sizeEx = TEXT_SIZE_SMALL;
                    font = FONT_BOLD;
                };

                // ================================
                // INDFOR
                // ================================
                class Independent: RscProgress {
                    idc = 300;
                    onLoad = PROGRESS_ONLOAD;
                    x = QUOTE(GRID_W(LABEL_WIDTH));
                    y = QUOTE(GRID_H(PROGRESS_Y(2)));
                    w = QUOTE(GRID_W(BAR_WIDTH));
                    h = QUOTE(GRID_H(PROGRESS_BAR_HEIGHT));
                    colorBar[] = COLOR_INDFOR;
                };

                class IndependentTextLeft: RscText {
                    idc = 301;
                    x = QUOTE(0);
                    y = QUOTE(GRID_H(PROGRESS_Y(2)));
                    w = QUOTE(GRID_W(LABEL_WIDTH));
                    h = QUOTE(GRID_H(PROGRESS_BAR_HEIGHT));
                    text = "INDFOR";
                    colorText[] = COLOR_INDFOR;
                    style = TEXT_STYLE_RIGHT;
                    sizeEx = TEXT_SIZE_SMALL;
                    font = FONT_BOLD;
                };

                class IndependentTextRight: RscText {
                    idc = 302;
                    x = QUOTE(GRID_W(LABEL_WIDTH + BAR_WIDTH));
                    y = QUOTE(GRID_H(PROGRESS_Y(2)));
                    w = QUOTE(GRID_W(LABEL_WIDTH));
                    h = QUOTE(GRID_H(PROGRESS_BAR_HEIGHT));
                    text = "0%";
                    colorText[] = COLOR_PROGRESS_TEXT;
                    style = TEXT_STYLE_LEFT;
                    sizeEx = TEXT_SIZE_SMALL;
                    font = FONT_BOLD;
                };

                // ================================
                // CIVILIAN
                // ================================
                class Civilian: RscProgress {
                    idc = 400;
                    onLoad = PROGRESS_ONLOAD;
                    x = QUOTE(GRID_W(LABEL_WIDTH));
                    y = QUOTE(GRID_H(PROGRESS_Y(3)));
                    w = QUOTE(GRID_W(BAR_WIDTH));
                    h = QUOTE(GRID_H(PROGRESS_BAR_HEIGHT));
                    colorBar[] = COLOR_CIV;
                };

                class CivilianTextLeft: RscText {
                    idc = 401;
                    x = QUOTE(0);
                    y = QUOTE(GRID_H(PROGRESS_Y(3)));
                    w = QUOTE(GRID_W(LABEL_WIDTH));
                    h = QUOTE(GRID_H(PROGRESS_BAR_HEIGHT));
                    text = "CIV";
                    colorText[] = COLOR_CIV;
                    style = TEXT_STYLE_RIGHT;
                    sizeEx = TEXT_SIZE_SMALL;
                    font = FONT_BOLD;
                };

                class CivilianTextRight: RscText {
                    idc = 402;
                    x = QUOTE(GRID_W(LABEL_WIDTH + BAR_WIDTH));
                    y = QUOTE(GRID_H(PROGRESS_Y(3)));
                    w = QUOTE(GRID_W(LABEL_WIDTH));
                    h = QUOTE(GRID_H(PROGRESS_BAR_HEIGHT));
                    text = "0%";
                    colorText[] = COLOR_PROGRESS_TEXT;
                    style = TEXT_STYLE_LEFT;
                    sizeEx = TEXT_SIZE_SMALL;
                    font = FONT_BOLD;
                };
            };
        };
    };
};
