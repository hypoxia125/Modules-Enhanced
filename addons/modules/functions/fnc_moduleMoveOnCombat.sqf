#include "script_component.hpp"

params [
    ["_mode", "", [""]],
    ["_input", [], [[]]]
];
_input params [
    ["_module", objNull, [objNull]],
    ["_isActivated", false, [true]],
    ["_isCuratorPlaced", false, [true]]
];

if (!isServer) exitWith {};
if (!is3DEN && {!_isActivated}) exitWith {};
if (_mode in ["dragged3DEN", "unregisteredFromWorld3DEN"]) exitWith {};

// Variables
private _delay = _module getVariable [QUOTE(Delay), 0];
private _units = synchronizedObjects _module select {_x isKindOf "CAManBase"};
if (_delay < 0) exitWith {[typeOf _module] call EFUNC(Error,invalidArgs)};

switch _mode do {
    case "init": {
        if (is3DEN) exitWith {};

        // Get groups
        if (_units isEqualTo []) exitWith {[typeOf _module] call EFUNC(Error,requiresSync)};
        private _groups = _units apply {group _x};
        _groups = _groups arrayIntersect _groups;

        [_groups, _delay] call FUNC(moveOnCombat);
    };

    case "connectionChanged3DEN": {
        private _synced = get3DENConnections _module apply {_x select 1};
        private _invalid = _synced select {!(_x isKindOf "CAManBase")};
        if (_invalid isNotEqualTo []) then {
            [typeOf _module] call EFUNC(Error,invalidSync);

            // remove connection
            remove3DENConnection ["Sync", _invalid, _module];
        };
    };

    default {};
};
