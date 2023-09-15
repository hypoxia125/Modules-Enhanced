#include "script_component.hpp"

params [
    ["_unit", objNull, [objNull]],
    ["_teleTo", [0,0,0], [[]]]
];

if (!(local _unit)) exitWith {};

private _travelTime = linearConversion [0, 1e5, _unit distance _teleTo, 0, 30, true];

// Fade screen
private _layer = QGVAR(blankScreen) call BIS_fnc_rscLayer;
uiNamespace setVariable [QGVAR(blankScreen), _layer];
_layer cutText [
    localize (FORMAT_1(QGVAR(teleportingNotification), _travelTime)),
    "BLACK OUT", 3, true, true
];

[{
    params ["_unit", "_teleTo", "_travelTime"];

    [QGVAR(hideObjectForTeleport), [_unit, true]] call CBA_fnc_localEvent;

    private _pos = [
        _teleTo,
        2, 10, 2, 1, 1, 0,
        [],
        _teleTo
    ] call BIS_fnc_findSafePos;
    _pos set [2, 0];

    _unit setPosATL _pos;
    _unit setDir (getDir _unit + (_unit getRelDir _teleTo));

    [{
        params ["_unit"];

        [QGVAR(hideObjectForTeleport), [_unit, false]] call CBA_fnc_localEvent;

        // Fade screen in
        private _layer = uiNamespace getVariable QGVAR(blankScreen);
        _layer cutText [
            LLSTRING(teleportedNotification),
            "BLACK IN", 3, true, true
        ];
    }, [_unit], _travelTime] call CBA_fnc_waitAndExecute;
}, [_unit, _teleTo, _travelTime], 4] call CBA_fnc_waitAndExecute;