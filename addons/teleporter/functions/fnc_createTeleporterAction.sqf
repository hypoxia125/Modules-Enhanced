#include "script_component.hpp"

params ["_object"];

private _data = ["object", _object] call FUNC(getTeleporterData);

_data params ["_name", "_object", "_side", "_bidirectional", "_travelTime", "_active"];

private _actionID = _object addAction [
    LLSTRING(OpenTeleportMenu),
    {
        params ["_target", "_caller", "_actionID", "_arguments"];

        call FUNC(openTeleportMenu);
    },
    nil, 1e6, true, true, "",
    toString {
        private _data = ["object", _target] call FUNC(getTeleporterData);
        side group _this == (_data param [2, sideUnknown]) &&
        {_data param [3, false]}
    },
    5, false, "", ""
];

INFO_2("(%1) Teleporter Action Created For: %2",QFUNC(createTeleporterAction),_object);
[QGVAR(TeleportActionCreated), [_object, _actionID]] call CBA_fnc_localEvent;
