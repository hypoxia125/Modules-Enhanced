#include "script_component.hpp"

params [
    ["_state", 1, [-1]],
    ["_text", "", [""]]
];

switch _state do {
    case 0: {
        private _layer = uiNamespace getVariable QGVAR(blankScreen);
        if (isNil "_layer") exitWith {};

        _layer cutText [_text, "BLACK IN", 3, true, true];
        uiNamespace setVariable [QGVAR(blankScreen), nil];
    };

    case 1: {
        private _layer = uiNamespace getVariable QGVAR(blankScreen);
        if (isNil "_layer") then {
            _layer = QGVAR(blankScreen) call BIS_fnc_rscLayer;
            uiNamespace setVariable [QGVAR(blankScreen), _layer];
        };

        _layer cutText [_text, "BLACK OUT", 1e-10, true, true];
    };
};
