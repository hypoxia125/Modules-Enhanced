#define MAINPREFIX z
#define PREFIX meh

#define REQUIRED_VERSION 2.14

// Versioning
#include "\z\meh\addons\main\script_version.hpp"

//#define DEBUG_MODE_FULL

#include "\x\cba\addons\main\script_macros_common.hpp"
#include "\x\cba\addons\xeh\script_xeh.hpp"

#define SEC_TO_MIN(sec) (sec / 60)
#define SEC_TO_HR(sec) (sec / 60 / 60)
#define MIN_TO_SEC(min) (min * 60)
#define MIN_TO_HR(hr) (min / 60)
#define HR_TO_SEC(hr) (hr * 60 * 60)
#define HR_TO_MIN(hr) (hr * 60)

#ifdef DISABLE_COMPILE_CACHE
    #undef PREP
    #define PREP(fncName) DFUNC(fncName) = compile preprocessFileLineNumbers QPATHTOF(functions\DOUBLES(fnc,fncName).sqf)
#else
    #undef PREP
    #define PREP(fncName) [QPATHTOF(functions\DOUBLES(fnc,fncName).sqf), QFUNC(fncName)] call CBA_fnc_compileFunction
#endif
