#include "script_component.hpp"

params [
    "_display",
    "_config"
];

LOG_1("Display Created: %1", _display);

disableSerialization;

private _data = GVAR(teleporterData);

// Current Grid

(_display displayCtrl IDC_CURRENTGRID) ctrlSetText (str mapGridPosition player);

// Locations List
_data apply {
    _x params ["_name", "_object", "_side", "_bidirectional", "_travelTime", "_active"];

    if (
        !alive _object ||
        !_active ||
        side group player isNotEqualTo _side
    ) then {
        continue;
    };
    
    private _index = (_display displayCtrl IDC_LOCLIST) lbAdd _name;

    if (
        _object isKindOf "AllVehicles" &&
        {
            [_object, ""] call FUNC(findOpenVehiclePosition) <= 0 && {!(player in (_object getVariable [QGVAR(currentTravelers), []]))}
        }
    ) then {
        (_display displayCtrl IDC_LOCLIST) lbSetColor [_index, [0.9,0,0,1]];
    } else {
        (_display displayCtrl IDC_LOCLIST) lbSetColor [_index, [0,0.8,0,1]];
    }
};

[QGVAR(teleportMenuCreated), [_display]] call CBA_fnc_localEvent;
