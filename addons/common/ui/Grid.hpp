#define GUI_GRID_W  (((safezoneW / safezoneH) min 1.2) / 40)
#define GUI_GRID_H  ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25)

// Maximum offsets to reach screen edges from center
#define MAX_LEFT     -40
#define MAX_RIGHT     40
#define MAX_TOP       -25
#define MAX_BOTTOM    25

// Position helpers for edge-aligned controls
#define ALIGN_LEFT(offset, width)  CENTER_X(MAX_LEFT + (offset))
#define ALIGN_RIGHT(offset, width) CENTER_X(MAX_RIGHT - (width) - (offset))
#define ALIGN_TOP(offset, height)  CENTER_Y(MAX_TOP + (offset))
#define ALIGN_BOTTOM(offset, height) CENTER_Y(MAX_BOTTOM - (height) - (offset))

#define VCENTER(height) CENTER_Y(-(height)/2)

#define GUI_GRID_CENTER_X  (safezoneX + safezoneW/2)
#define GUI_GRID_CENTER_Y  (safezoneY + safezoneH/2)

#define CENTER_X(offset)  GUI_GRID_CENTER_X + (offset) * GUI_GRID_W
#define CENTER_Y(offset)  GUI_GRID_CENTER_Y + (offset) * GUI_GRID_H

#define GRID_W(units)  ((units) * GUI_GRID_W)
#define GRID_H(units)  ((units) * GUI_GRID_H)