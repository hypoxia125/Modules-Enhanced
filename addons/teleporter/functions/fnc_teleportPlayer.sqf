#include "script_component.hpp"

params [
    ["_unit", objNull, [objNull]],
    ["_object", objNull, [objNull]],
    ["_travelTime", -1, [-1]]
];

if (!(local _unit)) exitWith {};

if (_travelTime == -1) then {
    _travelTime = [_unit, _object] call FUNC(getTravelTime);
};

// Fade screen
private _layer = QGVAR(blankScreen) call BIS_fnc_rscLayer;
uiNamespace setVariable [QGVAR(blankScreen), _layer];
_layer cutText [
    (FORMAT_1(LLSTRING(teleportingNotification), _travelTime)),
    "BLACK OUT", 3, true, true
];

[{
    params ["_unit", "_object", "_travelTime"];

    [QGVAR(hideObjectForTeleport), [_unit, true]] call CBA_fnc_localEvent;

    // Set vehicle to have a traveler
    private _travelers = _object getVariable [QGVAR(currentTravelers), []];
    _travelers pushBackUnique player;
    _object setVariable [QGVAR(currentTravelers), _travelers, true];

    [{
        params ["_unit", "_object", "_travelTime"];

        if (vehicle _unit isNotEqualTo _unit) then {
            moveOut _unit;
            _unit setVelocity [0,0,0];
        };

        if (
            alive _object &&
            {
                _object isKindOf "AllVehicles" &&
                [_object, ""] call FUNC(findOpenVehiclePosition) > 0
            }
        ) then {
            if ([_object, "cargo"] call FUNC(findOpenVehiclePosition) > 0) then {
                _unit moveInCargo _object;
            } else {
                _unit moveInAny _object;
            };
            [QGVAR(teleportedUnit), [_unit, _object]] call CBA_fnc_globalEvent;
        } else {
            private _pos = [
                getPosATL _object,
                2, 10, 2, 1, 1, 0,
                [],
                getPosATL _object
            ] call BIS_fnc_findSafePos;
            _pos set [2, 0];

            _unit setPosATL _pos;
            _unit setDir (getDir _unit + (_unit getRelDir _object));

            [QGVAR(teleportedUnit), [_unit, _pos]] call CBA_fnc_globalEvent;
        };

        // Remove a traveler
        private _travelers = _object getVariable [QGVAR(currentTravelers), []];
        _travelers = _travelers - [player];
        _object setVariable [QGVAR(currentTravelers), _travelers, true];
        
        [QGVAR(hideObjectForTeleport), [_unit, false]] call CBA_fnc_localEvent;

        // Fade screen in
        private _layer = uiNamespace getVariable QGVAR(blankScreen);
        _layer cutText [
            LLSTRING(teleportedNotification),
            "BLACK IN", 3, true, true
        ];
    }, [_unit, _object, _travelTime], _travelTime] call CBA_fnc_waitAndExecute;
}, [_unit, _object, _travelTime], 4] call CBA_fnc_waitAndExecute;
