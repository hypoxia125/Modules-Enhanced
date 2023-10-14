#include "script_component.hpp"

params [["_module", "", [objNull, ""]]];

if (is3DEN) then {
    [FORMAT_1(LLSTRING(InvalidSync),_module), 1, 5, true] call BIS_fnc_3DENNotification;
} else {
    [QGVAR(SystemMsg), FORMAT_1(LLSTRING(InvalidSync_Short),_module)] call CBA_fnc_globalEvent;
};
