#include "script_component.hpp"

params [
    "_vehicle",
    "_slotType"
];

private _openSlots = ({isNull _x} count (fullCrew [_vehicle, _slotType, true] apply {_x select 0}));

_openSlots
