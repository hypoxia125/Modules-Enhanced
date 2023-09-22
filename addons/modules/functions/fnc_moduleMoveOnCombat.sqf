#include "script_component.hpp"

params [
    ["_module", objNull, [objNull]],
    ["_units", [], [objNull, []]]
];

if (!isServer) exitWith {false};

// Variables
private _delay = _module getVariable [QGVAR(ModuleMoveOnCombat_Delay), 0];

// Validate variables
if (_units isEqualType objNull) then {_units = [_units]};

// Get groups
private _groups = _units apply {group _x};
_groups = _groups arrayIntersect _groups;

[_groups, _delay] call FUNC(moveOnCombat);
