/* ----------------------------------------------------------------------------
Function: meh_modules_fnc_ModuleEarthquakeDamageArea

Author: Hypoxic

Public: False - Requires internal data

Description:
    Validates editor connections. Damage-area settings are read by the epicenter.
---------------------------------------------------------------------------- */

#include "script_component.hpp"

params [["_mode", "", [""]], ["_input", [], [[]]]];
_input params [["_module", objNull, [objNull]]];

if (_mode == "connectionChanged3DEN") then {
    private _synced = get3DENConnections _module apply {_x select 1};
    private _invalid = _synced select {!(_x isKindOf "MEH_ModuleEarthquakeEpicenter")};
    if (_invalid isNotEqualTo []) then {
        [typeOf _module] call EFUNC(Error,invalidSync);
        remove3DENConnection ["Sync", _invalid, _module];
    };
};
