class CfgAmmo {
    class F_40mm_White;
    class MEH_FlareBase: F_40mm_White {};

    // White Flare <1 min, 3 min, 5 min>
    class MEH_40mm_White_60: MEH_FlareBase {
        lightColor[] = {0.5,0.5,0.5,0.5};
        timeToLive = 60;
    };

    class MEH_40mm_White_180: MEH_40mm_White_60 {
        timeToLive = 180;
    };

    class MEH_40mm_White_300: MEH_40mm_White_60 {
        timeToLive = 300;
    };

    // Red Flare <1 min, 3 min, 5 min>
    class MEH_40mm_Red_60: MEH_FlareBase {
        lightColor[] = {0.5,0.25,0.25,0};
        timeToLive = 60;
    };

    class MEH_40mm_Red_180: MEH_40mm_Red_60 {
        timeToLive = 180;
    };

    class MEH_40mm_Red_300: MEH_40mm_Red_60 {
        timeToLive = 300;
    };

    // Green Flare <1 min, 3 min, 5 min>
    class MEH_40mm_Green_60: MEH_FlareBase {
        lightColor[] = {0.25,0.5,0.25,0};
        timeToLive = 60;
    };

    class MEH_40mm_Green_180: MEH_40mm_Green_60 {
        timeToLive = 180;
    };

    class MEH_40mm_Green_300: MEH_40mm_Green_60 {
        timeToLive = 300;
    };

    // Yellow Flare <1 min, 3 min, 5 min>
    class MEH_40mm_Yellow_60: MEH_FlareBase {
        lightColor[] = {0.5,0.5,0.25,0};
        timeToLive = 60;
    };

    class MEH_40mm_Yellow_180: MEH_40mm_Yellow_60 {
        timeToLive = 180;
    };

    class MEH_40mm_Yellow_300: MEH_40mm_Yellow_60 {
        timeToLive = 300;
    };

    // Purple Flare <1 min, 3 min, 5 min>
    class MEH_40mm_Purple_60: MEH_FlareBase {
        lightColor[] =  {0.5,0.25,0.5,0};
        timeToLive = 60;
    };

    class MEH_40mm_Purple_180: MEH_40mm_Purple_60 {
        timeToLive = 180;
    };

    class MEH_40mm_Purple_300: MEH_40mm_Purple_60 {
        timeToLive = 300;
    };

    // Orange Flare <1 min, 3 min, 5 min>
    class MEH_40mm_Orange_60: MEH_FlareBase {
        lightColor[] =  {0.5,0.35,0.25,0};
        timeToLive = 60;
    };

    class MEH_40mm_Orange_180: MEH_40mm_Orange_60 {
        timeToLive = 180;
    };

    class MEH_40mm_Orange_300: MEH_40mm_Orange_60 {
        timeToLive = 300;
    };

    // Blue Flare <1 min, 3 min, 5 min>
    class MEH_40mm_Blue_60: MEH_FlareBase {
        lightColor[] =  {0.25,0.25,0.5,0};
        timeToLive = 60;
    };

    class MEH_40mm_Blue_180: MEH_40mm_Blue_60 {
        timeToLive = 180;
    };

    class MEH_40mm_Blue_300: MEH_40mm_Blue_60 {
        timeToLive = 300;
    };
};