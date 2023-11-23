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

if (_mode in ["dragged3DEN", "unregisteredFromWorld3DEN"]) exitWith {};

// Variables
private _area = _module getVariable ["ObjectArea", [100, 100, 0, false, 100]];

switch _mode do {
    case "init": {
        if (is3DEN) exitWith {};
        if (!hasInterface) exitWith {};

        private _objects = synchronizedObjects _module select {!(_x isKindOf "EmptyDetector")};
        if (count _objects > 1) exitWith {};

        private _object = _objects select 0;

        // Use module if object doesn't exist
        if (isNil "_object") then {_object = _module};

        _area = [getPosATL _object] + _area;

        [_module, _object, _area] call EFUNC(communicationjammer,initCommJammer);
    };
};