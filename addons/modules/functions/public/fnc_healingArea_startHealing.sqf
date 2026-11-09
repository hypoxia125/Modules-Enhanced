/*
    Function: meh_modules_fnc_healingArea_startHealing
    Heal units in an ATL area once per second on the server.
    Arguments: [area, amountPerTick, lifetimeObject]. lifetimeObject is optional.
    Returns a script handle; terminate it to stop healing.
*/
#include "script_component.hpp"

params [
    ["_area", [], [[]]],
    ["_rate", 0, [0]],
    ["_lifetimeObject", objNull, [objNull]]
];

if (!isServer || {count _area < 6} || {!((_area#0) isEqualType [])} || {count (_area#0) < 2} || {_rate < 0}) exitWith {scriptNull};

private _stopWithObject = !isNull _lifetimeObject;
[_area, _rate, _lifetimeObject, _stopWithObject] spawn {
    params ["_area", "_rate", "_lifetimeObject", "_stopWithObject"];

    while {!_stopWithObject || {alive _lifetimeObject}} do {
        sleep 1;
        if (_stopWithObject && {!alive _lifetimeObject}) exitWith {};

        private _affectedUnits = entities [["CAManBase"], [], false, true] select {_x inArea _area};
        LOG_1("Healing Area - Affected Units:: %1",_affectedUnits);
        if (_affectedUnits isEqualTo []) then { continue };

        {
            private _unit = _x;
            getAllHitPointsDamage _unit params ["_hitpoints", "_selections", "_values"];

            for "_i" from 0 to (count _hitpoints - 1) do {
                if (_values#_i < 1) then {
                    [QGVAR(HealingArea_HealUnit), [_unit, _hitpoints # _i, (_values # _i - _rate) max 0], owner _unit] call CBA_fnc_ownerEvent;
                };
            };
            if ({_x > 0} count _values == 1) then {
                _unit setDamage 0;
            };
        } forEach _affectedUnits;
    };
}
