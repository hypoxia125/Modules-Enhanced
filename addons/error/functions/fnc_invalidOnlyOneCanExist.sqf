#include "script_component.hpp"

params [
    ["_module", "", [objNull, ""]],
    ["_additionalInfo", "", [""]]
];

if (is3DEN) then {
    [FORMAT_2(LLSTRING(OnlyOneCanExist),_module,_additionalInfo), 1, 5, true] call BIS_fnc_3DENNotification;
    ERROR(FORMAT_2(LLSTRING(OnlyOneCanExist),_module,_additionalInfo));
} else {
    [QGVAR(SystemMsg), FORMAT_1(LLSTRING(OnlyOneCanExist),_module)] call CBA_fnc_globalEvent;
    ERROR(FORMAT_2(LLSTRING(OnlyOneCanExist),_module,_additionalInfo));
};
