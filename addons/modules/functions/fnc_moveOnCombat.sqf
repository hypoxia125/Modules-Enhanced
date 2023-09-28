/*
    Author: Hypoxic
    Sets units in given groups to hold their position until combat starts. Optional delay before movement can be given.

    Arguments:
    0: Groups - ARRAY or GROUP
    1: Delay - NUMBER

    ReturnValue:
    0: Groups - ARRAY
    1: Delay - NUMBER

    Example:
    [group_1, group_2, group_3, 300] call MEH_Modules_fnc_moveOnCombat;

    Public: Yes
*/

#include "script_component.hpp"

params [
    ["_groups", [], [[], grpNull]],
    ["_delay", 0, [-1]]
];

// Validate variables
if (_groups isEqualType grpNull) then {_groups = [_groups]};
if (_delay < 0) then {_delay = 0};

// Execute on groups
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

[_groups, _delay];
