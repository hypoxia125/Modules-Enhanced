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

// Variables
private _chuteOpenHeight = _module getVariable "ChuteOpenHeight";
private _chuteType = _module getVariable "ChuteType";
private _trailingSmoke = _module getVariable "TrailingSmoke";

_chuteType = ["NonSteerable_Parachute_F", "Steerable_Parachute_F"] select (_chuteType == 0);

private _vehicles = synchronizedObjects _module select {_x isKindOf "Air"};
switch _mode do {
    case "init": {
        if (is3DEN) exitWith {};

        if (_vehicles isEqualTo []) then {[typeOf _module] call EFUNC(Error,requiresSync)};
        [_vehicles, _chuteOpenHeight, _chuteType, _trailingSmoke] call FUNC(ParadropTroopTransport);
    };

    case "connectionChanged3DEN": {
        private _synced = get3DENConnections _module apply {_x select 1};
        private _invalid = _synced select {!(_x isKindOf "Air")};

        if (_invalid isNotEqualTo []) then {
            [typeOf _module] call EFUNC(Error,invalidSync);

            // remove connection=
            remove3DENConnection ["Sync", _invalid, _module];
        };
    }
}