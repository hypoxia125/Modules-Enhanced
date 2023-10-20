#include "script_component.hpp"

params [
    "_control",
    "_lbCurSel",
    "_lbSelection"
];

private _nameSel = _control lbText _lbCurSel;
private _data = ["name", _nameSel] call FUNC(getTeleporterData);

_data params ["_name", "_object", "_side", "_bidirectional", "_travelTime", "_active"];

private _gridLoc = mapGridPosition _object;
private _travelDistance = player distance ASLtoAGL (getPosASL _object);
if (_travelTime == -1) then {
    _travelTime = [player, ASLtoAGL (getPosASL _object)] call FUNC(getTravelTime);
};

// Set grid location
(ctrlParent _control displayCtrl IDC_DESTGRID) ctrlSetText _gridLoc;
// Set grid distance
(ctrlParent _control displayCtrl IDC_DESTDIST) ctrlSetText (FORMAT_1("%1 meters", round _travelDistance));
// Set travel time
(ctrlParent _control displayCtrl IDC_DESTTIME) ctrlSetText (FORMAT_1("%1 seconds", round _travelTime));

[QGVAR(teleportMenu_updateInfo), [_gridLoc, round _travelDistance, round _travelTime]] call CBA_fnc_localEvent;
