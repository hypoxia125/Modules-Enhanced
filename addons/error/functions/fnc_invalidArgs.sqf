#include "script_component.hpp"

params [
    ["_module", "", [objNull, ""]],
    ["_additionalInfo", "None", [""]]
];

if (is3DEN) then {
    [FORMAT_2(LLSTRING(InvalidArgs),_module,_additionalInfo), 1, 5, true] call BIS_fnc_3DENNotification;
    ERROR(FORMAT_2(LLSTRING(STR_MEH_Error_InvalidArgsRPT),_module,_additionalInfo));
} else {
    [QGVAR(SystemMsg), FORMAT_1(LLSTRING(InvalidArgs_Short),_module)] call CBA_fnc_globalEvent;
    ERROR(FORMAT_2(LLSTRING(STR_MEH_Error_InvalidArgsRPT),_module,_additionalInfo));
};
