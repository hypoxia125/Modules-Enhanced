#define PATHTOPUBLICFUNC(var) QUOTE(functions\public\var)
#define PATHTOPRIVATEFUNC(var) QUOTE(functions\private\var);
#define PATHTOMODULEFUNC(var) QUOTE(functions\moduleFunctions\var);

#define PUBLIC_FUNC(name) class name { file = PATHTOPUBLICFUNC(name); }
#define PRIVATE_FUNC(name) class name { file = PATHTOPRIVATEFUNC(name); }
#define MODULE_FUNC(name) class name { file = PATHTOMODULEFUNC(name); }

class CfgFunctions {
    class ADDON {
        class fnc {
            MODULE_FUNC(ambientArtilleryVirtual);
            PUBLIC_FUNC(createVirtualArtilleryRound);
            PUBLIC_FUNC(doVirtualArtilery);
        };
    };
};