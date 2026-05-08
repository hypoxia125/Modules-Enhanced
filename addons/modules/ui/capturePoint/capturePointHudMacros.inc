// Layout constants
#define PROGRESS_BAR_HEIGHT 0.9
#define PROGRESS_GAP 0.1
#define TITLE_HEIGHT 0.8
#define LABEL_WIDTH 2
#define BAR_WIDTH 8
#define TOTAL_WIDTH 12

#define PROGRESS_Y(INDEX) (INDEX * (PROGRESS_BAR_HEIGHT + PROGRESS_GAP) + TITLE_HEIGHT)
#define PROGRESS_BARS_TOTAL_HEIGHT(COUNT) ((PROGRESS_BAR_HEIGHT * COUNT) + (PROGRESS_GAP * (COUNT - 1)) + TITLE_HEIGHT)

// Color constants
#define COLOR_BG {0.05, 0.05, 0.08, 0.85}
#define COLOR_TITLE_BG {0.13, 0.54, 0.21, 1}
#define COLOR_TITLE_TEXT {0.95, 0.95, 0.95, 1}
#define COLOR_PROGRESS_TEXT {0.95, 0.95, 0.95, 1}

// Faction colors
#define COLOR_BLUFOR {0, 0.3, 0.6, 1}
#define COLOR_OPFOR {0.5, 0, 0, 1}
#define COLOR_INDFOR {0, 0.5, 0, 1}
#define COLOR_CIV {0.40, 0.00, 0.50, 1}

// Text style constants
#define TEXT_STYLE_LEFT ST_LEFT
#define TEXT_STYLE_RIGHT ST_RIGHT
#define TEXT_STYLE_CENTER ST_CENTER
#define FONT_BOLD "RobotoCondensedBold"
#define FONT_REGULAR "RobotoCondensed"
#define TEXT_SIZE_SMALL QUOTE(GRID_H(0.5))
#define TEXT_SIZE_MEDIUM QUOTE(GRID_H(0.55))

// Progress bar onLoad script
#define PROGRESS_ONLOAD ""