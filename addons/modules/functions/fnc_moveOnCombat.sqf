#include "script_component.hpp"

params [
    ["_module", objNull, [objNull]],
    ["_units", [], [objNull, []]],
    ["_isActivated", false, [true]]
];

if (!isServer) exitWith {false};
if (_units isEqualTo objNull) then {_units = [_units]};

private _groups = _units apply {group _x};
_groups = _groups arrayIntersect _groups;

private _delay = _module getVariable [QGVAR(ModuleMoveOnCombat_Delay), 0];

// execute on groups
_groups apply {
    private _group = _x;
    private _units = units _group;

    _units apply {
        _x disableAI "PATH";
    };

    [{
        params ["_group", "_delay"];
        private _condValid = units _group findIf {alive _x} != -1;
        private _activate = combatBehaviour _group in ["COMBAT", "STEALTH"];
        _activate || {(!(_condValid))};
    }, {
        params ["_group", "_delay"];
        private _condValid = units _group findIf {alive _x} != -1;
        if (!(_condValid)) exitWith {};
        [{
            params ["_group"];
            units _group apply {
                _x enableAI "PATH";
            };
        }, [_group], _delay] call CBA_fnc_waitAndExecute;
    }, [_group, _delay]] call CBA_fnc_waitUntilAndExecute;
};

true