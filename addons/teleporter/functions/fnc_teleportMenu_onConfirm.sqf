#include "script_component.hpp"

params ["_control"];

private _lbControl = findDisplay IDD_TELEPORTMENU displayCtrl IDC_LOCLIST;
private _nameSel = _lbControl lbText (lbCurSel _lbControl);
private _data = ["name", _nameSel] call FUNC(getTeleporterData);

_data params ["_name", "_object", "_side", "_bidirectional", "_travelTime", "_active"];

if (!_active) exitWith {
    hint LLSTRING(TeleportUnavailable);
};
if (_object isKindOf "AllVehicles") then {
    if ([_object, ""] call FUNC(findOpenVehiclePosition) <= 0 && {!(player in (_object getVariable [QGVAR(currentTravelers), []]))}) exitWith {
        hint LLSTRING(NoAvailableVehicleSlots);
    };
};

[player, _object, _travelTime] call FUNC(teleportPlayer);
