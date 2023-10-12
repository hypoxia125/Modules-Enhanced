#include "script_component.hpp"

if (is3DEN) then {
    [LLSTRING(InvalidArgs), 1, 5, true] call BIS_fnc_3DENNotification;
} else {
    [QGVAR(SystemMsg), LLSTRING(InvalidArgs)] call CBA_fnc_globalEvent;
};
