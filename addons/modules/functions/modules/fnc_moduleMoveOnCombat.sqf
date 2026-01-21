#include "script_component.hpp"

// Parameters
//------------------------------------------------------------------------------------------------
params [
    ["_mode", "", [""]],
    ["_input", [], [[]]]
];
_input params [
    ["_module", objNull, [objNull]],
    ["_isActivated", false, [true]],
    ["_isCuratorPlaced", false, [true]]
];

// Pre-Execution Checks
//------------------------------------------------------------------------------------------------
if (!isServer) exitWith {};
if (!is3DEN && {!_isActivated}) exitWith {};
if (_mode in ["dragged3DEN", "unregisteredFromWorld3DEN"]) exitWith {};

// Variables
//------------------------------------------------------------------------------------------------
private _delay = _module getVariable [QUOTE(Delay), 0];
private _units = synchronizedObjects _module select {_x isKindOf "CAManBase"};

_delay = abs _delay;

// Functions
//------------------------------------------------------------------------------------------------
private _execute = {
    params ["_groups", "_delay"];

    if (_groups isEqualType grpNull) then { _groups = [_groups] };

    _groups apply {
        private _group = _x;

        _group setVariable [QGVAR(moveOnCombat_delay), _delay];

        units _group apply { _x disableAI "PATH" };

        // Delay system if > 0
        if (_delay > 0) then {
            _group addEventHandler ["CombatModeChanged", {
                params ["_group", "_newMode"];

                if !(_newMode in ["COMBAT", "STEALTH"]) exitWith {};

                private _delay = _group getVariable [QGVAR(moveOnCombat_delay), 0];

                [{
                    params ["_group"];
                    units _group apply { _x enableAI "PATH" };
                }, [_group], _delay] call CBA_fnc_waitAndExecute;

                _group removeEventHandler [_thisEvent, _thisEventHandler];
            }];
        };
    };
};

// Code Start
//------------------------------------------------------------------------------------------------
switch _mode do {
    case "init": {
        if (is3DEN) exitWith {};

        // Get groups
        if (_units isEqualTo []) exitWith {[typeOf _module] call EFUNC(Error,requiresSync)};
        private _groups = _units apply {group _x};
        _groups = _groups arrayIntersect _groups;

        [_groups, _delay] call _execute;
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
