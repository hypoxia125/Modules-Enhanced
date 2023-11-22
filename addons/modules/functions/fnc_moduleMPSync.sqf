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

if (!is3DEN && {!_isActivated}) exitWith {};
if (_mode isEqualTo "dragged3DEN") exitWith {};

// Variables
private _minPlayers = _module getVariable ["MinPlayers", 1];
private _timeout = _module getVariable ["Timeout", 30];
private _variableToPass = _module getVariable ["VariableToPass", QEGVAR(MPSync,syncComplete)];

switch _mode do {
    case "init": {
        if (is3DEN) exitWith {};

        [_minPlayers, _timeout, _variableToPass] call EFUNC(MPSync,init);
    };

    case "connectionChanged3DEN": {
        private _synced = get3DENConnections _module apply {_x select 1};
        private _invalid = _synced;
        if (_invalid isNotEqualTo []) then {
            [typeOf _module] call EFUNC(Error,invalidSync);

            // remove connection
            remove3DENConnection ["Sync", _invalid, _module];
        };
    };
};
