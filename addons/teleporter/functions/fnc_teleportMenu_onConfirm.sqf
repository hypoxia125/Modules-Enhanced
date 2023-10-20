#include "script_component.hpp"

params ["_control"];

private _lbControl = findDisplay IDD_TELEPORTMENU displayCtrl IDC_LOCLIST;
private _nameSel = _lbControl lbText (lbCurSel _lbControl);
private _data = ["name", _nameSel] call FUNC(getTeleporterData);

_data params ["_name", "_object", "_side", "_bidirectional", "_travelTime", "_active"];

if (!_active) exitWith {
    hint LLSTRING(TeleportUnavailable);
};

[player, getPosATL _object, _travelTime] call FUNC(teleportPlayer);
