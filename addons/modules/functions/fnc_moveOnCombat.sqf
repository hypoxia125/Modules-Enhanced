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

    _group setVariable [QGVAR(moveOnCombat_delay), _delay];

    units _group apply {
        _x disableAI "PATH";
    };

    _group addEventHandler ["CombatModeChanged", {
        params ["_group", "_newMode"];

        if !(_newMode in ["COMBAT","STEALTH"]) exitWith {};

        private _delay = _group getVariable [QGVAR(moveOnCombat_delay), 0];

        [{
            params ["_group"];
            units _group apply {
                _x enableAI "PATH";
            };
        }, [_group], _delay] call CBA_fnc_waitAndExecute;

        _group removeEventHandler [_thisEvent, _thisEventHandler];
    }];
};

[_groups, _delay];
