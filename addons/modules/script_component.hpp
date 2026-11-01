#define COMPONENT modules

// #define DEBUG_MODE_FULL

#include "\z\meh\addons\main\script_mod.hpp"

// Keep module callbacks and implementation helpers internal; compile public APIs separately.
#ifdef DISABLE_COMPILE_CACHE
    #define PREP_PRIVATE(fncName) DFUNC(fncName) = compile preprocessFileLineNumbers QPATHTOF(functions\private\DOUBLES(fnc,fncName).sqf)
    #define PREP_PUBLIC(fncName) DFUNC(fncName) = compile preprocessFileLineNumbers QPATHTOF(functions\public\DOUBLES(fnc,fncName).sqf)
#else
    #define PREP_PRIVATE(fncName) [QPATHTOF(functions\private\DOUBLES(fnc,fncName).sqf), QFUNC(fncName)] call CBA_fnc_compileFunction
    #define PREP_PUBLIC(fncName) [QPATHTOF(functions\public\DOUBLES(fnc,fncName).sqf), QFUNC(fncName)] call CBA_fnc_compileFunction
#endif
