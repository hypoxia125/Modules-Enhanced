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
if (_mode in ["dragged3DEN", "unregisteredFromWorld3DEN"]) exitWith {};

// Variables
private _explosiveType = _module getVariable [QUOTE(ExplosiveType), "GrenadeHand"];
private _explodeChance = _module getVariable [QUOTE(ExplodeChance), 0.5];
private _canDisable = _module getVariable [QUOTE(CanDisable), 0];
private _persist = _module getVariable [QUOTE(Persist), false];

// Verify variables
private _objects = synchronizedObjects _module select {!(_x isKindOf "EmptyDetector" || _x isKindOf "Module_F")};
if (
    _explosiveType isEqualTo "" ||
    (!(isClass (configFile >> "CfgAmmo" >> _explosiveType)))
) exitWith {[typeOf _module] call EFUNC(Error,invalidArgs)};
if (_explodeChance < 0) then {_explodeChance = 0};
if (_explodeChance > 1) then {_explodeChance = 1};

switch _mode do {
    case "init": {
        if (is3DEN) exitWith {};

        if (_objects isEqualTo []) then {[typeOf _module] call EFUNC(Error,requiresSync)};
        [_objects, _explosiveType, _explodeChance, _canDisable, _persist] call FUNC(trapInventory);
    };

    case "connectionChanged3DEN": {
        private _synced = get3DENConnections _module apply {_x select 1};
        private _invalid = _synced select {(_x isKindOf "EmptyDetector" || _x isKindOf "Module_F")};
        if (_invalid isNotEqualTo []) then {
            [typeOf _module] call EFUNC(Error,invalidSync);

            // remove connection
            remove3DENConnection ["Sync", _invalid, _module];
        };
    };

    default {};
};
